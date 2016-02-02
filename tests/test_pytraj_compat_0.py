from __future__ import print_function
import unittest
from saxs import _saxs as sx
from saxs.pytraj_compat import read_pdb_from_frame
from pytraj.decorators import no_test

class Test(unittest.TestCase):
    @no_test
    def test_0(self):
        print ("use saxs")
        pdb = sx.read_pdb("./test.pdb")
        v_dx = sx.read_dx("./")
        print (pdb)
        print (len(v_dx))
        d1 = v_dx[0]
        print (d1.keys())
        print (d1['ngrid'])
        v_max, v_min = sx.calc_extreme_pdb(pdb)
        print (v_max)
        print (v_min)

    def test_1(self):
        from pytraj import io
        import numpy as np

        print ("use pytraj")
        # load traj
        traj = io.load("./test.pdb", "test.pdb")
        n_atoms = traj.top.n_atoms

        # creat dummy B-factors
        b_array = np.zeros(n_atoms)

        # create dummy r_array
        r_array = np.asarray([atom.gb_radius for atom in traj.top])
        #print (r_array[0])

        # read pdb for 1st frame
        pdb = read_pdb_from_frame(traj.top, traj[0], b_array, r_array) 
        #print (len(pdb))
        #print (pdb[0])
        #print (pdb)

        # read dx, find all guv.* files in current folder
        v_dx = sx.read_dx("./")

        # v_dx is a list of dictionary
        # in C++ saxs, this is a vector of struct
        print (len(v_dx))
        d1 = v_dx[0]
        print (d1.keys())

        # get info
        x, y, z = d1['ngrid']
        print (x * y * z)
        print (d1['conc'])
        print (d1['type'])
        print (d1['delta'])
        print (d1['origin'])
        arr0 = np.asarray(d1['value'])
        assert arr0.shape[0] == (x * y * z)

        # calculate vcoor_max, vcoor_min: dummy example
        v_max, v_min = sx.calc_extreme_pdb(pdb)
        #print (v_max)
        #print (v_min)

if __name__ == "__main__":
    unittest.main()
