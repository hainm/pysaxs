# distutils: language = c++
from libcpp.string cimport string
from libcpp.vector cimport vector
from . cimport _saxsDS as sx

#cdef extern from "saxs.h":
#    ctypedef struct dx_type:
#        string type
#        double conc
#        vector[double] value
#        vector[size_t] ngrid
#        vector[double] origin
#        vector[double] delta
#    
#    ctypedef struct coeff_f:
#        double a1, b1, a2, b2, a3, b3, a4, b4, c
#    
#    vector[dx_type] dx
#    vector[coordinate] pdb_coord
#    
#    string dx_dir, pdb_file, outfile, exper
#    
#    double qcut = 0.5      # Cutoff q
#    double anom_f = 0      # f' in anomalous scattering
#    double df_on = 0
#    double df_off = 0
#    double conc_salt = 0   # Bulk concentration of salt
#    double conc_wat = 55.34# Water concentration
#    double cutoff = 20
#    bint expli = 0         # Account for explicit H atoms in pdb file
#    bint tight = 0         # Control Lebedev quadrature tight or loose convergence
#    bint flex = 0          # Account for flexibility using B-factor in the PDB file
#    #bint corr = 0         # Using corrected atomic factor for water as in J Chem Phys 2000, 113, 9149
#    bint decomp = 0        # Decomposing intensity into site contributions
#    bint off_cutoff = 0
#    double dq = 0.01
#    unsigned ncpus
#    
#    # Declare functions to use
#    
#    void usage ()
#    
#    
#    void read_dx (const string &dx_dir,
#                         vector[dx_type] &dx)
#    
#    
#    bint check_dx (const vector[dx_type] &dx)
#    
#    
#    void read_pdb (const string &pdb_file,
#                   vector[coordinate] &pdb_coord)
#    
#    
#    void mergeH (vector[coordinate] &pdb_coord)
#    
#    
#    void extreme_pdb (const vector[coordinate] &pdb_coord,
#                      coordinate &max,
#                      coordinate &min)
#    
#    
#    void read_exp (const string &exper,
#                   vector[double] &q)
#    
#    
#    coordinate get_coordinate (const dx_type &dx,
#                               size_t index)
#    
#    
#    size_t cal_index (const dx_type &dx,
#                      size_t x,
#                      size_t y,
#                      size_t z)
#    
#    
#    double atom_fact (const coeff_f &atom,
#                      double q)
#    
#    
#    void assign_val (const string &type,
#                     double q,
#                     size_t nHyd,
#                     bint expli,
#                     double &atomic_factor)
#    
#    
#    vector[size_t] list_cutoff (const dx_type &dx,
#                                const vector[coordinate] &pdb_coord,
#                                const coordinate &max,
#                                const coordinate &min,
#                                double cutoff)
#    
#    
#    #complex[double] form_factor (const vector[coordinate] &pdb_coord,
#    #                             const coordinate &q_vector,
#    #                             double q,
#    #                             bint flex,
#    #                             bint expli)
#    #
#    
#    #complex[double] grid_factor (const dx_type &dx,
#    #                             bint excess,
#    #                             double atomic_factor,
#    #                             const vector[size_t] &list_cutoff,
#    #                             const coordinate &q_vector)
#    
#    
#    dx_type ex_elec (const vector[dx_type] &dx,
#                     double anom_f,
#                     bint expli)
#    
#    
#    vector[double] cal_I (const vector[dx_type] &dx,
#                          bint excess,
#                          const vector[coordinate] &pdb_coord,
#                          const vector[ vector[size_t] ] &list_cutoff,
#                          double q,
#                          size_t rule,
#                          bint flex,
#                          double anom_f,
#                          bint expli)
#
#    vector[vector[double]] test_main(double anom_f, string pdb_solu, string pdb_solv,
#                                     double qcut, double dq,
#                                     double dcutoff, bint expli)
