
'BlitzMax program : 01 May 2015 18:01:01
'Template         : template_maxgui.bmx

SuperStrict
Import maxgui.drivers
Import maxgui.proxygadgets

'Include "proxy_ButtonExtra.bmx"

Global window:tgadget=		CreateWindow("Main",100,100,300,500,,WINDOW_RESIZABLE|WINDOW_TITLEBAR|WINDOW_CENTER)

Local bex:Tgadget[10],ww:Int=260


bex[0]=CreateButtonExtra("This is a textfield","Click me",10,20,ww,30,window,GADGET_TEXTFIELD)
bex[1]=CreateButtonExtra("This is a button","message",10,60,ww,30,window,GADGET_BUTTON)
bex[2]=CreateButtonExtra("This is a combobox","message",10,100,ww,30,window,GADGET_COMBOBOX)
bex[3]=CreateButtonExtra("slider <#value#>","message",10,140,ww,30,window,GADGET_SLIDER)
bex[4]=CreateButtonExtra("Progress <#value#>","message",10,180,ww,30,window,GADGET_PROGBAR)
bex[5]=CreateButtonExtra("Folder","my path",10,220,ww,30,window,GADGET_FOLDERPICKER)
bex[6]=CreateButtonExtra("File","my path",10,260,ww,30,window,GADGET_FILEPICKER)
bex[7]=CreateButtonExtra("Spinner"," ",10,300,ww,30,window,GADGET_SPINNER)
bex[8]=CreateButtonExtra("DatePicker"," ",10,340,ww,30,window,GADGET_DATEPICKER)
bex[9]=CreateButtonExtra("CheckBox"," ",10,370,ww,30,window,GADGET_BUTTONCHECKER)



SetGadgetText bex[8],"dd ml yy"

SetSliderRange bex[3],0,100
SetSliderValue bex[3],70

SetSliderRange bex[7],0,100
SetSliderValue bex[7],70

AddGadgetItem bex[2],"One"
AddGadgetItem bex[2],"Two"
AddGadgetItem bex[2],"Three"

SetGadgetText bex[1],"<#TITLE#>Label new"
SetGadgetText bex[1],"<#SIZE#>30"

SelectGadgetItem bex[2],2

UpdateProgBar bex[4],.55
Rem
Local tmp:Tgadget=tbuttonExtra(bex[6]).Button
If tmp
	Print "Class: "+GadgetClass(TMP)
	Print "Name : <"+tmp.name+">"
	Tfilepicker(tmp).SelectFilter("XLS:XLS")
	
End If
End Rem
Local tmp2:tgadget=tbuttonExtra(bex[6]).GetProxy()
If tmp2
	Print "Tmp2 not null"
	Tfilepicker(tmp2).SelectFilter("XLS:XLS")	

End If





Repeat
	WaitEvent()
	'Print CurrentEvent.ToString()

	Select EventID()
		Case EVENT_APPTERMINATE, EVENT_WINDOWCLOSE
			End
			
		Case EVENT_GADGETACTION
				Select EventSource()
					Case bex[0]		Print "0: textfield ("+String(EventExtra())+")"
					Case bex[1]		Print "1: button"
					Case bex[2]		Print "2: ComboBox = "+EventData()
					Case bex[3]		Print "3: Slider = "+EventData()

					Case bex[5]		Print "5: Folder = "+EventData()+" "+String(EventExtra())
					Case bex[6]		Print "6: File   = "+EventData()+" "+String(EventExtra())
					Case bex[7]		Print "7: Spinner   = "+EventData()+" "+String(EventExtra())
					Case bex[8]		Print "8: DatePicker   = "+EventData()+" "+String(EventExtra())


					
				End Select
	
	
	End Select
Forever
