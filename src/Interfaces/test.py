import re

txt = "info@cnbc"

#Check if the string has any digits:

password = re.search("([a-z]|[A-Z]|[0-9])+\@([a-z]|[A-Z]|[0-9])+((\.(([A-Z]|[a-z]|[0-9])+))|(\.(([A-Z]|[a-z]|[0-9])+)){2})$", txt)
begin = re.search("",txt)

if (password):
  print("YES! We have a match!")
else:
  print("No match")