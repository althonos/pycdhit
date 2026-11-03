# coding: utf-8
# cython: language_level=3
"""Bindings to CD-HIT, an accelerated sequence clustering program.
"""

# --- C imports --------------------------------------------------------------

from cpython.unicode cimport PyUnicode_AsUTF8AndSize

cimport cdhit
from cdhit.options cimport Options
from cdhit.seq cimport SequenceDB, Sequence

cdef Options DEFAULT_OPTIONS = Options()

# --- Python imports ---------------------------------------------------------

import array
import dataclasses
import typing

__version__ = PROJECT_VERSION

# --- Functions --------------------------------------------------------------

@dataclasses.dataclass(frozen=True)
class Clustering:
    clusters: array.array
    representatives: array.array

    @property
    def n_clusters(self):
        """`int`: The number of clusters found in the clustering.
        """
        return len(self.representatives)

def cluster(
    sequences: typing.Iterable[str], 
    *, 
    cpus: typing.Optional[int] = None,
    identity_threshold: float = DEFAULT_OPTIONS.cluster_thd,
) -> array.array:
    cdef ssize_t     length
    cdef size_t      i
    cdef const char* s
    cdef str         sequence
    cdef Sequence*   seq      = NULL
    cdef SequenceDB  db       = SequenceDB()
    cdef Options     options  = Options()

    options.max_memory = 0  # don't attempt limiting memory
    options.threads = 1     # use a single thread (for now)
    options.input = "n/a"   # bogus filename so CD-HIT doesn't complain
    options.output = "n/a"  # bogus filename so CD-HIT doesn't complain
    
    options.cluster_thd = identity_threshold
    
    try:
        options.Validate()
    except Exception as exc:
        raise ValueError("Failed to validate parameters") from exc

    #?
    options.NAAN = cdhit.NAAN_array[options.NAA]
    db.NAAN = cdhit.NAAN_array[options.NAA]

    # seq_db.Read(...)
    for i, sequence in enumerate(sequences):
        s = PyUnicode_AsUTF8AndSize(sequence, &length)
        seq = new Sequence()
        seq[0] = s
        seq.tot_length = length
        seq.index = db.sequences.size()
        db.sequences.Append(seq)

    with nogil:
        db.SortDivide(options)
        db.DoClustering(options)

    # Extract flat clusters and representatives
    clusters = array.array('Q')
    for k in range(db.sequences.size()):
        clusters.append(db.sequences[k].cluster_id)
    representatives = array.array('Q')
    for k in range(db.rep_seqs.size()):
        representatives.append(db.rep_seqs[k])
    return Clustering(
        clusters=clusters,
        representatives=representatives,
    )



# --- Init code ----------------------------------------------------------------

cdhit.InitNAA(cdhit.MAX_UAA)