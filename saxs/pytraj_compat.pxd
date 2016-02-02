# distutils: language = c++
from libcpp.vector cimport vector
from cpython.array cimport array as pyarray
from . cimport _saxsDS as sx
from pytraj.Frame cimport _Frame, Frame
from pytraj.Frame cimport _Topology, Topology

cdef vector[sx.coordinate] vcoord_from_frame(const _Topology _top, const _Frame _frame)
