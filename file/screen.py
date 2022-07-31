import os
import sys
from tkinter import *
from tkinter import messagebox
root = Tk()
label = Label(root)
label.pack()
partnerid = sys.argv[1]
def left(event):
    os.system('echo left > server\click.txt')
    os.system('curl -X PUT --upload-file server\click.txt https://', partnerid, '.ap.ngrok.io')
def middle(event):
    os.system('echo middle > server\click.txt')
    os.system('curl -X PUT --upload-file server\click.txt https://', partnerid, '.ap.ngrok.io')
def right(event):
    os.system('echo right > server\click.txt')
    os.system('curl -X PUT --upload-file server\click.txt https://', partnerid, '.ap.ngrok.io')
def location(event):
    os.system('echo ', event.x, " > server\x.txt")
    os.system('curl -X PUT --upload-file server\x.txt https://', partnerid, '.ap.ngrok.io')
    os.system('echo ', event.y, " > server\y.txt")
    os.system('curl -X PUT --upload-file server\y.txt https://', partnerid, '.ap.ngrok.io')
def letter(event):
    key = '%s' %event.char
    os.system('echo ', key, ' > key.txt')
def on_closing():
    if messagebox.askokcancel("Quit", "Do you want to quit?"):
        os.system('echo > server\exit.txt')
        os.system('curl -X PUT --upload-file server\exit.txt https://', partnerid, '.ap.ngrok.io')
        root.destroy()
width= root.winfo_screenwidth()
height= root.winfo_screenheight()
root.geometry("%dx%d" % (width, height))
root.protocol("WM_DELETE_WINDOW", on_closing)
root.bind("<Key>",letter)
root.bind("<Button-1>", left)
root.bind("<Button-2>", middle)
root.bind("<Button-3>", right)
#root.bind("<Motion>", lambda event: label.configure(text=f"{event.x}, {event.y}"))
root.bind("<Motion>", location)

photo = PhotoImage(file = 'server\screenshot.png')
root.update()

canvas = Canvas(root)
canvas.pack(expand=YES, fill=BOTH)

img = canvas.create_image(0,0, anchor="nw", image=photo)
root.after(20000, lambda: canvas.delete(img))
root.mainloop()