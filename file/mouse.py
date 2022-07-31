import sys
from os import system
system("title " + "mouse")
import pyautogui as g
#x y click key
loop = True
while loop:
    x = sys.argv[1]
    y = sys.argv[2]
    g.moveTo(x, y)

    click = sys.argv[3]
    if not click == 0:
        if click == "left":
            g.click(button='left')
        if click == "right":
            g.click(button='right')
        if click == "middle":
            g.click(button='middle')

    key = sys.argv[4]
    if not key == 0:
        g.typewrite(key)