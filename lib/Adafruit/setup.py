#!/usr/bin/env python

import setuptools
setuptools.setup(
    name="Adafruit",
    description="Libraries that Dexter Industries Robots depend on",
    author="Adafruit",
    url="http://www.adafruit.com/",
    py_modules=['I2C','Platform'],
    #install_requires=open('requirements.txt').readlines(),
)
