from decimal import *

print("----"*20)

bonus=Decimal(input("Bonus from salary Investment: ")) # Bonus from salary. E.g. 15% of your salary
initial=Decimal(input("Initial Investment: "))
divi_percentage=(Decimal(input("Dividend Percentage: ")))/100
years=int(input("Years to calculate: "))
investment=initial+bonus
dividend=investment*divi_percentage

for i in range(1,years+1):
    print(f"Year {i}: \n | Dividend: {round(dividend,3)}€ \n | Investment: {round(investment,3)}€")
    print(" *")
    investment=investment+dividend+bonus
    dividend=investment*(divi_percentage)