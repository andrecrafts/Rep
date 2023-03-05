import subprocess
import re
data = subprocess.check_output(['netsh', 'wlan', 'show', 'profiles']).decode('utf-8')
pattern = ': .{1,20}'
all_matches = re.finditer(pattern, data)
Profiles = []
for matches in all_matches:
    matchstring = (matches.group())[2:]
    Profiles.append(matchstring)
    
for profile in Profiles:
    profileR = profile.replace("\r", "")
    data = subprocess.check_output(["netsh", "wlan", "show", "profile", "name=" + f"{profileR}", "key=clear"]).decode('utf-8')
    pattern = 'Key Content\s+: .{1,30}'
    all_keys = re.finditer(pattern, data)
    for key in all_keys:
        keystring = (key.group())[25:]
        keyR = keystring.replace("\r", "")
        print(f'{profileR:<30} | {keystring}')
