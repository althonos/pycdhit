from libc.stdio cimport FILE

from libcpp cimport bool

from cdhit.options cimport Options
from cdhit.vector cimport Vector


cdef extern from "cdhit-common.h":

    cppclass Sequence:
        char* data

        int size
        int bufsize
        int size_R2

        FILE* swap
        int offset

        size_t des_begin
        size_t des_begin2
        
        int tot_length
        int tot_length2

        char* identifier

        int index
        short int state
        int cluster_id
        float identity
        float distance
        int coverage[4]

        Sequence()
        Sequence(const Sequence& other)
        Sequence(const Sequence& other, const Sequence& other2, int mode)

        void operator=(const char* s)
        void operator+(const char* s)

        void Clear()
        void Resize(n)
        void Reserve(n)

        void Swap(Sequence& other)
        int Format()
        void ConvertBases()
        void trim(int trim_len)
        void SwapIn()
        void SwapOut()


    cppclass SequenceDB:
        int NAAN

        Vector[Sequence*] sequences
        Vector[int]       rep_seqs

        long long total_letter
        long long total_desc
        size_t max_len
        size_t min_len
        size_t len_n50

        SequenceDB()

        void Clear()

        # void Read( const char *file, const Options & options );
        # void Readgz( const char *file, const Options & options );

        # void Read( const char *file, const char *file2, const Options & options );
        # void Readgz( const char *file, const char *file2, const Options & options );

        # void WriteClusters( const char *db, const char *newdb, const Options & options );
        # void WriteClustersgz( const char *db, const char *newdb, const Options & options );

        # void WriteClusters( const char *db, const char *db_pe, const char *newdb, const char *newdb_pe, const Options & options );
        # void WriteClustersgz( const char *db, const char *db_pe, const char *newdb, const char *newdb_pe, const Options & options );

        # void WriteExtra1D( const Options & options );
        # void WriteExtra2D( SequenceDB & other, const Options & options );
        # void DivideSave( const char *db, const char *newdb, int n, const Options & options );

        # void SwapIn( int seg, bool reponly=false );
        # void SwapOut( int seg );

        void SortDivide(Options& options, bool sort=True) except +
        # void MakeWordTable( const Options & optioins );

        # size_t MinimalMemory( int frag_no, int bsize, int T, const Options & options, size_t extra=0 );

        # void ClusterOne( Sequence *seq, int id, WordTable & table,
        # 		WorkingParam & param, WorkingBuffer & buf, const Options & options );

        # void ComputeDistance( const Options & options );
        void DoClustering( const Options & options ) except +
        # void DoClustering( int T, const Options & options );
        # void ClusterTo( SequenceDB & other, const Options & optioins );
        # int  CheckOne( Sequence *seq, WordTable & tab, WorkingParam & par, WorkingBuffer & buf, const Options & opt );
        # int  CheckOneEST( Sequence *seq, WordTable & tab, WorkingParam & par, WorkingBuffer & buf, const Options & opt );
        # int  CheckOneAA( Sequence *seq, WordTable & tab, WorkingParam & par, WorkingBuffer & buf, const Options & opt );