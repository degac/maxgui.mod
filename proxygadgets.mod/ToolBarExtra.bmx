SuperStrict

Import MaxGUI.MaxGUI
Import brl.max2d
Import "common.bmx"
Rem
	
		toolbar extra
		
		v.1.35 03 mar 2018
			
				ModifyGadgetItem toolbar,id,"ICON_NUMBER"
				same as ToggleGadgetItem
				
				+ added method SetState(state) for single item
		
		v.1.34	15 mar 2014
				+ method: 
					ModifyGadgetItem
						it changes only text,tips,extra (at the moment)
					ToggleGadgetItem (only for TOOLBARITEM_SWITCH)
					SelectedGadgetItem() and more
		
				+ added new GADGET: SLIDER, in ToolTip you can add %V to pass the slider's value
				
				! fixed: toolbar color and gadget colors, resize windows, and toolbar view
				! moved to common.bmx the 'MakeLight' function for pixmap/iconstrip
		
		v 1.33
		
		10 mar 2014
		+	methods:
				Clear - remove all icons in the toolbar
				RemoveItem - remove a SINGLE icon/item in the toolbar
		
		08 mar 2014
		+	methods: 
				SetTextColor
				SetFont
				SetIconStrip (for new icons)
				
		
		
		
		
		+ automatic grey-disabled for pixmap
		+ automatic lighter (over) for pixmap

		+ support for Localization (require a RedrawGadget)
		+ support for HideGadget and ShowGadget for toolbar

End Rem
Const TOOLBARITEM_BUTTON:Int=1
Const TOOLBARITEM_TEXTFIELD:Int=2
Const TOOLBARITEM_COMBOBOX:Int=3
Const TOOLBARITEM_SWITCH:Int=4
Const TOOLBARITEM_LABEL:Int=5
Const TOOLBARITEM_TEXTBUTTON:Int=6
Const TOOLBARITEM_RADIOBUTTON:Int=7
Const TOOLBARITEM_SLIDER:Int=8
Const TOOLBARITEM_SEPARATOR:Int=99



Type tToolItem 

	
	Global font_size:Int=FontSize(LookupGuiFont())	
	Field gadget:tgadget
	Field return_id:Int
	Field status:Int=1
	Field WIDTH:Int=80
	Field enabled:Int=~STATE_DISABLED,old_enabled:Int=~STATE_DISABLED
	Field icon_normal:Int,icon_select:Int,icon_current:Int
	Field item_type:Int=TOOLBARITEM_BUTTON
	Field toolbar:tToolbarExtra
	Field tip:String


	Method Clear:Int()
		If gadget FreeGadget gadget
		If toolbar toolbar=Null
	End Method
	
	
	
	Function Create:tToolitem(id:Int,tb:tToolbarExtra,_x:Int,_TYPE:Int,_title$,_return_id:Int=-1,_icon:Int=-1)
		Local it:ttoolitem=New ttoolitem
		Local pix:TPixmap
		it.return_id=_return_id
		If it.return_id=-1
			it.return_id=Len(tb.tool_gadget)-1
		End If
		it.item_type=_TYPE
		it.WIDTH=tb.item_width
		
		Select _TYPE
			
			Case TOOLBARITEM_SEPARATOR
			
			Case TOOLBARITEM_SLIDER
				it.gadget=CreateSlider(_x,4,it.WIDTH,20,tb.panel,SLIDER_HORIZONTAL|SLIDER_TRACKBAR)
		
			Case TOOLBARITEM_BUTTON,TOOLBARITEM_SWITCH 
			
				it.gadget=	CreatePanel(_x,0,24,32,tb.panel,PANEL_ACTIVE)
				If _icon>-1
					pix=PixmapFromIconStrip(tb.iconstrip,_icon)
					SetGadgetPixmap it.gadget,pix,PANELPIXMAP_CENTER
					SetGadgetToolTip it.gadget,LocalizeString(_title)
					If _TYPE=TOOLBARITEM_SWITCH
						it.icon_normal=_icon
						it.icon_select=_icon+1
						it.icon_current=_icon
					End If
				End If
			Case TOOLBARITEM_RADIOBUTTON
				it.gadget=	CreateButton(LocalizeString(_title),_x,1,it.WIDTH,30,tb.panel,BUTTON_RADIO|BUTTON_PUSH)
			Case TOOLBARITEM_TEXTBUTTON
				it.gadget=	CreateButton(LocalizeString(_title),_x,3,it.WIDTH,25,tb.panel)
			
			Case TOOLBARITEM_TEXTFIELD
				it.gadget=	CreateTextField(_x,4,it.WIDTH,22,tb.panel)
				SetGadgetToolTip it.gadget,LocalizeString(_title)
				SetGadgetSensitivity it.gadget,SENSITIZE_KEYS
				SetGadgetText it.gadget,LocalizeString(_title)
			Case TOOLBARITEM_COMBOBOX
				it.gadget=	CreateComboBox(_x,4,it.WIDTH,22,tb.panel)
				SetGadgetToolTip it.gadget,LocalizeString(_title)
				
			Case TOOLBARITEM_LABEL	
				it.gadget=	CreateLabel(LocalizeString(_title),_x,8,it.WIDTH,22,tb.panel)
				Local size:Int=Len(LocalizeString(_title))
				SetGadgetShape it.gadget,_x,8,(size-1)*font_size,22
				
		End Select
		If tb.tfont<>Null Then SetGadgetFont(it.gadget,tb.tfont)
		If tb.txt_rgb it.gadget.SetTextColor tb.txt_rgb[0],tb.txt_rgb[1],tb.txt_rgb[2]
		If _TYPE=TOOLBARITEM_SLIDER
		If tb.colors	SetGadgetColor it.gadget,tb.colors[0],tb.colors[1],tb.colors[2]
			SetGadgetToolTip it.gadget,LocalizeString(_title.Replace("%V",""))
		End If
		it.tip=_title
		it.toolbar=tb
		SetGadgetExtra it.gadget,it
		it.icon_current=_icon
		it.toolbar.ReshapeAll()
		Return it
		
	End Function
	
	Function CreateSeparator:Ttoolitem()
		Local it:ttoolitem=New ttoolitem
		it.item_type=TOOLBARITEM_SEPARATOR
		Return it
	End Function
	
	Method AddSubItem:Int(_title:String="",_FLAGS:Int=0,_icon:Int=-1,_tip$="",_EXTRA:Object=Null)
		AddGadgetItem gadget,_title,_FLAGS,_icon,_tip,_EXTRA
	End Method
	


	
	Method SelectSubItem:Int(id:Int)
		SelectGadgetItem gadget,id
	End Method
	
	Method SetSwitchIcon:Int(_normal:Int=0,_select:Int=0)
		icon_normal=_normal
		icon_select=_select
		SwapIcon()
	End Method
	
	Method SetState:Int(_STATE:Int=0)
		Local _icon:Int
		Select _STATE
			Case 0	_icon=icon_normal
			Case 1 _icon=icon_select		
		End Select
			icon_current=_icon
		Local pix:TPixmap=PixmapFromIconStrip(toolbar.iconstrip,_icon)
		SetGadgetPixmap gadget,pix,PANELPIXMAP_CENTER

	Return 0

	End Method
	
	
	Method SwapIcon:Int()
		Local _icon:Int=icon_normal
		Select status
			Case 0
				_icon=icon_normal
			Case 1
				_icon=icon_select
		End Select
		status=1-status
		icon_current=_icon
		Local pix:TPixmap=PixmapFromIconStrip(toolbar.iconstrip,_icon)
		SetGadgetPixmap gadget,pix,PANELPIXMAP_CENTER
		
	End Method
	
	Method SetOver:Int()
		Local pix:TPixmap
		If enabled=~STATE_DISABLED
			If item_type=TOOLBARITEM_BUTTON Or item_type=TOOLBARITEM_SWITCH
				pix=PixmapFromIconStrip(toolbar.light_iconstrip,icon_current)
				SetGadgetPixmap gadget,pix,PANELPIXMAP_CENTER
			End If
		End If
	End Method
	
	Method SetNormal:Int()
		Local pix:TPixmap
		If item_type=TOOLBARITEM_BUTTON Or item_type=TOOLBARITEM_SWITCH
				pix=PixmapFromIconStrip(toolbar.iconstrip,icon_current)
				SetGadgetPixmap gadget,pix,PANELPIXMAP_CENTER
				If enabled=STATE_DISABLED
							pix=PixmapFromIconStrip(toolbar.grey_iconstrip,icon_current)
							SetGadgetPixmap gadget,pix,PANELPIXMAP_CENTER
				End If
		End If
	End Method
	
	Method SetProp:Int(key:String,value:String)
		Rem
				to change specific props
		End Rem
		Local vs:String[],vi:Int[],vf:Int[]
		vs=value.split(",")
		
		Select key.toupper()
			
			Case "STATE"
				SwapIcon()
		
			Case "RANGE"
				vs=vs[..2]
				vi=vi[..Len(vs)]
				For Local i:Int=0 Until Len(vs)
					vi[i]=Int(vs[i])
				Next
				
				If item_type=TOOLBARITEM_SLIDER	
					SetSliderRange gadget,vi[0],vi[1]
				End If
			Case "VALUE"
				vs=vs[..1]
				If item_type=TOOLBARITEM_SLIDER	
					SetSliderValue gadget,Int(vs[0])
				End If
				
	
		End Select
	
	End Method
	
End Type
Rem
bbdoc:Create a toolbar with extra functions
about: this toolbar is a little different from the standard one<br>
It allows to have many other gadget (of different type) in it<br>
You can have more than one toolbar in your window/panel<br>

The type of gadget must be defined using #AddGadgetItem<br>
You can use #RemoveGadgetItem and #ClearGadgetItems to remove a single or all the items

[ @Style | @Description 
* TOOLBARITEM_BUTTON | It specifies a standard button
* TOOLBARITEM_SEPARATOR | It creates a separator (just a blank space)
* TOOLBARITEM_TEXTBUTTON | It creates a Button with text passed via AddGadgetItem
* TOOLBARITEM_SWITCH | It creates a button/switch: it can have 2 values ON or OFF
* TOOLBARITEM_LABEL | It creates a Label
* TOOLBARITEM_TEXTFIELD | It creates a textfield gadget
* TOOLBARITEM_RADIOBUTTON | It creates a radio button
* TOOLBARITEM_COMBOBOX | It creates a ComboBox gadget<br>This gadget must be created using the METHOD @AddItem<br>Items to it must be added using METHOD @AddSubItem<br>
* TOOLBARITEM_SLIDER | It creates a Trackbar slider<br>This gadget should be created using the METHOD @AddItem<br>to set @Range and @Value<br>In tooltip you can use %%V to pass the sliders' value
]

You can set the size of any gadget added changing the FIELD @item_width <br>
You also can use <br>
@ModifyGadgetItem to change items<br>
@ToogleGadgetItem to change the status of a TOOLBARITEM_SWITCH<br>
There are also the following methods (non MaxGui standard)

[ @Style | @Description 
* SetSwitchIcon(a,b) | It allow to specify what icons are used in the SWITCH BUTTON
* AddItem(TOOLBARITEM_BUTTON,"Add",1,0) | Equivalent to using #AddGadgetItem
* AddSubItem("Item 1") | Needed to use ComboBox gadget
* AddSeparator() | The same as using TOOLBARITEM_SEPARATOR
* SetProp(key$,value$) | you can set some prop of gadget<br>RANGE - x,y<br>VALUE - x<br>
* SetState(value) | to force a specific state on TOOLBARITEM_SWITCH
]

End Rem
Function CreateToolbarExtra:TtoolbarExtra(_PARENT:tgadget=Null,_iconstrip:ticonstrip=Null,style:Int=0)
	Return ttoolbarextra.Create(_PARENT,_iconstrip,style)
End Function


Type tToolbarExtra  Extends TProxyGadget
	Global item_width:Int=80
	Field panel:tgadget,line:tgadget,line_up:tgadget
	Field parent:tgadget,tfont:Tguifont
	Field tool_gadget:tToolItem[],colors:Byte[3]
	Field iconstrip:TiconStrip
	'Field grey:TPixmap
'	Field light:TPixmap
	Field grey_iconstrip:ticonstrip
	Field light_iconstrip:ticonstrip
	Field x:Int
	Field name:String
	Field left_button:tgadget,right_button:tgadget
	Field start_from:Int=0,last_from:Int,txt_rgb:Int[3]
	Global list_tbextra:TList
	
	Function Create:tToolbarExtra(parent:tgadget=Null,_iconstrip:ticonStrip=Null,_style:Int=0)
		If parent=Null Return Null
		
		Local tb:tToolbarExtra=New tToolbarExtra
	
		tb.panel=	CreatePanel(0,0,ClientWidth(parent),32,parent)
		tb.line=	CreateLabel("",0,30,ClientWidth(parent),0,tb.panel,LABEL_SEPARATOR)
		tb.line_up=	CreateLabel("",0,0,ClientWidth(parent),0,tb.panel,LABEL_SEPARATOR)
		tb.iconstrip=_iconstrip
		tb.parent=parent
		AddHook EmitEventHook,EventHandler,tb
		SetGadgetLayout tb.panel,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,0
		
		If list_tbextra=Null list_tbextra=New TList
		list_tbextra.addlast tb
		tb.SetProxy( tb )
		tb.left_button=CreateButton("<",0,2,10,28,tb.panel)
		tb.right_button=CreateButton(">",10,2,10,28,tb.panel)
		SetGadgetLayout tb.left_button,EDGE_ALIGNED,0,EDGE_ALIGNED,0
		SetGadgetLayout tb.right_button,EDGE_ALIGNED,0,EDGE_ALIGNED,0
		tb.visible=True
		tb.grey_iconstrip=Ticonstrip(makeGrey(_iconstrip))
		tb.light_iconstrip=Ticonstrip(MakeLight(_iconstrip))
		'tb.light=TPixmap(Makelight(_iconstrip))
		
		
		Local re:Byte,ge:Byte,be:Byte
		
		LookupGuiColor( GUICOLOR_WINDOWBG,re,ge,be)
		SetGadgetColor tb.panel,re,ge,be
		tb.colors=[re,ge,be]
		Return tb
	End Function
	
	Method SetTextColor:Int(r:Int=255,g:Int=255,b:Int=255)
		txt_rgb=[r,g,b]
	End Method
	
	
	Method SetColor:Int(r:Int=255,g:Int=255,b:Int=255)
		SetGadgetColor panel,r,g,b
		colors=[Byte(r),Byte(g),Byte(b)]
	End Method
	
	Method Activate:Int(cmd:Int=0)
		For Local t:ttoolItem=EachIn tool_gadget
			If t.gadget
				SetGadgetToolTip t.gadget,LocalizeString(t.tip)
			End If
		Next
	End Method
		
	Method CleanUp:Int()
		'DebugLog "ToolBarExtra:CleanUp"
		RemoveHook EmitEventHook,EventHandler,Self
		If tool_gadget
			For Local k:Int=0 Until Len(tool_Gadget)
				If tool_gadget[k]<>Null
				tool_gadget[k].Clear
				tool_gadget[k]=Null
				End If
			Next
			tool_gadget=Null
		End If
		If colors		colors=Null
		If iconstrip iconstrip=Null
		'If light		light=Null
		If txt_rgb	txt_rgb=Null
		If grey_iconstrip grey_iconstrip=Null
		If light_iconstrip light_iconstrip=Null		
		If tfont	tfont=Null
		If left_button	FreeGadget left_button;left_button=Null
		If right_button	FreeGadget right_button;right_button=Null
		If line		FreeGadget line;line=Null
		If panel		FreeGadget panel;panel=Null 
		If panel FreeGadget panel;panel = Null
		'Super.CleanUp()
		'DebugLog "End"
	End Method
	
	Method SetShow:Int(truefalse:Int=True)
		If truefalse=True And visible=0
			SetGadgetShape panel,0,0,panel.WIDTH,32
			For Local g:tgadget=EachIn parent.kids
				If g<>panel
					SetGadgetShape g,g.xpos,g.ypos+32,g.WIDTH,g.HEIGHT
				End If
			Next
			visible=1
			ReshapeAll()
			EnableAll()
			RedrawGadget panel
		End If
		If truefalse=False And visible=1
			SetGadgetShape panel,0,0,panel.WIDTH,0
			RedrawGadget panel
			For Local g:tgadget=EachIn parent.kids
				If g<>panel
					SetGadgetShape g,g.xpos,g.ypos-32,g.WIDTH,g.HEIGHT
				End If
			Next
			visible=0
		End If
		
	End Method
	
	Method ReshapeAll:Int()
			Local _x:Int,_y:Int,_h:Int,_w:Int
			Local tow:Int
			If tool_gadget=Null Return 0
			For Local g:tToolItem=EachIn tool_gadget
				If g.item_type<>TOOLBARITEM_SEPARATOR
					tow:+GadgetWidth(g.gadget)+1
					HideGadget g.gadget
				Else
					tow:+16
				End If
				
			Next
			If tow>panel.WIDTH _X=20

			tow=0
			'For Local g:tToolItem=EachIn tool_gadget
			Local g:ttoolItem
			If start_from>Len(tool_gadget)-1 start_from=Len(tool_gadget)-1
			If start_from<0 start_from=0

			For Local index:Int=start_from Until Len(tool_Gadget)		
				g=tool_Gadget[index]
				If g
				If g.item_type<>TOOLBARITEM_SEPARATOR
					ShowGadget g.gadget
					_y=GadgetY(g.gadget)
					_w=GadgetWidth(g.gadget)
					_h=GadgetHeight(g.gadget)
					SetGadgetShape g.gadget,_x,_y,_W,_h
					_x:+_w+1
					tow:+_w+1
				Else
					_x:+16
					tow:+16
				End If
				
							
				
				End If
				
				
				
			Next

			
			If (tow)>panel.WIDTH-32

				ShowGadget left_button
				ShowGadget right_button
			Else
				HideGadget left_button
'				last_from=start_from
'				start_from=0
				HideGadget right_button
			End If
			
			
			
			
			If last_from>0 ShowGadget right_button;ShowGadget LEFT_BUTTON
			RedrawGadget panel
	End Method
	
	
	Function eventHandler:Object( pID%, pData:Object, pContext:Object )
		Local pEvent:TEvent =  TEvent(pData)
		Local obj:tToolbarExtra= tToolbarExtra(pContext)
		Local item:ttoolitem
		Local extra:String
		
		If pEvent
		'	Print "Event: {"+pevent.tostring()+"}"
			Select pevent.id
			
				Case EVENT_MOUSELEAVE
					If pevent.source<>Null
						item=Ttoolitem(GadgetExtra(TGADGET(PEVENT.SOURCE)))	
						If item
							item.SetNormal()
						End If
					End If
				Case EVENT_MOUSEENTER
					If pevent.source<>Null
						item=Ttoolitem(GadgetExtra(TGADGET(PEVENT.SOURCE)))	
						If item
							item.SetOver()
						End If
					End If
				Case EVENT_WINDOWMOVE,EVENT_WINDOWCLOSE,EVENT_WINDOWACTIVATE,WINDOW_ACCEPTFILES
					obj.ReshapeAll()
				
				Case EVENT_WINDOWSIZE
						If obj.visible=True
						Local w:Int=ClientWidth(tgadget(pevent.source))
						SetGadgetShape obj.panel,0,0,w,32
						SetGadgetShape obj.line,0,30,w,0
						SetGadgetShape obj.line_up,0,0,w,0
						obj.last_from=0
						obj.start_from=0

						obj.reshapeAll()
						End If
				Case EVENT_KEYUP
				
					If pevent.data=13
						For Local tb:ttoolbarExtra=EachIn obj.list_tbextra
							If tb<>Null
								For Local item:ttoolitem=EachIn tb.tool_gadget
									If item.gadget=pevent.source
										Return CreateEvent( EVENT_GADGETACTION, item.toolbar,item.return_id,0,0,0,String(GadgetText(item.gadget)))
									End If
								Next
							End If
						Next
					End If
					
					
					
				Case EVENT_GADGETACTION
			
					For Local tb:ttoolbarExtra=EachIn obj.list_tbextra
						If tb<>Null
							If tb.left_button=tgadget(pevent.source)
								tb.start_from:+1
								tb.last_from=tb.start_from
								tb.ReshapeAll()
								PEVENT=Null
								Return Null
							End If
							
							If tb.right_button=tgadget(pevent.source)
								tb.last_from:-1
								tb.start_from=tb.last_from

								tb.ReshapeAll()
								PEVENT=Null
								Return Null
							End If
							Local mods:Int,x:Int,y:Int,ti:String										
							For Local item:ttoolitem=EachIn tb.tool_gadget
								mods=-1
								If pevent.source=item.gadget 
									If item.enabled=~STATE_DISABLED And item.item_type<>TOOLBARITEM_TEXTFIELD
									
										If item.item_type=3
											extra=String(pevent.data)
										End If
										If item.item_type=TOOLBARITEM_SLIDER
											mods=SliderValue(item.gadget)
											'DebugLog "Item:Slider : "+mods
											ti=item.tip
											If ti<>""
												If ti.contains("%V") ti=ti.Replace("%V",String(mods))
											End If

											SetGadgetToolTip item.gadget,ti
										End If

										Return CreateEvent( EVENT_GADGETACTION, item.toolbar,item.return_id,mods,x,y,extra)
										'Return Null
									End If
								End If
							Next

						End If
					Next
					


				Case EVENT_MOUSEDOWN
					'	Print "MouseDown "
						For Local tb:ttoolbarExtra=EachIn obj.list_tbextra
							If tb<>Null
								'control 'slide' button
								If tb.left_button=pevent.source
									tb.start_from:+1
									tb.ReshapeAll()
									Return Null
								End If
							End If
						Next	

							item=Ttoolitem(GadgetExtra(TGADGET(PEVENT.SOURCE)))	
							If item

							If item.enabled=~STATE_DISABLED
									If item.item_type=TOOLBARITEM_SWITCH	item.SwapIcon()	
									Return CreateEvent( EVENT_GADGETACTION, item.toolbar,item.return_id)
							End If
							End If
			End Select

		End If
		
		Return pData
	EndFunction


	Method InsertItem:Int(index:Int,Text:String="",tip:String="",icon:Int=-1,extra:Object=Null,flags:Int=TOOLBARITEM_BUTTON)
			
		tool_gadget=tool_gadget[..index+1]
		
		Local Return_ID:Int=INDEX
		If TIP<>"" RETURN_ID=Int(TIP)
		
		If flags=TOOLBARITEM_SEPARATOR
			tool_gadget[index]=tToolItem.CreateSeparator()
			x:+16
		Else
			tool_gadget[index]=ttoolitem.Create(index,Self,x,flags,Text,return_id,icon)
			x:+GadgetWidth(tool_Gadget[index].gadget)+1
		End If

		
	
	End Method
	
	Method SelectItem:Int(index:Int,t:Int=0)
		?debug
		If index<0 Or index>Len(tool_Gadget) Throw "Index out of range"
		?
		'0	select	1 deselect	2 toggle
		If tool_gadget[index].item_type=TOOLBARITEM_SWITCH
				tool_gadget[index].SwapIcon()		
		End If
	End Method
	
	Method SetEnabled:Int(sta:Int = True)
		If sta EnableAll() Else DisableAll()
	End Method
	
	Method State:Int()
		Return ~STATE_HIDDEN
	End Method
	
	Method EnableAll:Int()
		Local pix:TPixmap
		For Local t:ttoolitem=EachIn tool_Gadget
			If t.gadget  
					EnableGadget t.gadget		
					If t.item_type=TOOLBARITEM_BUTTON Or t.item_type=TOOLBARITEM_SWITCH
						pix=PixmapFromIconStrip(iconstrip,T.icon_current)
						SetGadgetPixmap t.gadget,pix,PANELPIXMAP_CENTER
						
						If t.enabled=STATE_DISABLED
							pix=PixmapFromIconStrip(grey_iconstrip,T.icon_current)
							SetGadgetPixmap t.gadget,pix,PANELPIXMAP_CENTER
						End If
					End If
			
			End If
	
		Next
		EnableGadget left_button
		EnableGadget right_button
	End Method
	
	Method DisableAll:Int()
		Local pix:TPixmap
		For Local t:ttoolitem=EachIn tool_Gadget
			If t.gadget  
			
					DisableGadget t.gadget		
					If t.item_type=TOOLBARITEM_BUTTON Or t.item_type=TOOLBARITEM_SWITCH
			
						pix=PixmapFromIconStrip(grey_iconstrip,T.icon_current)
						SetGadgetPixmap t.gadget,pix,PANELPIXMAP_CENTER
					End If
			
			End If
		Next
		DisableGadget left_button
		DisableGadget right_button

	End Method

	Method SetItem:Int(index:Int,Text:String,tip:String,icon:Int,extra:Object,flags:Int)
	?debug
		If index<0 Or index>Len(tool_Gadget) Throw "Index out of range"
	?
		If tip<>"" SetGadgetToolTip tool_gadget[index].gadget,tip
		If extra<>Null SetGadgetExtra tool_gadget[index].gadget,extra
		
		If tool_gadget[index].item_type=TOOLBARITEM_SWITCH
			tool_gadget[index].SwapIcon()
			Return 0		
		End If
		If Text<>"" SetGadgetText tool_gadget[index].gadget,Text
		
	End Method

	Method SetItemState:Int(index:Int=0,state:Int=1)
		?debug
		If index<0 Or index>Len(tool_Gadget) Throw "Index out of range"
		?
		Local pix:TPixmap	
		Select state
				Case -1
					pix=PixmapFromIconStrip(grey_iconstrip, tool_gadget[index].icon_current)
					SetGadgetPixmap  tool_gadget[index].gadget,pix,PANELPIXMAP_CENTER
					tool_Gadget[index].enabled=STATE_DISABLED
			
				Case 0
					pix=PixmapFromIconStrip(iconstrip, tool_gadget[index].icon_current)
					SetGadgetPixmap  tool_gadget[index].gadget,pix,PANELPIXMAP_CENTER
					tool_Gadget[index].enabled=~STATE_DISABLED
		End Select
	
	End Method

	Method ItemState:Int(index:Int=0)
		?debug
		If index<0 Or index>Len(tool_Gadget) Throw "Index out of range"
		?
		Return tool_gadget[index].enabled
	End Method
	
	Method ItemCount:Int()
		Return Len(tool_gadget)
	End Method
	
	Method ItemText$(index:Int=-1)
		If index = -1 Then Return Null
		?debug
				If index<0 Or index>=tool_gadget.length Throw "Gadget item index out of range. ("+index+")"
		?
	
		If tool_gadget[index].gadget
			Return GadgetText(tool_Gadget[index].gadget)
		End If
		Return ""

	End Method

	Method ItemIcon:Int(index:Int)
		?debug
				If index<0 Or index>=tool_gadget.length Throw "Gadget item index out of range. ("+index+")"
		?
		Return tool_gadget[index].icon_current
	End Method

	Method ItemFlags:Int(index:Int)
		?debug
				If index<0 Or index>=tool_gadget.length Throw "Gadget item index out of range. ("+index+")"
		?
		Return tool_gadget[index].item_type 

	End Method
	
	Method ItemExtra:Object(index:Int=-1)
		If index = -1 Then Return Null
		?debug
				If index<0 Or index>=tool_gadget.length Throw "Gadget item index out of range. ("+index+")"
		?
		'DebugLog "Index: "+index+" ItemType: "+tool_gadget[index].item_type+" ReturnID:"+tool_Gadget[index].return_id
		Return tool_gadget[index].gadget.extra
	End Method

	
	Method AddItem:tToolItem(_TYPE:Int=TOOLBARITEM_BUTTON,_title$="",_return_id:Int=-1,icon:Int=-1)
		Local size:Int=Len(tool_Gadget)
		tool_gadget=tool_gadget[..size+1]
		If _TYPE=TOOLBARITEM_SEPARATOR
			tool_gadget[size]=tToolItem.CreateSeparator()
			x:+16
		Else
			tool_gadget[size]=ttoolitem.Create(size,Self,x,_TYPE,_title$,_return_id,icon)
			x:+GadgetWidth(tool_Gadget[size].gadget)+1
		End If
		Return tool_Gadget[size]
	End Method
	
	Method AddSeparator:Int()
		AddItem(TOOLBARITEM_SEPARATOR)
	End Method
	
	Method RemoveItem:Int(index:Int=-1)
		If index<0 Return 1
		?debug
				If index<0 Or index>=tool_gadget.length Throw "Gadget item index out of range. ("+index+"/size: "+Len(tool_gadget)+")"
		?
		If tool_gadget[index]<>Null
			
			If tool_gadget[index].item_type=TOOLBARITEM_SEPARATOR
				x:-16
			Else
				x:-GadgetWidth(tool_Gadget[index].gadget)+1

			End If
			
			tool_gadget[index].Clear
			tool_gadget[index]=Null
			tool_gadget=tool_gadget[..index]+tool_gadget[index+1..]
			ReshapeAll()
		End If
	End Method
	
	Method Clear:Int()
		'DebugLog "ToolbarExtra: RemoveAllItems"
		For Local i:Int=0 Until tool_gadget.length
			If tool_gadget[i]<>Null
				tool_gadget[i].clear
				tool_gadget[i]=Null
			End If
		Next
		tool_gadget=Null
		x=0
		reshapeall()
	End Method
	
	Method SetIconStrip:Int(ics:TiconStrip)
		iconStrip=Ics
		grey_iconstrip=Ticonstrip(makeGrey(iconstrip))
		light_iconstrip=Ticonstrip(MakeLight(iconStrip))
		Local pix:TPixmap
		For Local t:ttoolitem=EachIn tool_Gadget
			If t.gadget  
				If t.icon_current>-1
						pix=PixmapFromIconStrip(iconstrip,T.icon_current)
						SetGadgetPixmap t.gadget,pix,PANELPIXMAP_CENTER
						If t.enabled=STATE_DISABLED
							pix=PixmapFromIconStrip(grey_iconstrip,T.icon_current)
							SetGadgetPixmap t.gadget,pix,PANELPIXMAP_CENTER
						End If
				End If
			End If
		Next

	End Method

	Method class:Int()
		Return GADGET_TOOLBAR
	End Method
	
	Method SetToolTipExtra:Int(ID:Int,_ti$="")
		If id>-1 And id<Len(tool_Gadget)
			If tool_gadget[id]=Null Print "Is NULL id :"+id
			
			If _ti.contains("%V") And tool_gadget[id].item_type=TOOLBARITEM_SLIDER
				_ti.Replace("%V",String(SliderValue(tool_Gadget[id].gadget)))
			End If
			
			If tool_Gadget[id].gadget<>Null 
				SetGadgetToolTip tool_gadget[id].gadget,_ti
				tool_gadget[id].tip=_ti
			End If 
		End If
	End Method
	
	Method SetFont:Int(Font:Tguifont)
	
	End Method
	
	Method SetIcon:Int(ID:Int,_icon:Int=-1)
		If _icon>-1
				Local pix:TPixmap=PixmapFromIconStrip(iconstrip,_icon)
				SetGadgetPixmap tool_gadget[id].gadget,pix,PANELPIXMAP_CENTER
		End If
	End Method
	
	Method SelectedItem:Int()
		Return -1
	End Method
	Method SelectedItems:Int[]()
		Return [0]
	End Method
End Type
