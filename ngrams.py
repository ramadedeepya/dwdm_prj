import sys
f = open(sys.argv[1],'r')
ngrams = []
for line in f:
     line = line.rstrip("\n")
     a = []
     a = line.split(" ")
     if sys.argv[2] == "uni":
        for k in a:
           ngrams.append(k)
     if sys.argv[2] == "bi":
        for k in range(len(a)-1):
            p = []
            p.append(a[k])
            p.append(a[k+1])
            ngrams.append(p)
     if sys.argv[2] == "tri":
        for k in range(len(a)-2):
            p = []
            p.append(a[k])
            p.append(a[k+1])
            p.append(a[k+2])
            ngrams.append(p)
if sys.argv[2] == "uni":
     for i in ngrams:
            print i
if sys.argv[2] == "bi":
     for k in ngrams:
             print k[0] + " " + k[1]
if sys.argv[2] == "tri":
     for k in ngrams:
             print k[0] + " " + k[1] + " " + k[2]

  
        

