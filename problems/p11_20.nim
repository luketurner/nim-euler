# Find the greatest product of four adjacent numbers in the same direction in the grid below.
# SOLVED
# Method: Tokenize grid into flat numeric array and iterate over all possible rows/diagonals/columns.
problem 11:
    var maxProd = 0
    const gridString = util.slurpAsset("p11.txt")
    # parse string into a seq
    var grid = newSeq[int]()
    for t in gridString.tokenize:
        if not t[1]:
            grid.add(t[0].parseInt)
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
# Method: Simple iterative search using helper factorsOf proc
problem 12:
    var num = 1
    var summand = 1
    while true:
        var nFactors = 0
        for fac in num.factors:
            nFactors += 1
        if nFactors > 500:
            return $num
        summand += 1
        num += summand

# Find the first ten digits of the sum of the sequence of 100 50-digit numbers
# SOLVED
# Method: Calculate sum, discarding insignificant digits
# Note that we are keeping the first 12 characters from each line because
# with 100 numbers, it's possible for the 10th digit value to be slightly
# larger depending on the sums of the 11th and 12th digits.
problem 13:
    const nums = util.slurpAsset("p13.txt").splitLines()
    var sum = 0
    for num in nums:
        sum += ($num[0..11]).parseInt
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
# Method: using memoized collatz length function
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
# Method: Count the routes using depth-first search 
problem 15:
    return $routesBetween(0, 0, 20, 20, newTable[util.Point, int]())

# What is the sum of the digits of the number 2^1000?
# SOLVED
# Method: Use bignum implementation
problem 16:
    var num = 1.toBignum
    var sum = 0
    for i in 1..1000:
        num *= 2
    for i in num.digits:
        sum += i
    return $sum

proc letterize(x: int): string =
    return case x
        of 0: "" # usually zeros are silent
        of 1: "one"
        of 2: "two"
        of 3: "three"
        of 4: "four"
        of 5: "five"
        of 6: "six"
        of 7: "seven"
        of 8: "eight"
        of 9: "nine"
        of 10: "ten"
        of 11: "eleven"
        of 12: "twelve"
        of 13: "thirteen"
        of 14: "fourteen"
        of 15: "fifteen"
        of 18: "eighteen"
        of 16, 17, 19: letterize(x - 10) & "teen"
        of 20..29: "twenty"  & letterize(x mod 10)
        of 30..39: "thirty"  & letterize(x mod 10)
        of 40..49: "forty"   & letterize(x mod 10)
        of 50..59: "fifty"   & letterize(x mod 10)
        of 60..69: "sixty"   & letterize(x mod 10)
        of 70..79: "seventy" & letterize(x mod 10)
        of 80..89: "eighty"  & letterize(x mod 10)
        of 90..99: "ninety"  & letterize(x mod 10)
        of 100..999: (x / 100).floor.toInt.letterize &
            (if x mod 100 == 0: "hundred" else: "hundredand") &
            letterize(x mod 100)
        of 1000: "onethousand"
        else: ""

# If 1..1000 were written in words, how many letters would be used?
# SOLVED
# Method: Recursive case/of statement
problem 17:
    var totalLen = 0
    for i in 1..1000:
        totalLen += i.letterize.len
    return $totalLen

proc findPath(pyramid: TableRef[Point, int], memo: TableRef[Point, int], coords: Point): int =
    if not pyramid.hasKey(coords):
        return 0
    if memo.hasKey(coords):
        return memo[coords]
    let (x, y) = coords
    let result = pyramid[coords] + max(
        findPath(pyramid, memo, (x: x, y: y+1)),
        findPath(pyramid, memo, (x: x+1, y: y+1)))
    memo[coords] = result
    return result


# Find the path from the top of the triangle to the bottom which has the
# greatest value.
# SOLVED
# Method: Dynamic programming (memoized recursion)
# Note: Also solves problem 67
problem 18:
    const pyramidLines = util.slurpAsset("p18.txt").splitLines()
    var pyramid = newTable[Point, int]()
    for y in 0..(pyramidLines.high):
        let nums = pyramidLines[y].split()
        for x in 0..(nums.high):
            pyramid[(x, y)] = nums[x].parseInt
    echo pyramid[(0, 75)]
    return $findPath(pyramid, newTable[Point, int](), (0, 0))

# How many months started with Sunday between 1901-01-01 and 2000-12-31?
# Note, 1 Jan 1901 was Tuesday
# SOLVED
# Method: Keep track of the day while iterating over all months in the century
problem 19:
    var day, numMonths: int
    day = 1
    for year in 1901..2000:
        for month in 1..12:
            if (day mod 7) + 1 == 6:
                numMonths += 1
            day += (case month
                of 4, 6, 9, 11: 30
                of 2:
                    if year mod 4 == 0 and (year mod 100 != 0 or year mod 400 == 0):
                        29
                    else:
                        28
                else: 31)
    return $numMonths

# Find the sum of the digits in the number 100!
# SOLVED
# Method: Use bignum implementation
problem 20:
    var num = 1.toBignum
    var sum = 0
    for n in 1..100:
        num *= n
    for n in num.digits:
        sum += n
    return $sum
