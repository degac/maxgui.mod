SuperStrict
Import MaxGUI.MaxGUI
Import brl.retro
Import "Spinner.bmx"
Rem
		Color picker
End Rem

Rem
bbdoc:Create a Color picker button
about:Create a button to choose a color
It generates an EVENT_GADGETACTION and EventExtra returns a 'string' with red, green, blue value separated by commas.<br>
To set a new color use SetGadgetText gadget,"red,green,blue"<br>
To get the current color use GadgetText: it returns a string (r,g,b)<br>
You can change the color typing an HEX code directly in the textfield.<br>
<br>
STYLE:

[
* 0 | color's component are shown with R: G: B: prefix (ie: R:255 G:128 B:128)
* 1 | color's component are shown without R: G: B: prefix (ie: 255 128 128)
* 2 | color's component are shown in HEX format (ie: #4286f4)
* 3 | you can change each color component using a spinner
]
<br>
Use standard #RequestColor
<br>
End Rem
Function CreateColorPicker:tColorPicker(x:Int,y:Int,w:Int,h:Int,group:tgadget,style:Int=0)
	Return tColorPicker.Create(x,y,w,h,group,style)
End Function


Type tColorpicker Extends Tproxygadget
	Field panel:tgadget
	Field label:tgadget
	Field button:tgadget
	Field rgb:Int[3]
	Field spinner:Tspinner[3]
	
	Method class:Int()
		Return GADGET_COLORPICKER
	End Method
	
	Method SetFont:Int(fnt:Tguifont=Null)
		If fnt=Null Return 0
		If label SetGadgetFont label,fnt
		If button	SetGadgetFont button,fnt	
		
		If spinner
			For Local sp:Tspinner=EachIn spinner
				SetGadgetFont sp,fnt			
			Next
		End If
		
	End Method
	
	Method CleanUp:Int()
		RemoveHook EmitEventHook,EventHandler,Self

		If label FreeGadget label;label = Null
		If button FreeGadget button;button = Null
		If panel FreeGadget panel;panel = Null
		If spinner
					FreeGadget spinner[0]
					FreeGadget spinner[1]
					FreeGadget spinner[2]
					spinner=Null		
		End If
		Super.CleanUp()
	End Method
	
	Method SetShow:Int(bool:Int)
		panel.setshow(bool)
	End Method

	Method SetEnabled:Int(status:Int=True)
		If status=True
			EnableGadget panel
			EnableGadget label
			EnableGadget button
			If spinner
			EnableGadget spinner[0]
			EnableGadget spinner[1]
			EnableGadget spinner[2]
			End If
		Else
			DisableGadget panel
			DisableGadget label
			DisableGadget button
			If spinner
			DisableGadget spinner[0]
			DisableGadget spinner[1]
			DisableGadget spinner[2]
			End If
		End If
	

	End Method


	Function Create:tColorPicker(x:Int,y:Int,w:Int,h:Int,group:tgadget,style:Int=0)
		Local sp:tColorPicker=New tColorPicker
		Local w1:Int=(w-25)/3
		sp.panel=CreatePanel(x,y,w,h,group)
		sp.rgb=[255,255,255]
		If style=2
			sp.label=CreateTextField(1,1,w-25,h-3,sp.panel)
		ElseIf style=3
			sp.spinner[0]=CreateSpinner(0,0,w1,25,sp.panel)
			sp.spinner[1]=CreateSpinner(w1,0,w1,25,sp.panel)
			sp.spinner[2]=CreateSpinner(w1*2,0,w1,25,sp.panel)
			SetSpinnerRange sp.spinner[0],0,255,0
			SetSpinnerRange sp.spinner[1],0,255,0
			SetSpinnerRange sp.spinner[2],0,255,0
			SetSpinnerValue sp.spinner[0],255
			SetSpinnerValue sp.spinner[1],255
			SetSpinnerValue sp.spinner[2],255
		Else
			sp.label=CreateLabel("",1,1,w-25,h-3,sp.panel,LABEL_SUNKENFRAME|LABEL_CENTER)
		End If
		
		sp.button=CreatePanel(w-24,1,22,h-2,sp.panel,PANEL_SUNKEN)
		
		SP.style=STYLE
		
		sp.UpdateValue()
		
		
		SetGadgetSensitivity sp.button,SENSITIZE_ALL
		If sp.label SetGadgetSensitivity sp.label,SENSITIZE_MOUSE
		
		AddHook EmitEventHook,EventHandler,sp
		sp.SetProxy sp.panel
		
		SetGadgetLayout sp.panel,EDGE_ALIGNED,EDGE_ALIGNED,0,0
		If sp.label SetGadgetLayout sp.label,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE
		SetGadgetLayout sp.button,0,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE
		If sp.spinner[0] SetGadgetLayout sp.spinner[0],EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE
		If sp.spinner[1] SetGadgetLayout sp.spinner[1],EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE
		If sp.spinner[2] SetGadgetLayout sp.spinner[2],EDGE_RELATIVE,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE

		Return sp
	End Function
	

	
	Method SetColor:Int(RED:Int,green:Int,blue:Int)
		SetGadgetColor label,RED,green,blue
	End Method
	
	Method GetText:String()
		'to get back R,G,B color
		Return rgb[0]+","+rgb[1]+","+rgb[2]
	End Method
	
	Method UpdateValue:Int()
		Select style
		Case 0
				SetGadgetText label,"R:"+RSet("000"+rgb[0],3)+" G:"+RSet("000"+rgb[1],3)+" B:"+RSet("000"+rgb[2],3)
		Case 1
				SetGadgetText label,RSet("000"+rgb[0],3)+" "+RSet("000"+rgb[1],3)+" "+RSet("000"+rgb[2],3)
		Case 2
				SetGadgetText label,Hex(rgb[0])[6..]+Hex(rgb[1])[6..]+Hex(rgb[2])[6..]
		End Select
		SetGadgetColor button,rgb[0],rgb[1],rgb[2]

		If style=3
			SetSpinnerValue spinner[0],rgb[0]
			SetSpinnerValue spinner[1],rgb[1]
			SetSpinnerValue spinner[2],rgb[2]		
		End If

	Return 0

	End Method
	
	Method SetText:Int(tx:String)
		'to set R,G,B color
		If tx="" Return -1
		Local tmp:String[]=tx.split(",")
		tmp=tmp[..3]
		rgb[0]=Int(tmp[0])
		rgb[1]=Int(tmp[1])
		rgb[2]=Int(tmp[2])
		UpdateValue()
	End Method

	Method SetLayout:Int(a:Int,b:Int,c:Int,d:Int)
	End Method
	
	
	Function eventHandler:Object( pID%, pData:Object, pContext:Object )
		Local pEvent:TEvent =  TEvent(pData)
		Local obj:tColorPicker= tColorPicker(pContext)
		
		If pEvent
		
			Select pevent.ID
				
				Case EVENT_GADGETACTION,EVENT_GADGETLOSTFOCUS 
					
					If pevent.source=obj.spinner[0] Or pevent.source=obj.spinner[1] Or pevent.source=obj.spinner[2]
						obj.rgb[0]=SpinnerValue(obj.spinner[0])
						obj.rgb[1]=SpinnerValue(obj.spinner[1])
						obj.rgb[2]=SpinnerValue(obj.spinner[2])
						SetGadgetColor OBJ.button,OBJ.rgb[0],OBJ.rgb[1],OBJ.rgb[2]
						EmitEvent CreateEvent(EVENT_GADGETACTION,obj,0,0,0,0,obj.rgb[0]+","+obj.rgb[1]+","+obj.rgb[2])
						Return pevent
					End If
					
					If pevent.source=obj.label
						If obj.style=2	'just for HEX value
							Local ty$=GadgetText(obj.label)
							If Len(ty)>=6	
								obj.rgb[0]=("$"+ty[..2]).toInt() 	 	 	 
								obj.rgb[1]=("$"+ty[2..4]).toInt()
								obj.rgb[2]=("$"+ty[4..6]).toInt()
								SetGadgetColor OBJ.button,OBJ.rgb[0],OBJ.rgb[1],OBJ.rgb[2]
								EmitEvent CreateEvent(EVENT_GADGETACTION,obj,0,0,0,0,obj.rgb[0]+","+obj.rgb[1]+","+obj.rgb[2])
								Return pevent
							End If
						End If	
					
					End If
				Case EVENT_MOUSEDOWN
				
					If PEVENT.SOURCE=OBJ.button
		
						If RequestColor(OBJ.rgb[0],OBJ.rgb[1],OBJ.rgb[2])
							OBJ.rgb[0]=RequestedRed()
							OBJ.rgb[1]=RequestedGreen()
							OBJ.rgb[2]=RequestedBlue()
							obj.UpdateValue()
						EndIf				
						EmitEvent CreateEvent(EVENT_GADGETACTION,obj,0,0,0,0,obj.rgb[0]+","+obj.rgb[1]+","+obj.rgb[2])
						Return pevent
					End If
			End Select

			
		End If
		
		Return pData
	EndFunction


End Type

