SuperStrict
Import maxgui.drivers
Import maxgui.proxygadgets
Global window:tgadget=		CreateWindow("Main",100,100,300,300,,WINDOW_TITLEBAR|WINDOW_CENTER)

Local cf0:Tgadget=CreateColorPicker(10,10,200,25,window,0)
Local cf1:Tgadget=CreateColorPicker(10,40,200,25,window,1)
Local cf2:Tgadget=CreateColorPicker(10,70,200,25,window,2)
Local cf3:Tgadget=CreateColorPicker(10,100,200,25,window,3)


SetGadgetText cf0,"255,0,0"
Print "RGB: "+GadgetText(cf0)
'DisableGadget cf

Repeat
	WaitEvent()
	'Print CurrentEvent.tostring()
	Select EventID()
		Case EVENT_APPTERMINATE, EVENT_WINDOWCLOSE
			End
		Case EVENT_GADGETACTION
			Select EventSource()
				Case cf0
					Print "Evento: GadgetAction: CF"
					Local rgb$=String(EventExtra())
					Print rgb
			
			End Select
	End Select
Forever
