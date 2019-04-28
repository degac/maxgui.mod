Rem
	FilePicker
	2011-2014 degac (CC) wwww.graphio.net
End Rem

SuperStrict

Import maxgui.drivers
Import maxgui.proxygadgets
AppTitle="File picker example"

Local window:tgadget	=CreateWindow(AppTitle,100,100,400,400,,WINDOW_TITLEBAR|WINDOW_CENTER|WINDOW_RESIZABLE)
Local pix:TPixmap=LoadPixmap("resources/icon_folder.png")
Local button:tgadget = CreateButton ("Destroy",10,80,100,24,window)
Local fp1:tFilepicker=	Createfilepicker("Please, choose a file",AppDir+"/",10,10,200,24,window,CHOOSE_FILE|SAVEFLAG)
Local fp2:tFilepicker=	Createfilepicker("Damn, choose a folder!",AppDir+"/",10,40,200,24,window,CHOOSE_FOLDER)
SetGadgetPixmap fp1,pix
SetGadgetPixmap fp2,pix
SetGadgetColor fp2,200,200,200
fp1.SelectFilter("Application:exe;Source:bmx")

While True
	WaitEvent 
	Select EventID()

		Case EVENT_GADGETACTION
			If EventSource()=button
				Print GCMemAlloced()
				FreeGadget fp1
				FreeGadget fp2
				Print GCMemAlloced()
				GCCollect()
				Print GCMemAlloced()
			End If
			If EventSource()=fp2
				Print "Folder: <"+String(EventExtra())+">"
			End If
		Case EVENT_WINDOWCLOSE
			End
	End Select
Wend
