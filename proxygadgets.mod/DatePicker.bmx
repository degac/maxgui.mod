Rem
		date picker
		
		29-08-2010
		
		Replaced Panel with an Hidden Window to work under MacOS
		
		02-may-2015
		
		fixed: floating window is always visible when main windows is resized
					or moved
		
		Fixed: when the gadget is nested in other gadget (panel etc)
		
		16-jul-2018
		
		added: method GetText()
		
End Rem
SuperStrict

Import MaxGUI.MaxGUI
Import "Calendar.bmx"
Import "common.bmx"
Rem
bbdoc:Create a date picker button
about:Create a button to choose from a calendar a specific date.<br>
You can setup the date format using @SetGadgetText, adding an * at the start<br>
So the string '*dd/mm/yy' will use the format like 15/02/18<br>
Without '*' @SetGadgetText will change the content of the datepicker label.<br>
End Rem
Function CreateDatePicker:Tgadget(x:Int,y:Int,w:Int,h:Int,group:tgadget)
	Return tdatepicker.Create(x,y,w,h,group)
End Function

Type tdatepicker Extends Tproxygadget
	Field panel:tgadget,panel2:tgadget
	Field label:tgadget
	Field button:tgadget
	Field window:tgadget,superParent:tgadget
	Field style:Int
	Field calendar:tgadget
	Field active:Int
	Field x:Int,y:Int,h:Int
	Field pixmap:TPixmap,grey_pixmap:TPixmap
	Field format$="dd/mm/yyyy"
	
	'Global icon:TPixmap=LoadPixmap("incbin::icon_calendar.png")
	
	Method SetFont:Int(fnt:Tguifont=Null)
		If fnt=Null Return 0
		If label SetGadgetFont label,fnt
		If button SetGadgetFont button,fnt
	'	If calendar SetGadgetFont calendar,fnt
	End Method
	
	Method CleanUp:Int()
		pixmap=Null
		grey_pixmap=Null
		If panel FreeGadget panel;panel=Null
		If panel2 FreeGadget panel2;panel2=Null
		If label FreeGadget label;label=Null
		If button FreeGadget button;button=Null
		If window FreeGadget window;window=Null
		If calendar FreeGadget calendar;calendar=Null

		RemoveHook(EmitEventHook,EventHandler,Self)
		Super.Cleanup()
	End Method
	
	Method SetShow:Int(bool:Int)
		panel.setshow(bool)
	End Method

	Method SetText:Int(txt$)
			If txt.startswith("*")
				If calendar 	SetGadgetText calendar,txt[1..]
			Else
				If label SetGadgetText label,txt
			End If
	End Method
	
	Method SetEnabled:Int(status:Int=True)
		If status=True
			EnableGadget panel
			SetGadgetPixmap button,pixmap
		Else
			SetGadgetPixmap button,grey_pixmap
			DisableGadget panel
		End If

	End Method

	Method GetText:String()
	'	SetGadgetText obj.label,String(pevent.extra)
	'	SetGadgetExtra obj,String(pevent.extra)
	'	DebugLog "DatePicker:GetText"
		Return GadgetText(label)
	End Method

	Method class:Int()
		Return GADGET_DATEPICKER
	End Method
	
	Method SetPixmap:Int(pix:TPixmap,flags:Int=0)
		SetGadgetPixmap button,pix
		pixmap=pix
		grey_pixmap=TPixmap(makegrey(pix))
	End Method
	
	Method SetColor:Int(rr:Int=255,gg:Int=255,bb:Int=255)
		SetGadgetColor label,rr,gg,bb
		Return 0
	End Method
	
	Function Create:tdatepicker(x:Int,y:Int,w:Int,h:Int,group:tgadget)
		Local sp:tdatepicker=New tdatepicker

		sp.panel=CreatePanel(x,y,w,h,group)
		sp.label=CreateLabel("",1,1,w-25,h-2,sp.panel,LABEL_FRAME)
		sp.button=CreateButton("",w-24,1,22,h-2,sp.panel)
		sp.window=group
		sp.superparent=sp.window
		
		If sp.window.class()<>GADGET_WINDOW	'non è una finestra!
			While GadgetClass(sp.window)<>GADGET_WINDOW
				sp.window=sp.window.parent
				Wend
		
		End If
		
		sp.style=CAL_WEEKEND|CAL_TODAY|CAL_PICKER
		'--- this is the 'hidden gadget'
		sp.x=x
		sp.y=y
		sp.h=h
		
		sp.panel2=CreateWindow("",group.xpos+x,group.ypos+h,180,230,,WINDOW_HIDDEN)
		
		SetGadgetShape sp.panel2,sp.window.xpos+x,sp.window.ypos+y+h,160,230
		sp.calendar=CreateCalendar(0,0,ClientWidth(sp.panel2),ClientHeight(sp.panel2),sp.panel2,SP.style)
		'HideGadget sp.panel2
		
		SetGadgetColor sp.label,200,200,200
		AddHook EmitEventHook,EventHandler,sp
		sp.SetProxy sp.panel
		Return sp
	End Function
	
	Function eventHandler:Object( pID%, pData:Object, pContext:Object )
		Local pEvent:TEvent =  TEvent(pData)
		Local obj:tdatepicker= tdatepicker(pContext)
		Local spx:Int,spy:Int
		Local sparent:tgadget=obj.panel.parent
		
		
		If sparent
			If GadgetClass(sparent)=GADGET_PANEL	
				spx:+sparent.xpos
				spy:+sparent.ypos
			
			End If
		
		End If
		
		
			
		If pEvent
			
			If pevent.ID=EVENT_WINDOWMOVE Or pevent.ID=EVENT_WINDOWSIZE
				If pevent.source=obj.window
					Local ox:Int,oy:Int
					ox=obj.window.xpos+obj.panel.xpos+spx
					oy=obj.window.ypos+obj.panel.ypos+obj.panel.HEIGHT+spy
					
					If (ox+160)>DesktopWidth() ox:-(ox+160-DesktopWidth())
					If (oy+230)>DesktopHeight() oy:-(oy+230-DesktopHeight())
					SetGadgetShape obj.panel2,ox,oy,160,230

				'	SetGadgetShape obj.panel2,obj.window.xpos+obj.panel.xpos,obj.window.ypos+obj.panel.ypos+obj.panel.HEIGHT,160,230
					RedrawGadget obj.panel2
					If obj.active=True
					ActivateWindow obj.panel2
					RestoreWindow obj.panel2
					End If
					Return pevent
				End If
			End If
			
			If pevent.ID=EVENT_WINDOWCLOSE
				If pevent.source=obj.window
					HideGadget obj.panel2
					Return pevent
				End If
			End If
			

		
			If pevent.ID=EVENT_GADGETCLOSE
				If pevent.source=obj.calendar
						HideGadget obj.panel2
						SetGadgetText obj.label,String(pevent.extra)
						SetGadgetExtra obj,String(pevent.extra)
						obj.active=False
						EmitEvent CreateEvent(EVENT_GADGETACTION,obj,0,0,0,0,pevent.extra)
				
						Return pevent
				End If
			End If
		
				
			Select pEvent.Source
				Case obj.button
	
					Local ox:Int,oy:Int
					ox=obj.window.xpos+obj.panel.xpos+spx
					oy=obj.window.ypos+obj.panel.ypos+obj.panel.HEIGHT+spy
					
					If (ox+160)>DesktopWidth() ox:-(ox+160-DesktopWidth())
					If (oy+230)>DesktopHeight() oy:-(oy+230-DesktopHeight())

						
					SetGadgetShape obj.panel2,ox,oy,160,230
				
	
					'SetGadgetShape obj.panel2,obj.window.xpos+obj.panel.xpos,obj.window.ypos+obj.panel.ypos+obj.panel.HEIGHT,160,230		
					RedrawGadget obj.panel2
					RedrawGadget obj.calendar
					ShowGadget obj.panel2
					obj.active=True
					Return pevent
			End Select			


			
		End If
		
		Return pData
	EndFunction


End Type

