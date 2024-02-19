#!/bin/python3
user_hashes = 'user_hashes.txt' # Should look like this -> username:hash
hash_pass = 'cracked_hashes.txt' # Should look like this -> hash:password
output_file = 'output.txt'

Hash_pass_dic = {}
with open(hash_pass) as f: # Opens and automatically closes the hash_pass file.
    lines = f.readlines()
    for hashes in lines:
        temp_list = hashes.split(':') # Seperates hash from password, and stores them in a list.
        Hash_pass_dic[temp_list[0]] = temp_list[1].replace('\n', "") # Hash becomes key, pass becomes item
        temp_list.clear()
    

output = open(output_file, "w")
with open(user_hashes) as f: # Opens and automatically closes the hash_pass file.
    lines = f.readlines()
    for user_hash in lines:
        temp_list = user_hash.split(':') # Seperates user from hash, and stores them in a list.
        user0 = temp_list[0]
        hash1 = temp_list[1].replace('\n', '')
        if(hash1 in Hash_pass_dic.keys()):
            output.writelines(f'{user0}:{hash1}:{Hash_pass_dic[hash1]}\n')
        else:
            output.writelines(f'{user0}:{hash1}:#N/A\n')
        temp_list.clear()

output.close()
