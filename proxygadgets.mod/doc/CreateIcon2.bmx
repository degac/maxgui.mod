
'BlitzMax program : 07 Aug 2015 16:59:19
'Template         : template_maxgui.bmx

SuperStrict
Import maxgui.drivers
Import maxgui.proxygadgets


Global window:tgadget=		CreateWindow("Main",100,100,300,300,,WINDOW_TITLEBAR|WINDOW_CENTER)

Local pix_timer:ticonstrip=LoadIconStrip("resources/icon_timer17.png")


Local ic_timer:tgadget=CreateIconGadget(275,100,24,24,window,pix_timer)





Repeat
	WaitEvent()
	
	Select EventID()
		Case EVENT_APPTERMINATE, EVENT_WINDOWCLOSE
			End
	End Select
Forever
