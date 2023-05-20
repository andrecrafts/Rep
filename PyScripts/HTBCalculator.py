from decimal import Decimal
import math
ActiveSystemOwns = Decimal(input('How many Root owns you did? '))
ActiveUserOwns = Decimal(input('How many User owns you did? '))
ActiveChallengeOwns = Decimal(input('How many Challenges you completed (ChallengeOwns)? '))
activeMachines = Decimal(input('How many active Machines exist? '))
activeChallenges = Decimal(input('How many active Challenges exist? '))

Points = (ActiveSystemOwns + (ActiveUserOwns / 2) + (ActiveChallengeOwns / 10)) / (activeMachines + (activeMachines / 2) + (activeChallenges / 10)) * 100
Points = round(Points, 5)
print("---"*20)
if(Points <= 5):
    print(f"Noob Rank: {Points}%")
elif(Points <= 20):
    print(f"Script Kiddie Rank: {Points}%")
elif(Points <= 45):
    print(f"Hacker Rank: {Points}%")
elif(Points <= 70):
    print(f"Pro Hacker Rank: {Points}%")
elif(Points <= 90):
    print(f"Elite Hacker Rank: {Points}%")
elif(Points < 100):
    print(f"Guru Rank: {Points}%")
elif(Points == 100):
    print(f"Omniscient Rank: {Points}%")
print("---"*20)
