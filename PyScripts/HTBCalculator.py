def CalcHTBRank(ActiveSystemOwns, ActiveUserOwns , ActiveChallengeOwns, activeMachines, activeChallenges):
    """Part1 = (ActiveSystemOwns + (ActiveUserOwns / 2) + (ActiveChallengeOwns / 10))
    Part2 = ((activeMachines + (activeMachines / 2) + (activeChallenges / 10)) * 100)
    if((Part1 <= 0 and Part2 <= 0) or (Part2 <= 0)):
        Rankis = 0
    else:
        Rankis = (Part1 / Part2)
    if(Rankis > 100):
        Rankis = 100
    elif(Rankis < 0):
        Rankis = 0
    """
    Rankis = (ActiveSystemOwns + (ActiveUserOwns / 2) + (ActiveChallengeOwns / 10)) / (activeMachines + (activeMachines / 2) + (activeChallenges / 10)) * 100
    return Rankis

print("-*-"*20)
print(" "*17+"HackTheBox Calculator")
print("-*-"*20)
print("$ ActiveSystemOwns:  ")
ActiveSOwns = int(input())
print("$ ActiveUserOwns:  ")
ActiveUOwns = int(input())
print("$ ActiveChallengeOwns:  ")
ActiveCOwns = int(input())
print("$ activeMachines:  ")
ActiveM = int(input())
print("$ activeChallenges:  ")
ActiveC = int(input())
Rank = CalcHTBRank(ActiveSOwns, ActiveUOwns, ActiveCOwns, ActiveM, ActiveC )
SRank= str(Rank)
if(Rank <= 5):
    print("Noob Rank: "+ SRank+ "%")
elif(Rank <= 20):
    print("Script Kiddie Rank: "+ SRank + "%")
elif(Rank <= 45):
    print("Hacker Rank: "+ SRank + "%")
elif(Rank <= 70):
    print("Pro Hacker Rank: "+ SRank + "%")
elif(Rank <= 90):
    print("Elite Hacker Rank: "+ SRank + "%")
elif(Rank < 100):
    print("Guru Rank: "+ SRank+ "%")
elif(Rank == 100):
    print("Omniscient Rank: "+ SRank + "%")
 