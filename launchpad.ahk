gui, Color, F2EDE0

Menu, FileMenu, Add, E&xit, ExitHandler
Menu, HelpMenu, Add, &About, AboutHandler
Menu, ConfigureMenu, Add, Set &Data Dir, DataDirHandler
Menu, ConfigureMenu, Add, Set &Exe Dir, ExeDirHandler
Menu, ConfigureMenu, Add, View Config, ConfigHandler
Menu, MyMenuBar, Add, &File, :FileMenu  ; Attach the two sub-menus that were created above.
Menu, MyMenuBar, Add, &Config, :ConfigureMenu
Menu, MyMenuBar, Add, &Help, :HelpMenu

Gui, Menu, MyMenuBar


Gui, Add, Picture, x0 y0 w430 h150 , doge.png
Gui, Add, Edit, x12 y160 w200 h30 vTipAmmountEdit
Gui, Add, Text, x215 y160 w150 h30 , Set Default Tip Ammount in DOGE
Gui, Add, CheckBox, vVerify, Verify
;Gui, Add, Button, x220 y330 w60 h30 , datadir
Gui, Add, Text, x220 y230 w150 h30 , This is your currently selected Data Directory
;Gui, Add, Button, x220 y370 w60 h30 , exedir
Gui, Add, Text, x220 y270 w150 h30 , This is your currently selected Exe Directory
Gui, Add, Button, x188 y425 w70 h30 , launch
Gui, Add, Button, x336 y475 w90 h30 , Save And Restart
Gui, Add, Button, x20 y475 w90 h30 , Rescan Blockchain
Gui, Add, Edit, x12 y230 w200 h30 vDataDirEdit +ReadOnly ;y difference 40px
Gui, Add, Edit, x12 y270 w200 h30  vExeDirEdit +ReadOnly
Gui, Show, x613 y322 h525 w446, Dogecoin Launchpad
Gui, Font, underline
Gui, Add, Text, x12 y320 cBlue gDogecoinReddit, Visit Dogecoin Subreddit
Gui, Add, Text, cBlue gCheckbal, Check DogeTipBot History
Gui, Add, Text, cBlue gWithdraw, Withdraw DogeTipBot Balance
Gui, Font, norm
Gui, Show







;-----------------------------------------Read Config file section:

;-----------------------------------------Read Line 1 (EXE Dir) from config.txt, set variables
FileReadLine, line, config.txt, 1
if ErrorLevel {
;msgbox Error reading from config file
}
datadir=%line%
GuiControl,, DataDirEdit, %datadir%
;-----------------------------------------Read line 2 (Data Dir) from config.txt, set variables
FileReadLine, line, config.txt, 2
if ErrorLevel {
;msgbox Looks like its your first time using DogeCoin Launchpad! (That, or something went horribly wrong)
}
exedir=%line%
GuiControl,, ExeDirEdit, %exedir%
;-----------------------------------------Read line 3 (Default Tip Amt) from config.txt, set variables
FileReadLine, line, config.txt, 3
if ErrorLevel {
;msgbox Looks like its your first time using DogeCoin Launchpad! (That, or something went horribly wrong)
}
tipammount=%line%
GuiControl,, TipAmmountEdit, %tipammount%

;-----------------------------------------Read line 4 (VERIFY flag) from config.txt, set variables
FileReadLine, line, config.txt, 4
if ErrorLevel {
msgbox Looks like its your first time using DogeCoin Launchpad! (That, or something went horribly wrong)
}
verify=%line%
GuiControl,, Verify, %verify%
Return



;---------------------------------------Code to insert Tip Ammount - escape chars around PLUS and slashes necessary
~^LButton::
if (verify = 1)
{
send {+}`/u`/dogetipbot %tipammount% doge verify
return
}
else {
send {+}`/u`/dogetipbot %tipammount% doge
}
return



;-------------------------------MENU HANDLERS---------------------

MenuFileOpen:
return

ExitHandler:
ExitApp
return

AboutHandler:
Msgbox Much Version! Very number! Such Development! `n VERSION 1.338
return

DataDirHandler:
FileSelectFolder, datadir
GuiControl,, DataDirEdit, %datadir%
return

ExeDirHandler:
FileSelectFolder, exedir
GuiControl,, ExeDirEdit, %exedir%
return

ConfigHandler:
Msgbox Wow! Such Configuration! `n Executable Directiory: %exedir% `n Data Directory: %datadir%

return








DogecoinReddit:
Run http://dogecoin.reddit.com
return		

Checkbal:
Run http://www.reddit.com/message/compose?to=dogetipbot&subject=history&message=`%2Bhistory
return		

Withdraw:
Run http://www.reddit.com/message/compose?to=dogetipbot&subject=withdraw&message=`%2Bwithdraw`%20ADDRESS`%20AMOUNT`%20doge
return		


Buttondatadir:
FileSelectFolder, datadir
GuiControl,, DataDirEdit, %datadir%
return



Buttonexedir:
FileSelectFolder, exedir
GuiControl,, ExeDirEdit, %exedir%
return



Buttonlaunch:

;-----------------------Check if dogecoin-qt.exe process is currently active
Process, wait, dogecoin-qt.exe, .5
NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
if NewPID != 0
{
    MsgBox Dogecoin-QT already appears to be running. Please close the application and try again.
    return
}
else {

Run, %exedir%\dogecoin-qt.exe -datadir=%datadir% 
}
return



ButtonSaveAndRestart:

Gui, Submit, NoHide ;this command submits the guis' datas' state

;--------------------------------------remove old config.txt
FileDelete, config.txt
;--------------------------------------create new config.txt
FileAppend,
(
%datadir%
%exedir%
%TipAmmountEdit%
%verify%
), config.txt
Reload
return



ButtonRescanBlockchain:


;-----------------------Check if dogecoin-qt.exe process is currently active
Process, wait, dogecoin-qt.exe, .5
NewPID = %ErrorLevel%  ; Save the value immediately since ErrorLevel is often changed.
if NewPID != 0
{
    MsgBox Dogecoin-QT already appears to be running. Please close the application and try again.
    return

	
	}
else {
MsgBox, 36, , Rescanning the blockchain is very time consuming and rarely necessary.  Are you sure you want to continue?
    IfMsgBox, Yes 
	Run, %exedir%\dogecoin-qt.exe -datadir=%datadir% -rescan
	IfMsgBox, No
	Return






}
return



return






return
GuiClose:
ExitApp
