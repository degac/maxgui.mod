SuperStrict
Import MaxGUI.MaxGUI
Import BRL.Timer
Import BRL.Max2d
Import "common.bmx"

Rem
		story
		
		27.12.2017	
		fixed a bug with Timer()

End Rem

Rem
bbdoc:Create an Icon gadget
about:This gadget shows an icon (static or animated).<br>
Image can be either a PIXMAP or an ICONSTRIP. In this case it is considered as animated.<br>
Style can be @ICON_GADGET_STATIC to show a static frame.<br>
With #SelectGadgetItem you can change the current frame.<br>
You can change animation parameters with #SetGadgetAnim and read them with #GetGadgetAnim.<br>
You can change iconstrip with #SetGadgetIconStrip or change static image with #SetGadgetPixmap<br>
An event of type EVENT_GADGETACTION is raised if you click on the icon.<br>
See also #SetGadgetAnim and #GetGadgetAnim<br>
End Rem
Function CreateIconGadget:TIconGadget(x:Int,y:Int,w:Int,h:Int,window:tgadget=Null,image:Object=Null,style:Int=0)
	Return Ticongadget.Create(x,y,w,h,window,image,style)
End Function

Rem
bbdoc:Set parameter for the IconGadget
about:See #CreateIconGadget
End Rem
Function SetGadgetAnim:Int(gadget:Tgadget,_play:Int=-1,fst:Int=-1,fe:Int=-1,fs:Int=-1,fd:Int=-1)
	Local g:TiconGadget=tIconGadget(gadget)
	If g
		If _play=1	g.animated=1
		If _play=0	g.animated=0
	
		If fd=0		g.frame_direction=0
		If fd=1		g.frame_direction=1
		
		If fst<>-1	g.frame_start=fst
		If fe<>-1		g.frame_max=fe
		If fs<>-1 	g.frame_duration=fs

		If g.iconstrip
			If g.frame_max>g.iconstrip.count g.frame_max=g.iconstrip.count-1
			If g.frame_start<0 g.frame_start=0
			If g.frame_current<g.frame_start g.frame_current=g.frame_start
		End If
	End If
End Function

Rem
bbdoc: Get info about animation of the IconGadget
about: 
[ @parameter | @Description 
* a | 1: animated, 0: not animated
* b | start frame
* c | end frame
* d | frame speed
* e | reversed (0,1)
]

End Rem
Function GetGadgetAnim:Int(gad:Tgadget,a:Int Var, b:Int Var, c:Int Var, d:Int Var,e:Int Var)
	Local g:Ticongadget=Ticongadget(gad)
	If g
		a=g.animated
		b=g.frame_start
		c=g.frame_max
		d=g.frame_duration
		e=g.frame_direction
		Return 0
	End If
End Function

Const ICON_GADGET_STATIC:Int=2

Type TIconGadget Extends tproxygadget
	Field style:Int,animated:Int,original_animated:Int
	Field panel:Tgadget,name:String
	Field iconstrip:TiconStrip,grey_iconstrip:Ticonstrip,o_iconstrip:Ticonstrip
	Field pixmap:TPixmap,grey_pixmap:TPixmap,o_pixmap:TPixmap
	Field frame_max:Int,frame_current:Int,frame_timer:Int,frame_duration:Int=125,frame_start:Int
	Field frame_direction:Int=0
	Global icon_timer:Ttimer
		
	Function Create:TIconGadget  (x:Int,y:Int,w:Int,h:Int,group:TGadget=Null,image:Object=Null,style:Int=0)
		Local sp:TIconGadget=New TIconGadget  
		If TIconGadget.icon_timer=Null TiconGadget.icon_timer=CreateTimer(60)
		
		If ticonstrip(Image)	'it is an iconstrip
			sp.iconstrip=ticonstrip(image)
			sp.o_iconstrip=Ticonstrip(image)
			sp.grey_iconstrip=ticonstrip(MakeGrey(image))
		End If
		If TPixmap(Image)		'is is a pixmap	---> means 'static icon'
			sp.pixmap=TPixmap(image)
			sp.o_pixmap=TPixmap(image)			
			sp.grey_pixmap=TPixmap(MakeGrey(image))
		End If
		
		SP.style=style		
		sp.panel=CreatePanel(x,y,w,h,group,PANEL_ACTIVE)
		
		If sp.pixmap
			SetGadgetPixmap sp.panel,sp.pixmap,PANELPIXMAP_FIT
			sp.animated=0
		End If
		
		sp.name="ID "+MilliSecs()
		
		If sp.iconstrip
			sp.pixmap=PixmapFromIconStrip(sp.iconstrip,0)
			SetGadgetPixmap sp.panel,sp.pixmap,PANELPIXMAP_FIT
			sp.frame_max=sp.iconstrip.count-1
			sp.animated=1
			sp.frame_start=0
			sp.frame_current=0
		End If
		
		Select SP.style
			Case ICON_GADGET_STATIC	sp.animated=0
		End Select
		
		sp.original_animated=sp.animated
		AddHook EmitEventHook,EventHandler,sp
		sp.SetProxy sp.panel
		sp.frame_timer=MilliSecs()
		
		'DebugLog "IconGadget: Animated: "+sp.animated
		
		Return sp
	End Function
	
	Method class:Int()
		Return GADGET_ICONGADGET
	End Method
	
	Method GetText:String()
		Return ""
	End Method
	
	Method SetIconStrip:Int(ics:Ticonstrip)
		iconstrip=ics
		o_iconstrip=ics
		grey_iconstrip=ticonstrip(MakeGrey(ics))
		pixmap=PixmapFromIconStrip(iconstrip,0)
		SetGadgetPixmap panel,pixmap,PANELPIXMAP_FIT
		frame_max=iconstrip.count
		frame_current=0
		frame_start=0
	End Method
	
	Method SetPixmap:Int(pix:TPixmap,flags:Int)
		pixmap=pix
		o_pixmap=pix		
		grey_pixmap=TPixmap(MakeGrey(pix))
		SetGadgetPixmap panel,pixmap,PANELPIXMAP_FIT
		animated=0
	End Method

	Method SelectItem:Int(index:Int,opt:Int=0)
		If iconstrip=Null Return -1
		
		If index<0 index=0
		If index>iconstrip.count-1	index=iconstrip.count-1
		frame_current=index
		Local pp:TPixmap		
		pp=PixmapFromIconStrip(iconstrip,frame_current)
		SetGadgetPixmap panel,pp,PANELPIXMAP_FIT

	End Method

	Method SetItem:Int(index:Int,Text:String,tip:String,icon:Int,extra:Object,flags:Int)
		If tip<>"" SetGadgetToolTip panel,tip
	End Method

	Method SetEnabled:Int(status:Int=True)
		If status=True
			animated=original_animated
			pixmap=o_pixmap
			iconstrip=o_iconstrip
			EnableGadget panel
		Else
			original_animated=animated
			animated=0
			pixmap=grey_pixmap
			iconstrip=grey_iconstrip
			DisableGadget panel
		End If
		Local pp:TPixmap
		If iconstrip
				pp=PixmapFromIconStrip(iconstrip,frame_current)
		Else
				pp=pixmap
		End If
		SetGadgetPixmap panel,pp,PANELPIXMAP_FIT

	End Method



	Method CleanUp:Int()
		icon_timer=Null
		pixmap=Null
		iconstrip=Null
		grey_pixmap=Null
		grey_iconstrip=Null
		o_pixmap=Null
		o_iconstrip=Null
		FreeGadget panel
		RemoveHook(EmitEventHook,EventHandler,Self)
		Super.Cleanup()
	End Method

	
	Function eventHandler:Object( pID%, pData:Object, pContext:Object )
		Local pEvent:TEvent = TEvent(pData)
		Local pp:TPixmap,sp:TiconGadget=TiconGadget(pContext)
		
		If pEvent 
			
			Select pevent.id
			
				Case EVENT_MOUSEDOWN
						If pevent.source=sp EmitEvent(CreateEvent(EVENT_GADGETACTION,pevent.source));Return Null
						
				Case EVENT_TIMERTICK	
						If pevent.source=sp.icon_timer
								If sp.animated=True
								If MilliSecs()>sp.frame_timer+sp.frame_duration
									pp=PixmapFromIconStrip(sp.iconstrip,sp.frame_current)
									SetGadgetPixmap sp.panel,pp,PANELPIXMAP_FIT
									If sp.frame_direction=0
										sp.frame_current:+1
										If sp.frame_current>sp.frame_max sp.frame_current=sp.frame_start
									Else
										sp.frame_current:-1
										If sp.frame_current<sp.frame_start sp.frame_current=sp.frame_max
									End If
									sp.frame_timer=MilliSecs()
								End If
							End If
						End If
			End Select
			
		EndIf

		
		Return pData
	EndFunction
	
	Method State:Int()
		
	End Method
	
	Method SetShow:Int(bool:Int)
		panel.setshow(bool)
	End Method


End Type