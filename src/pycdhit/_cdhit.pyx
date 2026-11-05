# coding: utf-8
# cython: language_level=3
"""Bindings to CD-HIT, an accelerated sequence clustering program.

References:
    - Li, W., & Godzik, A. (2006).
      Cd-hit: a fast program for clustering and comparing large sets of
      protein or nucleotide sequences. *Bioinformatics (Oxford, England),
      22(13)*, 1658–1659. :doi:`10.1093/bioinformatics/btl158` Epub 2006
      May 26. :pmid:`16731699`.
    - Fu, L., Niu, B., Zhu, Z., Wu, S., & Li, W. (2012).
      CD-HIT: accelerated for clustering the next-generation sequencing data.
      *Bioinformatics (Oxford, England), 28(23)*, 3150–3152.
      :doi:`10.1093/bioinformatics/bts565` :pmid:`23060610`.

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
import os
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
    double identity_threshold: float = DEFAULT_OPTIONS.cluster_thd,
    cpus: typing.Optional[int] = None,
) -> Clustering:
    """Cluster protein sequences with the CD-HIT algorithm.

    Arguments:
        sequences (iterable of `str`, `bytes` or buffer-like object): The
            sequences to cluster with CD-HIT.

    Keyword Arguments:
        identity_threshold (`float`): The identity threshold with which to
            cluster the sequences (``-c`` parameter from CD-HIT).
        cpus (`int`): The number of parallel threads to use to clustering.
            Pass 0 or `None` to use all available system threads, as given
            by `os.cpu_count`.

    """
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

    if cpus is None or cpus <= 0:
        _cpus = os.cpu_count() or 1
        options.threads = max(_cpus, 1)

    try:
        options.Validate()
    except Exception as exc:
        raise ValueError("Failed to validate parameters") from exc

    #?
    options.InitNAA(cdhit.MAX_UAA)
    options.NAAN = options.NAAN_array[options.NAA]
    db.NAAN = options.NAAN_array[options.NAA]

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

