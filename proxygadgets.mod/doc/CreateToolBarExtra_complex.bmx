Rem
	CreateToolBarExtra
	2009-2014 degac (CC) www.graphio.net
End Rem

SuperStrict

Import MaxGui.Drivers
Import maxgui.proxygadgets

Framework BRL.GLMax2D
Import MaxGUI.MaxGUI
Import BRL.PNGLoader
Import BRL.Timer
Import BRL.EventQueue



'Global defaultLanguage:TMaxGUILanguage = LoadLanguage(DEFAULT_LANGUAGEPATH)
'SetLocalizationLanguage( defaultLanguage )
'SetLocalizationMode( LOCALIZATION_ON|LOCALIZATION_OVERRIDE )


Global lng:TMaxGuiLanguage=LoadLanguage("resources/italiano.language.ini")
SetLocalizationLanguage( lng )
SetLocalizationMode( LOCALIZATION_ON|LOCALIZATION_OVERRIDE )
Local window:TGadget
Local tabber:TGadget
Local document:TGadget[3]
Local currentdocument:TGadget

' CreateDocument creates a hidden panel that fills entire tabber client area 

Function CreateDocument:TGadget(tabber:TGadget)
	Local	panel:TGadget
	panel=CreatePanel(0,0,ClientWidth(tabber),ClientHeight(tabber),tabber)
	SetGadgetLayout panel,1,1,1,1
	HideGadget panel
	Return panel
End Function

' create a default window with a tabber gadget that fills entire client area

window=CreateWindow("{{window_title}}",30,20,400,300,,WINDOW_TITLEBAR|WINDOW_CENTER|WINDOW_RESIZABLE)
AppTitle="ToolBarExtra test 1"
tabber=CreateTabber(0,40,ClientWidth(window),ClientHeight(window),window)
SetGadgetLayout tabber,1,1,1,1 

' add three items and corresponding document panels to the tabber

Global window2:tgadget

window2=CreateWindow("Window 2",100,100,300,200,,WINDOW_TITLEBAR)
HideGadget WINDOW2

AddGadgetItem tabber,"{{btn_document}} 0",GADGETITEM_LOCALIZED,-1,""
AddGadgetItem tabber,"{{btn_document}} 1",GADGETITEM_LOCALIZED,-1,"Tabber Tip 1"
AddGadgetItem tabber,"{{btn_document}} 2",GADGETITEM_LOCALIZED,-1,"tips 4 2"

document[0]=CreateDocument(tabber)
document[1]=CreateDocument(tabber)
document[2]=CreateDocument(tabber)

SetPanelColor document[0],255,200,200
SetPanelColor document[1],200,255,200
SetPanelColor document[2],200,200,255

' our documents start off hidden so make first one current and show

currentdocument=document[0]
ShowGadget currentdocument


Local iconstr:TiconStrip=LoadIconStrip("resources/icons4.png")
Local tb:tToolbarExtra=tToolbarExtra.Create(document[0],iconstr)

Local tb1:tToolbarExtra=CreateToolbarExtra(window,iconstr)
Local cb:tToolItem

AddGadgetItem(tb1,"{{tb_new}}",TOOLBARITEM_BUTTON,0)
AddGadgetItem(tb1,"{{tb_open}}",TOOLBARITEM_BUTTON,1)
AddGadgetItem(tb1,"{{tb_close}}",TOOLBARITEM_BUTTON,2,"100")
AddGadgetItem(tb1,"{{tb_save}}",TOOLBARITEM_BUTTON,3,"100")
AddGadgetItem(tb1,"",TOOLBARITEM_SEPARATOR)
AddGadgetItem(tb1,"+",TOOLBARITEM_TEXTBUTTON,10	)
Local sw1:ttoolitem

sw1=tb1.AddItem(TOOLBARITEM_SWITCH,"Switch",2000,10)
sw1.SetSwitchIcon(9,10)

AddGadgetItem(tb1,"",TOOLBARITEM_SEPARATOR)
AddGadgetItem(tb1,"Home",TOOLBARITEM_BUTTON,19)
AddGadgetItem(tb1,"Back",TOOLBARITEM_BUTTON,20)
AddGadgetItem(tb1,"Forward",TOOLBARITEM_BUTTON,21)
AddGadgetItem(tb1,"",TOOLBARITEM_SEPARATOR)
AddGadgetItem(tb1,"Find",TOOLBARITEM_LABEL)

tb1.item_width=120
AddGadgetItem(tb1,"",TOOLBARITEM_TEXTFIELD)
tb1.item_width=60
AddGadgetItem(tb1,"Go",TOOLBARITEM_BUTTON,8)
AddGadgetItem(tb1,"Go",TOOLBARITEM_TEXTBUTTON,9	)



Local cb1:ttoolitem

tb1.AddSeparator()
cb1=tb1.AddItem(TOOLBARITEM_COMBOBOX,"Combo Box",999)

		cb1.AddSubItem("Item 1")
		cb1.AddSubItem("Item 2")
		cb1.AddSubItem("Item 3")
		cb1.AddSubItem("Item 4")
		cb1.AddSubItem("Item 5")
		cb1.SelectSubItem(2)

AddGadgetItem(tb1,"RADIO 1",TOOLBARITEM_RADIOBUTTON,900)
AddGadgetItem(tb1,"RADIO 2",TOOLBARITEM_RADIOBUTTON,900)


Print "State "+GadgetHidden(tb1)

DisableGadgetItem tb1,2


Print "Total items: "+CountGadgetItems(tb1)


Rem 
tb1.AddItem(TOOLBARITEM_BUTTON,"Add",1,0)
tb1.AddItem(TOOLBARITEM_BUTTON,"Remove",2,1)
tb1.AddSeparator()
tb1.AddItem(TOOLBARITEM_TEXTFIELD,"Query",3)
tb1.AddItem(TOOLBARITEM_BUTTON,"GO",4,3)
tb1.AddItem(TOOLBARITEM_BUTTON,"GO",5,3)
tb1.AddItem(TOOLBARITEM_LABEL,"Choose",6,3)
tb1.AddItem(TOOLBARITEM_SWITCH,"Debug",7,11)
tb1.AddSeparator()
cb=tb1.AddItem(TOOLBARITEM_COMBOBOX,"Combo Box")

		cb.AddSubItem("Item 1")
		cb.AddSubItem("Item 2")
		cb.AddSubItem("Item 3")
		cb.AddSubItem("Item 4")
		cb.AddSubItem("Item 5")
		cb.SelectSubItem(2)


tb1.AddSeparator()
tb1.AddItem(TOOLBARITEM_TEXTBUTTON,"Button")
tb1.AddItem(TOOLBARITEM_TEXTBUTTON,"Button")
tb1.AddItem(TOOLBARITEM_TEXTBUTTON,"Button")
tb1.AddSeparator()
tb1.AddItem(TOOLBARITEM_RADIOBUTTON,"Opt 1")
tb1.AddItem(TOOLBARITEM_RADIOBUTTON,"Opt 2")
EndRem 



'Local tb3:tToolbarExtra=CreateToolbarExtra(document[1],iconstr)
'AddGadgetItem(tb3,"Build",TOOLBARITEM_BUTTON,10)
'AddGadgetItem(tb3,"Build",TOOLBARITEM_TEXTBUTTON)
'DisableGadget TB3
'tb1.name="Toolbar window"
'tb.name="Toolbar panel"
Local sw:ttoolitem
	For Local test:Int=0 To 4
	sw=tb.AddItem(TOOLBARITEM_SWITCH,"GO "+test,10000+test,11)
	sw.SetSwitchIcon(11,12)
	Next

' standard message loop with special tabber EVENT_GADGETACTION and EVENT_GADGETMENU handling

Local btn1:tgadget=		CreateButton("{{btn_disable_toolbar}} panel",10,40,100,20,document[0])
Local btn2:tgadget=		CreateButton("{{btn_enable_toolbar}} panel",10,70,100,20,document[0])

Local btn3:tgadget=		CreateButton("{{btn_disable_toolbar}} main",120,40,100,20,document[0])
Local btn4:tgadget=		CreateButton("{{btn_enable_toolbar}} main",120,70,100,20,document[0])

Local btn5:tgadget=		CreateButton("Enable 2nd item",10 ,100,100,20,document[0])
Local btn6:tgadget=		CreateButton("Disable 2nd item",10,130,100,20,document[0])

Local btn7:tgadget=		CreateButton("Hide main"		,10 ,160,100,20,document[0])
Local btn8:tgadget=		CreateButton("Show main"		,10, 190,100,20,document[0])

Local btn71:tgadget=		CreateButton("Hide tb panel"		,120 ,160,100,20,document[0])
Local btn81:tgadget=		CreateButton("Show tb panel"		,120, 190,100,20,document[0])


Local btn9:tgadget=		CreateButton("English" ,240,40,100,20,document[0])
Local btn10:tgadget=		CreateButton("Italiano",240,70,100,20,document[0])

Local txtarea:tgadget		CreateTextArea(10,10,200,200,document[2])


SetGadgetLayout btn1,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn2,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn3,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn4,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn5,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn6,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn7,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn8,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn71,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn81,EDGE_ALIGNED,0,EDGE_ALIGNED,0

SetGadgetLayout btn9,EDGE_ALIGNED,0,EDGE_ALIGNED,0
SetGadgetLayout btn10,EDGE_ALIGNED,0,EDGE_ALIGNED,0



'SetGadgetColor tb1,200,180,160

RedrawGadget tb1

While WaitEvent()

	'Print "Event: "+CurrentEvent.tostring()

	Select EventID()
			Case EVENT_GADGETACTION
		
			Select EventSource()
				
				Case btn9
					'set english language
					
					lng=LoadLanguage("resources/english.language.ini")
					SetLocalizationLanguage( lng )
					Print "Set english language"
					RedrawGadget tb1		'need this to update language
				Case btn10
					'set italian language
					lng=LoadLanguage("resources/italiano.language.ini")
					SetLocalizationLanguage( lng )
					Print "Set italian language"
					RedrawGadget tb1		'need this to update language
				Case tabber
						HideGadget currentdocument
						currentdocument=document[EventData()]
						ShowGadget currentdocument

				Case btn1
						DisableGadget tb
						Print "Disable toolbar panel"
				Case btn2
						EnableGadget tb
						Print "Enable toolbar panel"

				Case btn3
						DisableGadget tb1

				Case btn4
						EnableGadget tb1

				Case btn5
						EnableGadgetItem tb,2
						Print "Enable button 3"
				Case btn6
						DisableGadgetItem tb,2
						Print "Disable button 3"
						
				Case btn7
						HideGadget tb1
						
				Case btn8
						ShowGadget tb1
						
				Case btn71
						HideGadget tb
						
				Case btn81
						ShowGadget tb
						
				
				
				Case tb1
					Print "ID: "+EventData()
					Print "EXTRA: <"+String(EventExtra())+">"
					
					If EventData()=5

						ShowGadget window2
					
					End If
					
					If EventData()=12
							Notify "Looking for '"+String(EventExtra())+"'"
					End If
			End Select
		
		
			
		Case EVENT_GADGETMENU
			If EventSource()=tabber
				Notify "You right clicked the tab with index " + EventData() + "!"
			EndIf
		Case EVENT_WINDOWCLOSE
			If EventSource()=window End
			If EventSource()=window2 HideGadget window2
	End Select
Wend
