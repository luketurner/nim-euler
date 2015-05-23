problem 67:
    const pyramidLines = util.slurpAsset("p67.txt").splitLines()
    var pyramid = newTable[Point, int]()
    for y in 0..(pyramidLines.high):
        let nums = pyramidLines[y].split()
        for x in 0..(nums.high):
            pyramid[(x, y)] = nums[x].parseInt
    return $findPath(pyramid, newTable[Point, int](), (0, 0))

