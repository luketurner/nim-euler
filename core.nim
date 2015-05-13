from tables import initTable, hasKey, `[]`, `[]=`
from times import cpuTime

var problemTable = initTable[int, proc():string]()

proc registerProblem(i: int, f: proc():string) =
    problemTable[i] = f
    
template problem*(i: expr, body: stmt): stmt {.immediate.} =
    registerProblem(i, proc():string =
        body)
        
proc runProblem*(probNum: int): tuple[res: string, time: float] =
    ## Looks up problem and returns solution
    let startTime = cpuTime()
    let res = problemTable[probNum]()
    let endTime = cpuTime() - startTime
    return ($res, endTime)
    
proc isProblemDefined*(probNum: int): bool = problemTable.hasKey(probNum)