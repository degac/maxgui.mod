Rem
	CreateNotify
	© 2010 - degac - www.graphio.net
End Rem

SuperStrict

Import maxgui.drivers
Import maxgui.proxygadgets


Local is1:TPixmap=LoadPixmap("resources/icon_alert.png")
Local is2:ticonstrip=LoadIconStrip("resources/alert_animated.png")

Local window:tgadget	=CreateWindow("CreateNotify",100,100,400,400,,WINDOW_TITLEBAR|WINDOW_CENTER)
Local msg$="This is an example of advanced notify gadget.~nIt allows to use personalized images~nor animated ones."


CreateNotify(msg,window,is1)


msg="This is another one message.~n~n~nThis one has animated image"

CreateNotify(msg,window,is2)


While True
	WaitEvent 
	Select EventID()
		Case EVENT_WINDOWCLOSE
			End
	End Select
Wend
