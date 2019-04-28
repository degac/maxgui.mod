SuperStrict
Import maxgui.drivers
Import brl.eventqueue
Rem
	Josh Klink
	degac (some variations)
	
	21.07.2018	+added Method GetText()
	
End Rem
Const SPINNER_TRACKBAR:Int=1
Type TSpinner Extends TProxygadget
	
	Const SLIDERWIDTH:Int=18
	Const DIV:Int=80
	
	Field panel:TGadget
	Field textfield:TGadget
	Field slider:TGadget
	Field trackbar:TGadget
	Field value:Double
	Field Range:Double[2]
	Field accuracy:Int=1
	Field floatitemmultiplier:Double=10
	
	Method SetProp:Int(val:Int=0)
		setvalue_(val)
	End Method
	
	Method class:Int()
		Return GADGET_SPINNER
	End Method
	
	Method SetFont:Int(fnt:Tguifont=Null)
		If fnt=Null	Return 0
		If textfield SetGadgetFont textfield,fnt
	End Method
	
	Method SetShow:Int(bool:Int)
		panel.setshow(bool)
	End Method
	
	Method SetRange_:Int(minimum:Double,maximum:Double,accuracy:Int=1)
		Self.accuracy=accuracy
		floatitemmultiplier=10.0^Double(accuracy)
		Range[0]=minimum*floatitemmultiplier
		Range[1]=maximum*floatitemmultiplier-Range[0]+1
		SetSliderRange slider,1,Range[1]
		If trackbar
			SetSliderRange trackbar,1,Range[1]
		EndIf
		SetValue_(value)
	EndMethod
	
	Method SetColor:Int(r:Int=255,g:Int=255,b:Int=255)
		SetGadgetColor textfield,r,g,b
	End Method
	
	Method SetEnabled:Int(sta:Int=True)
		If sta=False
			DisableGadget panel
			DisableGadget textfield
			DisableGadget slider
			If trackbar DisableGadget trackbar
		Else
			EnableGadget panel
			EnableGadget textfield
			EnableGadget slider
			If trackbar EnableGadget trackbar
		End If
		
	End Method

	
	Method Cleanup:Int()
		RemoveHook(EmitEventHook,EventHook,Self)
		Super.Cleanup()
	EndMethod
	
	Function Create:TSpinner(x:Int,y:Int,WIDTH:Int,HEIGHT:Int,group:TGadget,flags:Int=0)
		Local spinner:TSpinner
		Local w:Int
		
		spinner=New TSpinner
				
		spinner.panel=CreatePanel(x,y,WIDTH,HEIGHT,group)
		spinner.setproxy(spinner.panel)
		
		w=spinner.panel.ClientWidth()
		If (SPINNER_TRACKBAR & flags)
			w=DIV
			If w>spinner.panel.ClientWidth() w=spinner.panel.ClientWidth()
		EndIf
		
		spinner.textfield=CreateTextField(0,0,w-SLIDERWIDTH,spinner.panel.ClientHeight(),spinner.panel)
		If (SPINNER_TRACKBAR & flags)
			SetGadgetLayout spinner.textfield,1,0,1,1
		Else
			SetGadgetLayout spinner.textfield,1,1,1,1
		EndIf
		
		SetGadgetSensitivity spinner.textfield,SENSITIZE_KEYS
		
		spinner.slider=CreateSlider(w-SLIDERWIDTH,0,SLIDERWIDTH,spinner.panel.ClientHeight(),spinner.panel,SLIDER_VERTICAL)		
		If (SPINNER_TRACKBAR & flags)
			SetGadgetLayout spinner.slider,1,0,1,1
		Else
			SetGadgetLayout spinner.slider,0,1,1,1
		EndIf
		AddHook(EmitEventHook,EventHook,spinner)
		
		If (SPINNER_TRACKBAR & flags)
			spinner.trackbar=CreateSlider(w,0,spinner.panel.ClientWidth()-w,spinner.panel.ClientHeight(),spinner.panel,SLIDER_TRACKBAR|SLIDER_HORIZONTAL)
			SetGadgetLayout spinner.trackbar,1,1,1,1
		EndIf
		
		spinner.SetRange_(0,1)
		Return spinner
	EndFunction
	
	Method SetValue_:Int(i:Double)
		i=Max(i,Range[0])
		i=Min(i,Range[1])
		i=Round(i*floatitemmultiplier)/floatitemmultiplier
		i:*floatitemmultiplier
		If i<Range[0] i=Range[0]
		If i>Range[0]+Range[1]-1 i=Range[0]+Range[1]-1
		SetGadgetText textfield,FloatToString(i/floatitemmultiplier,accuracy)
		SetSliderValue slider,Range[1]-(i-Range[0]+1)
		If trackbar SetSliderValue trackbar,i-Range[0]+1
		value=i

	EndMethod
	
	Method GetText:String()
		Return GadgetText(textfield)
	End Method
	
	Function EventHook:Object(id:Int,data:Object,context:Object)
		Local event:TEvent
		Local spinner:TSpinner
		Local i:Int
		Local value:Double
		
	
		event=TEvent(data)
		If event
			spinner=TSpinner(context)
			If spinner
				Select event.id
				
				Case EVENT_KEYDOWN
					If event.source=spinner.textfield
						If EventData()=KEY_PAGEUP
							value=spinner.value
							value=value-((Abs(spinner.Range[0])-Abs(spinner.Range[1]))/10)
							
							If spinner.accuracy=1 value=value/10
							
							spinner.setValue_(value)
							EmitEvent CreateEvent(EVENT_GADGETACTION,spinner)
								Return Null

							
						End If
						If EventData()=KEY_PAGEDOWN
							value=spinner.value
							value=value+((Abs(spinner.Range[0])-Abs(spinner.Range[1]))/10)
							If spinner.accuracy=1 value=value/10
							spinner.SetValue_(value)
							EmitEvent CreateEvent(EVENT_GADGETACTION,spinner)
						Return Null

						End If
					
						
					End If
					
				
				Case EVENT_GADGETLOSTFOCUS
					If event.source=spinner.textfield
						spinner.SetValue_(Double(GadgetText(spinner.textfield)))
						EmitEvent CreateEvent(EVENT_GADGETACTION,spinner)
						Return Null
					EndIf				
				Case EVENT_GADGETACTION
					Select event.source
					Case spinner.trackbar
						If spinner.trackbar
							i=(SliderValue(spinner.trackbar)+spinner.Range[0]-1)
							spinner.SetValue_(i/spinner.floatitemmultiplier)
						EndIf
					Case spinner.textfield
						Return Null
					Case spinner.slider
						i=spinner.Range[1]-(SliderValue(spinner.slider)-spinner.Range[0]+1)
						spinner.SetValue_(Double(i)/spinner.floatitemmultiplier)
						EmitEvent CreateEvent(EVENT_GADGETACTION,spinner)
						Return Null
					EndSelect
				EndSelect
			EndIf
		EndIf
		Return data
	EndFunction
	
	Function Round:Int(val:Double)
		Local dec#
		dec#=val-Floor(val)
		If dec<0.5 Return Floor(val) Else Return Ceil(val)
	EndFunction	
	
	Function FloatToString:String(value:Float,places:Int=3)
		Local sign:Int=Sgn(value)
		value=Abs(value)
		Local i:Int=Round(value*10^places)
		Local ipart:Int=Int(i/10^places)
		Local dpart:Int=i-ipart*10^places
		Local si$=ipart
		Local di$
		If dpart>0
			di=dpart
			While di.length<places
				di="0"+di
			Wend
			di="."+di
		EndIf
		While di[Len(di)-1..]="0"
			di=di[..di.length-1]'Left(di,di.length-1)
		Wend
		If places
			If di="" di=".0"
		EndIf
		If sign=-1 si="-"+si
		Return si+di
	EndFunction	
	
EndType

Rem
bbdoc:Create a Spinner gadget
about:
If @flags is @SPINNER_TRACKBAR a trackbar/slider is shown to change the values.

You can use @{PAGE UP} and @{PAGE DOWN} to change value.
End Rem
Function CreateSpinner:TSpinner(x:Int,y:Int,W:Int,H:Int,group:TGadget,flags:Int=0)
	Return TSpinner.Create(x,y,W,H,group,flags)
EndFunction

Rem
bbdoc:Set the spinner range
about: 
If @accuracy is 1, min and max are Integer values.

If @accuracy is 0, min and max are floating values.

See #CreateSpinner for more information
End Rem
Function SetSpinnerRange:Int(spinner:TSpinner,minimum:Double,maximum:Double,accuracy:Int=1)
	spinner.SetRange_(minimum,maximum,accuracy)
	SetGadgetToolTip spinner.textfield,"Min: "+spinner.FloatToString(Minimum,3)+"~nMax: "+spinner.FloatToString(Maximum,3)
EndFunction

Rem
bbdoc:Set the spinner value
about:see #CreateSpinner for more information

End Rem
Function SetSpinnerValue:Int(spinner:TSpinner,value:Double)
	spinner.SetValue_(value)
EndFunction

Rem
bbdoc:Get the spinner value
about:see #CreateSpinner for more information
End Rem
Function SpinnerValue:Double(spinner:TSpinner)
	
	If SPINNER.accuracy=0	
		Return spinner.value
	Else
		Return (SPINNER.value)/10
	End If
EndFunction
