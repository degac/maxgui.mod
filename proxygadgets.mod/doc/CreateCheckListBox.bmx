Rem
	checklistbox
	2009-2014 degac (CC) wwww.graphio.net
End Rem

SuperStrict
Import maxgui.drivers'FLTKmaxgui'drivers
Import maxgui.proxygadgets


	Local window:tgadget=CreateWindow("test 2",100,100,350,340,,WINDOW_TITLEBAR|WINDOW_CENTER|WINDOW_RESIZABLE)
	
	Local list1:tgadget=CreateCheckListBox( 10,10,150,200,window)
	Local list2:tgadget=CreateCheckListBox(180,10,150,200,window)
	
	Local but1:tgadget	=CreateButton("Clear all"	,10,220,100,25,window)
	Local but2:tgadget	=CreateButton("Copy"		,10,250,100,25,window)
	Local but3:tgadget	=CreateButton("Destroy"	,120,220,100,25,window)
	Local but4:tgadget	=CreateButton("Enable"	,120,250,100,25,window)
	Local but5:tgadget	=CreateButton("Disable"	,230,250,100,25,window)
	Local but6:tgadget	=CreateButton("Check all"	, 10,280,100,25,window)
	Local but7:tgadget	=CreateButton("UnCheck all"	,120,280,100,25,window)
	Local but8:tgadget	=CreateButton("Toggle all"	,230,280,100,25,window)
	Local but9:tgadget	=CreateButton("Add Item"	,230,220,100,25,window)
	
	
	Local ic:ticonstrip=LoadIconStrip("resources/toolbar.png")
	
	SetGadgetIconStrip list1,ic
	SetGadgetIconStrip list2,ic
	SetGadgetColor list1,200,100,90

	For Local ii:Int=1 To 25
		AddGadgetItem list1,"Item "+ii,Rand(0,1),(ii Mod 11),"Tip "+ii
	Next

	listAddExclusion(list1,"0,1,2")
	'listAddExclusion(list1,"3,4,5")
	
	Local CCOUNT:Int=CountGadgetItems(list1)
	
	While True
	WaitEvent 

	Select EventID()
	
		Case EVENT_GADGETSELECT
		
			If EventSource()=list1
					Print "ID: "+EventData()
			End If
	
		Case EVENT_GADGETACTION	
			Select EventSource()
			
				Case list1
					Print "  Item checked :"+EventData()+" "+EventX()
					
				Case list2
					Print "  Item (list2) : "+EventData()+" "+EventX()
			
				Case but9 'add an item
				
					AddGadgetItem list1,"New Item "+CCOUNt,Rand(0,1)
					ccount:+1
			
				Case but6 'check all
					SelectGadgetItem(list1,-1)
				Case but7 'uncheck all
					DeselectGadgetItem(list1,-1)	
				Case but8 'toggle item
					ToggleGadgetItem(list1,-1)			
			
				Case but1
					ClearGadgetItems list1
				Case but2
					
					ClearGadgetItems list2
					Local result:Int[]=SelectedGadgetItems(list1)
					For Local i:Int=EachIn result
							AddGadgetItem list2,GadgetItemText(list1,i),list1.ItemState(i),list1.ItemIcon(i),list1.ItemTip(i),GadgetItemExtra(list1,i)
					Next

				Case but3
					If list1 FreeGadget list1
					
				Case but5
					DisableGadget list1
				Case but4
					EnableGadget list1
				
					
				
			End Select
	
		Case EVENT_WINDOWCLOSE
			End
	End Select
Wend

End 
