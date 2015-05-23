# Hand-rolled limited implementation of bignums,
# to be used in solving various Euler problems.
# Internally represents each number as a sequence of "leaves",
# and addition/multiplication are performed across the leaves
# using modular arithmetic.
# Because a lot of these types of problems involve summing the digits
# of the number, we make sure to keep everything in base 10.

import math

## Base Bignum type
type Bignum* = tuple[leafMax: int, leaves: seq[int]]

proc carry(leaves: var seq[int], leafMax: int) =
    ## Internal function implements carrying by clamping
    ## the value of each leaf so that it is under leafMax.
    for i in 0..leaves.high:
        let leaf = leaves[i]
        if leaf >= leafMax:
            leaves[i] = leaf mod leafMax
            if i == leaves.high:
                leaves.add(0)
            leaves[i+1] += (leaf / leafMax).floor.toInt

proc `+`*(a: Bignum, b: int): Bignum =
    ## Adds an int and a bignum together.
    let leafMax = a.leafMax
    var leav = a.leaves
    if leav.len == 0:
        leav.add(0)
    leav[leav.low] += b
    carry(leav, leafMax)
    return (leafMax, leav)

proc `*`*(a: Bignum, b: int): Bignum =
    ## Multiplies an int and a bignum.
    let leafMax = a.leafMax
    var leav = a.leaves
    for i in 0..leav.high:
        leav[i] *= b
    carry(leav, leafMax)
    return (leafMax, leav)

proc `+=`*(a: var Bignum, b: int) {.inline.} = a = a + b
proc `*=`*(a: var Bignum, b: int) {.inline.} = a = a * b

proc `$`*(x: Bignum): string =
    ## Converts a bignum into a string
    for leaf in x.leaves:
        result = $leaf & result

iterator digits*(a: Bignum): int =
    ## Iterate over each digit in the bignum in order of significance
    for i in countdown(a.leaves.high, a.leaves.low):
        for d in $(a.leaves[i]):
            yield ord(d) - 48

proc toBignum*(n: int, leafLength: int = 7): Bignum =
    ## Creates a bignum from a starting integer. Optionally allows you to
    ## specify a custom leafLength, which indicates how many digits are
    ## stored in each leaf.
    let leafMax = 10.0.pow(leafLength.toFloat).toInt
    var result: Bignum = (leafMax, newSeq[int]())
    result += n
    return result
