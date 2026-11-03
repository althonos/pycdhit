from libc.stdio cimport FILE

from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef extern from "cdhit-common.h" nogil:

    cppclass Options:
        int     NAA
        int     NAAN
        int     NAA_top_limit

        size_t  max_memory  #  -M: 400,000,000 in bytes
        int     min_length  #  -l: 10 bases
        bool    cluster_best   #  -g: 0, the first  1, the best
        bool    global_identity  #  -G:
        bool    store_disk  #  -B:
        int     band_width  #  -b: 20
        double  cluster_thd  #  -c
        double  distance_thd  #  -D
        double  diff_cutoff  #  -s: 0.0
        double  diff_cutoff2  #  -s2: 1.0
        int     diff_cutoff_aa  #  -S: 999999
        int     diff_cutoff_aa2  #  -S2: 0
        int     tolerance  #  -t: 2
        double  long_coverage  #  -aL:
        int     long_control  #  -AL:
        double  short_coverage  #  -aS:
        int     short_control  #  -AS:
        int     min_control  #  -A:
        double  long_unmatch_per  #  -uL
        double  short_unmatch_per  #  -uS
        int     unmatch_len  #  -U
        int     max_indel  #  -D
        int     print
        int     des_len
        int     frag_size
        int     option_r
        int     threads
        int     PE_mode      #  -P
        int     trim_len     #  -cx
        int     trim_len_R2  #  -cy
        int     align_pos    #  -ap for alignment position

        size_t  max_entries
        size_t  max_sequences
        size_t  mem_limit

        bool    has2D
        bool    isEST
        bool    is454
        bool    useIdentity
        bool    useDistance
        bool    backupFile

        string  input
        string  input_pe
        string  input2
        string  input2_pe
        string  output
        string  output_pe

        int     sort_output   #  -sc
        int     sort_outputf  #  -sf

        Options()

        bool SetOptionCommon( const char *flag, const char *value ) except +
        bool SetOption( const char *flag, const char *value ) except +
        bool SetOption2D( const char *flag, const char *value ) except +
        bool SetOptionEST( const char *flag, const char *value ) except +
        bool SetOptions( int argc, char *argv[], bool twodata=false, bool est=false ) except +

        void Validate() except +
        void ComputeTableLimits( int min_len, int max_len, int typical_len, size_t mem_need ) except +
        void Print() except +