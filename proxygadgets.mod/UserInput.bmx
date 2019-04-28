SuperStrict

Import MaxGUI.MaxGUI
Import "common.bmx"

Rem
	UserInput
	© 2010 - degac - www.graphio.net

	v1.2	07-feb-2014	added DefaultValues[]

End Rem

Rem
bbdoc:Create a user input window/panel
about:@msg contains the title of the panel (or of the window), @fields contains the title of textfields separated by the symbol '|'.
If a field contains ** (double asterisk) this set that field as 'PASSWORD FIELD'.<br>
If @group is NULL a window will be opened, otherwise a panel from @x and @y point will be drawn on the current window.<br>
#{SetGadgetText}(gadget,field1|field2|field3) will set a default value for each textfield.<br>
return: the gadget will return an EVENT_GADGETCLOSE and EventExtra() will contain an array of string with the content of each textfield.
End Rem
Function CreateInput:tUserInput(msg:String="",Fields:String="",x:Int=0,y:Int=0,group:tgadget=Null,defaults:String[]=Null)
	Return tUserInput.Create(msg$,fields$,x,y,group,defaults)
End Function


Type tUserInput Extends Tproxygadget

	Field panel:tgadget
	Field label:tgadget		'contains some text
	Field txt:tgadget[]		'the textfields
	Field lbl:tgadget[]		'the label-text
	Field btn_ok:tgadget
	Field btn_cancel:tgadget
	Field _window:Int
	Field window:tgadget
	
	Method class:Int()
		Return GADGET_USERINPUT
	End Method

	Method SetFont:Int(fnt:Tguifont=Null)
		If fnt=Null Return 0
		If window 
			SetGadgetFont window,fnt
		End If	
		
	End Method

	Method CleanUp:Int()

		If btn_ok 		FreeGadget btn_ok
		If btn_cancel	FreeGadget btn_cancel
	
		If txt
			For Local s:tgadget=EachIn txt
				FreeGadget s
			Next
			txt=Null	
		End If
	
		If lbl
			For Local s:tgadget=EachIn lbl
				FreeGadget s
			Next
			lbl=Null	
		End If
	
		
		If window FreeGadget window;window=Null
		If panel FreeGadget panel;panel=Null
		If label FreeGadget label;label=Null
		GCCollect()
		RemoveHook EmitEventHook,EventHandler,Self
		Super.CleanUp()

	End Method
	
	Method SetText:Int(tx:String)
		If tx="" Return -1
		Local r:String[]=tx.split("|")
		r=r[..Len(txt)]
		Local c:Int
		For Local g:tgadget=EachIn txt
			SetGadgetText g,r[c]
			c:+1
		Next
		
	
	End Method
	

	Function Create:tUserInput(msg$,fields$,x:Int=0,y:Int=0,group:tgadget=Null,def:String[]=Null)
		Local sp:tUserInput=New tUserInput
		Local w:Int,h:Int
		If group w=ClientWidth(group)
		h=24
		'fields=fields+"|"
		Local it$[]=fields.split("|")
		h=Len(it)*48+24+48
		sp.lbl=New tgadget[Len(it)]
		sp.txt=New tgadget[Len(it)]
		def=def[..Len(it)]
		
		
		If group=Null
			group=CreateWindow(msg,10,10,300,h+40,,WINDOW_TITLEBAR|WINDOW_CENTER)
			sp._window=1
			w=295
			sp.window=group
			
		End If

		If sp._window=1
			x=0;y=0
			sp.btn_ok=	CreateButton("Ok",ClientWidth(group)-80,h-15,70,24,group,BUTTON_OK)
			sp.btn_cancel=	CreateButton("Cancel",10,h-15,70,24,group)
			
		End If
		sp.panel=CreatePanel(x,y,w-x*2,h-22,group,PANEL_GROUP)',PANEL_ACTIVE
		If msg<>"" And sp._window=0	sp.label=CreateLabel(msg,0,0,w,24,sp.panel)

		Local c:Int,_style:Int,_txt:String
		For Local i$=EachIn it
			
			If i.contains("**") _style=TEXTFIELD_PASSWORD;_txt=i.Replace("**","") Else _style=0;_txt=i
			'Print c+" ["+_txt+"] "+(c*48+26)
			sp.lbl[c]=CreateLabel(_txt,1,c*48+8+24*(sp._window=0),w,18,sp.panel)
			sp.txt[c]=CreateTextField(0,c*48+26+24*(sp._window=0),w-x*2-10,22,sp.panel,_style)
			SetGadgetText sp.txt[c],def[c]
			c:+1
		Next
		
		AddHook EmitEventHook,EventHandler,sp
		sp.SetProxy sp.panel
		Return sp
	End Function
	
	Method SetColor:Int(RED:Int,green:Int,blue:Int)
		For Local g:tgadget=EachIn txt
		SetGadgetColor g,RED,green,blue
		Next
	End Method
	
	Method SETENABLED:Int(sta:Int=True)
		If sta
			Local tg:tgadget
			For tg=EachIn lbl
				EnableGadget tg
			Next
			For tg=EachIn txt
				EnableGadget tg
			Next
			EnableGadget label
		
		Else
			Local tg:tgadget
			For tg=EachIn lbl
				DisableGadget tg
			Next
			For tg=EachIn txt
				DisableGadget tg
			Next
			DisableGadget label
		End If
	
	End Method
	
	Function eventHandler:Object( pID%, pData:Object, pContext:Object )
		Local pEvent:TEvent =  TEvent(pData)
		Local obj:tUserInput= tUserInput(pContext)
		Local res:String[],gad:tgadget,count:Int
		
		If pEvent
		
			Select pevent.ID
				
				Case EVENT_WINDOWCLOSE
					If obj._window=1
						If pevent.source=obj.window
							FreeGadget obj
							Return Null						
						End If
					End If
			
				Case EVENT_GADGETACTION
				
					If obj._window=1
						If pevent.source=obj.btn_ok
							count=0
							res=New String[Len(obj.txt)]
							For gad=EachIn obj.txt
								res[count]=GadgetText(gad)
								count:+1
							Next
							pevent.extra=res			
			
							EmitEvent CreateEvent(EVENT_GADGETCLOSE,obj,0,0,0,0,res)	
							FreeGadget obj	
						End If
						
						If pevent.source=obj.btn_cancel							
							FreeGadget obj
							Delay 10
							EmitEvent CreateEvent(EVENT_GADGETCLOSE,Null)	
						End If
					Else
					'if is in panel
						count=0
						res=New String[Len(obj.txt)]
						For gad=EachIn obj.txt
							res[count]=GadgetText(gad)
						count:+1
						Next
						pevent.extra=res		
						SetGadgetExtra obj,res
						Return pevent
					End If
			
		
			End Select

			
		End If
		
		Return pData
	EndFunction


End Type

