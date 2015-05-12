from os import commandLineParams
from parseutils import parseInt
from math import sqrt, floor, pow
from sequtils import newSeqWith, toSeq, foldl
from strutils import tokenize
from times import cpuTime
from re import re, findAll
from tables import initTable, hasKey, `[]`, `[]=`

# Dispatch table for problem functions,
# used to support command-line parameters
var problems = initTable[int, proc():string]()

# Looks up problems and prints solutions
proc main() =
    for arg in commandLineParams():
        var num = 0
        discard parseInt(arg, num)
        if problems.hasKey(num):
            var startTime = cpuTime()
            echo("\t\t", $num, " : ", problems[num](), " in ", (cpuTime() - startTime) * 1000, "ms")
        else:
            echo("\"", arg, "\" is not a valid argument.")

# Helper template wraps statement block in an
# anonymous proc and inserts it in the problem
# list at a given place.
template problem(i: expr, body: stmt): stmt {.immediate.} =
    problems[i] = proc():string =
        body

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

# Find a*b*c where a^2 + b^2 = c^2 and a+b+c = 1000
# Note: using Euclid's method for generating triples
# SOLVED
problem 9:
    for m in 1..50:
        for n in 1..m:
            # simplified form of a+b+c expressed in terms of m,n
            if 2*m*(m+n) == 1000:
                return $(2*m*n*(m*m-n*n)*(m*m+n*n))
    return "fail"

# Find the sum of all primes below 2 million
# SOLVED
problem 10:
    var sum = 0
    for i in primesThrough(2_000_000):
        sum += i
    return $sum

# Find the greatest product of four adjacent numbers in the same direction in the grid below.
# SOLVED
problem 11:
    var maxProd = 0
    let gridString = """
08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08
49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00
81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65
52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91
22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80
24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50
32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70
67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21
24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72
21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95
78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92
16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57
86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58
19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40
04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66
88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69
04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36
20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16
20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54
01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48"""
    # parse string into a seq
    var grid = newSeq[int]()
    for t in tokenize(gridString):
        if not t[1]:
            var pInt : int
            discard parseInt(t[0], pInt)
            grid.add(pInt)
    # Examine the seq by iterating over all possible rows/diagonals/columns.
    # In order to make the code concise, most numeric values are hardcoded.
    # If the grid was of variable size, I should move the steps into variables.
    for x in 0..16:
        for y in countup(0, 380, 20):
            let i = x + y # the starting point of the row/diag/col to be checked
            if x <= 16:
                maxProd = max(maxProd, grid[i] * grid[i+1] * grid[i+2] * grid[i+3]) # Try the row
                if y <= 320: maxProd = max(maxProd, grid[i] * grid[i+21] * grid[i+42] * grid[i+63]) # Try the backward diagonal \
                if y >= 60: maxProd = max(maxProd, grid[i] * grid[i-19] * grid[i-38] * grid[i-57]) # Try the forward diagonal /
            if y <= 320: maxProd = max(maxProd, grid[i] * grid[i+20] * grid[i+40] * grid[i+60]) # Try the column
    return $maxProd
            
main()
