# Evaluate the sum of all amicable numbers under 10000.
# Numbers are amicable if sum_of_divisors(a) == b and sum_of_divisors(b) == a and a != b
# SOLVED
# Method: build table of factor-sums, then use that to find amicable numbers
problem 21:
    var factorSum = newTable[int, int]()
    var amicableSum, sum: int
    for i in 1..9999:
        sum = 0
        for fac in i.factors():
            if fac != i:
                sum += fac
        factorSum[i] = sum
    for i in 1..9999:
        sum = factorSum[i]
        if 0 < sum and sum < 10000 and factorSum[sum] == i and sum != i:
            amicableSum += i
    return $amicableSum

# Find the total of the "scores" for each name in the document.
# Name score given by (sum of lexicographical values)*(position in sorted list)
#problem 22:
#    const names = util.slurpAsset("p22.txt").replace("\"","").split(",")
#    var scoreTable = newTable[string, int]()
#    let numNames = names.len
#    for name in names:
#        scoreTable[name] = name.mapIt(int, ord(it) - 40).foldl(a + b)
#    echo "table made"
#    var newNames = algorithm.sort(names, proc(x, y: string): int =
#        system.cmp(scoreTable[x], scoreTable[y]))
#    echo "sorted"
#
#    return $123
