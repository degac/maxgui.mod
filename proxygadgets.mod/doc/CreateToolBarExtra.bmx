Rem
		ToolBarExtra
		basic example
		
		see _complex example
End Rem

SuperStrict
Import maxgui.drivers
Import maxgui.proxygadgets

Global window:tgadget=		CreateWindow("Main",100,100,600,300,,WINDOW_RESIZABLE|WINDOW_TITLEBAR|WINDOW_CENTER)
Local textarea:Tgadget=		CreateTextArea(5,150,280,100,window)
Local ics:TiconStrip=LoadIconStrip("resources/icons4.png")

Global tb1:TtoolbarExtra=CreateToolbarExtra(window,ics)

AddGadgetItem tb1,"Button 1",TOOLBARITEM_BUTTON,1		'0
AddGadgetItem tb1,"Button 2",TOOLBARITEM_BUTTON,2		'1
AddGadgetItem tb1,"Button 3",TOOLBARITEM_BUTTON,3		'2
AddGadgetItem tb1,"Button 4",TOOLBARITEM_SWITCH,5		'3	icon 6 is the default
AddGadgetItem tb1,"Button 5",TOOLBARITEM_BUTTON,8		'4
AddGadgetItem tb1,"Search",TOOLBARITEM_LABEL			'5
AddGadgetItem tb1,"Type here",TOOLBARITEM_TEXTFIELD	'6
AddGadgetItem tb1,"Go...",TOOLBARITEM_BUTTON,8		'7
AddGadgetItem tb1,"%V",TOOLBARITEM_SLIDER,9			'8
Local it1:TtoolItem
'				type of the item, 'tips/title', EventData(), icon
it1=tb1.AddItem(TOOLBARITEM_SWITCH,"Switch",2000,11)	'2000 ---> in EventData()
it1.SetSwitchIcon(9,10)
it1=tb1.AddItem(TOOLBARITEM_SLIDER,"Value %V",2100)
it1.SetProp("range","0,9")
it1.SetProp("value","0")

Local btn1:tgadget=	CreateButton("Disable toolbar",10,50,100,25,window)
Local btn2:tgadget=	CreateButton("Disable 3rd item",10,80,100,25,window)
Local btn3:tgadget=	CreateButton("Remove 4th item",10,105,100,25,window)
Local btn4:tgadget=	CreateButton("Enable toolbar",110,50,100,25,window)

CreateLabel "Please resize the window to see the effect on the toolbar",300,150,100,100,window

Repeat
	WaitEvent()
	
	Select EventID()
		Case EVENT_APPTERMINATE, EVENT_WINDOWCLOSE
			End
		Case EVENT_GADGETACTION
			Select EventSource()
				Case btn1	DisableGadget tb1
				Case btn4	EnableGadget tb1
				
				Case btn2
						DisableGadgetItem tb1,2 'count from 0...
				Case btn3
						RemoveGadgetItem tb1,3	'count from 0...
				Case tb1	'check the toolbar items...
					Select EventData()
						Case 6
							AddTextAreaText textarea,"You typed: "+String(EventExtra())+"~n"
						Case 7	'the button 'go'
							AddTextAreaText textarea,"Go: "+GadgetItemText(tb1,6) 
						Case 2000	'see AddItem above
						Case 2100	'see AddItem above
							Print "Slider 2 : "+EventMods()
					End Select
			End Select
	End Select
Forever
