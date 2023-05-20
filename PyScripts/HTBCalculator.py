from decimal import Decimal
ActiveSystemOwns = Decimal(input('How many Root owns you did? '))
ActiveUserOwns = Decimal(input('How many User owns you did? '))
ActiveChallengeOwns = Decimal(input('How many Challenges you completed (ChallengeOwns)? '))
activeMachines = Decimal(input('How many active Machines exist? '))
activeChallenges = Decimal(input('How many active Challenges exist? '))

Points = (ActiveSystemOwns + (ActiveUserOwns / 2) + (ActiveChallengeOwns / 10)) / (activeMachines + (activeMachines / 2) + (activeChallenges / 10)) * 100
print(f"{Points}%")
