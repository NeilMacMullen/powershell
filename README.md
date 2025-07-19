# Powershell scripts


This repository contains a number of powershell scripts I use.  You're welcome to use them too!

## Tab.ps1 

Useful if you tend to have a lot of terminal tabs open.  Simply call `tab.ps` to change the color of the tab header or rename it.
Even more handy if you use an alias..

```Powershell
set-alias -name t -value tab.ps1

# set the title of the tab
t build

# change the color of the tab to a new random color
t

# create a new tab with title and random color
t "this is a new tab" -newtab

```
<img width="808" height="362" alt="image" src="https://github.com/user-attachments/assets/fefac39f-37d1-4431-9dfa-ea16dcfca63a" />
