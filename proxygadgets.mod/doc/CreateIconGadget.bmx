Rem
		CreateIconGadget
End Rem
SuperStrict 
Import MaxGui.Drivers
Import maxgui.proxygadgets
Local pix:ticonstrip=LoadIconStrip("resources/alert_animated.png")
Local pix2:ticonstrip=LoadIconStrip("resources/level.png")
Local pix3:TPixmap=LoadPixmap("resources/time.png")
Local pix4:ticonstrip=LoadIconStrip("resources/icon_timer17.png")
Local window:TGadget = CreateWindow("CreateIconGadget", 100, 100, 420, 280, Null, WINDOW_TITLEBAR|WINDOW_CENTER )

Local ic1:Tgadget=CreateIconGadget(10,10,64,64,window,pix4)
Local ic2:Tgadget=CreateIconGadget(160,10,48,48,window,pix2)',ICON_GADGET_STATIC)
Local ic3:tgadget=CreateIconGadget(10,80,64,64,window,pix3)
Local ic4:tgadget=CreateIconGadget(275,100,24,24,window,pix2,ICON_GADGET_STATIC)

SelectGadgetItem ic2,2
DisableGadget ic3

Local btn:tgadget[8]

btn[0]=	CreateButton("Enable" ,10,150,100,25,window)
btn[1]=	CreateButton("Disable",10,180,100,25,window)

btn[2]=	CreateButton("Show" ,120,150,100,25,window)
btn[3]=	CreateButton("Hide",120,180,100,25,window)

btn[5]=	CreateButton("Change",240,180,100,25,window)
btn[6]=	CreateButton("Start/Stop",120,210,100,25,window)
btn[7]=	CreateButton("Get Info",10,210,100,25,window)
btn[4]=	CreateSlider(240,150,100,20,window,SLIDER_TRACKBAR|SLIDER_HORIZONTAL)

SetSliderRange btn[4],0,10
SetSliderValue btn[4],0

Local anim:Int=0

Repeat
	WaitEvent()
	
	Select EventID()
		Case EVENT_GADGETACTION
			Select EventSource()
				Case btn[0]	EnableGadget ic3;EnableGadget ic1
				Case btn[1]	DisableGadget ic3;DisableGadget ic1
				Case btn[2]	ShowGadget ic2
				Case btn[3]	HideGadget ic2
				Case btn[4]	SelectGadgetItem ic4,EventData()
				Case btn[5]	'change animation strip! 
							SetGadgetIconStrip ic4,pix4
							SetSliderValue btn[4],0
							SetSliderRange btn[4],0,pix4.count-1
							
							SetGadgetPixmap ic2,pix3
							
				Case btn[6]	'start/stop
							Select anim
								Case 0 SetGadgetAnim(ic2,0);anim=1
								Case 1 SetGadgetAnim(ic2,1);anim=0
							End Select
				
				Case btn[7]	'get info about animation in gadget IC1
							Local a:Int,b:Int,c:Int,d:Int,e:Int
							GetGadgetAnim(ic1,a,b,c,d,e)
							DebugLog "Animated   : "+a
							DebugLog "Start frame: "+b
							DebugLog "End   frame: "+c
							DebugLog "Speed frame: "+d
							DebugLog "Dir anim   : "+e
							
			End Select
	
		Case EVENT_APPTERMINATE, EVENT_WINDOWCLOSE
			End
	End Select
Forever
