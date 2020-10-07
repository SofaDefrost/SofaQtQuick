#!/bin/sh

unset SOFA_ROOT
unset SOFA_PATH
export PYTHONHOME=../
export PYTHONPATH=../lib/python3/site-packages
export LD_LIBRARY_PATH=../lib:../lib/x86_64-linux-gnu/

./runSofa2
