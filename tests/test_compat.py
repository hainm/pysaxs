from __future__ import print_function
import unittest
from saxs import _saxs as sx
from saxs.pytraj_compat import *

class Test(unittest.TestCase):
    def test_0(self):
        p, v = test_compat("./tz2.pdb", "./tz2.top")
        print (p)
        print (v)

if __name__ == "__main__":
    unittest.main()
