cd "C:\Users\muchhal1\OneDrive - Michigan State University\EC422\Project\Aria\Project_Aria"
clear
* OPEN LOG FILE
log using ProjectFigsLog.txt, text replace
* Draw Figure 1: (1a and 1b)
do FIGURE1.do
* Draw Figure 2
do FIGURE2.do
* Draw Figure 3
do FIGURE3.do
*clear
log close
exit
