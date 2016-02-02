# distutils: language = c++
from __future__ import absolute_import
from . _saxs_md cimport saxs_md_calc as _calc_saxs_md
from . cimport _saxsDS as sx
from .pytraj_compat cimport vcoord_from_frame
from pytraj.externals.six import string_types
from pytraj.Frame cimport Frame
from pytraj.Topology cimport Topology

__all__ = ['calc_saxs_md',]

def calc_saxs_md(solute_traj=None, solvent_traj=None,
                 double anom_f=0.0, double qcut=1., double dq=0.01,
                 double dcutoff=5., bint explicit_hydrogen=False, 
                 bint tight=False, 
                 dtype='list', ncpus=2):
    """
    solute_traj : Trajectory-like
    solvent_traj : Trajectory-like
    anom_f : float, 
    qcut : float, default 1.
        momentum transfer q cutoff
    dq : float, default 0.01
        q spacing
    dcutoff : float, default 5.
        distance cutoff to the solute,
        keep only waters and ions within cutoff from the solute
    explicit_hydrogen : bool, default True
        accounting for explicit H atoms
    tight : bool, default False
        use tighter convergence criteria for Lebedev quadrature
    dtype : return type, {'list', 'ndarray'}, default 'list'
    ncpus : int, default 2
        number of cpus for openmp. Need to install libsaxs_md with "-fopenmp" flag
    """

    # TODO : weight_solute, weight_solvent
    cdef vector[sx.coordinate] solute_coord, solvent_coord
    cdef vector[vector[sx.coordinate]] v_solute_traj, v_solvent_traj
    cdef Frame solute_frame, solvent_frame
    cdef Topology _solute_top = solute_traj.top
    cdef Topology _solvent_top = solvent_traj.top
    cdef vector[unsigned] weight_solute = [1. for _ in range(solute_traj.n_frames)]
    cdef vector[unsigned] weight_solvent = [1. for _ in range(solvent_traj.n_frames)]
    cdef int i

    if isinstance(solute_traj, string_types) and isinstance(solvent_traj, string_types):
        raise ValueError("don't care about pdb files")
    else:
        for solute_frame in solute_traj:
            solute_coord = vcoord_from_frame(_solute_top.thisptr[0], 
                                             solute_frame.thisptr[0])
            v_solute_traj.push_back(solute_coord)
        for solvent_frame in solvent_traj:
            solvent_coord = vcoord_from_frame(_solvent_top.thisptr[0], 
                                              solvent_frame.thisptr[0])
            v_solvent_traj.push_back(solvent_coord)

    vv = _calc_saxs_md(v_solute_traj, v_solvent_traj,
                       weight_solute, weight_solvent,
                       anom_f, qcut, dq, dcutoff, explicit_hydrogen, tight, ncpus)

    if dtype == 'list':
        return vv
    elif dtype == 'ndarray':
        import numpy as np
        return np.asarray(vv)
    else:
        raise ValueError("dtype must be 'list' for 'ndarray'")

def read_pdb_saxs(pdb_file):
    cdef vector[vector[sx.coordinate]] pdb_coord
    cdef vector[unsigned] weight

    _read_pdb (pdb_file.encode(),
               pdb_coord,
               weight)
    return (pdb_coord, weight)
