#!/usr/bin/env python

import os
import sys

try:
    from setuptools import setup
except:    
    from distutils.core import setup

here    = os.path.abspath(os.path.dirname(__file__))
README  = open(os.path.join(here, 'README.md')).read()
CHANGES = open(os.path.join(here, 'CHANGES.txt')).read()
VERSION = '0.1.0'
AUTHOR  = 'iaintshine'
EMAIL   = 'bodziomista@gmail.com'

setup(
    name='SocialCoffee',
    version=VERSION,
    author=AUTHOR,
    author_email=EMAIL,
    packages=['socialcoffee', 'socialcoffee.test'],
    scripts=[],
    url='https://github.com/iaintshine/social_coffee',
    license='LICENSE.txt',
    description='Python client library for interaction with social coffee thrift service.',
    long_description=README + '\n\n' + CHANGES,
    install_requires=[
        'thrift == 1.0.0-dev'
    ],
)