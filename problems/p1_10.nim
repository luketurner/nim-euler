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
    const bignum = slurpAsset("p8.txt").replace("\n", "")
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