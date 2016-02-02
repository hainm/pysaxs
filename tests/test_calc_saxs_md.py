from __future__ import print_function
import unittest
from saxs.pytraj_compat import *
from saxs import _saxs_md as smd
from pytraj import io
from pytraj.testing import Timer

class Test(unittest.TestCase):
    def test_0(self):
        print (smd.calc_saxs_md.__doc__)
        traj0 = io.load("./data/solu.pdb", "./data/solu.pdb")
        traj1 = io.load("./data/solv.pdb", "./data/solv.pdb")

        @Timer()
        def test():
            v = smd.calc_saxs_md(solute_traj=traj0,
                                 solvent_traj=traj1, 
                                 explicit_hydrogen=True,
                                 dtype='ndarray')
        test()

        # make sure to reproduce saxs's data
        v = smd.calc_saxs_md(solute_traj=traj0,
                             solvent_traj=traj1, 
                             explicit_hydrogen=True,
                             dtype='ndarray')
        import numpy as np
        from pytraj.testing import aa_eq
        saved_data = np.loadtxt("./data/saxs.out", skiprows=9).transpose()
        print (v)
        aa_eq(v, saved_data[1])

if __name__ == "__main__":
    unittest.main()
