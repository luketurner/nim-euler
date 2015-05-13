## Contains encapsulated helper/utility procedures

from math import sqrt, floor
from sequtils import newSeqWith

template slurpAsset*(fname: string): string =
    slurp("./assets/" & fname)

proc intSqrt*(x: int): int = toInt(floor(sqrt(toFloat(x))))

iterator factorsOf*(x: int): int =
    ## Iterates over all factors of a given integer (NOT necessarily ordered)
    for i in 1..intSqrt(x):
        if x mod i == 0:
            yield i
            yield toInt(x / i)

iterator fibonacci*(): int =
    ## Unbounded iteration over fibonacci numbers
    var a = 0
    var b = 1
    while true:
        yield a
        b = a + b
        a = b - a

iterator primesThrough*(max: int): int =
    ## Simple prime number generator using sieve of Eratosthenes
    var maybePrimes = newSeqWith(max, true)
    var p = 2 # contains current prime
    var mult = 2 # contains multiple of prime
    while p < max:
        if maybePrimes[p-1]: # next prime
            yield p
            mult = p
            while mult < max:
                maybePrimes[mult-1] = false
                mult += p
        p += 1

proc isPrime*(x: int): bool =
    ## Checks the primality of x
    for i in primesThrough(intSqrt(x)):
        if x mod i == 0:
            return false
    return true
