# coding: utf-8
# cython: language_level=3
"""Bindings to CD-HIT, an accelerated sequence clustering program.
"""

# --- C imports --------------------------------------------------------------

from cpython.unicode cimport PyUnicode_AsUTF8AndSize

cimport cdhit
from cdhit.options cimport Options
from cdhit.seq cimport SequenceDB, Sequence

# --- Python imports ---------------------------------------------------------

import typing

__version__ = PROJECT_VERSION

# --- Functions --------------------------------------------------------------

def cluster(
    sequences: typing.Iterable[str], 
    *, 
    cpus: typing.Optional[int] = None,
):

    cdef ssize_t     length
    cdef size_t      i
    cdef const char* s
    cdef str         sequence
    cdef Sequence*   seq      = NULL
    cdef SequenceDB  db       = SequenceDB()
    cdef Options     options  = Options()

    options.threads = 1
    options.input = "n/a"
    options.output = "n/a"

    options.Validate()
    
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

    db.SortDivide(options)
    db.DoClustering(options)

    return [db.sequences[k].cluster_id for k in range(db.sequences.size())]



# --- Init code ----------------------------------------------------------------

cdhit.InitNAA(cdhit.MAX_UAA)