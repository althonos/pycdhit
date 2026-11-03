from libcpp.vector cimport vector

cdef extern from "cdhit-common.h":

    cppclass Vector[T](vector[T]):
        Vector()
        Vector(size_t)
        Vector(size_t, const T& default)

        void Append(const T& item)
        # int size()