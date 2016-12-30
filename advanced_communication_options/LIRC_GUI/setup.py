#!/usr/bin/python
# To install the ir_receiver_check library systemwide, use: sudo python setup.py install
import setuptools
setuptools.setup(
	name="ir_receiver_check",
	description="Drivers and examples for using the ir_receiver_check in Python",
	author="Dexter Industries",
	py_modules=['ir_receiver_check'],
	#install_requires=open('requirements.txt').readlines(),
)
