from __future__ import print_function
import unittest
from saxs import _saxs_md as smd
from saxs import pytraj_compat as pt

class Test(unittest.TestCase):
    def test_0(self):
        from pytraj import io

        fname = "./data/tz2.pdb"
        traj = io.load(fname, fname)
        ptpdb = pt.read_pdb_from_frame(traj.top, traj[0])
        spdb = smd.read_pdb_saxs(fname)[0]

        print (ptpdb)
        print (spdb[0][0])

        ##for x in ptpdb:
        #for x in spdb:
        #    print (x)


if __name__ == "__main__":
    unittest.main()
