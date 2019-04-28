SuperStrict
Import maxgui.drivers
Rem

		Progress Bar Evolution
		© degac - 30 ago 2009
		require MaxGUI and some images to work at the best
		
		1.2 - 06 jan 2018
			+ added SetFont() and minor fixes
		
		1.1 - 31 ago 2009
		
			! fixed bug in CleanUp() method
			+ added new style: PBAR_ACTIVE
			+ added new style: PBAR_NOBORDER

End Rem
Rem
'SuperStrict
'Import maxgui.maxgui

Rem
bbdoc: Create a Progress Bar gadget
about:
The Progress Bar gadget has the following styles

[ @Style | @Meaning
* PBAR_STANDARD | It draws a normal progress bar.
* PBAR_DISCRETE |  It draws a discrete progress bar.
* PBAR_INDICATOR | it draws below the progress bar some position indicators.
* PBAR_ALERT | The level reached by the progress bar changes the colour of it. 
* PBAR_SHOW | In the progress bar is showed the % value.
* PBAR_RATING | It draws a rating indicator (1-5 stars)
]

You can combine the styles:
	
	PBAR_STANDARD|PBAR_SHOW			It will shows a standard progress bar and the % value.
	PBAR_STANDARD|PBAR_SHOW|PBAR_INDICATOR	It will shows a standard progress bar, the % value and the indicators.

	PBAR_ALERT	can be used for both PBAR_STANDARD and PBAR_DISCRETE progress bar.
	The warning and critical value (respectly YELLOW and RED color) are set with SetSliderRange command.
	
	PBAR_RATING
	
	The user can change the value (number of stars showed) clicking with the mouse on the gadget.
	You can set the value (0-5) with SetSliderValue command.

End Rem
Function CreatePbar:tGADGET(x:Int,y:Int,WIDTH:Int,HEIGHT:Int,group:TGadget,flags:Int=PBAR_STANDARD)
	Return TPbar.Create(x,y,WIDTH,HEIGHT,group,flags)
EndFunction

Const PBAR_STANDARD:Int	=1
Const PBAR_SHOW:Int		=2
Const PBAR_DISCRETE:Int	=4
Const PBAR_INDICATOR:Int	=8
Const PBAR_ALERT:Int		=16
Const PBAR_RATING:Int		=32
Const PBAR_ACTIVE:Int		=64
Const PBAR_NOBORDER:Int	=128

Type TPbar Extends TProxygadget

	Field _void_pixmap:TPixmap
	Field _green_pixmap:TPixmap
	Field _RED_pixmap:TPixmap
	Field _YELLOW_pixmap:TPixmap
	Field pixmap:TPixmap
	Field _star_pixmap:TPixmap
	Field pixmap_flags:Int=PANELPIXMAP_FIT

	Field panel:tgadget
	Field panel_value:tgadget
	Field panels:tgadget[10]
	Field labels:tgadget[11]
	Field tcolor:Int[]=[0,0,0]

	Field w:Int,h:Int
	
	Field _label_P:tgadget,_label_V:tgadget
	Field _value:Float
	Field _value_warning:Int=6,_value_critical:Int=8
	Field STYLE:Int
	Field flags:Int
	
	Method SetFont:Int(fnt:Tguifont=Null)
		If fnt=Null Return 0
		SetGadgetFont _label_p,fnt
		SetGadgetFont _label_v,fnt
	End Method
	Method GetText:String()
		Return String(_value)
	End Method
	Method Cleanup:Int()
		RemoveHook(EmitEventHook,EventHook,Self)
		setproxy(Null)
		
		If labels
				For Local ss:Int=0 Until labels.length
					If labels[ss] FreeGadget labels[ss]
					labels[ss]=Null
				Next
		End If
		
		If panels
				For Local ss:Int=0 Until panels.length
					If panels[ss] FreeGadget panels[ss]
					panels[ss]=Null
				Next
		End If
		
		If tcolor tcolor=Null
		If panel FreeGadget panel;panel=Null
		If panel_value FreeGadget panel_value;panel_value=Null
		If _label_p FreeGadget _label_p;_label_P=Null
		If _label_v FreeGadget _label_v;_label_v=Null

		
		labels=Null
		panels=Null
		_void_pixmap=Null
		_green_pixmap=Null
		_red_pixmap=Null
		_yellow_pixmap=Null
		_star_pixmap=Null
		pixmap=Null
		'free()
		'Super.cleanup()
	EndMethod
	
	Method SetProp:Int(_val:Int=0)
		_value=_val
		If flags&PBAR_RATING SetValue(_val)
	End Method
	
	Method SetRange:Int(_min:Int=0,_max:Int=10)
		If _min<0 _min=0
		If _max>10 _max=10
		_value_warning=_min
		_value_critical=_max		
	End Method

	Method SetEnabled:Int(sta:Int=True)
		If sta=False
			DisableGadget panel
			DisableGadget panel_value
			If _label_p DisableGadget _label_p
			If _label_v DisableGadget _label_v
			If panels
				For Local ss:Int=0 Until panels.length
					DisableGadget panels[ss]
				Next
			End If

		Else
			EnableGadget panel
			EnableGadget panel_value
			If _label_p EnableGadget _label_p
			If _label_v EnableGadget _label_v
			If panels
				For Local ss:Int=0 Until panels.length
					EnableGadget panels[ss]
				Next
			End If


		End If
		
	End Method

	Method SetShow:Int(bool:Int)
		If panel panel.setShow(bool)
		If panel_value panel_value.SetShow(bool)
		If _label_p	_label_p.SetShow(bool)
		If _label_v _label_v.SetShow(bool)
		If panels
			For Local ss:Int=0 Until panels.length
				If panels[ss] panels[ss].SetShow(bool)
			Next
		End If
		If labels
				For Local ss:Int=0 Until labels.length
					If labels[ss] labels[ss].SetShow(bool)
				Next
		End If

	End Method
	
	Method class:Int()
		Return GADGET_PROGBAR
	End Method
	
	Method SetValue:Int(_val:Float=0)
		
		_value=_val
		Local new_width:Int=_val*GadgetWidth(panel)-2
		Local showval:Float=(Float(new_width)/GadgetWidth(panel))*100+1
		Local current_pix:TPixmap=_green_pixmap
		
		If STYLE=0 'STANDARD
				
				SetGadgetShape panel_value,0,0,new_width,GadgetHeight(panel)-2
			
				If flags&PBAR_ALERT
					If PIXMAP<>Null
					If (Int(showval)/10)>=_value_warning Then SetGadgetPixmap panel_value,_yellow_pixmap,PANELPIXMAP_FIT

					If (Int(showval)/10)>=_value_critical Then SetGadgetPixmap panel_value,_red_pixmap,PANELPIXMAP_FIT
					Else
						If (Int(showval)/10)>=_value_warning Then SetGadgetColor panel_value,239,212,107	
						If (Int(showval)/10)>=_value_critical Then SetGadgetColor panel_value,228,75,67
					End If
				
				End If
			
			
				If _val<.5
					If _label_p
						SetGadgetText _label_p,Int(showval)+" %"
						HideGadget _label_v
						ShowGadget _label_p
						SetGadgetTextColor _label_p,0,0,0'tcolor[0],tcolor[1],tcolor[2]
					End If
				Else
				
					If _label_v 
						Local hhp:Int=h/2-10
						If hhp<0 hhp=0
						SetGadgetShape _label_v,2,HHP,GadgetWidth(panel),GadgetHeight(panel)-6
						SetGadgetText _label_v,Int(showval)+" %"
						HideGadget _label_p
						ShowGadget _label_v
						SetGadgetTextColor _label_v,255,255,255'tcolor[0],tcolor[1],tcolor[2]
					End If
				End If
		End If '--------------------------------- STANDARD STYLE
		
		If STYLE=1 ' DISCRETE
			Local WIDTH:Int=GadgetHeight(panel)
			Local ww:Int=(WIDTH-4)/10-2
			Local X1:Int=1
			If flags&PBAR_ALERT
				If (Int(showval)/10)>=_value_warning Then current_pix=_yellow_pixmap
				If (Int(showval)/10)>=_value_critical Then current_pix=_red_pixmap
			End If
			For Local s:Int=0 Until 10
			
				If _void_pixmap
						SetPanelPixmap panels[s],_void_pixmap,PANELPIXMAP_FIT
				Else
						SetGadgetColor panels[s],192,192,192
				End If


				If s<=Int(showval)/10 
				
					If current_pix
						SetPanelPixmap panels[s],current_pix,PANELPIXMAP_FIT
					Else
						SetGadgetColor panels[s],149,208,98
					End If
				End If
			Rem
				
					If flags&PBAR_ALERT ' ALERT
							
						If (Int(showval)/10)>=_value_warning And s>=_value_warning
							If _yellow_pixmap
								SetPanelPixmap panels[s],_yellow_pixmap,PANELPIXMAP_FIT
							Else
								SetGadgetColor panels[s],239,212,108
							End If
						End If
						
						If (Int(showval)/10)>=_value_critical And s>=_value_critical
							If _red_pixmap
								SetPanelPixmap panels[s],_red_pixmap,PANELPIXMAP_FIT
							Else
								SetGadgetColor panels[s],242,110,106
							End If
						End If
	
					End If
				End If
			End Rem
			
			

			Next
		End If '----------------------------------- DISCRETE STYLE ------------------------------
		
		If style=2 ' RATING
			
			For Local s:Int=1 To 5
				If s<=_value			
					If _star_pixmap 
						?linux
						SetPanelPixmap panels[s-1],Null
						RedrawGadget panels[s-1]
						?						
						SetPanelPixmap panels[s-1],_star_pixmap,PANELPIXMAP_TILE'PANELPIXMAP_FIT
					End If
				Else
					SetPanelPixmap panels[s-1],Null
				End If

			Next			
			


		End If
		
	End Method
	
	Method SetColor:Int(R:Int=255,G:Int=255,B:Int=255)
		SetGadgetColor panel,r,g,b
	End Method
	
	Method SetTextColor:Int(R:Int=255,G:Int=255,B:Int=255)
		If PANEL_VALUE SetGadgetColor panel_value,r,g,b
		tcolor=[r,g,b]
	End Method
	
	Method SetPixmap:Int(pix:TPixmap,flags:Int)
		pixmap=pix
		pixmap_flags=flags
		?linux
			If pixmap 
				SetPanelPixmap panel_value,Null
				RedrawGadget panel_value
				SetPanelPixmap panel_value,pixmap,PANELPIXMAP_STRETCH
			End If
		?
		?win32
			If pixmap SetPanelPixmap panel_value,pixmap,PANELPIXMAP_STRETCH
		?
	End Method
	
	
	
	Function Create:TPbar(x:Int,y:Int,WIDTH:Int,HEIGHT:Int,group:TGadget,flags:Int=PBAR_STANDARD)
		Local PB:TPBAR=New TPBAR

		pb._void_pixmap=LoadPixmap("resources/indicator_void.png")
		pb._green_pixmap=LoadPixmap("resources/indicator_green.png")
		pb._red_pixmap=LoadPixmap("resources/indicator_RED.png")
		pb._yellow_pixmap=LoadPixmap("resources/indicator_YELLOW.png")
		pb._star_pixmap=LoadPixmap("resources/star.png")

		pb.w=WIDTH
		pb.h=HEIGHT
		
		If flags&PBAR_INDICATOR			

			Local hh:Int=5,cou:Int,x2:Int=x
			Local sw:Int=WIDTH/10
							
			While x2<(x+WIDTH+2)			
				If cou=0 Or cou=5 Or cou=10 hh=8 Else hh=4
				pb.labels[cou]=CreateLabel("",x2,y+HEIGHT+1,2,hh,group,LABEL_SEPARATOR)
				x2:+sw
				cou:+1
			Wend
		End If


		If FLAGS&PBAR_STANDARD 
			
			If flags&PBAR_NOBORDER
				pb.panel=CreatePanel(x,y,WIDTH,HEIGHT,group)
			Else
				pb.panel=CreatePanel(x,y,WIDTH,HEIGHT,group,PANEL_BORDER)
			End If
			pb.panel_value=CreatePanel(1,1,pb._value,HEIGHT-2,pb.panel)
			SetGadgetColor PB.panel_value,10,36,106
						
			If flags&PBAR_SHOW
				Local hhp:Int=HEIGHT/2-10
				If hhp<0 hhp=0
				PB._label_P=CreateLabel("",0,hhp,WIDTH-5,HEIGHT,pb.panel,LABEL_RIGHT)
				If PB.panel_value pb._label_V=CreateLabel("",0,hhp,WIDTH,HEIGHT,pb.panel_value,LABEL_LEFT)
				

			End If
			
			pb.style=0 ' standard
		
		End If
	
		If flags&PBAR_DISCRETE
			'create a discrete progress bar (10 'pieces' of bar)
			pb.panel=CreatePanel(x,y,WIDTH,HEIGHT,group)',PANEL_BORDER)
		'	SetGadgetColor pb.panel,212,208,200

			Local ww:Int=(WIDTH-8)/10-1
			Local X1:Int=1
			For Local s:Int=0 Until 10
				pb.panels[s]=CreatePanel(X1,2,ww,HEIGHT-8,pb.panel)',PANEL_BORDER)
				X1:+WW+2
				If pb._void_pixmap 
			
					SetPanelPixmap pb.panels[s],pb._void_pixmap,PANELPIXMAP_FIT
				Else
					SetGadgetColor pb.panels[s],192,192,192
				End If
			Next
			pb.style=1 ' discrete
		
		End If
		
		If flags&PBAR_RATING	
			
			pb.style=2
			pb.panel=CreatePanel(x,y,WIDTH,HEIGHT,group)',PANEL_ACTIVE|PANEL_BORDER)
			Local ww:Int=32
			Local X1:Int=1
			If pb._star_pixmap ww=PixmapWidth(pb._star_pixmap)			

			For Local s:Int=0 Until 5
				pb.panels[s]=CreatePanel(X1,2,ww,HEIGHT-8,pb.panel,PANEL_ACTIVE)
				x1:+ww
				If pb._star_pixmap 
					SetPanelPixmap pb.panels[s],pb._star_pixmap,PANELPIXMAP_FIT
				End If
			Next		
			
			pb.setvalue(5)	
			
		End If
		
		
		pb.flags=flags
		pb.SetProxy(pb)
		AddHook(EmitEventHook,EventHook,PB)
		Return PB
	EndFunction
		
	Function EventHook:Object(id:Int,data:Object,context:Object)
		Local event:TEvent
		Local pbar:TPbar
		Local i:Int
		event=TEvent(data)
		If event
			pbar=TPbar(context)
			If pbar

				If PBAR.style=2
				
					
				If event.id=EVENT_MOUSEENTER
					SetPointer POINTER_HAND
				End If
				
				If event.id=EVENT_MOUSELEAVE
					SetPointer POINTER_DEFAULT
				End If
				
				
				
				If EVENT.id=EVENT_MOUSEDOWN
					If pbar.flags&PBAR_ACTIVE
						For Local s:Int=0 Until 5
							If event.source=pbar.panels[S]
								PBAR.setProp(s+1)
								EmitEvent CreateEvent(EVENT_GADGETACTION,pbar,pbar._value)
								Return Null
								
							End If
						Next
					End If
				End If
				End If
				
			EndIf
		EndIf
		Return data
	EndFunction
	
	
EndType
