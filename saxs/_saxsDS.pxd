# distutils: language = c++
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef extern from "saxsDS.h" nogil:
    ctypedef struct coordinate:
        string type 
        double x, y, z
        double r
        double B_factor
        size_t nHyd

    ctypedef struct coeff_f:
        string atomtype
        double a1, b1, a2, b2, a3, b3, a4, b4, c
