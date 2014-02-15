gui, Color, F2EDE0
Gui, Add, Picture, x0 y0 w430 h150 , doge.png
Gui, Add, Edit, x12 y160 w200 h30 vTipAmmountEdit
Gui, Add, Text, x215 y160 w150 h30 , Set Default Tip Ammount in DOGE
Gui, Add, Button, x220 y330 w60 h30 , datadir
Gui, Add, Text, x280 y330 w150 h30 , Set your Data Directory Here
Gui, Add, Button, x220 y370 w60 h30 , exedir
Gui, Add, Text, x280 y370 w150 h30 , Set your Dogecoin-qt.exe Directory Here
Gui, Add, Button, x188 y450 w70 h30 , launch
Gui, Add, Button, x336 y540 w90 h30 , Save Settings
Gui, Add, Button, x20 y540 w90 h30 , Rescan Blockchain
Gui, Add, Edit, x12 y330 w200 h30 vDataDirEdit
Gui, Add, Edit, x12 y370 w200 h30  vExeDirEdit
Gui, Show, x613 y322 h580 w446, Dogecoin Launchpad
Gui, Font, underline
Gui, Add, Text, cBlue gDogecoinReddit, Visit Dogecoin Subreddit
Gui, Add, Text, cBlue gCheckbal, Check DogeTipBot Balance
Gui, Add, Text, cBlue gWithdraw, Withdraw DogeTipBot Balance
Gui, Font, norm
Gui, Show




;-----------------------------------------Read config.txt file into memory
FileReadLine, line, config.txt, 1
if ErrorLevel {
;msgbox Error reading from config file
}
datadir=%line%
GuiControl,, DataDirEdit, %datadir%
;--------------------------------------Read line 2 (Data Dir) from config.txt
FileReadLine, line, config.txt, 2
if ErrorLevel {
msgbox Looks like its your first time using DogeCoin Launchpad! (That, or something went horribly wrong)
}
exedir=%line%
GuiControl,, ExeDirEdit, %exedir%
FileReadLine, line, config.txt, 3
if ErrorLevel {
msgbox Looks like its your first time using DogeCoin Launchpad! (That, or something went horribly wrong)
}
tipammount=%line%
GuiControl,, TipAmmountEdit, %tipammount%
Return

;---------------------------------------Code to insert Tip Ammount - escape chars around PLUS and slashes necessary
~^LButton::
send {+}`/u`/dogetipbot %tipammount% doge
Return



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



ButtonSaveSettings:

Gui, Submit, NoHide ;this command submits the guis' datas' state

;--------------------------------------remove old config.txt
FileDelete, config.txt
;--------------------------------------create new config.txt
FileAppend,
(
%datadir%
%exedir%
%TipAmmountEdit%
), config.txt
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
