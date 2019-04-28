Strict

Rem
bbdoc: MaxGUI/Proxy Gadgets
about: This module contains any official proxy gadgets that wrap around the standard MaxGUI gadgets and provide an additional library
of gadgets that can be used in a whole host of programs. Any gadgets in this library can be used with the standard MaxGUI functions
available in the core #MaxGUI.MaxGUI module - updated to handle the new features.<br><br>
[ @{PROXY GADGET} | @{Description}
* HYPERLINK | Creates an HyperLink gadget - see #CreateHyperLink
* SPLITTER | Creates an Splitter gadget - see #CreateSplitter
* SCROLLPANEL | Creates an ScrollPanel gadget - see #CreateScrollPanel
* CALENDAR | Creates a calendar - see #CreateCalendar
* USERINPUT | Creates a calendar - see #CreateInput
* CHECKLISTBOX | Creates a managed listbox with checks - see #CreateCheckListBox
* DATEPICKER | Creates a datapicker - see #CreateDatePicker
* FILEPICKER | Creates a filepicker - see #CreateFilePicker
* LISTMANAGER | Creates a managed listbox- see #CreateListManager
* NOTIFY | Creates an advanced notify - see #CreateNotify
* PROGRESSBAR | Creates an advanced progressbar - see #CreatePBar
* TOOLBAR EXTRA | Creates an advanced toolbar - see #CreateToolBarExtra
* SPINNER | Creates a spinner - see #CreateSpinner
* TABBER MANAGER | Creates a managed tabber gadget - see #CreateTabberManager
* ICONGADGET | Creates an Icon gadget - see #CreateIconGadget
* BUTTONEXTRA | Creates a special gadget - see #CreateButtonExtra
* COLORPICKER | Creates a colorpicker - see #CreateColorPicker
]

Some images of the proxygadgets

<img src="proxy_colorpicker.png" />
<img src="proxy_calendar.png" />
<img src="proxy_checklistbox.png" />
<img src="proxy_datepicker.png" />
<img src="proxy_filepicker.png" />
<img src="proxy_icongadget.png" />
<img src="proxy_listmanager.png" />
<img src="proxy_notify.png" />
<img src="proxy_progressbar.png" />
<img src="proxy_spinner.png" />
<img src="proxy_toolbarextra.png" />
<img src="proxy_userinput.png" />
<br>
End Rem
Module MaxGUI.ProxyGadgets
ModuleInfo "Version: 1.14"
ModuleInfo "License: BSD License"
ModuleInfo "History: 1.14 Release"
ModuleInfo "History: (degac) Added: ColorPicker"
ModuleInfo "History: (degac) Added: IconGadget"
ModuleInfo "History: (degac) fixed: implemented Hide/Show Enable/Disable in FilePicker, DatePicker, ToolBarExtra, TabberManager, ListManager"
ModuleInfo "History: (degac) fixed: created common.bmx file to share some code to various gadgets."

ModuleInfo "History: 1.13 Release"
ModuleInfo "History: degac add: Calendar, DatePicker, FilePicker, CheckListBox, ListManager, Notify, ProgressBar, ToolBarExtra"

ModuleInfo "History: 1.12 Release"
ModuleInfo "History: Added optional pHandleSize parameter."
ModuleInfo "History: Added ability to set split handle background color."
ModuleInfo "History: Fixed SPLIT_LIMITPANESIZE and SPLIT_CLICKTOTOGGLE bug."
ModuleInfo "History: 1.11 Release"
ModuleInfo "History: Hyperlink gadget now defaults to link colour returned by LookupGuiColor()."
ModuleInfo "History: 1.10 Release"
ModuleInfo "History: Decreased the TSplitter threshold for orientation flip."
ModuleInfo "History: 1.09 Release"
ModuleInfo "History: Added SCROLLPANEL_HNEVER and SCROLLPANEL_VNEVER constants."
ModuleInfo "History: 1.08 Release"
ModuleInfo "History: Added a new TScrollPanel gadget."
ModuleInfo "History: 1.07 Release"
ModuleInfo "History: Tweaked THyperlinkGadget.eventHandler() so that it works consistently on all platforms."
ModuleInfo "History: 1.06 Release"
ModuleInfo "History: Fixed some rogue dragging locks for splitters on Windows."
ModuleInfo "History: 1.05 Release"
ModuleInfo "History: Tidied up TSplitter.eventHook(), fixing several bugs in drag code."
ModuleInfo "History: 1.04 Release"
ModuleInfo "History: Added a new SetSplitterBehavior command."
ModuleInfo "History: 1.03 Release"
ModuleInfo "History: Fixed hyperlink tooltips."
ModuleInfo "History: A hyperlink's URL can now be modified/retrieved using SetGadgetExtra / GadgetExtra."
ModuleInfo "History: 1.02 Release"
ModuleInfo "History: Added a new TSplitter gadget. See CreateSplitter for more info."
ModuleInfo "History: 1.01 Release"
ModuleInfo "History: Filtered EVENT_MOUSEDOWN to avoid infinite loop on Windows."
ModuleInfo "History: Updated THyperlinkGadget to use LookupGuiFont()."
ModuleInfo "History: Inherited MaxGUI.Win32MaxGUI's label SS_NOTIFY fix."
ModuleInfo "History: 1.00 Release"
ModuleInfo "History: Added the first custom gadget: the hyperlink control."

Import "hyperlink.bmx"
Import "splitter.bmx"
Import "scrollpanel.bmx"

Import "Calendar.bmx"
Import "UserInput.bmx"
Import "CheckListBox.bmx"
Import "DatePicker.bmx"
Import "FilePicker.bmx"
Import "ListManager.bmx"
Import "Notify.bmx"
Import "ProgressBar.bmx"
Import "ToolBarExtra.bmx"
Import "Spinner.bmx"
Import "IconGadget.bmx"
Import "ButtonExtra.bmx"
Import "Colorpicker.bmx"
