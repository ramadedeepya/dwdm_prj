require 'torch'
require 'nn'

file1 = io.open("uniq_50ktokens.txt",'r')
filem = io.open("final_50kfilinput.txt",'r')
file3 = io.open("word_emb.txt",'w')
-- Step 1: Define your vocabulary map
vocab={}
ctr = 1;
for line in io.lines("uniq_50ktokens.txt")
do
     vocab[line] = ctr
     ctr = ctr+1
end

-- Step 2: Define constants
vocab_size=ctr-1
word_embed_size=10
learning_rate=0.01
window_size=2
max_epochs=10
neg_samples_per_pos_word=2

--Step 4: Define your model
wordLookup=nn.LookupTable(vocab_size,word_embed_size)
contextLookup=nn.LookupTable(vocab_size,word_embed_size)
model=nn.Sequential()
model:add(nn.ParallelTable())
model.modules[1]:add(contextLookup)
--wordlookup_clone=actuallookup:clone("weight","bias","gradWeight","gradBias")
model.modules[1]:add(wordLookup)
model:add(nn.MM(false,true)) -- 'true' to transpose the word embeddings before matrix multiplication
--model:add(nn.Sigmoid())
model:add(nn.HardTanh())
model:add(nn.LogSoftMax())
-- Step 5: Define the loss function (Binary cross entropy error)
criterion=nn.BCECriterion()
-- Step 6: Define the trainer
trainer=nn.StochasticGradient(model,criterion)
trainer.learningRate=learning_rate
trainer.maxIteration=max_epochs

--print('Word Lookup before learning')
--print(wordLookup.weight)
--------------------------------------------------------------------------------------------------------------------
--polarity

-- Step 4: Define your model
wordLookup_p = wordLookup:clone()
--wordLookup=nn.LookupTable(vocab_size,word_embed_size)
--contextLookup=nn.LookupTable(vocab_size,word_embed_size)
contextLookup_p=contextLookup:clone("weight","bias","gradWeight","gradBias")
model_p=nn.Sequential()
model_p:add(nn.ParallelTable())
model_p.modules[1]:add(contextLookup_p)
--wordlookup_clone=actuallookup:clone("weight","bias","gradWeight","gradBias")
model_p.modules[1]:add(wordLookup_p)
model_p:add(nn.MM(false,true)) -- 'true' to transpose the word embeddings before matrix multiplication
model_p:add(nn.HardTanh())
--model:add(nn.Sigmoid())

model:add(nn.LogSoftMax())

-- Step 5: Define the loss function (Binary cross entropy error)
criterion=nn.BCECriterion()

-- Step 6: Define the trainer
trainer_p=nn.StochasticGradient(model_p,criterion)
trainer_p.learningRate=learning_rate
trainer_p.maxIteration=max_epochs

--print('Word Lookup before learning')
--print(wordLookup_p.weight)
---------------------------------------------------------------------------------------------------------------------
-- Step 3: Prepare your dataset
count = 1
batch = 50
word = {}
context = {}
context_pol = {}
label = {}
pol = {}
dataset={}
dataset_p={}
array = {}
for m in filem:lines() 
do
    table.insert(array,m);
end
total_batches = table.getn(array)/batch
--total_batches = 500
while(count<total_batches)
do 
   
   itr = 1
   --print("vjhjh")
   --print(count)
   strt = count
   for line=strt,batch+strt,1
   do
     count = count + 1
     a = array[line]:split(" ")
     k = 0
     while(k<2)
     do
         rand_num = math.random(ctr-1)
         if((rand_num~=vocab[a[1]]) and (rand_num~=vocab[a[3]]))
         then
               if (k==0)
               then
                   neg1 = rand_num
                   k = k+1
               end
               if (k==1)
               then
                   neg2 = rand_num
                   k = k+1
               end
         end
     end
     word[itr] = torch.Tensor{vocab[a[2]]}
     context[itr] = torch.Tensor{vocab[a[1]],vocab[a[3]],neg1,neg2}
     context_pol[itr] = torch.Tensor{vocab[a[1]],vocab[a[3]]}
     label[itr] =   torch.Tensor({1,1,0,0})  
     pol[itr] = torch.Tensor{a[4],a[4]}      
     itr = itr+1
   end
   function dataset:size() return itr-1 end
   for i=1,dataset:size()
   do
      dataset[i] = {{context[i],word[i]},label[i]}
   end
   trainer:train(dataset)

   function dataset_p:size() return itr-1 end
   for i=1,dataset_p:size()
   do
    dataset_p[i] = {{context_pol[i],word[i]},pol[i]}
   end
   trainer_p:train(dataset_p)
end
--print('\nWord Lookup after learning b4 senti')
--print(wordLookup.weight)
print('\nWord Lookup after learning')
print(wordLookup_p.weight)
--file3:write(wordLookup_p.weight)
