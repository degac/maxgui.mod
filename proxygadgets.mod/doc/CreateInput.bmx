Rem
	CreateInput
	2010 - 2014 - degac (CC) www.graphio.net
End Rem

SuperStrict

Import maxgui.drivers'fltkmaxgui'drivers
Import maxgui.proxygadgets
AppTitle="UserInput example"
Local window:tgadget	=CreateWindow(AppTitle,100,100,400,400,,WINDOW_TITLEBAR|WINDOW_CENTER)
Local in:tgadget=CreateInput("Insert some title here","Name|Surname|Password**|NickName",10,20)
Local in2:tgadget=CreateInput("Please insert Product key","Key|Password**",10,40,window)
SetGadgetText in2,"Noname|Nopassword"
Local button:tgadget=CreateButton("User Input",10,10,100,24,window)
Local BUTTON_OK:tgadget=CreateButton("Confirm",10,200,80,24,window)
SetGadgetColor in2,200,80,100
Local temp_in:tgadget[]
Local count:Int


While True
	WaitEvent 
	Select EventID()
		Case EVENT_GADGETACTION
		
			If EventSource()=BUTTON_OK
				Local res:String[]=String[](GadgetExtra(in2))
				If res
						For Local s:String=EachIn res
							Print "Panel <"+s+">"
						Next

				Else
					Print "[null]"
				End If
			End If
			
			If EventSource()=button
				temp_in=temp_in[..count+1]
				temp_in[count]=CreateInput("Casual "+count,"Name|Surname|Password**|NickName",10,20)
				count:+1
			End If
		Case EVENT_GADGETCLOSE
			Print "Event GadgetClose..."
			If EventSource()=in
				Local res:String[]=String[](EventExtra())
				For Local s:String=EachIn res
					Print "<"+s+">"
				Next
			End If
			
			For Local cc:tgadget=EachIn temp_in
				If EventSource()=cc
					Local res:String[]=String[](EventExtra())
						For Local s:String=EachIn res
							Print "<"+s+">"
						Next
				End If
			Next

			
		Case EVENT_WINDOWCLOSE
			End
	End Select
Wend
