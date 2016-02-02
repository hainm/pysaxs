#!/usr/bin/env python
import ctypes as ct
from ctypes import byref
import os

amberhome = os.environ['AMBERHOME']
libsaxs_dir = os.path.join(amberhome, "lib", "libsaxs.so")
plib = ct.cdll.LoadLibrary(libsaxs_dir)
print (plib)
