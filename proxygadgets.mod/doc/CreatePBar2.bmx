Rem
		Progress Bar Evolution
		2009-2014 degac (CC) www.graphio.net
End Rem

SuperStrict
Import maxgui.drivers'fltkMAXGUI'drivers
Import maxgui.proxygadgets
Local window:TGadget

window=CreateWindow("Progress Bar",40,40,500,350,,WINDOW_CENTER|WINDOW_TITLEBAR)

CreateLabel "Default MaxGui"	,10, 10,180,20,window	'0
CreateLabel "Standard"		,10, 40,180,20,window	'1
CreateLabel "Standard (personalized)"	,10, 70,180,20,window	'2 - NO BORDER + COLORIZED
CreateLabel "Standard+Show+indicator"	,10,100,180,20,window	'3
CreateLabel "Discrete"		,10,130,180,20,window	'4
CreateLabel "Discrete+Alert"	,10,160,180,20,window	'5
CreateLabel "Standard+Alert+Indicator"	,10,190,180,20,window	'5
CreateLabel "Rating"			,10,220,180,20,window	'6
CreateLabel "Rating - interactive"	,10,250,180,20,window	'6


Local standard:tgadget=   CreateProgBar(210,10,200,20,window)
Local prog1:Tgadget=		CreatePbar(210,40,200,20,window)
Local prog2:Tgadget=		CreatePbar(210,70,200,20,window,PBAR_STANDARD|PBAR_NOBORDER)
Local prog3:tgadget=		CreatePbar(210,100,200,20,window,PBAR_SHOW|PBAR_STANDARD|PBAR_INDICATOR)'|PBAR_NOBORDER)
Local prog4:tgadget=		CreatePbar(210,130,200,20,window,PBAR_DISCRETE)
Local prog5:tgadget=		CreatePbar(210,160,200,20,window,PBAR_DISCRETE|PBAR_ALERT)
Local prog6:tgadget=		CreatePbar(210,190,200,20,window,PBAR_STANDARD|PBAR_ALERT|PBAR_INDICATOR)
Local prog7:tgadget=		CreatePbar(210,220,14*5,20,window,PBAR_RATING)
Local prog8:tgadget=		CreatePbar(210,250,14*5,20,window,PBAR_RATING|PBAR_ACTIVE)

'SetGadgetColor PROG8,255,255,255



SetSliderValue prog7,5

'SetGadgetColor standard,255,200,150
'SetGadgetColor standard,200,0,200,False
'SetGadgetColor prog,255,200,150
'SetGadgetColor prog,200,0,200,False

SetGadgetPixmap prog2,LoadPixmap("resources/green_bar.png")' here we change the graphical aspect of the progress bar
SetSliderRange prog5,4,8

HideGadget prog6

Local mytimer:ttimer=CreateTimer(10)

While WaitEvent()
	Select EventID()
	
		Case EVENT_GADGETACTION
			
			If EventSource()=prog8
				Print "User Rating: "+EventData()
			End If
	
		Case EVENT_WINDOWCLOSE
			Exit
			
		Case EVENT_TIMERTICK
			Local t:Int=EventData()
			If t=50 StopTimer(mytimer)
			UpdateProgBar standard,t/50.0
			UpdateProgBar prog1,t/50.0
			UpdateProgBar prog2,t/50.0
			UpdateProgBar prog3,t/50.0
			UpdateProgBar prog4,t/50.0
			UpdateProgBar prog5,t/50.0
			UpdateProgBar prog6,t/50.0

	End Select
Wend
FreeGadget prog1
FreeGadget prog2
FreeGadget prog3
FreeGadget prog4
FreeGadget prog5
FreeGadget prog6
FreeGadget prog7
FreeGadget prog8
End

