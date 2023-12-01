#!/usr/local/bin/python
#
# Script to launch meld as a git diff-tool

import sys
import os

# print(sys.argv)

os.system('meld "%s" "%s"' % (sys.argv[2], sys.argv[5]))
