# distutils: language = c++
from __future__ import absolute_import
from . _saxs cimport read_pdb as _read_pdb
from . _saxs cimport read_dx as _read_dx
from . _saxs cimport extreme_pdb as _extreme_pdb, mergeH as _merge_H
from .utils import convert_dict_to_namedtuple

__all__ = ['read_pdb', 'read_dx', 'calc_extreme_pdb']

def read_pdb(pdb_name):
    """return a list of dict"""
    pdb_name = pdb_name.encode()
    cdef vector[coordinate] vcoord
    _read_pdb(pdb_name, vcoord)
    return vcoord

def read_dx(dx_dir="./", restype='normal_list'):
    """
    Parameters
    ----------
    dx_dir : str, default "./"
    restype : str {"normal_list", "namedtuple"}, default "normal_list"
    """
    """return a list of namedtuple"""
    dx_dir = dx_dir.encode()
    cdef vector[dx_type] v_dx
    _read_dx(dx_dir, v_dx)
    if restype == 'normal_list':
        return v_dx
    elif restype == 'namedtuple':
        return [convert_dict_to_namedtuple(x) for x in v_dx]

def calc_extreme_pdb(vector[coordinate] &pdb_coord):
    cdef coordinate v_min
    cdef coordinate v_max
    _extreme_pdb(pdb_coord, v_max, v_min)
    return (v_max, v_min)
