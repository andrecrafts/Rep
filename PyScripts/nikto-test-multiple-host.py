#!/usr/bin/env python3
# Made by WafflesExploits
import re
import subprocess
import argparse
import sys
import os

parser = argparse.ArgumentParser(description='Test multiple hosts on nikto. Provide a list of hosts in a file.', formatter_class=argparse.RawTextHelpFormatter)
parser.add_argument('-hf','--hosts-file', type=str, help="Path to file containing hosts.")
args = parser.parse_args()

if(not(args.hosts_file)):
    parser.print_help()
    sys.exit()

# Define variables
hosts_file = args.hosts_file
# Functions
def convert_to_output_file(host_name):
    host_output1 = re.sub('://', '.', host_name)
    host_output1 = re.sub('/.*', '', host_output1) + ".txt"
    return host_output1

# Grab hosts
hosts_list = []
with open(hosts_file) as f:
    hosts_list = re.sub('\n$', '', f.read()) # Reads File and removes last \n character
hosts_list = hosts_list.split('\n')

# Run commands
for host in hosts_list:
    print(f'*Started scanning {host}*')
    host_output = convert_to_output_file(host)
    os.mkdir('./nikto_results')
    cmd = (f'nikto -h {host} -o ./nikto_results/{host_output}').split(' ')
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    o, e = proc.communicate()
    print(f'*Terminated scanning {host}*')


#print('Output: ' + o.decode('ascii'))
#print('Error: '  + e.decode('ascii'))
#print('code: ' + str(proc.returncode))
