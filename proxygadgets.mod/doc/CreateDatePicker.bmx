Rem
		CreateDatePicker
		2009-2014 degac (CC) wwww.graphio.net
End Rem	

SuperStrict
Import MaxGUI.Drivers
Import maxgui.proxygadgets

Local pix:TPixmap=LoadPixmap("resources/icon_calendar.png")
Local window:TGadget = CreateWindow("Date picker",100,100,310,300,,WINDOW_TITLEBAR|WINDOW_CENTER|WINDOW_RESIZABLE)
CreateLabel("From:", 10,10,100,20,window)
CreateLabel("To:",  130,10,100,20,window)
Local date1:tgadget	=CreateDatePicker(10,30,100,24,window)
Local date2:tgadget	=CreateDatePicker(130,30,100,24,window)
SetGadgetPixmap date1,pix
SetGadgetPixmap date2,pix

Local button1:tgadget	=CreateButton("Get date 1",10,100,100,25,window)
Local button2:tgadget	=CreateButton("Get date 2",10,130,100,25,window)
Local button3:tgadget	=CreateButton("Hallo world",10,170,100,25,window)

While True
	WaitEvent
		Select EventID()
		
	
		Case EVENT_GADGETACTION
			Select EventSource()	
				Case button1
					Print "Date 1 {"+String(GadgetExtra(date1))+"}"
				Case button2
					Print "Date 2 {"+String(GadgetExtra(date2))+"}"
			End Select
				
						
		Case EVENT_WINDOWCLOSE
			If EventSource() = window End
		End Select
Wend

End