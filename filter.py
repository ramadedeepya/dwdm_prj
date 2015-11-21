import string
f = open("listTweets.txt",'r')
for line in f:
    line = line.rstrip("\n")
    line = line.strip(" </s>")
    line = line.strip("<s>")
    line = ''.join([i for i in line if i not in string.punctuation])
    line = line.rstrip(" ")
    print line
    
