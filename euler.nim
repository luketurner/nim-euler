from os import commandLineParams
from parseutils import parseInt
from math import sqrt, floor, pow
from sequtils import newSeqWith, toSeq, foldl
from times import cpuTime
from re import re, findAll

# Dispatch table for problem functions,
# used to support command-line parameters
var problems: seq[proc():string] = @[]

# Looks up problems and prints solutions
proc main() =
    for arg in commandLineParams():
        var num = 0
        discard parseInt(arg, num)
        if num-1 >= problems.low() and num-1 <= problems.high():
            var startTime = cpuTime()
            echo("\t\t", $num, " : ", problems[num - 1](), " in ", (cpuTime() - startTime) * 1000, "ms")
        else:
            echo("\"", arg, "\" is not a valid argument.")

# Helper template wraps statement block in an
# anonymous proc and inserts it in the problem
# list at a given place.
template problem(i: expr, body: stmt): stmt {.immediate.} =
    problems.insert(proc():string =
        body, i-1)

##
## Helper functions for use in the problems
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
    var palindrome: int
    for i in 100..999:
        for j in 100..999:
            let s = $(i*j)
            let slen = s.len
            var palindromic = true
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
    # note: start factors with 0 to get around the lack of initial value parameter in foldl
    let factors = @[0, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    var lcm = 2520
    while foldl(factors, a + (lcm mod b)) != 0:
        lcm += 2520
    return $lcm
    
# Find the difference between square(sum(1..100)) and sum(square(1..100))
# SOLVED
problem 6:
    var sum, squareSum: int
    for i in 1..100:
        sum += i
        squareSum += toInt(pow(toFloat(i), 2.0))
    return $(toInt(pow(toFloat(sum), 2.0)) - squareSum)
    
# Find the 10001st prime - very easy with primesThrough already written
# SOLVED
problem 7:
    var i = 0
    for n in primesThrough(200000):
        i += 1
        if i == 10001:
            return $n

# Find the thirteen adjacent digits that have the greatest product.
# (note: done with only one string assignment)
# SOLVED
problem 8:
    let bignum = 
        "73167176531330624919225119674426574742355349194934" &
        "96983520312774506326239578318016984801869478851843" &
        "85861560789112949495459501737958331952853208805511" &
        "12540698747158523863050715693290963295227443043557" &
        "66896648950445244523161731856403098711121722383113" &
        "62229893423380308135336276614282806444486645238749" &
        "30358907296290491560440772390713810515859307960866" &
        "70172427121883998797908792274921901699720888093776" &
        "65727333001053367881220235421809751254540594752243" &
        "52584907711670556013604839586446706324415722155397" &
        "53697817977846174064955149290862569321978468622482" &
        "83972241375657056057490261407972968652414535100474" &
        "82166370484403199890008895243450658541227588666881" &
        "16427171479924442928230863465674813919123162824586" &
        "17866458359124566529476545682848912883142607690042" &
        "24219022671055626321111109370544217506941658960408" &
        "07198403850962455444362981230987879927244284909188" &
        "84580156166097919133875499200524063689912560717606" &
        "05886116467109405077541002256983155200055935729725" &
        "71636269561882670428252483600823257530420752963450"
    var product, maxProduct: int
    for i in 0..(bignum.len - 13):
        product = 1
        for j in 0..12:
            product *= ord(bignum[i+j]) - 48 # character code math probably faster than parseInt
        if product > maxProduct:
            maxProduct = product
    return $maxProduct
            
main()
