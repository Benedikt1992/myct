#!/usr/bin/env python

import os
import shutil
from distutils.cmd import Command

from setuptools import setup

with open(os.path.join('myct', 'VERSION')) as version_file:
    version = version_file.read().strip()


class CleanAllCommand(Command):
    """A custom command to clean the project directory."""

    description = 'remove build artifacts from build, *dist, etc'
    user_options = [
        # The format is (long option, short option, description).
        ('includeDistributions', 'd', 'removes distributions inside the `dist` folder as well'),
    ]
    boolean_options = ['includeDistributions']

    def initialize_options(self):
        """ Set default values for options."""
        self.includeDistributions = None

    def finalize_options(self):
        """ check provided args """
        pass

    def run(self):
        for directory in ('build', 'myct.egg-info', 'myct.dist-info'):
            if os.path.exists(directory):
                shutil.rmtree(directory)

        if self.includeDistributions and os.path.exists('dist'):
            shutil.rmtree('dist')


# end class CleanAllCommand

setup(
    name='MyCT',
    version=version,
    description="""
    My Container Tool is a ultra lightweight solution to run processes in an isolated environment. 
    It is built on linux features like chroot and cgroups.
    """,
    author='Benedikt Bock, Sebastian Schmidl, Frederic Schneider',
    author_email='benedikt.bock@student.hpi.de, sebastian.schmidl@student.hpi.de, Frederic.Schneider@student.hpi.de',
    url='https://github.com/Benedikt1992/myct',
    license='MIT',

    # own commands
    cmdclass={
        'cleanAll': CleanAllCommand,
    },

    # dependencies
    install_requires=[
    ],

    # packages
    packages=['myct'],
    package_dir={'myct': './myct'},

    # executable scripts
    entry_points={
        'console_scripts': [
            'myct=myct.cli:run'
        ],
    },
)
