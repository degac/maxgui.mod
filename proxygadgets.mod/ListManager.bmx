SuperStrict

Import MaxGUI.MaxGUI
Import brl.max2d
Import "common.bmx"
Rem
'
'List Manager
'	v.2.3 - Degac

	23-09-2018	added LIST_DIRS options

	06-01-2018	added SetFont() metho
	
	24-12-2013	added SetTooltips() method
	

	29-08-2009

	21-08-2010
		
		Added support for SetGadgetPixmap pixmap,style
		
			pixmap : is an image containg different icons for add,remove etc
			style  : 	LBM_ICON_ACTIVE to load 'active' icons, 
					LBM_ICON_INACTIVE to load 'inactive' icons


	14-08-2010 - fixed some bugs in GetItem
	
		This gadget creates a listbox with some useful command-buttons the allow to
		
			ADD (a user text or a file)
			REMOVE an item
			Move UP
			Move DOWN
			Clear all the items
			Scan a folder to add determinated files based on a filter
			EDIT (added: 06-01-2011)
		
	06-01-2011
	
		+ now you can change the content of a list by typing it in the textfield
		
	08-10-2016
	
		! FIXED BUG in SetGadgetLayout
		+ Added method SetShape (not seems used...)
		
		------------------
	
		Options style:
		
	
		LIST_FILES			with this style the ListManager allows to add files and
						to scan a folder to add files based on the filter.
						Additional command-methods:
					
						- SelectFilter("jpg,png,tga")
						- SelectPath("where/open/my/folder")
						
		LIST_SHOWONLYNAME		used in conjunction with LIST_FILES shows in the listbox
						only the file name (without path and extension). The tips contains full PATH

		LIST_ITEMS			manages simple user-text input
						
		LIST_FORCEORDER		only effect the LIST_ITEMS. Every item manually added is sorted in alphabetic
						order.
						
		
		LIST_DIRS			used to show only folders (23.09.2018)
						
						
		Standard MaxGUI commands reconigzed
		
		DisableGadget 	listmanager
		EnableGadget	listmanager
		SetGadgetColor	listmanager,red,green,blue
		ModifyGadgetItem listmanager,index,text,flags,icon,tip,extra
		RemoveGadgetItem listmanager,index
		AddGadgetItem    listmanager,index
		GadgetItemText   listmanager,index
		InsertGadgetItem listmanager,index		
		
		Not standard method available
		
		SelectFilter(for_file_filtering)
		SelectPath(path_where_to_open)
		GetItemList			returns a list with the items in the listbox
		GetItemArray		returns a string array with the items in the listbox
		SetItemList(list)		fill the listbox with the items contained in the list
		SetItemArray(array$[])	fill the listbox with the items contained in the string array
		SetDefinitions(array$[])	set the tooltip in a different language
		SetMessage(array$[])		set the messages in a different language
		SetTooltips(array$[])		set the tooltip for any single buttons (add, remove...)
		
		GetItemExtraList				returns a list with the extra items in the listbox
		GetItemExtraArray			returns a string array with the extra items in the listbox

		
		deprecated: - automatic - the gadget needs 2 images for the buttons: enabled and disabled icons.
		If there are not images, the gadget button will show some text (+ - ^ v Clear Dir) to allow the user to use it

		to do:
		
		- handle window resizing
		- handle EVENT_GADGETLOSTFOCUS without errors

End Rem

'import maxgui.maxgui
'SuperStrict


Rem
bbdoc: Create a listbox with some additional commands to add, remove and move items in it
about: The listbox is a standard listbox but can show different commands to add, remove and move items.<br>
It can handle @text items or @files items with using this @style flag<br>

[ @Style | @Description 
* LIST_DIRS | add folders<br>
You can use SelectPath("where/open/my/folder")
						<br>

* LIST_FILES | add files and to scan a folder to add files based on the filter<br>
		You can select a filter and a path with this @methods<br>					
						- SelectFilter("jpg,png,tga")
						- SelectPath("where/open/my/folder")
						<br>
		
* LIST_SHOWONLYNAME | used in conjunction with LIST_FILES shows in the listbox only the file name (without path and extension). The tips contains full PATH
* LIST_ITEMS | manages simple user-text input
* LIST_FORCEORDER | only effect the LIST_ITEMS. Every item manually added is sorted in alphabetic order.

]
<br>
End Rem
Function CreateListManager:TlistManager(x:Int,y:Int,w:Int,h:Int,group:TGadget = Null,_style:Int = LIST_FILES|LIST_SHOWONLYNAME|LIST_FORCEORDER,filter:String="exe")
	If group = Null Return Null	
	Return TlistManager.Create(x,y,w,h,group,_style)
End Function



Const LIST_FILES:Int=1
Const LIST_ITEMS:Int=2
Const LIST_SHOWONLYNAME:Int=4
Const LIST_FORCEORDER:Int=8
Const LBM_ICON_ACTIVE:Int=16
Const LBM_ICON_INACTIVE:Int=32
Const LIST_DIRS:Int=64 

	Function ExternalFilter:String(source$="",st$="")
		
		Return source$
	End Function


Type TlistManager Extends Tproxygadget

	
	Field fpointer_FILTER:String(source$,remov$)

	Global list_listmanager:TList=New TList
	Global _IN_MSG:String[]=["Add a file","Clear all the items","Select a folder","Warning!!! There are %%NUMBER%% files~n to add to the list!"]
	Global _BTN_BALOON:String[]=["Add","Remove","Move up selected item","Move down selected item","Clear all the items","Scan a folder and adds the files"]
	
	Rem
			SetGadgetToolTip sp.btn_adddir,"Scan a folder and adds the files"
		Else
			sp.txt_item=	CreateTextField(5,h-hh+24,w-10,22,sp.panel)
		End If
	
		sp.EnableIcons()
				
		SetGadgetToolTip sp.btn_add		,"Add an item"
		SetGadgetToolTip sp.btn_remove	,"Remove an item"
		SetGadgetToolTip sp.btn_up		,"Move up the selected item"
		SetGadgetToolTip sp.btn_down		,"Move down the selected item"
		SetGadgetToolTip sp.btn_clear	,"Clear all the items"

	End Rem
	
	Field sid:String
	Field parent:tgadget
	Field panel:TGadget
	Field list_box:tgadget
	Field btn_add:tgadget
	Field btn_remove:tgadget
	Field btn_up:tgadget
	Field btn_down:tgadget
	Field btn_clear:tgadget
	Field btn_AddDir:tgadget
	Field txt_item:tgadget
	Field filter:String,path:String,reqfilter:String
	Field filter_items:String[]
	Field last_selected:Int=-1
	Field _list_manager_icons:ticonstrip
	Field _list_manager_icons_disabled:ticonstrip
	Field hidden:Int=0

	Field style:Int
	
	Method SetFont:Int(fnt:Tguifont=Null)
		If fnt=Null Return 0
		If list_box 	SetGadgetFont list_box,fnt
		If btn_add	SetGadgetFont btn_add,fnt
		If btn_remove	SetGadgetFont btn_remove,fnt
		If btn_up		SetGadgetFont btn_up,fnt
		If btn_down	SetGadgetFont btn_down,fnt
		If btn_clear	SetGadgetFont btn_clear,fnt
		If btn_AddDir	SetGadgetFont btn_AddDir,fnt
		If txt_item	SetGadgetFont txt_item,fnt
	End Method
	
	Method SetEnabled:Int(sta:Int = True)
		If sta EnableAll() Else DisableAll()
	End Method
	
	Method SelectFilter:Int(_filter:String="")
		'filter examples = EXE;TXT;JPG
		If _filter="" 
			filter=""
			filter_items=filter_items[..0]	
			reqfilter=""	
			Return -1
		End If
		filter=_filter
		Local Current_item:Int=0
		For Local it:String=EachIn _filter.split(";")
			filter_items=filter_items[..current_item+1]
			filter_items[current_item]=it.toLower()
			reqfilter=reqfilter+it.toLower()+","
			current_item:+1
		Next
		reqfilter=reqfilter[..Len(reqfilter)-1]
		reqfilter="User:"+reqfilter+";All files:*"
		
	End Method
		
	Method SelectPath:Int(_PATH:String="")
		path=_PATH
	End Method
	
	Method GetItem:String()
		Local ipos:Int=SelectedGadgetItem(list_box)
		If ipos>-1  Return list_box.ItemText(ipos)
		Return ""

	End Method
	
	Method SetShape:Int(x:Int,y:Int,w:Int,h:Int)
		'DebugLog "SetShape called..."
		Super.setshape x,y,w,h
		btn_addDir.SetShape x,y,w,h
		btn_add.SetShape x,y,w,h
		btn_clear.SetShape x,y,w,h
		btn_down.SetShape x,y,w,h
		btn_up.SetShape x,y,w,h
		list_box.SetShape x,y,w,h
		panel.SetShape x,y,w,h
		txt_item.SetShape x,y,w,h
		Return 0

	End Method
	
	Method ItemExtra:Object(index:Int=0)
		?debug
		If index<0 Or index>CountGadgetItems(list_box) Throw "Index out of range"
		?
		Return GadgetItemExtra(list_box,index)
	End Method

	Method SetItem:Int(index:Int,Text:String,tip:String,icon:Int,extra:Object,flags:Int)
		?debug
		If index<0 Or index>CountGadgetItems(list_box) Throw "Index out of range"
		?
		ModifyGadgetItem list_box,index,Text,flags,icon,tip,extra
	End Method
	
	Method InsertItem:Int(index:Int,Text:String="",tip:String="",icon:Int=-1,extra:Object=Null,flags:Int=0)
		?debug
		If index<0 Or index>CountGadgetItems(list_box)  Throw "Index out of range"
		?	
		
		If index=CountGadgetItems(list_box)
			AddGadgetItem list_box,Text,flags,icon,tip,extra
		Else
			InsertGadgetItem list_box,index,Text,flags,icon,tip,extra
		End If
		
	End Method
	
	Method RemoveItem:Int(index:Int)
		?debug
		If index<0 Or index>CountGadgetItems(list_box)  Throw "Index out of range"
		?	
		RemoveGadgetItem list_box,index
	End Method

	Method ItemCount:Int()
		Return CountGadgetItems(list_box)
	End Method
	
	
	Method CleanUp:Int()
		RemoveHook EmitEventHook,EventHandler,Self

		If list_box FreeGadget list_box;list_box=Null
		If btn_Add FreeGadget btn_add;btn_add=Null
		If btn_remove FreeGadget btn_remove;btn_remove=Null
		If btn_up FreeGadget btn_up;btn_UP=Null
		If btn_down FreeGadget btn_down;btn_down=Null
		If btn_clear FreeGadget btn_clear;btn_clear=Null
		If btn_adddir FreeGadget btn_AddDir;btn_addDir=Null
	

		If txt_item:tgadget FreeGadget txt_item:tgadget;txt_item=Null
		If panel FreeGadget panel;panel = Null
		
		Super.CleanUp()
	End Method
	
	Method Clear:Int()
		If list_box ClearGadgetItems list_box
	Return 0

	End Method
	
	Method class:Int()
		Return GADGET_LISTMANAGER
	End Method

	Method SetColor:Int(RED:Int,green:Int,blue:Int)
		SetGadgetColor list_box,RED,green,blue
	End Method
	
		Method SetLayout:Int(le:Int,ri:Int,Top:Int,bot:Int)
		
		SetGadgetLayout panel,le,ri,top,bot
		SetGadgetLayout list_box,le,ri,EDGE_ALIGNED,EDGE_RELATIVE
		SetGadgetLayout btn_add,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE
		SetGadgetLayout btn_remove,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE
		SetGadgetLayout btn_up,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE
		SetGadgetLayout btn_down,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE
		SetGadgetLayout btn_clear,EDGE_RELATIVE,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE
		
		If btn_addDir
				SetGadgetLayout btn_addDir,EDGE_RELATIVE,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE
		End If
	
		If txt_item
				SetGadgetLayout txt_item,EDGE_ALIGNED,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE
		End If
	
	Return 0

	End Method
	
	
	Method ItemText:String(index:Int)
		?debug
		If index<0 Or index>CountGadgetItems(list_box) Throw "Index out of range"
		?
		Return GadgetItemText(list_box,index)
	End Method

	Method State:Int()
		Return STATE_HIDDEN
	End Method
	
	Method SetShow:Int(truefalse:Int=True)
		Super.setshow(truefalse)
		If truefalse=True
			hidden=0
		Else
			hidden=STATE_HIDDEN
		End If
	End Method
	
	Method SetItemList:Int(_CONTENT:TList=Null)
		If _CONTENT=Null Return -1
		For Local ss:String=EachIn _CONTENT
			If ss<>Null AddGadgetItem list_box,ss,0,-1,ss,ss
		Next
		
	End Method
	
	Method SetItemArray:Int(_CONTENT:String[])
		If _CONTENT=Null Return -1
		For Local ss:String=EachIn _CONTENT
			If ss<>Null 
				InsertItem(CountGadgetItems(list_box),ss,ss,-1,ss,0)
			End If
		Next

	End Method
	
	Method GetItemList:TList()
		Local temp:TList=New TList
		For Local c:Int=0 Until CountGadgetItems(list_box)
			temp.addlast list_box.ItemText(c)
		Next
		Return temp
	End Method
	
	Method GetItemExtraList:TList()
		Local temp:TList=New TList
		For Local c:Int=0 Until CountGadgetItems(list_box)
			temp.addlast list_box.ItemExtra(c)
		Next
		Return temp
	End Method
	
	
	
	Method GetItemArray:String[]()
		Local temp:String[]
		Local size:Int
		temp=New String[CountGadgetItems(list_box)]
		'DebugLog "Temp size: "+Len(temp)
		For Local c:Int=0 Until CountGadgetItems(list_box)
			temp[c]=list_box.ItemText(c)
		Next
		Return temp
	End Method
		
	Method GetItemExtraArray:String[]()
		Local temp:String[]
		Local size:Int
		temp=New String[CountGadgetItems(list_box)]
		
		For Local c:Int=0 Until CountGadgetItems(list_box)
			temp[c]=String(list_box.ItemExtra(c))
		Next
		Return temp
	End Method
	
	Function Create:TlistManager(x:Int,y:Int,w:Int,h:Int,group:TGadget,style:Int = LIST_FILES)
		Local sp:TlistManager= New TlistManager
		Local sizew:Int=w/5'(w-5)/5
		Local hh:Int=50,ip:Int=0,posx:Int
		
		If style&LIST_FILES Or style&LIST_DIRS Then hh=25;sizew=w/6'sizew=(w-6)/6;hh=25
		
		sp.panel = 		CreatePanel(x,y,w,h,group)

		posx=5
		sizew:-2
		sp.list_box=		CreateListBox(5,1,w-10,h-hh-3,sp.panel)
		sp.btn_add=		CreateButton(" + "	,posx,h-hh,sizew,22,sp.panel)
		posx:+sizew
		sp.btn_remove=	CreateButton(" - "	,posx,h-hh,sizew,22,sp.panel)
		posx:+sizew
		sp.btn_up=		CreateButton(" ^ "	,posx,h-hh,sizew,22,sp.panel)
		posx:+sizew
		sp.btn_down=		CreateButton(" v "	,posx,h-hh,sizew,22,sp.panel)
		posx:+sizew
		sp.btn_clear=		CreateButton("Clear",posx,h-hh,sizew,22,sp.panel)
		posx:+sizew
		
		If style&LIST_FILES Or style&LIST_DIRS
			sp.btn_adddir=	CreateButton("Dir",posx,h-hh,sizew,22,sp.panel)
			SetGadgetToolTip sp.btn_adddir,_BTN_BALOON[5]'"Scan a folder and adds the files"
		Else
			sp.txt_item=	CreateTextField(5,h-hh+24,w-10,22,sp.panel)
		End If

	
		sp.EnableIcons()
				
		SetGadgetToolTip sp.btn_add		,_BTN_BALOON[0]'"Add an item"
		SetGadgetToolTip sp.btn_remove	,_BTN_BALOON[1]'"Remove an item"
		SetGadgetToolTip sp.btn_up		,_BTN_BALOON[2]'"Move up the selected item"
		SetGadgetToolTip sp.btn_down		,_BTN_BALOON[3]'"Move down the selected item"
		SetGadgetToolTip sp.btn_clear	,_BTN_BALOON[4]'"Clear all the items"
		
		sp.style=style
		sp.SetProxy(sp.panel)
		SetGadgetLayout sp, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED, EDGE_ALIGNED

		AddHook(EmitEventHook,EventHandler,sp,-1)
		list_listmanager.addlast sp
		Return sp
	End Function
	
	
	Method SetDefinitions:Int(array:String[])
		array=array[..6]
		SetGadgetToolTip btn_add,array[0]
		SetGadgetToolTip btn_remove,array[1]
		SetGadgetToolTip btn_up,array[2]
		SetGadgetToolTip btn_down,array[3]
		SetGadgetToolTip btn_clear,array[4]
		If array[5]<>"" SetGadgetToolTip btn_AddDir,array[5];Print "DEF : "+array[5]
	
	End Method
	
	Method SetTooltips:Int(array:String[])
		If Len(_BTN_BALOON)<>Len(array) array=array[..Len(_BTN_BALOON)]
		_BTN_BALOON=array
	End Method
	

	
	Method SetMessage:Int(array:String[])
		If Len(_IN_MSG)<>Len(array) array=array[..Len(_IN_MSG)]
		_IN_MSG=array
	End Method
	
	
	

	Method SetPixmap:Int(_iconstrip:TPixmap=Null,style:Int=LBM_ICON_ACTIVE)
		'Print "SetPixmap..."
		If _iconstrip=Null Return -1
		_list_manager_icons=LoadIconStrip(_iconStrip)
		Self.EnableIcons()
		If _list_manager_icons _list_manager_icons_disabled=LoadIconStrip(MakeGrey(_iconStrip))
	End Method
	
	Method EnableIcons:Int()
		Local pix:TPixmap
	
		If _list_manager_icons<>Null
	
			pix=PixmapFromIconStrip(_list_manager_icons,0)
			SetGadgetPixmap btn_add,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			pix=PixmapFromIconStrip(_list_manager_icons,1)
			SetGadgetPixmap btn_remove,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			pix=PixmapFromIconStrip(_list_manager_icons,2)
			SetGadgetPixmap btn_up,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			pix=PixmapFromIconStrip(_list_manager_icons,3)
			SetGadgetPixmap btn_down,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			pix=PixmapFromIconStrip(_list_manager_icons,4)
			SetGadgetPixmap btn_clear,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			
			If btn_addDir
				pix=PixmapFromIconStrip(_list_manager_icons,5)
				SetGadgetPixmap btn_addDir,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			End If
		End If

	End Method
	
	Method DisableIcons:Int()
		Local pix:TPixmap
		If _list_manager_icons_disabled<>Null
			pix=PixmapFromIconStrip(_list_manager_icons_disabled,0)
			SetGadgetPixmap btn_add,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			pix=PixmapFromIconStrip(_list_manager_icons_disabled,1)
			SetGadgetPixmap btn_remove,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			pix=PixmapFromIconStrip(_list_manager_icons_disabled,2)
			SetGadgetPixmap btn_up,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			pix=PixmapFromIconStrip(_list_manager_icons_disabled,3)
			SetGadgetPixmap btn_down,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			pix=PixmapFromIconStrip(_list_manager_icons_disabled,4)
			SetGadgetPixmap btn_clear,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			
			If btn_addDir
				pix=PixmapFromIconStrip(_list_manager_icons_disabled,5)
				SetGadgetPixmap btn_addDir,pix,GADGETPIXMAP_ICON|GADGETPIXMAP_NOTEXT
			End If
		End If
		
	End Method
	
	Method EnableAll:Int()
		EnableGadget panel
		EnableGadget list_box
		EnableGadget btn_add
		EnableGadget btn_remove
		EnableGadget btn_up
		EnableGadget btn_down
		EnableGadget btn_clear
		If btn_adddir EnableGadget btn_addDir
		If txt_item EnableGadget txt_item;SetGadgetColor txt_item,255,255,255
		EnableIcons()
	End Method 
	
	Method DisableAll:Int()
		DisableGadget panel
		DisableGadget list_box
		DisableGadget btn_add
		DisableGadget btn_remove
		DisableGadget btn_up
		DisableGadget btn_down
		DisableGadget btn_clear
		If btn_adddir DisableGadget btn_addDir
		If txt_item SetGadgetColor txt_item,212,208,200;DisableGadget txt_item
		DisableIcons()
	End Method 

	Method AddItem:Int(Text:String="",flags:Int=0,icon:Int=-1,tip:String="",extra:Object=Null)
		InsertItem(CountGadgetItems(list_box),Text,tip,icon,extra,flags)
	End Method

	
	Function eventHandler:Object(pID%, pData:Object, pContext:Object)

		Local event:TEvent=TEvent(pData)
		Local obj:tlistManager=TlistManager(pContext)
		Local temp:String,ipos:Int,dpos:Int
		Local cotemp:Object,cttemp:String
		Local otemp:Object,ttemp:String
		Local otip:String,dtip:String
		
		

		
		If event
			If obj
				Select event.ID
				
					Case EVENT_GADGETSELECT
						If event.source=obj.list_box And obj.style&LIST_ITEMS 
							ipos=SelectedGadgetItem(obj.list_box)
							obj.last_selected=ipos
						End If

				
					Case EVENT_GADGETACTION	
						Select event.source
							
							Case obj.list_box
								If obj.style&LIST_ITEMS 
								ipos=SelectedGadgetItem(obj.list_box)
									If ipos>-1 And ipos<CountGadgetItems(obj.list_box)
										'Print GadgetItemText(obj.list_box,ipos)
										SetGadgetText obj.txt_item,GadgetItemText(obj.list_box,ipos)
										obj.last_selected=ipos
									End If
		
								End If
			 
											
							Case obj.txt_item
								If obj.last_selected>-1 And obj.last_selected<CountGadgetItems(obj.list_box)
								ModifyGadgetItem(obj.list_box,obj.last_selected,GadgetText(obj.txt_item))		
								End If
											
											
							Case obj.btn_add
									obj.last_selected=-1
								
							If obj.style&LIST_FILES	
								temp=RequestFile(_IN_MSG[0],obj.reqfilter,False,obj.path)
								If temp<>""
									If obj.style&LIST_SHOWONLYNAME
										obj.AddItem StripAll(temp),0,-1,temp,temp
									Else
										obj.addItem  temp,0,-1,temp,temp
									End If
								End If
							End If
							
							If obj.style&LIST_DIRS 	
								temp=RequestDir(_IN_MSG[0],obj.path)
								If temp<>""
									If obj.style&LIST_SHOWONLYNAME
										obj.AddItem StripAll(temp),0,-1,temp,temp
									Else
										obj.addItem  temp,0,-1,temp,temp
									End If
								End If
							End If
							
							
							
							If obj.style&LIST_ITEMS
								SetGadgetColor obj.txt_item,255,255,255
								temp=GadgetText(obj.txt_item)
								If temp<>""
									obj.AddItem(temp,0,-1,temp,temp)
							'		AddGadgetItem obj.list_box,temp,0,-1,temp,temp
									SetGadgetText obj.txt_item,""
									ActivateGadget OBJ.txt_item
								Else
									SetGadgetColor obj.txt_item,200,20,20
									ActivateGadget OBJ.txt_item

								End If
							
								If OBJ.style&LIST_FORCEORDER
									Local tempitems:String[]=Obj.GetItemArray()
									tempItems.Sort()
									ClearGadgetItems obj.list_box
									obj.SetItemArray(tempItems)
									tempitems=Null				
								End If
							
							End If

							Return Null
						Case obj.btn_up
		
						ipos=SelectedGadgetItem(obj.list_box)
						If ipos>-1
							cotemp=GadgetItemExtra(obj.list_box,ipos) ' oggetto _ ORIGINE
							cttemp=GadgetItemText(obj.list_box,ipos)
							otip=obj.list_box.itemtip(Ipos)

							dpos=ipos-1
							If dpos>-1
								otemp=GadgetItemExtra(obj.list_box,dpos) ' DESTINAZIONE
								ttemp=GadgetItemText(obj.list_box,dpos)
								dtip=obj.list_box.itemTip(Dpos)

								ModifyGadgetItem(obj.list_box,dpos,cttemp,0,-1,otip,cotemp)
								ModifyGadgetItem(obj.list_box,ipos,ttemp,0,-1,dtip,otemp)
								SelectGadgetItem obj.list_box,dpos
								obj.last_selected=dpos

							End If
												
						End If
						Return Null
					Case obj.btn_down
								ipos=SelectedGadgetItem(obj.list_box)
							
						If ipos>-1
							cotemp=GadgetItemExtra(obj.list_box,ipos) ' oggetto _ ORIGINE
							cttemp=GadgetItemText(obj.list_box,ipos)
							otip=obj.list_box.itemtip(Ipos)
	
							dpos=ipos+1
							If dpos>-1 And dpos<CountGadgetItems(obj.list_box)
								otemp=GadgetItemExtra(obj.list_box,dpos) ' DESTINAZIONE
								ttemp=GadgetItemText(obj.list_box,dpos)
								dtip=obj.list_box.itemTip(Dpos)
	
								ModifyGadgetItem(obj.list_box,dpos,cttemp,0,-1,otip,cotemp)
								ModifyGadgetItem(obj.list_box,ipos,ttemp,0,-1,dtip,otemp)
								SelectGadgetItem obj.list_box,dpos
								obj.last_selected=dpos

							End If
						
						End If
						Return Null
			
					
					Case obj.btn_remove
						ipos=SelectedGadgetItem(obj.list_box)
						If ipos>-1
							RemoveGadgetItem obj.list_box,ipos
						End If
						Return Null
					
					Case obj.btn_clear
						If CountGadgetItems(obj.list_box)>0
							Local Con:Int=Confirm(_IN_MSG[1],True)
							If con=True ClearGadgetItems obj.list_box
						End If
						Return Null
					
					Case obj.btn_adddir
						
						If obj.style&LIST_FILES	Or obj.style&LIST_DIRS
							temp=RequestDir(_IN_MSG[2],obj.path)
							If temp<>""
							tfiles.clear()
							obj.DisableAll()
							ScanDir(obj,temp)
							If tfiles.lista.count()>10000
								Local tmp_msg$=_IN_MSG[3]
								tmp_msg=tmp_msg.Replace("%%NUMBER%%"," "+String(tfiles.lista.count())+" ")
								Notify tmp_msg
'								Notify "Warning!!! There are "+tfiles.lista.count()+" files~n to add to the list!"
							End If
							

							
							For Local ss:tfiles=EachIn tfiles.lista
								If obj.fpointer_FILTER<>Null
									ss.file=obj.fpointer_FILTER(ss.file,"")
								End If
								If obj.style&LIST_SHOWONLYNAME
									AddGadgetItem obj.list_box,StripAll(ss.file),0,-1,ss.file,ss.file
								Else
									AddGadgetItem obj.list_box,ss.file,0,-1,ss.file,ss.file
								End If
							Next
							End If
							obj.EnableAll()
						End If
						Return Null
					End Select
				End Select
			End If
		End If
	
	
		Return pdata

	EndFunction

	

	
End Type

Type tfiles

	Global lista:TList=New TList

	Field file:String
	
	Function add:tfiles(_NAME$)
		If _NAME.Trim()="" Return Null
		
		Local cc:tfiles=New tfiles
		cc.file=_NAME
		lista.addlast cc
		Return cc		
	End Function
	
	Function Clear()
		ClearList lista
	End Function
	
End Type

Function ScanDir:Int(obj:TlistManager,path:String,recursive:Int=True,lvl:Int=0)
Local counter:Int,mydir:Byte ptr,file$
Local filename$,lastpath:String,lst:String
If path="" Then path=CurrentDir()
If path[Len(path)-1]<>"\" Then path=path+"\"

path=path.Replace("\\","\")

mydir=ReadDir(path)
counter=0
Repeat
	file$=NextFile(mydir)
	If file$="" Then Exit
		filename$=path$+file$
		
		If obj.style&LIST_FILES 
			If FileType(filename)=1
		
			If obj.filter<>""	
				For Local fitem:String=EachIn obj.filter_items

					If ExtractExt(filename.tolower())=fitem.toLower()
						tfiles.add(filename)
						counter:+1
					End If
				Next
			
			Else

				tfiles.add(filename)
				counter:+1
			End If
		Else
			
			If recursive=True
				If file$<>"." And file$<>".."
					If FileType(filename$) = 2
						lst=lPath(filename)
						lvl=lvl+1
						scandir(obj,filename$ , True , lvl)
					End If
				End If
			End If
		End If
	End If
		If obj.style&LIST_DIRS 
			If FileType(filename)=2
				tfiles.add(filename)
				counter:+1
			End If
		Else
			If recursive=True
				If file$<>"." And file$<>".."
					If FileType(filename$) = 2
						lst=lPath(filename)
						lvl=lvl+1
						scandir(obj,filename$ , True , lvl)
					End If
				End If
			End If
		End If

	Forever
	
	CloseDir mydir
	Return counter
								
End Function

Function lPath:String(file:String)
	Local fi:String = file'ExtractDir(file)
	Local lo:Int
	For lo = Len(fi) To 1 Step - 1
		If fi[lo..lo+1]= "/" Or fi[lo..lo+1]="\" Exit
	Next
'	Return Mid(fi,lo+1,Len(fi)-lo)
	Return fi[lo+1..lo+Len(fi)-lo]
End Function

