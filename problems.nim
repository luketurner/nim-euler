## Problem definitions

from math import sqrt, floor, pow
from sequtils import foldl
from strutils import tokenize, replace, splitLines, parseInt
from tables import initTable, newTable, hasKey, `[]`, `[]=`, TableRef

from core import problem
from util import isPrime, primesThrough, fibonacci, intSqrt, factorsOf, slurpAsset

include problems.p1_10
include problems.p11_20
