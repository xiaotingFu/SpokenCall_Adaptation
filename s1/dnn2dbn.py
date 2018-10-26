import sys

with open(sys.argv[1], 'r') as theFile:
    theLines = theFile.readlines()

endIndex = len(theLines) - 1

for i in range(2, len(theLines)+1):
    if("Transform" in theLines[-i]):
        endIndex = len(theLines) - i
        break

with open(sys.argv[2], 'w') as theOutput:
    for j in range(0, endIndex):
        theOutput.write(theLines[j])
    theOutput.write("</Nnet> \n")
