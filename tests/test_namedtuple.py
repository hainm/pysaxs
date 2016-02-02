from __future__ import print_function
import unittest
from saxs import _saxs as sx
from saxs.pytraj_compat import *

class Test(unittest.TestCase):
    def test_0(self):
        dx = sx.read_dx("./")
        d0 = dx[0]
        print (d0)

if __name__ == "__main__":
    unittest.main()
