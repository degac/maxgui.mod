Rem
		Calendar gadget
		2011-2014 degac (CC) wwww.graphio.net
End Rem	

SuperStrict
Import MaxGUI.Drivers
Import maxgui.proxygadgets
Local window:TGadget = CreateWindow("Calendar v. 1.4",100,100,210,300,,WINDOW_TITLEBAR|WINDOW_CENTER|WINDOW_RESIZABLE)
Local data:TCalendar = CreateCalendar(10,40,180,,window,CAL_PICKER|CAL_TODAY)
SetGadgetLayout data, EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE
Local label:TGadget = CreateLabel(" ",10,5,200,25,window)
SetGadgetColor data,200,200,200
'this method to set an Appointment-reminder on the calendar
SetCalendarAppointment(data,"10-06","Test application!")
SetCalendarAppointment(data,"10-06","Second appointment...~nRemember to conquer the world!")
SetCalendarAppointment(data,"10-06","Buy the milk")
SetCalendarAppointment(data,"12-06","World launch!")
SetCalendarAppointment(data,"12-01-2014","---appointment---1")
SetCalendarAppointment(data,"12-01-2014","---appointment---2")
SetCalendarAppointment(data,"09-06-2014","This is a fixed date")
RemoveAppointments(data,"10-06",2)
'RemoveAppointments(data,"12-06")
'SetCalendarHoliday(data,"15-08,16-08","Ferragosto")
'SetCalendarLocale(data,"Lu,Ma,Me,Gi,Ve,Sa,Do","Gen,Feb,Mar,Apr,Mag,Giu,Lug,Ago,Set,Ott,Nov,Dic")
'SetCalendarLocale(data,"Lu,Ma,Me,Gi,Ve,Sa,Do","Gennaio,Febbraio,Marzo,Aprile,Maggio,Giugno,Luglio,Agosto,Settembre,Ottobre,Novembre,Dicembre")
'RedrawGadget data 'you need to 'redraw' the gadget to see the appointments set for the current month
'RedrawGadget data2
'Local app$[]=GetCalendarAppointment(data,"10-06",1)
'For Local ss$=EachIn app
'	Print "Appointment: {"+ss+"}"
'Next
While True
	WaitEvent
		Select EventID()
		Case EVENT_GADGETCLOSE
			If EventSource()=DATA
				Print "Date : "+String(EventExtra())
				Print "Or   : "+EventX()+" "+EventY()+" "+EventData()
			End If
		Case EVENT_GADGETACTION
			
			If EventSource() = data
				SetGadgetText label,String(EventExtra())
			End If
	
		Case EVENT_WINDOWCLOSE
			If EventSource() = window End 
			End Select
Wend

End