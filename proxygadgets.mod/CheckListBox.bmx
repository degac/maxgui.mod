SuperStrict

Import MaxGUI.MaxGUI
Import brl.eventqueue

Rem
	checklistbox
	
	version 2.0 - degac
	
	18 agosto 2009
	
	2.2
		! fixed for MacOS: items where not enabled/disabled
	
	2.1
		+ added IconStrip support
		+ added RemoveGadgetItem
		+ added SelectGadgetItem (-1 as index means ALL the items)
		+ added DeselectGadgetItem (-1 as index means ALL the items)
		+ added ToggleGadgetItem (-1 as index means ALL the items)

	2.2	26-08-2009
	
		! fixed Event Handling
		+ added MouseWheel control
		+ added CheckListBox generates an EVENT_GADGETACTION when a checkbox is clicked
		  - EventData()		returns the ID [0..n-1] of the item selected
		  - EventX()		returns the ID state (true or false)	
	
	2.3   08-11-2009
	
		+ added support for EVENT_GADGETSELECT when user moves the cursors on the list
	
	2.4		04.01.2018
	
		! fix problem with fonts & scaling
	
End Rem
'superstrict
'import maxgui.maxgui
'import BRL.EventQueue

Rem
bbdoc: Create a List box with support for checkboxes and icons
about: With this gadget you can create check-list
End Rem
Function CreateCheckListBox:Tchecklistbox (x:Int , y:Int , w:Int , h:Int , win:tgadget , style:Int = 0) 
	Return Tchecklistbox .Create(x , y , w , h , win ,  style) 
End Function


Type SingleItem
	Field panel:tgadget
	Field check:tgadget
	Field label:tgadget
	Field icon:tgadget
	Field iconNumber:Int
	Field parent:tchecklistbox
	Field item_h:Int=20
	
	
		
	Function Create:SingleItem(parent:tchecklistbox,txt$,tip$="",icon:Int=-1,state:Int=0)
		Local ss:singleItem=New singleItem
		Local yy:Int=parent.it.length*ss.item_h-ss.item_h
			
		ss.panel=CreatePanel(0,yy,ClientWidth(parent.panel),ss.item_h,parent.panel,PANEL_ACTIVE)
		ss.check=CreateButton("",5,0,16,ss.item_h-1,ss.panel,BUTTON_CHECKBOX)
		ss.label=CreateLabel(txt,40,2,ClientWidth(ss.panel),ss.item_h,SS.panel)
		ss.icon= CreatePanel(20,1,18,ss.item_h-2,ss.panel)
		
		SetGadgetLayout SS.panel,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_RELATIVE
		SetGadgetSensitivity ss.label,SENSITIZE_MOUSE
		
	'	SetGadgetLayout SS.CHECK,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_ALIGNED,EDGE_RELATIVE
	'	SetGadgetLayout SS.LABEL,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_ALIGNED,EDGE_RELATIVE
	'	SetGadgetLayout SS.ICON,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_ALIGNED,EDGE_RELATIVE
		If GadgetY(ss.panel)<0 Or GadgetY(ss.panel)>GadgetY(parent.panel)+GadgetHeight(parent.panel) HideGadget ss.panel
	

		ss.parent=parent
		
		SetGadgetToolTip ss.label,tip
		SetButtonState ss.check,state
		Return SS
	End Function
	
	Method Change:Int(txt$,tip$,_iconNumber:Int=-1,state:Int=-1)
	
		SetGadgetText label,txt
		SetGadgetToolTip label,tip
		If _iconNumber>-1
				Local px:TPixmap=PixmapFromIconStrip(parent.myiconstrip, _iconNumber)
				SetGadgetPixmap icon,px,PANELPIXMAP_CENTER
				iconNumber=_iconNumber
				
		End If

		
		If state<>-1 SetButtonState check,state	
	
	End Method
	
	Method Clear:Int()
		If label FreeGadget label
		If check FreeGadget check
		If panel FreeGadget panel
		If icon FreeGadget icon
		
		icon=Null
		label=Null
		check=Null
		panel=Null	
	End Method
	
	Method SetFont:Int(fnt:Tguifont)
		If fnt=Null Return -1
		SetGadgetFont label,fnt		
		item_h=FontSize(fnt)*2+4		
		If item_h<20 item_h=20
		Return 0
	End Method

	Method SetEnabled:Int(status:Int=True)
		
		If status=True
			EnableGadget label
			EnableGadget check
			EnableGadget panel
			EnableGadget icon
		Else
			DisableGadget label
			DisableGadget check
			DisableGadget panel
			DisableGadget icon

		End If
	
	End Method
	
End Type

Function ListAddExclusion:Int(gad:tgadget,lista:String="")
	tchecklistbox(gad).AddExclusion(lista)
End Function

Function ListCleanExclusion:Int(gad:tgadget)
	tchecklistbox(gad).CleanExclusion()
End Function



Type Tchecklistbox Extends TProxyGadget

	Global list_checklistbox:TList

	Field myiconstrip:ticonstrip
	Field panel:tgadget
	Field slider:tgadget
	Field style:Int
	Field current_position:Int,visible:Int
	Field panel_width:Int
	Field it:singleItem[]
	Field mx:Int[][]
	Field mx_counter:Int
	Field _r:Int=255,_g:Int=255,_b:Int=255
	Field item_h:Int=20
	
	
	Method AddExclusion:Int(linea:String="")
		If linea="" Return -1
		
		mx=mx[..mx_counter+1]
		Local subsize:Int

		For Local si:String=EachIn linea.split(",")
			subsize=mx[mx_counter].length
			mx[mx_counter]=mx[mx_counter][..subsize+1]
			mx[mx_counter][subsize]=Int(si)
		Next
		mx_counter:+1
	End Method
	
	Method CleanExclusion:Int()
		mx_counter=0
		For Local o:Int=0 Until mx.length
			mx[o]=mx[o][..0]
		Next
		mx=mx[..0]
	End Method
	
	
	Method InsertItem:Int(index:Int,Text:String,tip:String,icon:Int,extra:Object,flags:Int)
		
		?debug
		If index<0 Or index>it.length Throw "Index out of range"
		?	
		it=it[..it.length+1]
		For Local i:Int=it.length-2 To index Step -1
			it[i+1]=it[i]
		Next
		If it[index]<>Null 
				SetGadgetText it[index].label,Text
				SetGadgetExtra it[index].label,extra
				
				If extra=Null Print "Extra is NULL..."
				
				If icon>-1
					Local px:TPixmap=PixmapFromIconStrip(myiconstrip, icon)
					SetGadgetPixmap it[index].icon,px,PANELPIXMAP_CENTER
					it[index].iconNumber=icon
				End If
		Else
			it[index]=SingleItem.Create(Self,Text$,tip$,icon,flags)
			it[index].label.Extra=Extra
			

			If icon>-1
				Local px:TPixmap=PixmapFromIconStrip(myiconstrip, icon)
				SetGadgetPixmap it[index].icon,px,PANELPIXMAP_CENTER
				it[index].iconNumber=icon
			End If
		End If
		
		Local num:Int = it.length - visible + 1
		If slider SetSliderRange slider ,0,num
'		Print "Total items: "+it.length+" Num: "+num

	End Method
	
	Method SetIconStrip:Int(_iconstrip:ticonStrip)
		myiconstrip=_iconStrip
	End Method
	
	Method SetFont:Int(fnt:Tguifont)
		If fnt=Null Return -1
		item_h=FontSize(fnt)*2+4
	
		If item_h<20 item_h=20
		If it<>Null 
					For Local iu:SingleItem=EachIn it
						iu.SetFont(fnt)
					Next
		End If
		_refresh()
		Return 0
	End Method
	
	Method SelectItem:Int(index:Int=-1,op:Int=1)
		Rem
			if index=-1 SELECT ALL the items
			
			OP = 1	set CHECKED
			OP = 0	set UNCHEKED
			OP = 2	TOGGLE
		End Rem
		
		If index=-1
			If op=0 Or op=1
				For Local ss:singleitem=EachIn it
					If ss	SetButtonState(ss.check,OP)
				Next
			Else
				For Local ss:singleitem=EachIn it
					If ss	SetButtonState(ss.check,1-ButtonState(ss.check))
				Next
			
			End If
		Else
			
			If index<it.length 
				If OP=0 Or OP=1 
					SetButtonState(it[index].check,OP)
				Else
					SetButtonState(it[index].check,1-ButtonState(it[index].check))

				End If
			End If
			
		End If
					
		
	
	End Method
	
	
	
	Method SetEnabled:Int(status:Int=True)
	If status=True
			EnableGadget slider
			EnableGadget panel
		Else
			DisableGadget slider
			DisableGadget panel
		End If

		For Local ss:singleitem=EachIn it
			ss.SetEnabled(status)
		Next
	End Method
	
	Method ItemCount:Int()
		Return it.length
	End Method
	
	Method class:Int()
		Return GADGET_CHECKLISTBOX
	End Method
	
	Method RemoveItem:Int(index:Int)
		?debug
		If index<0 Or index=>it.length Throw "Index out of range"
		?	
		'DebugLog "Remove Index: "+index+" Size: "+it.length
		it[index].Clear()
		it[index]=Null
		
		For Local t:Int=index+1 Until it.length
			it[t-1]=it[t]
		Next
		it=it[..it.length-1]
		
		'Replace position

		For Local t:Int=index Until it.length
			SetGadgetShape it[t].panel , 0 , t * item_h, panel_width , item_h
		Next
		If slider SetSliderRange slider ,  it.length,visible


	End Method
	
	Method _refresh:Int()
		'DebugLog "Refresh: Item_h: "+item_h
		For Local t:Int=0 Until it.length
			SetGadgetShape it[t].panel , 0 , t*item_h, panel_width , item_h
			SetGadgetShape it[t].label , 40, 2,panel_width, item_h
			
		Next

	Return 0

	End Method
	
	Method SetItem:Int(index:Int,Text:String,tip:String,icon:Int,extra:Object,flags:Int)
		?debug
		If index<0 Or index>it.length Throw "Index out of range"
		?	
		it[index].Change(Text,tip,icon,flags)	
	End Method
	
	Method ItemText:String(index:Int)
		?debug
		If index<0 Or index>it.length Throw "Index out of range"
		?
		Return GadgetText(it[index].label)
	End Method
	
	Method ItemTip:String(index:Int)
		?debug
		If index<0 Or index>it.length Throw "Index out of range"
		?
		Return it[index].label.GetTooltip()
	End Method
	
	Method ItemExtra:Object(index:Int)
		?debug
		If index<0 Or index>it.length Throw "Index out of range"
		?
		Return GadgetExtra(it[index].label)

	End Method
	
	Method ItemIcon:Int(index:Int)
		?debug
				If index<0 Or index>=it.length Throw "Index out of range"
		?
		Return it[index].iconnumber
	End Method
	
	Method ItemState:Int(index:Int)
		?debug
		If index<0 Or index>it.length Throw "Index out of range"
		?
		Return ButtonState(it[index].check)
	End Method
	
	Method Clear:Int()
		For Local ss:singleItem=EachIn it
			ss.clear()
			ss=Null
		Next
		it=Null
		
	End Method
	
	Method SetColor:Int(r:Int,g:Int,b:Int)
		SetGadgetColor panel,r,g,b
		For Local si:singleitem=EachIn it
			SetGadgetColor si.panel,r,g,b
			SetGadgetColor si.label,r,g,b
			SetGadgetColor si.check,r,g,b
		Next	
		_r=r
		_g=g
		_b=b
	End Method
	
	Method SelectedItems:Int[]()
		'SELECED (=CHECKED) ITEMS
		Local count:Int,i:Int,array:Int[it.length]
		For i=0 Until it.length
			If it[i]
				If ButtonState(it[i].check)=True
					array[count]=i
					count:+1
				End If
			End If
		Next
		If count>0 Return array[..count]	

	End Method
	
	Method CleanUp:Int()
		RemoveHook EmitEventHook, eventHandler, Self
		SetProxy(Null)
		Clear()
		If slider FreeGadget slider
		If panel FreeGadget panel
		Super.cleanup()
	End Method
	
	Method Free:Int()

	End Method
	


	Function Create:Tchecklistbox ( x:Int, y:Int, w:Int, h:Int, group:TGadget,style:Int=0 )
		Local mb:Tchecklistbox =New Tchecklistbox 
		mb.panel = CreatePanel(x , y , w-20 , h , group , PANEL_ACTIVE) 
		
		mb.style = style
		mb.slider=CreateSlider(x+w-20,y,20,h,group,SLIDER_VERTICAL)
		
		SetGadgetLayout MB.panel,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED
		SetGadgetLayout MB.slider,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_ALIGNED
		SetGadgetColor mb.panel,255,255,255
		ActivateGadget mb.panel
		AddHook EmitEventHook,eventHandler,mb,-1
		mb.setproxy(mb.panel)
		
		mb.panel_width=ClientWidth(mb.panel)
		mb.visible=Int(h/mb.item_h)
	
		Return mb
	EndFunction
	
	Function eventHandler:Object(pID%, pData:Object, pContext:Object)
	
	Local tmpSuperPanel:Tchecklistbox = Tchecklistbox (pContext)
	If tmpSuperPanel Then pData = tmpSuperPanel.eventHook(pID%, pData:Object, pContext:Object)
	Return pData 

	EndFunction


	Method EventHook:Object( id:Int, data:Object, context:Object )
'	Function _Hook:Object( id:Int, data:Object, context:Object )

		Local mb:Tchecklistbox 
		Local event:TEvent
		Local con:Int
		event=TEvent(data)
		If event=Null Return data


		
		Select Event.id
			
			Case EVENT_MOUSEDOWN'ENTER
				For Local what:singleitem=EachIn it
						SetGadgetColor what.panel,what.parent._r,what.parent._g,what.parent._b
				Next
				
		
				For Local what:singleitem=EachIn it
						SetGadgetColor what.panel,what.parent._r,what.parent._g,what.parent._b
						If what.label=event.source
							EmitEvent CreateEvent( EVENT_GADGETSELECT, Self,con,,ButtonState(what.check),,GadgetExtra(what.label))
							SetGadgetColor what.panel,(255-what.parent._r/2),(255-what.parent._g/2),(255-what.parent._b/2)
							Data = Null
							Return data
						End If
						con:+1
				Next
			Case EVENT_MOUSEWHEEL
				
					current_position:-CurrentEvent.data

						If current_position < 0 current_position = 0
						If current_position > it.length-visible current_position=it.length-visible
						con=0
						For Local what:singleitem=EachIn it
							SetGadgetShape what.panel , 0 , con * what.item_h - current_position* what.item_h , panel_width , what.item_h
							If GadgetY(what.panel)<0 Or GadgetY(what.panel)>GadgetY(panel)+GadgetHeight(panel)+what.item_h
								HideGadget what.panel
							Else
								ShowGadget what.panel
							End If

							con:+1
						Next
					SetSliderValue slider,current_position


			
				
			
			Case EVENT_GADGETACTION
			
					For Local what:singleitem=EachIn it
						If what.check=event.source
							'Print "Checked..."+con
							EmitEvent CreateEvent( EVENT_GADGETACTION, Self,con,,ButtonState(what.check))
							Data = Null
							Return data
						End If
						con:+1
					Next
				
				Select Event.source
					Case slider
						current_position = SliderValue(slider)'EventData() 
						
						If current_position < 0 current_position = 0
						If current_position > it.length current_position=it.length
						Local con:Int
						For Local what:singleitem=EachIn it
							SetGadgetShape what.panel , 0 , con * what.item_h - current_position* what.item_h , panel_width , what.item_h
							If GadgetY(what.panel)<0 Or GadgetY(what.panel)>GadgetY(panel)+GadgetHeight(panel)+what.item_h
								HideGadget what.panel
							Else
								ShowGadget what.panel
							End If

							con:+1
						Next

			
					Default
						Return Data				
				EndSelect
			
				'EmitEvent CreateEvent( EVENT_GADGETACTION, Self, -1)', 0, currentH, currentV, Null )
				Data = Null
				
		EndSelect
		
		Return Data
	End Method	

End Type
