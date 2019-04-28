SuperStrict
Import MaxGUI.MaxGUI
Import "common.bmx"
Rem
		date picker
End Rem

Rem
bbdoc:Create a File picker button
about:Create a button to choose a path for a file or for a folder

Style: 
[
* CHOOSE_FILE | Choose a file. The file filter is set with the @{method SelectFilter}
* CHOOSE_FOLDER | Choose a folder
* SAVEFLAG | To use the save requester
]
<br>
@SelectFilter
Use standard #RequestFile 
Use @GadgetText to get the path

<br>
End Rem
Function CreateFilePicker:tFilepicker(msg:String,cpath:String,x:Int,y:Int,w:Int,h:Int,group:tgadget,style:Int=CHOOSE_FILE)
	Return tFilepicker.Create(msg,cpath,x,y,w,h,group,style)
End Function

	Const CHOOSE_FILE:Int=		1
	Const CHOOSE_FOLDER:Int=	2
	Const SAVEFLAG:Int=		4
	Const GADGET_FOLDERPICKER:Int=40

Type tFilepicker Extends Tproxygadget


	Field panel:tgadget
	Field label:tgadget
	Field button:tgadget
	Field path:String,start_path:String,message:String
	Field style:Int
	Field extensions:String
	Field pixmap:TPixmap,grey_pixmap:TPixmap
	
	Method SetFont:Int(fnt:Tguifont=Null)
		If fnt=Null Return 0
		If label SetGadgetFont label,fnt
		If button SetGadgetFont button,fnt
	
	End Method
	
	Method SetPixmap:Int(pix:TPixmap,flags:Int=0)
		If pix
	
			SetGadgetText button,""
			SetGadgetPixmap button,pix	
			pixmap=pix
			grey_pixmap=TPixmap(makegrey(Pix))
		EndIf
	End Method
	
	Method SelectFilter:Int(_filter$="")
		If _filter="" Return -1
		extensions=_filter		
	End Method
	
		Method class:Int()
		Return GADGET_FILEPICKER
	End Method
	
	Method CleanUp:Int()
		RemoveHook EmitEventHook,EventHandler,Self

		If label FreeGadget label;label = Null
		If button FreeGadget button;button = Null
		If panel FreeGadget panel;panel = Null
		pixmap=Null
		grey_pixmap=Null
		Super.CleanUp()
	End Method
	
	Method SetShow:Int(bool:Int)
		panel.setshow(bool)
	End Method

	Method SetEnabled:Int(status:Int=True)
		If status=True
			EnableGadget panel
			SetGadgetPixmap button,pixmap
			EnableGadget label
			EnableGadget button
		Else
			SetGadgetPixmap button,grey_pixmap
			DisableGadget panel
			DisableGadget label
			DisableGadget button
		End If
	

	End Method


	Function Create:tFilepicker (msg$="",ini_path:String="",x:Int,y:Int,w:Int,h:Int,group:tgadget,style:Int=CHOOSE_FILE)
		Local sp:tFilepicker =New tFilepicker 
		
		sp.panel=CreatePanel(x,y,w,h,group)
		sp.label=CreateTextField(1,1,w-25,h-2,sp.panel)
		sp.button=CreateButton("...",w-24,1,22,h-2,sp.panel)
		SetGadgetText sp.label,ini_path
		If msg<>"" SetGadgetText sp.label,msg
		
		
	
		sp.start_path=ini_path
		sp.message=msg
		SP.style=STYLE
		AddHook EmitEventHook,EventHandler,sp
		sp.SetProxy sp.panel
		
		SetGadgetLayout sp.panel,EDGE_ALIGNED,EDGE_ALIGNED,0,0
		SetGadgetLayout sp.label,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE,EDGE_RELATIVE
		SetGadgetLayout sp.button,EDGE_RELATIVE,EDGE_ALIGNED,EDGE_RELATIVE,EDGE_RELATIVE

		Return sp
	End Function
	

	
	Method SetColor:Int(RED:Int,green:Int,blue:Int)
		SetGadgetColor label,RED,green,blue
	End Method
	
	Method GetText:String()
		Return GadgetText(label)
	End Method
	
	Method SetText:Int(tx:String)
		If tx="" Return -1
		SetGadgetText label,tx
	
	End Method

	Method SetLayout:Int(a:Int,b:Int,c:Int,d:Int)
	End Method
	
	
	Function eventHandler:Object( pID%, pData:Object, pContext:Object )
		Local pEvent:TEvent =  TEvent(pData)
		Local obj:tFilepicker = tFilepicker (pContext)
		Local path:String
		Local _flag:Int=False
		If obj.style&SAVEFLAG=SAVEFLAG _flag=True
		
		If pEvent
		
			Select pevent.ID
				Case EVENT_GADGETACTION
					If PEVENT.SOURCE=OBJ.button
						If obj.style&CHOOSE_FILE
							path=RequestFile(obj.message,obj.extensions,_flag,obj.start_path)
						ElseIf (OBJ.style&CHOOSE_FOLDER=CHOOSE_FOLDER)
							path=RequestDir(obj.message,obj.start_path)
						End If
						pevent.extra=path
						If path<>"" SetGadgetText obj.label,path
						SetGadgetExtra(obj,path)
						EmitEvent CreateEvent(EVENT_GADGETACTION,obj,0,0,0,0,String(PATH))
						Return pevent
					End If
			End Select

			
		End If
		
		Return pData
	EndFunction


End Type

