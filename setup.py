import sys
from glob import glob

if sys.version_info < (2, 6):
    sys.stderr.write('You must have at least Python 2.6 for saxs\n')
    sys.exit(0)

import os
from distutils.core import setup, Command
from distutils import ccompiler
from distutils.extension import Extension
from random import shuffle
import time

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

# check/install Cython
cmdclass = {}
try:
    from Cython.Distutils import build_ext
    from Cython.Build import cythonize
    has_cython = True
    cmdclass['build_ext'] = build_ext
except ImportError:
    has_cython = False
    from distutils.command.build_ext import build_ext 
    cmdclass['build_ext'] = build_ext

rootname = os.getcwd()
pysaxs_home = rootname + "/saxs/"

try:
    amberhome = os.environ['AMBERHOME']
    has_amberhome = True
except:
    has_amberhome = False

if has_amberhome:
    saxs_dir = amberhome + "/AmberTools/src/saxs/"
    cpptraj_include = amberhome + "/AmberTools/src/cpptraj/src/"
    saxs_include = saxs_dir
    libdir = amberhome + "/lib/"
else:
    saxs_dir, saxs_include, libdir = None, None, None
    nice_message = "must set AMBERHOME"
    sys.stderr.write(nice_message)
    sys.exit(0)

# get *.pyx files
pyxfiles = []
f = open('pyxlist.txt', 'r')
try:
    for line in f.readlines():
        if "#" not in line:
            pyxfiles.append(line.split("\n")[0])
finally:
    f.close()

ext_modules = []
for ext_name in pyxfiles:
    if has_cython:
        ext = ".pyx"
    else:
        ext = ".cpp"
    pyxfile = pysaxs_home + ext_name + ext

    # replace "/" by "." get module
    if "/" in ext_name:
        ext_name = ext_name.replace("/", ".")

    sources = [pyxfile]

    extmod = Extension("saxs." + ext_name,
                    sources=sources,
                    libraries=['saxs_md', 'cpptraj'],
                    language='c++',
                    library_dirs=[libdir,],
                    include_dirs=[saxs_include, pysaxs_home, cpptraj_include],
                    extra_compile_args=['-O0', '-ggdb'],
                    extra_link_args=['-O0', '-ggdb'])

    extmod.cython_directives = {
            'embedsignature':True,
            'boundscheck': False,
            }
    ext_modules.append(extmod)

pxd_include_dirs = [
        directory for directory, dirs, files in os.walk('saxs')
        if '__init__.pyx' in files or '__init__.pxd' in files
        or '__init__.py' in files
        ]

pxd_include_patterns = [
        p+'/*.pxd' for p in pxd_include_dirs ]

setup_args = {}
packages = [
        'saxs',
        ]

pylen = len('saxs') + 1
pxdlist = [p.replace("saxs/", "") for p in pxd_include_patterns]
datalist = pxdlist

if __name__ == "__main__":
    setup(name="pysaxs",
        version="0.0.1.dev0",
        author="Hai Nguyen",
        author_email="hainm.comp@gmail.com",
        url="ambermd.org",
        packages=packages,
        description="""Python API for saxs""",
        license = "BSD License",
        classifiers=[
                    'Development Status :: 4 - Beta',
                    'Operating System :: Unix',
                    'Operating System :: MacOS',
                    'Intended Audience :: Science/Research',
                    'License :: OSI Approved :: BSD License',
                    'Programming Language :: Python :: 2.6'
                    'Programming Language :: Python :: 2.7',
                    'Programming Language :: Python :: 3.3',
                    'Programming Language :: Python :: 3.4',
                    'Programming Language :: Cython',
                    'Programming Language :: C',
                    'Programming Language :: C++',
                    'Topic :: Scientific/Engineering'],
        ext_modules = ext_modules,
        package_data = {'saxs' : datalist},
        cmdclass = cmdclass,
    )
