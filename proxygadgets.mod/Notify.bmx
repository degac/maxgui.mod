SuperStrict
Import MaxGUI.MaxGUI
Import BRL.EventQueue
Import "IconGadget.bmx"
Rem
	Notify Gadget
	© 2010 - degac - www.graphio.net

	1.0 - Initial release
	1.1 - Supports for animated images
	1.2 - Button is now an 'OK button', just press RETURN to close the window
	1.3 - (06-01-2014) - Now use CreateIconGadget to display animation/icon and emit an event
	1.4 - (06-01-2018) - added SetFont() support
End Rem
Global EVENT_NOTIFY_COMPLETED:Int=AllocUserEventId("EVENT_NOTIFY_COMPLETED")
Rem
bbdoc: a Notify gadget with personalized image/animation
about: @msg is the message you want To display<br>@group is the parent window<br>@pix is an Object (a pixmap Or an IconStrip Object)<br><br>It's possible to pass a FONT to change it<br>See #LoadPixmap And #LoadIconStrip For more informations.
<br>Images should be 128x128 pixel in size for better result.
End Rem
Function CreateNotify:Int (msg:String="",group:tgadget,pix:Object=Null,fnt:Tguifont=Null)
	Tnotifygadget.Create(msg$,0,group:tgadget,pix,fnt)
	Repeat
		WaitEvent
		
	Until EventID()=EVENT_NOTIFY_COMPLETED
End Function

Type Tnotifygadget Extends Tproxygadget

	Field Text:tgadget		'the text/message
	Field BUTTON_OK:tgadget		'the OK button
	Field BUTTON_CANCEL:tgadget
	Field button_abort:tgadget
	Field window:tgadget		'the window
	Field old_window:tgadget	'the parent window
	Field LINE:TGADGET,style:Int
	Field _destroy:Int
	Field IconGadget:Tgadget
	
	Method CleanUp:Int()
		If IconGadget FreeGadget Icongadget;Icongadget=Null
		If BUTTON_OK FreeGadget BUTTON_OK;BUTTON_OK=Null
		If BUTTON_CANCEL FreeGadget BUTTON_CANCEL;BUTTON_CANCEL=Null
		If button_abort FreeGadget button_abort;button_abort=Null
		RemoveHook EmitEventHook,EventHandler,Self
		If Text FreeGadget Text;Text=Null
		If window FreeGadget window;window=Null
	
		Super.CleanUp()
		
	End Method
	
	Method class:Int()
		Return GADGET_NOTIFY
	End Method
	
	Method GetText:String()
		Return ""
	End Method
	
	Method SetFont:Int(fnt:Tguifont=Null)
		If fnt=Null Return 0
		If BUTTON_OK SetGadgetFont BUTTON_OK,fnt
		If BUTTON_CANCEL SetGadgetFont BUTTON_CANCEL,fnt
		If button_abort SetGadgetFont button_abort,fnt
		If Text SetGadgetFont Text,fnt
	End Method
	
	Function Create:Int (msg$,style:Int=0,group:tgadget=Null,img:Object=Null,fnt:Tguifont=Null)
		Local sp:Tnotifygadget =New Tnotifygadget 		
		Local size:Int=200,xtext:Int=10
		sp.style=style

		If img<>Null	size=400;xtext=150
		
		Local cx:Int,cy:Int
		cx=group.xpos
		cy=group.ypos+20
		
		sp.window=CreateWindow(AppTitle,cx,cy,size,200,,WINDOW_TITLEBAR)
		DisableGadget group
	
		sp.old_window=group
	
		sp.Text=CreateLabel(msg,xtext,10,ClientWidth(sp.window)-xtext-10,ClientHeight(sp.window)-40,sp.window)',LABEL_FRAME)
		sp.line=CreateLabel("",0,ClientHeight(sp.window)-30,ClientWidth(sp.window),30,sp.window,LABEL_SEPARATOR)
	
		Local x:Int=ClientWidth(sp.window)/2-40	
		SP.BUTTON_OK=CreateButton("Ok",x,ClientHeight(sp.window)-25,80,24,sp.window,BUTTON_OK)
		sp.icongadget=CreateIconGadget(10,10,128,128,sp.window,img)						
		DisableGadget group
		ActivateWindow sp.window
		sp.SetProxy sp.window
		
		If fnt	SetGadgetFont sp,fnt
		
		AddHook EmitEventHook,EventHandler,sp
	End Function
	
	Function eventHandler:Object( pID%, pData:Object, pContext:Object )
		Local pEvent:TEvent =  TEvent(pData)
		Local obj:Tnotifygadget = Tnotifygadget (pContext)
		If pEvent
		
			Select pevent.ID
								
				Case EVENT_GADGETACTION
					If obj.style=0
						If pevent.source=obj.BUTTON_OK
							ActivateWindow obj.old_window
							EnableGadget obj.old_window
							ActivateGadget obj.old_window
							FreeGadget obj

							EmitEvent(CreateEvent(EVENT_NOTIFY_COMPLETED))

						End If
					End If
			
				Case EVENT_WINDOWCLOSE

					If pevent.source=obj
						ActivateWindow obj.old_window
						FreeGadget obj
						EnableGadget obj.old_window
						ActivateGadget obj.old_window
	
						EmitEvent(CreateEvent(EVENT_NOTIFY_COMPLETED))

					End If
			
			End Select

			
		End If
		
	
	'	Return Null	'in this way NO events are passed to the MAIN program
	EndFunction


End Type

