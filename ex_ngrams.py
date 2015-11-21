#f = open("ngrams.txt",'r')
f = open("req_tweets.txt",'r')
g = open("req_labels.txt",'r')
for line,label in f,g:
    
    line = line.rstrip("\n")
    label = label.rstrip("\n")
    a = []
    a = line.split(" ")
    for k in range(len(a)-3):
        print a[k]+" "+a[k+1] + " "+ a[k+2] + label
