# distutils: language = c++

from libcpp.vector cimport vector
from cpython.array cimport array as pyarray
from . cimport _saxsDS as sx
from pytraj.Frame cimport _Frame, Frame
from pytraj.Frame cimport _Topology, Topology


cdef vector[sx.coordinate] vcoord_from_frame(_Topology _top, _Frame _frame):
    cdef vector[sx.coordinate] vcoord
    cdef sx.coordinate _coord
    cdef int i
    cdef Frame frame = Frame()
    frame.py_free_mem = False
    frame.thisptr = &_frame
    cdef int n_atoms = frame.n_atoms
    cdef Topology top = Topology()
    top.thisptr = &_top
    top.py_free_mem = False
    cdef pyarray[int] b_indices = top.indices_bonded_to("H")

    for i in range(n_atoms):
        _coord.x = _frame.XYZ(i)[0]
        _coord.y = _frame.XYZ(i)[1]
        _coord.z = _frame.XYZ(i)[2]
        atom = top[i]
        if atom.atomic_number in [1, 6, 7, 8, 15, 16]:
            aname = atom.name[0] # take only 1st letter
            molnum = atom.molnum
            if top.moleculelist[molnum].is_solvent():
                # compat with saxs
                aname += 'w'
        else:
            # take all characters for other elements
            # 
            aname = atom.name.strip()
        _coord.type = aname.encode()
        _coord.nHyd = b_indices[i]
        vcoord.push_back(_coord)
    return vcoord

def read_pdb_from_frame(Topology top, Frame frame):
    cdef vector[sx.coordinate] vcoord
    cdef sx.coordinate _coord
    cdef int i
    cdef int n_atoms = frame.n_atoms
    cdef pyarray[int] b_indices = top.indices_bonded_to("H")

    for i in range(n_atoms):
        _coord.x = frame.thisptr.XYZ(i)[0]
        _coord.y = frame.thisptr.XYZ(i)[1]
        _coord.z = frame.thisptr.XYZ(i)[2]
        atom = top[i]
        if atom.atomic_number in [1, 6, 7, 8, 15, 16]:
            aname = atom.name[0] # take only 1st letter
            molnum = atom.molnum
            if top.moleculelist[molnum].is_solvent():
                # compat with saxs
                aname += 'w'
        else:
            # take all characters for other elements
            # 
            aname = atom.name.strip()
        _coord.type = aname.encode()
        _coord.nHyd = b_indices[i]
        vcoord.push_back(_coord)
    return vcoord
