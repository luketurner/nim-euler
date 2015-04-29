from os import commandLineParams
from parseutils import parseInt
from math import sqrt, floor
from sequtils import newSeqWith, toSeq, foldl

# Dispatch table for problem functions,
# used to support command-line parameters
var problems: seq[proc():string] = @[]

# Looks up problems and prints solutions
proc main() =
    for arg in commandLineParams():
        var num = 0
        discard parseInt(arg, num)
        if num-1 >= problems.low() and num-1 <= problems.high():
            echo($num, " : ", problems[num-1]())
        else:
            echo("\"", arg, "\" is not a valid argument.")

# Helper template wraps statement block in an
# anonymous proc and inserts it in the problem
# list at a given place.
template problem(i: expr, body: stmt): stmt {.immediate.} =
    problems.insert(proc():string =
        body, i-1)

##
## Helper/utility things
##

# Unbounded iteration over fibonacci numbers
iterator fibonacci(): int =
    var a = 0
    var b = 1
    while true:
        yield a
        b = a + b
        a = b - a

# Simple prime number generator using sieve of Eratosthenes
# Note: might be more efficient to maintain the maybePrimes
# array between questions, but I think that's cheating.
iterator primesThrough(max: int): int =
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

# Primality checker
# I haven't looked into this much but I think that
# using primesThrough is faster than using a naive range slice.
proc isPrime(x: int): bool =
    for i in primesThrough(toInt(floor(sqrt(toFloat(x))))):
        if x mod i == 0:
            return false
    return true

##
## Problem definitions
##

# Find the sum of all numbers less than 1000 that are divisible by 3 or 5
# SOLVED
problem 1:
    var sum = 0
    for i in 1..999:
        if i mod 3 == 0 or i mod 5 == 0:
            sum += i
    return $sum

# Find the sum of all even Fibonacci numbers less than 4,000,000
# SOLVED
problem 2:
    var sum = 0
    for i in fibonacci():
        if i > 4_000_000:
            break
        if i mod 2 == 0:
            sum += i
    return $sum

# Find the largest prime factor of the number 600851475143
# SOLVED
problem 3:
    var maxPrime = 1
    for i in 1..toInt(floor(sqrt(600851475143.0))):
        if 600851475143 mod i == 0 and isPrime(i):
            maxPrime = i
    return $maxPrime

# Find the largest palindromic number made from the product of
# two three-digit numbers.
# SOLVED
problem 4:
    var s: string
    var slen, palindrome: int
    var palindromic = true
    for i in 100..999:
        for j in 100..999:
            s = $(i*j)
            slen = s.len
            palindromic = true
            for c in 0..toInt(floor(slen / 2)):
                if s[c] != s[slen - (c+1)]:
                    palindromic = false
            if palindromic and palindrome < i*j:
                palindrome = i*j
    return $palindrome

# Find the smallest number that is evenly divisible by 1..20
# Thanks to problem statement we already know that 2520 is the
# LCM of 1..10, so we just need to find the LCM of 2520 with 11..20
# SOLVED
problem 5:
    # note: start factors with 0 to get around the lack of initial value
    # parameter in foldl
    let factors = @[0, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    var lcm = 2520
    while foldl(factors, a + (lcm mod b)) != 0:
        lcm += 2520
    return $lcm

main()
