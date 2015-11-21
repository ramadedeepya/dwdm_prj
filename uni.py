import sys
f = open(sys.argv[1],'r')
a=[]
for line in f:
    line = line.rstrip("\n")
    if line not in a:
         a.append(line)
for k in a:
    print k
     
