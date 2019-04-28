
SuperStrict

Import MaxGui.Drivers
Import maxgui.proxygadgets
Local window:TGadget

window=CreateWindow("Spinner Example",40,40,320,240)

Local spinner:TSpinner
Local spinner0:tspinner

Local label:TGadget
Local x:Int=2,y:Int=2

label=CreateLabel("Float spinner:",x,y,200,18,window)
SetGadgetLayout label,1,0,1,0
y:+18
spinner0=CreateSpinner(x,y,80,20,window)

SetSpinnerRange(spinner0,0,10,1)
SetSliderValue spinner0,5
SetGadgetLayout spinner0,1,1,1,0
y:+22

label=CreateLabel("Integer spinner with trackbar:",x,y,200,18,window)
SetGadgetLayout label,1,0,1,0
y:+18
spinner=CreateSpinner(x,y,300,20,window,SPINNER_TRACKBAR)
SetSpinnerRange(spinner,-100,100,0)
SetGadgetLayout spinner,1,1,1,0
y:+22
SetGadgetColor spinner,200,20,20

spinner=CreateSpinner(x,y,300,20,window,SPINNER_TRACKBAR)
SetSpinnerRange(spinner,-10,10,0)
SetSpinnerValue(spinner,-3)
SetGadgetLayout spinner,1,1,1,0

'DisableGadget spinner



While True
	WaitEvent 
	'Print CurrentEvent.ToString()
	Select EventID()
		Case EVENT_GADGETACTION
			If EventSource()=spinner0
				Print "Value: "+SpinnerValue(spinner0)
			End If
		Case EVENT_WINDOWCLOSE
			End
	End Select
Wend
