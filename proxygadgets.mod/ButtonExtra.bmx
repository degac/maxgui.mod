SuperStrict
Import "Spinner.bmx"
Import "FilePicker.bmx"
Import "DatePicker.bmx"
Import "Colorpicker.bmx" 




Rem
		ButtonExtra
		26.12.2017
			+ added support for ColorPicker
			+ fixed some documentation
			+ added new features: DEF field used to pass parameters
End Rem

Rem
bbdoc:Create a Special button/field
about:Create a combination of label+button/textfield/slider/progress bar/combobox

Style defines what type of 'extra' gadget you want

[ @{GADGET_CLASS} | @{Description}
* GADGET_TEXTFIELD | Creates a textfield
* GADGET_BUTTON | Creates a basic button
* GADGET_BUTTONCHECKER | Creates a checker button
* GADGET_SLIDER | Creates a slider
* GADGET_COMBOBOX | Creates a combobox
* GADGET_PROGBAR | Creates a progress bar
* GADGET_FILEPICKER | Creates a filepicker
* GADGET_FOLDERPICKER | Creates a folderpicker
* GADGET_SPINNER | Creates a spinner
* GADGET_DATEPICKER | Creates a datepicker
* GADGET_COLORPICKER | Color requester
]
<br>
You can use standard MaxGUI commands: @SetSliderRange, @AddGadgetItems and so on.<br>

You can use @DEF field in specific gadget to setup values
<br>
[ @{GADGET_CLASS} | @{Content}
* GADGET_SLIDER | The string contains: value,slider_min,slider_max 
* GADGET_PROGBAR | The string contains: value
* GADGET_SPINNER | The string contains: value,slider_min,slider_max  
* GADGET_COLORPICKER | The string determines the style of the colorpicker:0,1,2,3
]
<br>

You can 'send' a message to a single extra-gadget using this pseudo-commands:
<br>
[
* <#TITLE#> | Allow to change the label's text
* <#SIZE#> | Allow to resize the button/textfield gadget. The value is expressed in %%
]

<#VALUE#> is a placeholder for slider value<br>
When you move the slider, the text will change automatically.

End Rem
Function CreateButtonExtra:tbuttonExtra(msg:String,def:String,x:Int,y:Int,w:Int,h:Int,group:tgadget,style:Int=GADGET_TEXTFIELD)
Return tButtonExtra.Create(msg,def,x,y,w,h,group,style)
End Function

Type tButtonExtra Extends Tproxygadget


	Field panel:tgadget
	Field label:tgadget
	Field button:tgadget
	Field style:Int,Text$
	
	Method SetFont:Int(fnt:Tguifont=Null)
		'do nothing at the moment
		'If label SetGadgetFont label,fnt
		'Local bb:Tgadget=Self.getproxy()
		'If bb	SetGadgetFont bb,fnt
		
		Return 0
	End Method
	
	
	Method CleanUp:Int()
		RemoveHook EmitEventHook,EventHandler,Self
		If label FreeGadget label;label = Null
		If button FreeGadget button;button = Null
		If panel FreeGadget panel;panel = Null
		Super.CleanUp()
	End Method
	
	Method ItemExtra:Object(index:Int=0)
		If style=GADGET_COMBOBOX
		Return GadgetItemExtra(button,index)
		End If
	End Method

	Method Clear:Int()
		Select style
			Case GADGET_COMBOBOX	ClearGadgetItems button		
		End Select
		Return 0
	End Method

	Method SetPixmap:Int(pix:TPixmap,flags:Int)
		Select style
			Case GADGET_FILEPICKER,GADGET_FOLDERPICKER,GADGET_DATEPICKER,GADGET_BUTTON
					SetGadgetPixmap button,pix,flags
		
		End Select
	Return 0

	End Method
		


	Method SetItem:Int(index:Int,Text:String,tip:String,icon:Int,extra:Object,flags:Int)
		If style=GADGET_COMBOBOX
		ModifyGadgetItem button,index,Text,flags,icon,tip,extra
		End If
	End Method

	
	Method RemoveItem:Int(index:Int)
		If style=GADGET_COMBOBOX
					RemoveGadgetItem button,index
			End If
	End Method
	
	Method ItemCount:Int()
		If style=GADGET_COMBOBOX
			Return CountGadgetItems(button)
		End If
	End Method

	Method SelectedItem:Int()
		If style=GADGET_COMBOBOX Return SelectedGadgetItem(button)
	Return -1

	End Method
	
	Method SelectItem:Int(it:Int,st:Int)
			If style=GADGET_COMBOBOX
					SelectGadgetItem button,it
			End If
	End Method
	
	Method InsertItem:Int(index:Int,Text:String="",tip:String="",icon:Int=-1,extra:Object=Null,flags:Int=0)
		If style=GADGET_COMBOBOX
					AddGadgetItem button,Text,flags,icon,tip,extra
		End If
	End Method

	Method SetRange:Int(a:Int,b:Int)
		If style=GADGET_SLIDER	SetSliderRange button,a,b
		If style=GADGET_SPINNER	SetSpinnerRange tspinner(button),a,b,1
	End Method
	
	Method SetValue:Int(val:Float)
		If style=GADGET_PROGBAR	
			UpdateProgBar button,val
			Local txt$=Text.Replace("<#value#>",Int(val*100))
			SetGadgetText label,txt
		End If

	End Method
	
	Method GetProxy:Tgadget()
	'	DebugLog "ButtonExtra:GetProxy"

		Select style
				Case GADGET_FILEPICKER	Return tfilepicker(Self.button)
				Case GADGET_SPINNER 	Return tSpinner(Self.button)
				Case GADGET_DATEPICKER Return tDatePicker(Self.button)
				Case GADGET_BUTTON,GADGET_TEXTFIELD,GADGET_COMBOBOX		Return tgadget(Self.button)
				
				
				Case GADGET_COLORPICKER		Return tcolorpicker(Self.button)

		End Select

	End Method
	
		
	Method SetProp:Int(val:Int)
		If style=GADGET_SLIDER		Or style=GADGET_SPINNER 
			SetSliderValue button,val		
			Local txt$=Text.Replace("<#value#>",SliderValue(button))
			SetGadgetText label,txt

		Return 0
		End If
	
		Local tw:Int=GadgetWidth(panel)
		Local ns:Int=tw*Float(val)/100
		SetGadgetShape label,0,0,ns,GadgetHeight(label)
		SetGadgetShape button,ns,0,tw-ns,GadgetHeight(label)

		Return 0
	End Method

	Function Create:tButtonExtra (msg$="",def:String="",x:Int,y:Int,w:Int,h:Int,group:tgadget,style:Int=GADGET_TEXTFIELD)
		Local sp:tButtonExtra =New tButtonExtra 
		Local txt$
		sp.panel=CreatePanel(x,y,w,h,group)
		sp.label=CreateLabel(msg,0,6,w/2,h-2,sp.panel)
		sp.text=msg
		Local _substyle:Int
		Local _subvalue:String[]=def.split(",")
		_substyle=Int(_subvalue[0])		

		
		SetGadgetText sp.label,msg
	'	DebugLog "def : ("+DEF+")"
	'	DebugLog "msg : ("+msg+")"
		If style=GADGET_TEXTFIELD
			
			'DebugLog "ButtonExtra: Create: TEXTFIELD "+w+" "+h
			
			sp.button=CreateTextField(w/2,0,w/2,h,sp.panel)
			
			
			
			SetGadgetText sp.button,def
		ElseIf style=GADGET_BUTTON
			sp.button=CreateButton(def,w/2,0,w/2,h,sp.panel)
		ElseIf style=GADGET_COLORPICKER
			sp.button=CreateColorPicker(w/2,0,w/2,h,sp.panel,_substyle)
		ElseIf style=GADGET_BUTTONCHECKER
			sp.button=CreateButton(def,w/2,0,w/2,h,sp.panel,BUTTON_CHECKBOX)
			SetButtonState sp.button,_substyle
		ElseIf style=GADGET_COMBOBOX
			sp.button=CreateComboBox(w/2,0,w/2,h,sp.panel)
		ElseIf style=GADGET_SLIDER
			sp.button=CreateSlider(w/2,0,w/2,h,sp.panel,SLIDER_HORIZONTAL|SLIDER_TRACKBAR)
			If Len(_subvalue)=3
					SetSliderRange sp.button,Int(_subvalue[1]),Int(_subvalue[2])
					SetSliderValue sp.button,_substyle
			End If
			txt=sp.text.Replace("<#value#>",SliderValue(sp.button))
			SetGadgetText sp.label,txt

		ElseIf style=GADGET_PROGBAR
			sp.button=CreateProgBar(w/2,0,w/2,h-5,sp.panel)
			txt=sp.text.Replace("<#value#>","")
			SetGadgetText sp.label,txt
			If def<>"" 
			UpdateProgBar sp.button,Float(_substyle)/100
				txt=sp.text.Replace("<#value#>",def)
				SetGadgetText sp.label,txt
			End If
'		DebugLog "ProgBar: value : "+_substyle+" Def "+def
		ElseIf style&GADGET_FILEPICKER=GADGET_FILEPICKER
				sp.button=CreateFilePicker("",def,w/2,0,w/2,h-5,sp.panel)
				sp.button.name="FilePicker"
		ElseIf style&GADGET_FOLDERPICKER=GADGET_FOLDERPICKER
				sp.button=CreateFilePicker("",def,w/2,0,w/2,h-5,sp.panel,CHOOSE_FOLDER)
	
		ElseIf style=GADGET_SPINNER
					sp.button=CreateSpinner(w/2,0,w/2,h-5,sp.panel)
				If def<>""
					If Len(_subvalue)=3
					SetSpinnerRange tspinner(sp.button),Int(_subvalue[1]),Int(_subvalue[2])
					SetSpinnerValue tspinner(sp.button),_substyle
				End If
			End If
		
		ElseIf style=GADGET_DATEPICKER
					sp.button=CreateDatePicker(w/2,0,w/2,h-5,sp.panel)

		End If
		

		SP.style=STYLE
		AddHook EmitEventHook,EventHandler,sp
		sp.SetProxy sp'.panel
		
		
		
		SetGadgetLayout sp.panel,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,0
		SetGadgetLayout sp.button,0,EDGE_ALIGNED,EDGE_ALIGNED,0
		SetGadgetLayout sp.label,EDGE_ALIGNED,0,EDGE_ALIGNED,0

		Select style
			Case GADGET_TEXTFIELD,GADGET_PROGBAR,GADGET_SLIDER
			SetGadgetLayout sp.button,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,0

		
		End Select


		Return sp
	End Function
	
	Method setLayout:Int(a:Int,b:Int,c:Int,d:Int)
		SetGadgetLayout panel,a,b,c,d
'		SetGadgetLayout sp.button,0,EDGE_ALIGNED,EDGE_ALIGNED,0
'		SetGadgetLayout sp.label,EDGE_ALIGNED,0,EDGE_ALIGNED,0
		Return 0

	End Method
	
	Method SetValue_:Int(value:Double)
		If style=GADGET_SPINNER 	SetSpinnerValue tspinner(button),value
	End Method
	
	Method SetRange_:Int(minimum:Double,maximum:Double,accuracy:Int)
		If style=GADGET_SPINNER 	SetSpinnerRange tspinner(button),minimum,maximum,accuracy
	End Method
	
	Method SETENABLED:Int(sta:Int=True)
		If sta
			EnableGadget panel
			EnableGadget button
			EnableGadget label
	'		DebugLog "SetEnabled:"+sta
		Else
			DisableGadget label
			DisableGadget button
			DisableGadget panel
	'		DebugLog "SetEnabled:"+sta
		End If
	End Method
	
	Method State:Int()
		If style=GADGET_BUTTONCHECKER	Return button.State()
	End Method
	
	Method SetSelected:Int(st:Int)
			If style=GADGET_BUTTONCHECKER	SetButtonState button,st			
	End Method
	
	Method SetColor:Int(RED:Int,green:Int,blue:Int)
		SetGadgetColor label,RED,green,blue
		SetGadgetColor PANEL,RED,green,blue
		SetGadgetColor button,RED,green,blue

	End Method
	
	Method GetText$()
		Local _extradata:String
		Select style
			Case GADGET_TEXTFIELD,GADGET_DATEPICKER		Return GadgetText(button)
		End Select
		Return ""
	End Method
	
	Method SetToolTip:Int(_tip$="")
		If style=GADGET_TEXTFIELD SetToolTip(_tip)
	Return 0

	End Method
	
	Method SetText:Int(tx:String)
		If tx="" Return 0
	'	DebugLog "ButtonExtra: SetText: <"+tx+">"
		'special cases
		
		If tx.toupper().contains("<#TITLE#>")
			tx=tx.Replace("<#TITLE#>","")
			SetGadgetText label,tx		
			Return 1
		End If
				
		If tx.toupper().contains("<#SIZE#>")
			tx=tx.Replace("<#SIZE#>","")
			
			Local tw:Int=GadgetWidth(panel)
			Local ns:Int=tw*Float(Int(tx))/100
			SetGadgetShape label,0,0,ns,GadgetHeight(label)
			SetGadgetShape button,ns,0,tw-ns,GadgetHeight(label)
			Return 1
		End If
					
		SetGadgetText button,tx
	End Method
	
	Function eventHandler:Object( pID%, pData:Object, pContext:Object )
		Local pEvent:TEvent =  TEvent(pData)
		Local obj:tButtonExtra = tButtonExtra (pContext)
		Local _data:Int,_extraData$
		
		If pEvent
		
			Select pevent.ID
				Case EVENT_GADGETACTION
					If PEVENT.SOURCE=OBJ.button
						
						Select obj.style
							Case GADGET_TEXTFIELD,GADGET_FOLDERPICKER,GADGET_FILEPICKER
									_EXTRAdata=GadgetText(obj.button)
										SetGadgetExtra obj,_extradata
									
									
							Case GADGET_DATEPICKER
									_extradata=String(GadgetExtra(obj.button))
									SetGadgetExtra obj,_extradata

							Case GADGET_COMBOBOX
									_Data=SelectedGadgetItem(obj.button)
									SetGadgetExtra obj,String(_data)

	  						Case GADGET_SLIDER
									Local txt$
									txt=obj.text.Replace("<#value#>",SliderValue(obj.button))
									SetGadgetText obj.label,txt
									_data=SliderValue(obj.button)
										SetGadgetExtra obj,String(_data)

							Case GADGET_SPINNER
									_data=SpinnerValue(tspinner(obj.button))
									_extradata=String(Float(_data))
										SetGadgetExtra obj,String(_data)
							Case GADGET_BUTTONCHECKER
																			
									_data=ButtonState(obj.button)
									_extradata=String(Int(ButtonState(obj.button)))
									SetGadgetExtra obj,String(_data)
						End Select
						

						EmitEvent CreateEvent(EVENT_GADGETACTION,obj,_data,0,0,0,_extradata)
						Return pevent
					End If
			End Select

			
		End If
		
		Return pData
	EndFunction


End Type

