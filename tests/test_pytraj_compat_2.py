from __future__ import print_function
import unittest
from saxs import _saxs as sx
from saxs.pytraj_compat import read_pdb_from_frame
from pytraj.decorators import no_test

class Test(unittest.TestCase):
    def test_0(self):
        from pytraj import io
        import numpy as np

        print ("use pytraj")
        # load traj
        traj = io.load("./test.pdb", "test.pdb")
        v_dx = sx.read_dx("./")

        # v_dx is a list of dictionary
        # in C++ saxs, this is a vector of struct

        d1 = v_dx[0]
        x, y, z = d1['ngrid']
        print (x * y * z)
        print (d1['conc'])
        print (d1['type'])
        print (d1['delta'])
        print (d1['origin'])
        arr0 = np.asarray(d1['value'])
        assert arr0.shape[0] == (x * y * z)
        print ("shape of grids = %s %s %s" % (x, y, z))

if __name__ == "__main__":
    unittest.main()
