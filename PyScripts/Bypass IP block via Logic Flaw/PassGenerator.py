#!/bin/python #By WafflesExploits
Wordlist = 'pass.txt' #Password Wordlist
Output = 'output.txt'
valid_password = 'peter' # The valid password is always going to be the 2 attempt. So, put the valid username in second as well.

file = open(Output, "w+")
count = 0
with open(f'{Wordlist}') as f: # Opens and automatically closes the passwordfile.
    lines = f.readlines()
    for password in lines:
      file.write(password)
      file.write(valid_password+"\n")
      count += 1

file.close()