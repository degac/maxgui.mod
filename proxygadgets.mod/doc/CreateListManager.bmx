Rem
	CreateListManager
	2009-2014 degac (CC) www.graphio.net
End Rem
SuperStrict
Import MaxGUI.Drivers
Import maxgui.proxygadgets
Local window:TGadget = CreateWindow("ListManager v. 2.2",0,0,660,330,,WINDOW_TITLEBAR|WINDOW_CENTER)

'this opens a ListManager that handles user-text-item ORDERED
Local listbox1:tlistManager=CreateListManager( 10,10,210,200,window,LIST_ITEMS|LIST_FORCEORDER)
'this opens a ListManager that handles files (default LIST_FILES|LIST_SHOWONLYNAME)
Local listbox2:tlistManager=CreateListManager(220,10,210,200,window)
'this opens a ListManager that handles user-text-item not ordered
Local listbox3:tlistManager=CreateListManager(430,10,210,200,window,LIST_ITEMS)


Local px1:TPixmap=LoadPixmap("resources/lsman_icon3.png")
Local px2:TPixmap=LoadPixmap("resources/lsman_icon1.png")

SetGadgetPixmap listbox1,px1
SetGadgetPixmap listbox2,px2
'SetGadgetPixmap listbox3,px2


'DisableGadget listbox2
'HideGadget listbox1
'Print "Is hidden ?"+GadgetHidden(listbox1)

'ShowGadget listbox1
'Print GadgetHidden(listbox1)

'remember to set the Filter...

listbox2.SelectFilter("JPG;PNG")
listbox2.SelectPath("C:\")


Local button1:tgadget	=CreateButton("Disable 1",	 10,230,80,25,window)
Local button2:tgadget	=CreateButton("Enable 1",	100,230,80,25,window)
Local button3:tgadget	=CreateButton("Get list 1",	 10,260,80,25,window)
Local button4:tgadget	=CreateButton("Get list 2",	100,260,80,25,window)


Local array:String[]=["This","is","a","test"]

'listbox3.SetItemArray(array)
listbox1.SetItemArray(array)
AddGadgetItem listbox1,"This is a new line #1",0,-1,"Nothing",Null
'Rem
AddGadgetItem listbox1,"This is a new line #2"
AddGadgetItem listbox1,"This is a new line #3"
AddGadgetItem listbox1,"This is a new line #4"
AddGadgetItem listbox1,"This is a new line #5"
'end Rem
InsertGadgetItem listbox1,2,"0--Inserted---"

Local ins:String[]=listbox1.GetItemArray()

Print "How many items in listbox1? :" +CountGadgetItems(listbox1)


Local _terminate:Int=False

While _terminate=False
	WaitEvent
		Select EventID()
		
		Case EVENT_GADGETACTION
			If EventSource()=button1	DisableGadget listbox1
			If EventSource()=button2	EnableGadget listbox1
			
			If EventSource()=button3
				Print "Count: "+CountGadgetItems(listbox1)
				
				For Local ss:Int=0 Until CountGadgetItems(listbox1)
					Print ss+" "+GadgetItemText(listbox1,ss)
				Next
			End If
			
			If EventSource()=button4
				Local ob:Object
				Print "Count: "+CountGadgetItems(listbox2)
				For Local ss:Int=0 Until CountGadgetItems(listbox2)
					ob=GadgetItemExtra(listbox2,ss)
					Print ss+" {"+String(ob)+"}"
				Next
			End If
			
		
						
		Case EVENT_WINDOWCLOSE
			If EventSource() = window _terminate=True
		End Select
Wend

FreeGadget listbox1
FreeGadget listbox2
End


