from os import commandLineParams
from parseutils import parseInt

from util import runProblem, isProblemDefined

include problems

# Looks up problems and prints solutions
proc main() =
    for arg in commandLineParams():
        var num = 0
        discard parseInt(arg, num)
        
        if not isProblemDefined(num):
            echo("\t\t'", $arg, "' is not a valid problem.")
            continue
            
        let (res, time) = runProblem(num)
        echo("\t\t", num, " : ", res, " in ", time * 1000, "ms")

main()
