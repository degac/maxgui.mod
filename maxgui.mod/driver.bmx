Strict

Import "gadget.bmx"
Import "guifont.bmx"

Import MaxGUI.Localization
Import Brl.Map

Type TMaxGUIDriver
	
	Method UserName$() Abstract	
	Method ComputerName$() Abstract
	
	Method LoadFont:TGuiFont(name$,size,flags) Abstract
	Method CreateGadget:TGadget(GadgetClass,name$,x,y,w,h,group:TGadget,style) Abstract
	Method ActiveGadget:TGadget() Abstract
	Method RequestColor(r,g,b) Abstract
	Method RequestFont:TGuiFont(font:TGuiFont) Abstract	
	Method SetPointer(shape) Abstract
	Method LoadIconStrip:TIconStrip(source:Object) Abstract
	
	Method LookupColor( colorindex:Int, pRed:Byte Var, pGreen:Byte Var, pBlue:Byte Var )
		
		Select colorindex
			Case GUICOLOR_WINDOWBG
				pRed = 240; pGreen = 240; pBlue = 240
			Case GUICOLOR_GADGETBG
				pRed = 255; pGreen = 255; pBlue = 255
			Case GUICOLOR_GADGETFG
				pRed = 0; pGreen = 0; pBlue = 0
			Case GUICOLOR_SELECTIONBG
				pRed = 50; pGreen = 150; pBlue = 255
			Case GUICOLOR_LINKFG
				pRed = 0; pGreen = 0; pBlue = 255
		EndSelect
		
		Return False
		
	EndMethod
	
	Method LibraryFont:TGuiFont( pFontType% = GUIFONT_SYSTEM, pFontSize:Double = 0, pFontStyle% = FONT_NORMAL )
		?Win32
		If pFontSize <= 0 Then
			Select pFontType
				Case GUIFONT_SYSTEM;pFontSize = 8
				Case GUIFONT_SERIF;pFontSize = 11
				Default;pFontSize = 10
			EndSelect
		EndIf
		?Not Win32
		If pFontSize <= 0 Then
			pFontSize = 12
			?MacOs
			If pFontType = GUIFONT_SYSTEM Then pFontSize = 11
		?Not Win32
		EndIf
		?
		Select pFontType
			Case GUIFONT_MONOSPACED
				?Linux
				Return LoadFontWithDouble("Lucida",pFontSize,pFontStyle)
				?MacOS
				Return LoadFontWithDouble("Monaco",pFontSize,pFontStyle)
				?Win32
				'Let's give any Vista users the chance to use the new Consolas font.
				Local tmpFont:TGuiFont = LoadFontWithDouble("Consolas",pFontSize,pFontStyle)
				If tmpFont.name = "Consolas" Then Return tmpFont
				Return LoadFontWithDouble("Courier New",pFontSize,pFontStyle)
				?
			Case GUIFONT_SANSSERIF
				?Linux
				Return LoadFontWithDouble("FreeSans",pFontSize,pFontStyle)
				?MacOS
				Return LoadFontWithDouble("Helvetica",pFontSize,pFontStyle)
				?Win32
				Return LoadFontWithDouble("Arial",pFontSize,pFontStyle)
				?
			Case GUIFONT_SERIF
				?Linux
				Return LoadFontWithDouble("FreeSerif",pFontSize,pFontStyle)
				?MacOS
				Return LoadFontWithDouble("Times New Roman",pFontSize,pFontStyle)
				?Win32
				Return LoadFontWithDouble("Times New Roman",pFontSize,pFontStyle)
				?
			Case GUIFONT_SCRIPT
				?Linux
				Return LoadFontWithDouble("TSCu_Comic",pFontSize,pFontStyle)
				?MacOS
				Return LoadFontWithDouble("Comic Sans MS",pFontSize,pFontStyle)
				?Win32
				Return LoadFontWithDouble("Comic Sans MS",pFontSize,pFontStyle)
				?
			Default	'GUIFONT_SYSTEM
				?Linux
				Return LoadFontWithDouble("FreeSans",pFontSize,pFontStyle)
				?MacOS
				Return LoadFontWithDouble("Lucida Grande",pFontSize,pFontStyle)
				?Win32
				Return LoadFontWithDouble("MS Shell Dlg",pFontSize,pFontStyle)
				?
		EndSelect
	EndMethod
	
	Method LoadFontWithDouble:TGuiFont(name$,size:Double,flags)
		Return LoadFont(name,Int(size+0.5),flags)
	EndMethod
	
	' Localization Code
	
	Field _mapLocalized:TMap = CreateMap()
	
	Method SetLocalizationMode( Mode:Int )
		Local tmpApply:Int = False
		If (LocalizationMode() ~ Mode) & LOCALIZATION_ON Then tmpApply = True
		engine_SetLocalizationMode(Mode)
		If tmpApply Then ApplyLanguage()
	EndMethod
	
	Method SetLanguage( language:TMaxGUILanguage )
		engine_SetLocalizationLanguage(language)
		ApplyLanguage()
	EndMethod
	
	Method ApplyLanguage()
		For Local tmpGadget:TGadget = EachIn MapKeys(_mapLocalized)
			ApplyLocalization( tmpGadget )
		Next
	EndMethod
	
	Method SetGadgetLocalization( gadget:TGadget, text$, tooltip$ )
		If gadget Then
			MapInsert _mapLocalized, gadget, [text,tooltip]
			ApplyLocalization( gadget )
		EndIf
	EndMethod
	
	Method ApplyLocalization( gadget:TGadget )
		If gadget.Class() <> GADGET_CANVAS Then
			Local tmpString$[] = String[](MapValueForKey( _mapLocalized, gadget ))
			gadget.SetText(LocalizeString(tmpString[0]))
			gadget.SetTooltip(LocalizeString(tmpString[1]))
			For Local i:Int = 0 Until gadget.items.length
				If Max(gadget.ItemFlags(i),0)&GADGETITEM_LOCALIZED Then
					LocalizeGadgetItem( gadget, i )
				EndIf
			Next
		EndIf
	EndMethod
	
	Method LocalizeGadgetItem( gadget:TGadget, index:Int )
		gadget.SetListItem(index,LocalizeString(gadget.ItemText(index)),LocalizeString(gadget.ItemTip(index)),gadget.ItemIcon(index),gadget.ItemExtra(index))
	EndMethod
	
	Method GadgetLocalized:Int( gadget:TGadget )
		Return MapContains( _mapLocalized, gadget )
	EndMethod
	
	Method DelocalizeGadget( gadget:TGadget )
		MapRemove _mapLocalized, gadget
	EndMethod
	
End Type

Global maxgui_driver:TMaxGUIDriver

' Localization Handling

Const LOCALIZATION_OVERRIDE:Int = 2

Private

Function DelocalizeGadget(gadget:TGadget)
	maxgui_driver.DelocalizeGadget(gadget)
EndFunction

Function driver_SetLocalizationMode(Mode:Int)
	maxgui_driver.SetLocalizationMode(Mode)
EndFunction

Function driver_SetLocalizationLanguage(language:TMaxGUILanguage)
	maxgui_driver.SetLanguage(language)
EndFunction

Global engine_SetLocalizationMode( Mode:Int ) = _SetLocalizationMode
Global engine_SetLocalizationLanguage( language:TMaxGUILanguage ) = _SetLocalizationLanguage

_SetLocalizationMode = driver_SetLocalizationMode
_SetLocalizationLanguage = driver_SetLocalizationLanguage

TGadget.LocalizeString = LocalizeString
TGadget.DelocalizeGadget = DelocalizeGadget

Rem
bbdoc: Add in one batch, many items to a gadget
about: with this command you can add many items to a gadget (like listbox or combobox) passing them in an array, a list or a map (key values are considered)
@sel parameter indicates what item is 'selected'
End Rem
Function AddGadgetItems:Int(gadget:tgadget,obj:Object=Null,sel:Int=-1)
	If gadget=Null Return -1
	If obj=Null Return -1
	
	Local tmp:Object
	
	If obj=String[](obj)
		For Local s:String=EachIn String[](obj)
		'gadget.ItemCount(),Text,tip,icon,extra,flags)
			gadget.InsertItem(gadget.ItemCount(),s,s,-1,Null,0)
		Next
	End If
	
	If obj=TList(obj)
		For Local s:String=EachIn TList(obj)
		gadget.InsertItem(gadget.ItemCount(),s,s,-1,Null,0)		
		Next
	End If
	
	If obj=tmap(obj)
			For Local s:String=EachIn MapKeys(tmap(obj))
			tmp=MapValueForKey(tmap(obj),s)
			gadget.InsertItem(gadget.ItemCount(),s,s,-1,tmp,0)
			Next
	End If
	If sel<>-1
		gadget.SelectItem(sel,1)

	End If
End Function
