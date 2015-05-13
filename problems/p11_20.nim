# Find the greatest product of four adjacent numbers in the same direction in the grid below.
# SOLVED
problem 11:
    var maxProd = 0
    const gridString = slurpAsset("p11.txt")
    # parse string into a seq
    var grid = newSeq[int]()
    for t in tokenize(gridString):
        if not t[1]:
            grid.add(parseInt(t[0]))
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
    
# Find the first triangle number to have over 500 divisors
# SOLVED
problem 12:
    var num = 1
    var summand = 1
    while true:
        var nFactors = 0
        for fac in factorsOf(num):
            nFactors += 1
        if nFactors > 500:
            return $num
        summand += 1
        num += summand

# Find the first ten digits of the sum of the sequence of 100 50-digit numbers
# Note that we are keeping the first 12 characters from each line because
# with 100 numbers, it's possible for the 10th digit value to be slightly
# larger depending on the sums of the 11th and 12th digits.
# SOLVED
problem 13:
    const nums = slurpAsset("p13.txt").splitLines()
    var sum = 0
    for num in nums:
        sum += parseInt($(num[0..11]))
    return ($sum)[0..9]

# Used in problem 14
proc collatzLen(n: int, memo: TableRef[int, int]): int =
    if n == 1:
        return 1
    if memo.hasKey(n):
        return memo[n]
    let next = if n mod 2 == 0: toInt(n / 2) else: (n * 3) + 1
    let len = 1 + collatzLen(next, memo)
    memo[n] = len
    return len
    
# Find the longest Collatz sequence that starts with a number less than 1_000_000
# Rules: n -> n/2 (n is even)
#        n -> 3n+1 (n is odd)
# SOLVED
problem 14:
    var memo = newTable[int, int]()
    var maxLen = 0
    var maxStart = 0
    for i in 1..999_999:
        let len = collatzLen(i, memo)
        if len > maxLen:
            maxStart = i
            maxLen = len
    return $maxStart


# Memoized recursive function used in problem 15.
proc routesBetween(x, y, ex, ey: int, memo: TableRef[tuple[x: int, y: int], int]): int =
    if x == ex or y == ey:
        return 1
    if memo.hasKey((x, y)):
        return memo[(x, y)]
    let routes = 
        routesBetween(x+1, y, ex, ey, memo) + 
        routesBetween(x, y+1, ex, ey, memo)
    memo[(x, y)] = routes
    return routes
    
# How many different routes are there from the top-left corner to the
# bottom-right corner of a 20x20 grid, only moving right and down?
# SOLVED
# Note: I have come to realize this can be solved extremely simply
# using the formula for distinguishable permutations. But I have kept my
# naive solution since it works and runs in <1ms.
problem 15:
    return $routesBetween(0, 0, 20, 20, newTable[tuple[x: int, y: int], int]())
    
