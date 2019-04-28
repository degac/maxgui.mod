Rem
		CreateTabberManager()
		2013-2014 degac (cc) - www.graphio.net		
End Rem


SuperStrict
Import maxgui.drivers
Import maxgui.proxygadgets
Local icons:Ticonstrip=LoadIconStrip("resources/lsman_icon1.png")
Global window:tgadget=		CreateWindow("Main",100,100,300,300,,WINDOW_TITLEBAR|WINDOW_CENTER)
Local tbm:Tgadget=CreateTabberManager(0,10,ClientWidth(window),200,window)
'you can add Icons to the tabs
SetGadgetIconStrip tbm,icons
'add some tabs
AddGadgetItem tbm,"First",,0,"Primo pannello"
AddGadgetItem tbm,"Second",,1
AddGadgetItem tbm,"Third"
AddGadgetItem tbm,"Wrong"
'select the first one (index from 0)
SelectGadgetItem tbm,0
'disable 2nd panel
DisableGadgetItem tbm,1
Rem
	tabbermanager's GadgetExtra() contains an array of
	gadgets; this array refers to the each 'tab'
	to attach gadget on any single panel/tab you need
	to access this array.
	You can access directly to the ProxyGadget
	
	Local tabbers:tgadget[]=ttabberManager(tbm).documents

	or using the following way to cast
	
	Local tabbers:tgadget[]=tgadget[](GadgetExtra(tbm))

End Rem

'get the 'panels' as array of MaxGUI Tgadget
Local tabbers:tgadget[]=tgadget[](GadgetExtra(tbm))
If tabbers<>Null
	Print "Total tabbers: "+tabbers.length
Else
	Print "No tabs?"
End If

Local Btn:TGADGET[5]
BTN[2]=CreateButton("Disable",10,220,80,25,window)
BTN[3]=CreateButton("Enable",100,220,80,25,window)
SetGadgetColor tabbers[0],200,100,150
btn[0]=CreateButton("Enable 2nd panel",10,10,100,25,tabbers[0])
btn[1]=CreateButton("Disalbe 2nd panel",10,40,100,25,tabbers[0])
Local p:tgadget=tabbers[1]
For Local s:Int=1 To 3
	CreateButton("Option "+s,20,20+s*25,100,24,p,BUTTON_CHECKBOX)
Next
p:tgadget=tabbers[2]
For Local s:Int=1 To 3
	CreateButton("Radio "+s,20,20+s*25,100,24,p,BUTTON_RADIO|BUTTON_PUSH)
Next
Rem
	You can use the standard MaxGUI commands to
	- Remove a tab (RemoveGadgetItem)
	- Remove all tabs (ClearGadgetItems)
	- Modify a tab (ModifyGadgetItem)
End Rem

'RemoveGadgetItem tbm,3
'ClearGadgetItems tbm

ModifyGadgetItem tbm,0,"NewAlpha",,3,"new name"

'End Rem
Repeat
	WaitEvent()
	
	Select EventID()
		Case EVENT_APPTERMINATE, EVENT_WINDOWCLOSE
			End
		Case EVENT_GADGETACTION
			Select EventSource()
				Case Btn[0]
					EnableGadgetItem tbm,1
				Case btn[1]
					DisableGadgetItem tbm,1
				Case btn[3]	EnableGadget tbm
				Case btn[2]	DisableGadget tbm
				
			
			End Select
	End Select
Forever



