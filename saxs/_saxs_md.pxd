# distutils: language = c++
from libcpp.string cimport string
from libcpp.vector cimport vector
from . cimport _saxsDS as sx

cdef extern from "saxs_md.h" nogil:
    void _read_pdb "read_pdb_weight" (string &pdb_file,
                   vector[vector[sx.coordinate]] &pdb_coord,
                   vector[unsigned] &weight)

    vector[double] saxs_md_calc (vector[vector[sx.coordinate]] &solu_box,
                                 vector[vector[sx.coordinate]] &solv_box,
                                 vector[unsigned] &weight_solu,
                                 vector[unsigned] &weight_solv,
                                 double anom_f, double qcut, double dq,
                                 double dcutoff, bint expli, bint tight,
                                 unsigned ncpus)
