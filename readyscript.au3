#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Dokumente und Einstellungen\Dominik\Eigene Dateien\Downloads\Icon_1.ico
#AutoIt3Wrapper_Outfile=readyscript.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=readyscript
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=aquila
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/cv 0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/cv 0

#cs
	**********************************************************
	**********************************#****#******************
	***************************************#******************
	*****####******####*****#****#****#****#*********####*****
	****#****#****#****#****#****#****#****#********#****#****
	****#****#****#****#****#****#****#****#********#****#****
	****#***##****#***##****#****#****#****#********#***##****
	*****###*#*****###*#*****####*****#****######****###*#****
	*******************#**************************************
	*******************#**************************************
	**********************************************************


	01.03.2008 Scripting gestartet
	02.03.2008 Spielernamen- und Chatnachrichtenauslesung vereinfacht geschrieben
	03.03.2008 Gamelive und Halbzeitanzeige hinzugefügt
	04.03.2008 Scoreanzeige nach jeder Runde hinzugefügt und verbessert
	05.03.2008 Gui erstellt, Regauslesung und Regwrite hinzugefügt, readme.txt erstellt
	06.03.2008 Gewissen Fragen ob Bedinungen erfüllt sind hinzugefügt, Spielernamen- und Chatnachrichtenauslesung verbessert und Bugs behoben
	07.03.2008 #AutoItWrapper hinzugefügt, Transparenz hinzugefügt, Gui verschönert, Version 1.0 fertiggestellt
	08.03.2008 Kleine Feinheiten verbessert, Namechange eingebaut, damit man auch mit Namechange nur einmal ready sein kann, Version 1.0 geupdated
	09.03.2008 Chatnachrichtenauslesung und Scoreauslesung auf eine Datei beschränkt, Auslesung verbessert, Code angepasst
	10.03.2008 Gui verkleinert, einige Funktionen verändert
	11.03.2008 warmup, ADMIN.txt Abfrage hinzugefügt, setup xonx mrxx hinzugefügt. Version 1.1 fertiggestellt
	12.03.2008 CPU-Auslastung gesenkt, ADMIN.txt auslesung bzw. ADMINERKENNUNG funktionsfähig gemacht und bekannte BUGS behoben
	16.03.2008 _FileCountLines deutlich verbessert, damit nun jedes ready eines Spieler erkannt wird, Sortierungen in der _ready funktion
	16.03.2008 Automatische Updatefunktion mit eingebaut
	23.03.2008 6 Tage Tests mit HL-Protokoll gemacht, umschreiben des Scripts beginnt :D 23:30 - 1:00 Uhr - 300 Zeilen fertig -.-
	24.03.2008 Umschreiben des Scriptes um 18:30 beendet, Script wird noch etwas verfeinert
	04.04.2008 LadeBildschirm erstellt
	19.04.2008 Die letzten Bugs gekillt, Settingsauswahl mit eingebaut, Version 1.5 fertiggestellt
	01.05.2008 Warscheinlich letzten Bug endeckt und behoben, Regwrite/Regread mit Ini ersetzt
	04.05.2008 Time hinzugefügt
	08.05.2008 Script stop/resume hinzugefügt, Version 1.6 erstellt
	09.05.2008 Wenn ein Spieler ready war und den server verlässt ist er absofort nicht mehr ready, restart match Funktion eingebaut, jetzt URLAUB :D
	12.06.2008 Commands können nun selbst bestimmt werden
	29.06.2008 Script Options hinzugefügt und messages können nun selbst bestimmt werden
	20.08.2008 Irc eingebaut, damit man Gegner suchen kann, noch etwas verbuggt
	21.08.2008 Irc fertiggestellt
#ce

;=====================================================================================================================================================


;INCLUDES
#include <array.au3>
#include <File.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GuiConstants.au3>
#include <EditConstants.au3>
#include <String.au3>
#include <INet.au3>
#include <Constants.au3>
#include <ComboConstants.au3>

Global $messagesanzahl = 25, $Cryptpassword = 'XNW13DP4BAT9C77UA0DZPE2F0HGMDHYS1N808FE2'
;GLOBALS
Global $A2S_RCON_GETCHALLENGE, $A2S_RCON_SERVER, $socket, $challenge, $LANIP
Global $RdyP[11], $Playerready, $serverpw, $checkboxirc
Global $Playername, $Chat, $ircserverinput, $ircportinput, $ircnickinput
Global $Playerready, $INETIP, $checkbox, $radiorouterno, $radiorouteryes, $wanipinput
Global $Maxplayers, $IPPORT, $testAnzahl, $testMaxrounds
Global $IP, $Trans, $read, $PORT, $xonx, $Combostartup
Global $Admin, $Adminline, $13rundenregelallow
Global $splitErgebnis, $checkErgebnis, $ircdelayinput
Global $Overall1, $Overall2, $Channelinput[6]
Global $HalftimeT, $HalftimeCT, $Form1, $Input1, $Input2
Global $Ergebnis, $Ergebnis2, $Channel[6]
Global $13rundenregel, $pic, $color, $Button1, $lanipinput
Global $maxrounds, $RCON, $cfgfile, $message[50], $btwn
Global $ITEMTrans, $ITEMHilfe, $ITEMExit, $ITEMSkins, $ITEMSave, $defaultmessage
Global $rconcrypt, $restart, $IRC
Global $command[20], $cmd[20], $label[20], $cmddef[20], $scriptmessage[$messagesanzahl + 1], $msginput[$messagesanzahl + 1], $defaultmessage[$messagesanzahl + 1]
Global $msglabel[$messagesanzahl + 1], $scriptmessagestandard[$messagesanzahl + 1]
Global $nextoptions, $optheight, $labelheight, $Options1, $Options2, $Score1, $Score2, $OldScore1, $Oldscore2, $NewScore1, $NewScore2
Global $ITEMOptions, $IP[5], $PORT, $Overtime, $Options3, $checkboxot, $otstartmoney, $otmaxrounds, $udpport, $ot_maxrounds, $ot_startmoney

;OPTS
Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
$laniphelp = @IPAddress1
If $laniphelp = "0.0.0.0" Or $laniphelp = "" Then $laniphelp = @IPAddress2
If $laniphelp = "0.0.0.0" Or $laniphelp = "" Then $laniphelp = @IPAddress3
If $laniphelp = "0.0.0.0" Or $laniphelp = "" Then $laniphelp = @IPAddress4

If $CmdLine[0] = 6 Then
	If $CmdLine[1] = "-ip" And $CmdLine[3] = "-port" And $CmdLine[5] = "-rcon" Then
		_traymenu()
		Dim $exitbedingung = "0"
		Dim $loadingscreenbedingung = True
		$IP = $CmdLine[2]
		$IP = StringSplit($IP, ":")
		If @error Then
			MsgBox(0, "Error", @error)
			Exit
		EndIf
		$PORT = $CmdLine[4]
		$RCON = $CmdLine[6]
		_overtimeauslesung()
		_button()
	EndIf
EndIf

$PORT = IniRead(@ScriptDir & "\config.ini", "Script", "port", "")
If $PORT = "" Then
	IniWrite(@ScriptDir & "\config.ini", "Script", "port", "6563")
	$PORT = 6563
EndIf
$LANIP = IniRead(@ScriptDir & "\config.ini", "Script", "lanip", "")
If $LANIP = "" Then
	IniWrite(@ScriptDir & "\config.ini", "Script", "lanip", @IPAddress1)
	$LANIP = @IPAddress1
EndIf
$IRCServer = IniRead(@ScriptDir & "\config.ini", "IRC", "server", "")
If $IRCServer = "" Then
	IniWrite(@ScriptDir & "\config.ini", "IRC", "server", "irc.quakenet.org")
	$IRCServer = "irc.quakenet.org"
EndIf
$IrcPort = IniRead(@ScriptDir & "\config.ini", "IRC", "port", "")
If $IrcPort = "" Then
	IniWrite(@ScriptDir & "\config.ini", "IRC", "port", 6667)
	$IrcPort = 6667
EndIf
$IRCEnable = IniRead(@ScriptDir & "\config.ini", "IRC", "irc", "")
If $IRCEnable = "" Then
	IniWrite(@ScriptDir & "\config.ini", "IRC", "irc", "yes")
	$IRCEnable = "yes"
EndIf
For $i = 1 To 5
	$Channelread = IniRead(@ScriptDir & "\config.ini", "IRC", $i & "on" & $i, "")
	If $Channelread = "" Then IniWrite(@ScriptDir & "\config.ini", "IRC", $i & "on" & $i, "#" & $i & "on" & $i)
Next

_overtimeauslesung()

$bgcolor = 0x000000
$color = IniRead("config.ini", "Config", "color", "")
$picture = IniRead("config.ini", "Config", "picture", "")
Dim $exitbedingung = "0"
;LOADING SCREEN
$loadingscreenbedingung = False
Global $fortschrittswert, $progesslabel
$breite = @DesktopWidth / 2 - 125
$hoehe = @DesktopHeight / 2 - 62.5
$loadingscreen = GUICreate("Loading", 200, 100, $breite, $hoehe, $WS_POPUP)
GUISetBkColor(0x000000)
GUICtrlCreateLabel("Loading...", 10, 15, 180, 20, $SS_CENTER)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, $color)

$progress = GUICtrlCreateProgress(10, 44, 180, 20)
$ITEMExit = TrayCreateItem("Exit")

TrayItemSetOnEvent(-1, "_exit")

$sleep = 40
$progresslabel = GUICtrlCreateLabel("loading datas...", 10, 75, 180, 20, $SS_CENTER)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, $color)
GUISetState(@SW_SHOW)

For $i = 1 To 5
	$fortschrittswert += 10
	GUICtrlSetData($progress, $fortschrittswert)
	Sleep($sleep)
Next
$loadingscreenbedingung = True
;PROGRESSBAR LÄDT
GUICtrlSetData($progresslabel, "loading program...")
For $i = 1 To 5
	$fortschrittswert += 10
	GUICtrlSetData($progress, $fortschrittswert)
	Sleep($sleep)
Next

GUIDelete($loadingscreen)
TrayItemDelete($ITEMExit)
_traymenu()

;TRAYMENU WIRD ERSTELLT
Func _traymenu()
	$ITEMSkins = TrayCreateMenu("Skins")
	$skingreen = TrayCreateItem("white", $ITEMSkins)
	TrayItemSetOnEvent(-1, "_swhite")
	$skingreen = TrayCreateItem("green", $ITEMSkins)
	TrayItemSetOnEvent(-1, "_sgreen")
	$skinblue = TrayCreateItem("blue", $ITEMSkins)
	TrayItemSetOnEvent(-1, "_sblue")
	$skinyellow = TrayCreateItem("yellow", $ITEMSkins)
	TrayItemSetOnEvent(-1, "_syellow")
	$skinred = TrayCreateItem("red", $ITEMSkins)
	TrayItemSetOnEvent(-1, "_sred")
	$skinorange = TrayCreateItem("orange", $ITEMSkins)
	TrayItemSetOnEvent(-1, "_sorange")

	$ITEMSave = TrayCreateItem("Save Settings")
	TrayItemSetOnEvent(-1, "_save")
	$ITEMTrans = TrayCreateItem("Transparency")
	TrayItemSetOnEvent(-1, "_trans")
	$ITEMHilfe = TrayCreateItem("Help")
	TrayItemSetOnEvent(-1, "_readme")
	$ITEMOptions = TrayCreateMenu("Options")
	$optionscommand = TrayCreateItem("Commands", $ITEMOptions)
	TrayItemSetOnEvent(-1, "_optionscommand")
	$optionsmessage = TrayCreateItem("Messages", $ITEMOptions)
	TrayItemSetOnEvent(-1, "_optionsmessage")
	$optionsmessage = TrayCreateItem("Script", $ITEMOptions)
	TrayItemSetOnEvent(-1, "_optionsscript")
	TrayCreateItem("")
	$ITEMExit = TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1, "_exit")
EndFunc   ;==>_traymenu

Call("_programrun")

Func _programrun()
	IniWrite("config.ini", "Config", "color", $color)
	IniWrite("config.ini", "Config", "picture", $picture)
	GUIDelete($Form1)
	;ERSTELLUNG DES GUIS
	$Form1 = GUICreate("ReadyScript v2.0 - aquila", 270, 130)
	GUISetBkColor($GUI_BKCOLOR_TRANSPARENT)
	$pic = GUICtrlCreatePic(@ScriptDir & "\images\" & $picture, 0, 0, 270, 130)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$Input1 = GUICtrlCreateInput("", 90, 24, 150, 21)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, $color)
	GUICtrlSetBkColor(-1, $bgcolor)
	$Label1 = GUICtrlCreateLabel("IP:PORT", 25, 27, 50, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, $color)
	GUICtrlSetBkColor(-1, $bgcolor)

	$Input2 = GUICtrlCreateInput("", 90, 60, 150, 21)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, $color)
	GUICtrlSetBkColor(-1, $bgcolor)

	$Label2 = GUICtrlCreateLabel("RCON", 25, 63, 40, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, $color)
	GUICtrlSetBkColor(-1, $bgcolor)

	$Button1 = GUICtrlCreateButton("Run ReadyScript", 73, 95, 125, 25, 0)
	GUICtrlSetColor(-1, $color)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

	;ANZEIGEN DER IP + RCON
	$IP = IniRead("config.ini", "Server", "ip", "")
	If Not $IP = "" Then GUICtrlSetData($Input1, $IP)
	_encrypt() ;RCON WIRD DORT HERAUSGELESEN, ENTSCHLÜSSELT, UND IN VARIABLE $RCON abgespeichert
	If Not $RCON = "" Then GUICtrlSetData($Input2, $RCON)

	If IniRead("config.ini", "Config", "trans", "") = "true" Then ;TRUE = FENSTER DURCHSICHTIG
		$Trans = True
	ElseIf IniRead("config.ini", "Config", "trans", "") = "false" Then ;FALSE = FENSTER NICHT DURCHSICHTIG
		$Trans = False
	Else
		$Trans = False ;WENN INI NICHT EXISTIERT = FENSTER NICHT DURCHSICHTIG
	EndIf

	_trans() ;DORT WIRD DIE TRANSPARENZ GESETZT, JE NACHDEM WAS DIE INI AUSGELESEN HAT
	GUISetState(@SW_SHOW)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
	GUICtrlSetOnEvent($Button1, "_button0")
EndFunc   ;==>_programrun

While 1
	Sleep(100)
WEnd

Func _exit()
	Exit
EndFunc   ;==>_exit

; SKINSFARBEN
Func _sgreen()
	$color = 0x00FF00
	$picture = "green_bg.bmp"
	_programrun()
EndFunc   ;==>_sgreen

Func _sblue()
	$color = 0x005AFF
	$picture = "blue_bg.bmp"
	_programrun()
EndFunc   ;==>_sblue

Func _syellow()
	$color = 0xFFFF00
	$picture = "yellow_bg.bmp"
	_programrun()
EndFunc   ;==>_syellow

Func _sred()
	$color = 0xFF0000
	$picture = "red_bg.bmp"
	_programrun()
EndFunc   ;==>_sred

Func _sorange()
	$color = 0xFF8000
	$picture = "orange_bg.bmp"
	_programrun()
EndFunc   ;==>_sorange

Func _swhite()
	$color = 0xFFFFFF
	$picture = "white_bg.bmp"
	_programrun()
EndFunc   ;==>_swhite

Func _trans()
	If $Trans = False Then
		TrayItemSetState($ITEMTrans, $TRAY_UNCHECKED)
		WinSetTrans("ReadyScript v2.0 - aquila", "", 250)
		$Trans = True
	ElseIf $Trans = True Then
		TrayItemSetState($ITEMTrans, $TRAY_CHECKED)
		WinSetTrans("ReadyScript v2.0 - aquila", "", 150)
		$Trans = False
	EndIf
	_savetrans()
EndFunc   ;==>_trans

Func _overtimeauslesung()
	$overtimecheck = IniRead(@ScriptDir & "\config.ini", "Script", "overtime", "")
	$ot_startmoney = IniRead(@ScriptDir & "\config.ini", "Script", "ot_startmoney", "")
	$ot_maxrounds = IniRead(@ScriptDir & "\config.ini", "Script", "ot_maxrounds", "")
	If $overtimecheck = "" Then
		IniWrite(@ScriptDir & "\config.ini", "Script", "overtime", "no")
		$Overtime = False
		If $ot_startmoney = "" Then
			$ot_startmoney = "10000"
			IniWrite(@ScriptDir & "\config.ini", "Script", "ot_startmoney", "10000")
		EndIf
		If $ot_maxrounds = "" Then
			$ot_maxrounds = "5"
			IniWrite(@ScriptDir & "\config.ini", "Script", "ot_maxrounds", "5")
		EndIf
	ElseIf $overtimecheck = "yes" Then
		$Overtime = True
		If $ot_startmoney = "" Then
			$ot_startmoney = "10000"
			IniWrite(@ScriptDir & "\config.ini", "Script", "ot_startmoney", "10000")
		EndIf
		If $ot_maxrounds = "" Then
			$ot_maxrounds = "5"
			IniWrite(@ScriptDir & "\config.ini", "Script", "ot_maxrounds", "5")
		EndIf
	Else
		$Overtime = False
	EndIf
EndFunc   ;==>_overtimeauslesung

Func _settingssend()
	$cfgfile2 = @ScriptDir & "\configs\" & $cfgfile ;$CFGFILE WIRD DURCH SETUP XONX ERSTELLT. $CFGFILE2 IST NUN DER GANZE PFAD DER FILE.
	For $i = 1 To _FileCountLines($cfgfile2)
		$loadingsettings = FileReadLine($cfgfile2, $i) ;AUSLESUNG DES BEFEHLS
		$A2S_RCON_SERVER = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" ' & $loadingsettings) ;PROTOKOLL MIT DEM BEFEHL
		UDPSend($socket, $A2S_RCON_SERVER) ;SENDEN DES BEFEHLS
		If @error Then MsgBox(0, "", @error & @CRLF & "Error while sending Settings." & @CRLF & $cfgfile2 & @CRLF & "FILELINE: " & $i)
		Sleep(25) ;25 MILLISEKUNDEN FÜR JEDEN BEFEHL :D NICHTS FÜR ISDN USER.
	Next
EndFunc   ;==>_settingssend

Func _save() ;EINTRAG IN DIE CONFIG.INI - RCON WIRD VORHER NOCH IN DER FUNKTION _CRYPT VERSCHLÜSSELT
	$IP = GUICtrlRead($Input1)
	$RCON = GUICtrlRead($Input2)
	_crypt()
	IniWrite("config.ini", "Server", "ip", $IP)
	IniWrite("config.ini", "Server", "rcon", $rconcrypt)
EndFunc   ;==>_save

Func _optionsscript()
	If WinExists("Readyscript Options") Then GUIDelete($Options3)
	$Options3 = GUICreate("Readyscript Options", 480, 426, 193, 125)
	GUICtrlCreateLabel("UDP Port", 10, 50, 49, 17)
	$udpport = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Script", "port", ""), 114, 47, 113, 21, $ES_NUMBER)
	GUICtrlCreateLabel("Script options", 0, 22, 480, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateLabel("Startup settings", 250, 50, 100, 17)
	$Combostartup = GUICtrlCreateCombo("", 354, 47, 113, 21, $CBS_DROPDOWNLIST)
	$defaultcombovalue = "5on5"
	If IniRead(@ScriptDir & "\config.ini", "Script", "xonx", "") <> "" Then $defaultcombovalue = IniRead(@ScriptDir & "\config.ini", "Script", "xonx", "")
	GUICtrlSetData($Combostartup, "1on1|2on2|3on3|4on4|5on5", $defaultcombovalue)

	GUICtrlCreateLabel("LAN-IP / WAN-IP", 10, 99, 99, 21)
	$lanipinput = GUICtrlCreateInput($laniphelp, 114, 96, 113, 21)
	$checkboxot = GUICtrlCreateCheckbox("Enable overtime?", 10, 135, 200, 17)
	GUICtrlCreateLabel("Overtime startmoney", 10, 166, 99, 21)
	$otstartmoney = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Script", "ot_startmoney", ""), 114, 163, 113, 21, $ES_NUMBER)
	GUICtrlCreateLabel("Overtime maxrounds", 250, 166, 99, 21)
	$otmaxrounds = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Script", "ot_maxrounds", ""), 354, 163, 113, 21, $ES_NUMBER)

	$checkboxirc = GUICtrlCreateCheckbox("Enable IRC search?", 10, 202, 129, 17)
	If IsNumber(IniRead(@ScriptDir & "\config.ini", "IRC", "delay", "")) Then $delay = IniRead(@ScriptDir & "\config.ini", "IRC", "delay", "")
	GUICtrlCreateLabel("IRC Server", 10, 233, 99, 21)
	$ircserverinput = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "server", ""), 114, 230, 113, 21)
	GUICtrlCreateLabel("IRC Port", 250, 233, 99, 21)
	$ircportinput = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "port", ""), 354, 230, 113, 21, $ES_NUMBER)
	GUICtrlCreateLabel("IRC Message delay", 10, 257, 99, 21)
	$ircdelayinput = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "delay", ""), 114, 253, 113, 21)
	$ircnickinput = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "nick", ""), 354, 253, 113, 21)
	GUICtrlCreateLabel("IRC Nick", 250, 257, 99, 21)
	$Channelinput[1] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "1on1", ""), 114, 278, 113, 21)
	GUICtrlCreateLabel("Channel 1on1", 10, 281, 99, 21)
	$Channelinput[2] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "2on2", ""), 354, 278, 113, 21)
	GUICtrlCreateLabel("Channel 2on2", 250, 281, 99, 21)
	$Channelinput[3] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "3on3", ""), 114, 302, 113, 21)
	GUICtrlCreateLabel("Channel 3on3", 10, 305, 99, 21)
	$Channelinput[4] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "4on4", ""), 354, 302, 113, 21)
	GUICtrlCreateLabel("Channel 4on4", 250, 305, 99, 21)
	$Channelinput[5] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "IRC", "5on5", ""), 114, 326, 113, 21)
	GUICtrlCreateLabel("Channel 5on5", 10, 329, 99, 21)
;~ 	$checkbox = GUICtrlCreateCheckbox("Show score message?", 10, 360, 150, 17)
	$checkbox = GUICtrlCreateCheckbox("gg after 13/16 rounds?", 10, 360, 150, 17)
	$roundrule = IniRead(@ScriptDir & "\config.ini", "Script", "roundrule", "")
	If $roundrule = "yes" Then GUICtrlSetState($checkbox, $GUI_CHECKED)
	$Scriptoptionsaccept = GUICtrlCreateButton("Accept", 100, 394, 90, 20, 0)
	$Scriptoptionssettodefault = GUICtrlCreateButton("Set to default", 290, 394, 90, 20, 0)

	If IniRead(@ScriptDir & "\config.ini", "Script", "overtime", "") = "yes" Then
		GUICtrlSetState($checkboxot, $GUI_CHECKED)
	Else
		GUICtrlSetState($otstartmoney, $GUI_DISABLE)
		GUICtrlSetState($otmaxrounds, $GUI_DISABLE)
	EndIf
	If IniRead(@ScriptDir & "\config.ini", "IRC", "irc", "") = "yes" Then
		GUICtrlSetState($checkboxirc, $GUI_CHECKED)
	Else
		GUICtrlSetState($ircdelayinput, $GUI_DISABLE)
		GUICtrlSetState($ircportinput, $GUI_DISABLE)
		GUICtrlSetState($ircserverinput, $GUI_DISABLE)
		For $i = 1 To 5
			GUICtrlSetState($Channelinput[$i], $GUI_DISABLE)
		Next
	EndIf

	GUISetOnEvent($GUI_EVENT_CLOSE, "_optionsclose3")
	GUICtrlSetOnEvent($Scriptoptionsaccept, "_optionsscriptwrite")
	GUICtrlSetOnEvent($Scriptoptionssettodefault, "_optionsscriptsettodefault")
	GUICtrlSetOnEvent($checkboxot, "_cbscript1")
	GUICtrlSetOnEvent($checkboxirc, "_cbscript2")
;~ 	GUICtrlSetOnEvent($iphelplabel, "_iphelp")
	GUISetState(@SW_SHOW)
EndFunc   ;==>_optionsscript

Func _cbscript1()
	If GUICtrlRead($checkboxot) = $GUI_CHECKED Then
		GUICtrlSetState($otstartmoney, $GUI_ENABLE)
		GUICtrlSetState($otmaxrounds, $GUI_ENABLE)
	Else
		GUICtrlSetState($otstartmoney, $GUI_DISABLE)
		GUICtrlSetState($otmaxrounds, $GUI_DISABLE)
	EndIf
EndFunc   ;==>_cbscript1

Func _cbscript2()
	If GUICtrlRead($checkboxirc) = $GUI_CHECKED Then
		GUICtrlSetState($ircserverinput, $GUI_ENABLE)
		GUICtrlSetState($ircportinput, $GUI_ENABLE)
		GUICtrlSetState($ircdelayinput, $GUI_ENABLE)
		For $i = 1 To 5
			GUICtrlSetState($Channelinput[$i], $GUI_ENABLE)
		Next
	Else
		GUICtrlSetState($ircdelayinput, $GUI_DISABLE)
		GUICtrlSetState($ircserverinput, $GUI_DISABLE)
		GUICtrlSetState($ircportinput, $GUI_DISABLE)
		For $i = 1 To 5
			GUICtrlSetState($Channelinput[$i], $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>_cbscript2

Func _optionsscriptwrite()
	If GUICtrlRead($udpport) = "" Or GUICtrlRead($lanipinput) = "" Then
		MsgBox(0, "Error", "Please fill out all inputs!")
	Else
		If GUICtrlRead($checkbox) = $GUI_CHECKED Then
			IniWrite(@ScriptDir & "\config.ini", "Script", "roundrule", "yes")
			$13rundenregelallow = True
		Else
			IniWrite(@ScriptDir & "\config.ini", "Script", "roundrule", "no")
			$13rundenregelallow = False
		EndIf
		IniWrite(@ScriptDir & "\config.ini", "Script", "xonx", GUICtrlRead($Combostartup))
		IniWrite(@ScriptDir & "\config.ini", "IRC", "delay", GUICtrlRead($ircdelayinput))
		IniWrite(@ScriptDir & "\config.ini", "IRC", "nick", GUICtrlRead($ircnickinput))
		IniWrite(@ScriptDir & "\config.ini", "Script", "port", GUICtrlRead($udpport))
		$PORT = GUICtrlRead($udpport)
		IniWrite(@ScriptDir & "\config.ini", "Script", "lanip", GUICtrlRead($lanipinput))
		$LANIP = GUICtrlRead($lanipinput)
		If GUICtrlRead($checkboxot) = $GUI_CHECKED Then
			If GUICtrlRead($otmaxrounds) = "" Or GUICtrlRead($otstartmoney) = "" Then
				MsgBox(0, "Error", "Please fill out all inputs!")
			Else
				IniWrite(@ScriptDir & "\config.ini", "Script", "overtime", "yes")
				IniWrite(@ScriptDir & "\config.ini", "Script", "ot_startmoney", GUICtrlRead($otstartmoney))
				IniWrite(@ScriptDir & "\config.ini", "Script", "ot_maxrounds", GUICtrlRead($otmaxrounds))
				$Overtime = True
				$overtime_startmoney = GUICtrlRead($otstartmoney)
				$overtime_maxrounds = GUICtrlRead($otmaxrounds)
			EndIf
		Else
			IniWrite(@ScriptDir & "\config.ini", "Script", "overtime", "no")
			$Overtime = False
		EndIf
		If GUICtrlRead($checkboxirc) = $GUI_CHECKED Then
			If GUICtrlRead($ircserverinput) = "" Or GUICtrlRead($ircportinput) = "" Then
				MsgBox(0, "Error", "Please fill out all inputs!")
			Else
				IniWrite(@ScriptDir & "\config.ini", "IRC", "irc", "yes")
				IniWrite(@ScriptDir & "\config.ini", "IRC", "server", GUICtrlRead($ircserverinput))
				IniWrite(@ScriptDir & "\config.ini", "IRC", "port", GUICtrlRead($ircportinput))
				$IRCEnable = "yes"
				For $i = 1 To 5
					IniWrite(@ScriptDir & "\config.ini", "IRC", $i & "on" & $i, GUICtrlRead($Channelinput[$i]))
				Next
			EndIf
		Else
			IniWrite(@ScriptDir & "\config.ini", "IRC", "irc", "no")
			$IRCEnable = "no"
		EndIf
	EndIf
	GUIDelete($Options3)
EndFunc   ;==>_optionsscriptwrite

Func _optionsscriptsettodefault()
	GUICtrlSetData($Combostartup, "1on1|2on2|3on3|4on4|5on5", "5on5")
	GUICtrlSetData($otmaxrounds, "5")
	GUICtrlSetData($ircdelayinput, "30")
	GUICtrlSetData($otstartmoney, "10000")
	GUICtrlSetData($udpport, "6563")
	GUICtrlSetData($ircserverinput, "irc.quakenet.org")
	GUICtrlSetData($ircportinput, "6667")
	GUICtrlSetData($lanipinput, @IPAddress1)
	For $i = 1 To 5
		GUICtrlSetData($Channelinput[$i], "#" & $i & "on" & $i)
	Next
EndFunc   ;==>_optionsscriptsettodefault

Func _optionsmessage()
	If WinExists("Readyscript Options") Then GUIDelete($Options2)
	$labelheight = 35
	$msglabel[1] = "Repetitious say ready message"
	$msglabel[2] = "Ready message"
	$msglabel[3] = "Not ready message"
	$msglabel[4] = "Info message"
	$msglabel[5] = "Already ready message"
	$msglabel[6] = "Warmup message"
	$msglabel[7] = "Setup xonx mrxx message"
	$msglabel[8] = "Resume script message"
	$msglabel[9] = "Stop script message"
	$msglabel[10] = "Not admin message"
	$msglabel[11] = "Match end message"
	$msglabel[12] = "Match halftime message"
	$msglabel[13] = "Match start message"
	$msglabel[14] = "First half start message"
	$msglabel[15] = "Second half start message"
	$msglabel[16] = "Time message"
	$msglabel[17] = "Restart first half message"
	$msglabel[18] = "Restart second half message"
	$msglabel[19] = "First half score message"
	$msglabel[20] = "Halftime score message"
	$msglabel[21] = "Second half score message"
	$msglabel[22] = "Overall score message"
	$msglabel[23] = "Overtime start message"
	$msglabel[24] = "Overtime message"
	$msglabel[25] = "Overtime overall message"

	$Options2 = GUICreate("Readyscript Options", 555, 667, 193, 125)
	$Label1 = GUICtrlCreateLabel("Script message options", 0, 8, 555, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$optheight = 32
	For $i = 1 To $messagesanzahl
		$msginput[$i] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Messages", "$scriptmessage[" & $i & "]", ""), 164, $optheight, 380, 20)
		$optheight += 24
	Next

	For $i = 1 To $messagesanzahl
		GUICtrlCreateLabel($msglabel[$i], 10, $labelheight, 148, 17)
		$labelheight += 24
	Next

	$acceptoptions = GUICtrlCreateButton("Accept", 150, 637, 100, 20, 0)
	$settodefault = GUICtrlCreateButton("Set to default", 305, 637, 100, 20, 0)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###

	GUISetOnEvent($GUI_EVENT_CLOSE, "_optionsclose2")
	GUICtrlSetOnEvent($acceptoptions, "_optionswrite2")
	GUICtrlSetOnEvent($settodefault, "_optionssettodefault2")
EndFunc   ;==>_optionsmessage

Func _optionssettodefault2()
	_defaultmessages()
	For $i = 1 To $messagesanzahl
		GUICtrlSetData($msginput[$i], $defaultmessage[$i])
	Next
EndFunc   ;==>_optionssettodefault2

Func _optionswrite2()
	$optionscheck = ""
	For $i = 1 To $messagesanzahl
		If GUICtrlRead($msginput[$i]) = "" Then
			MsgBox(0, "Error", "Please fill out all fields!")
			Return
		EndIf
	Next
	For $i = 1 To $messagesanzahl
		$scriptmessagestandard[$i] = GUICtrlRead($msginput[$i])
		IniWrite(@ScriptDir & "\config.ini", "Messages", "$scriptmessage[" & $i & "]", $scriptmessagestandard[$i])
	Next
	GUIDelete($Options2)
EndFunc   ;==>_optionswrite2

Func _optionscommand()
	If WinExists("Readyscript Options") Then GUIDelete($Options1)
	$label[1] = "ready"
	$label[2] = "not ready"
	$label[3] = "info"
	$label[4] = "time"
	$label[5] = "warmup"
	$label[6] = "restart match"
	$label[7] = "resume script"
	$label[8] = "stop script"
	$label[9] = "setup"

	$Options1 = GUICreate("Readyscript Options", 301, 288, 193, 125)
	$Label1 = GUICtrlCreateLabel("Script command options", 50, 8, 200, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$optheight = 32
	For $i = 1 To 2
		$cmd[$i] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Commands", "$command[" & $i & "]", ""), 104, $optheight, 89, 20)
		$optheight += 24
	Next

	$cmd[10] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Commands", "$command[10]", ""), 195, 32, 89, 20)
	$cmd[11] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Commands", "$command[11]", ""), 195, 56, 89, 20)

	$optheight = 80
	For $i = 3 To 8
		$cmd[$i] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Commands", "$command[" & $i & "]", ""), 104, $optheight, 180, 20)
		$optheight += 24
	Next
	$cmd[9] = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini", "Commands", "$command[9]", ""), 104, $optheight, 89, 20)
	GUICtrlCreateInput(" xonx mrxx", 195, $optheight, 89, 20, $ES_READONLY)
	$labelheight = 35

	For $i = 1 To 9
		GUICtrlCreateLabel($label[$i], 10, $labelheight, 80, 17)
		$labelheight += 24
	Next

	$acceptoptions = GUICtrlCreateButton("Accept", 32, 256, 97, 20, 0)
	$settodefault = GUICtrlCreateButton("Set to default", 168, 256, 97, 20, 0)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###

	GUISetOnEvent($GUI_EVENT_CLOSE, "_optionsclose1")
	GUICtrlSetOnEvent($acceptoptions, "_optionswrite")
	GUICtrlSetOnEvent($settodefault, "_optionssettodefault")
EndFunc   ;==>_optionscommand

Func _optionsclose1()
	GUIDelete($Options1)
EndFunc   ;==>_optionsclose1
Func _optionsclose2()
	GUIDelete($Options2)
EndFunc   ;==>_optionsclose2
Func _optionsclose3()
	GUIDelete($Options3)
EndFunc   ;==>_optionsclose3

Func _optionswrite()
	$optionscheck = ""
	For $i = 1 To 9
		If StringInStr($optionscheck, GUICtrlRead($cmd[$i]) & "-") Then
			MsgBox(0, "Error", "Some commands exists more then one time!")
			Return
		EndIf
		If GUICtrlRead($cmd[$i]) = "" Then
			MsgBox(0, "Error", "Please fill out all fields!")
			Return
		EndIf
		$optionscheck &= GUICtrlRead($cmd[$i]) & "-"
	Next
	If GUICtrlRead($cmd[10]) = GUICtrlRead($cmd[11]) Then
		MsgBox(0, "Error", "Some commands exists more then one time!")
		Return
	EndIf
	For $i = 1 To 11
		$command[$i] = GUICtrlRead($cmd[$i])
		IniWrite(@ScriptDir & "\config.ini", "Commands", "$command[" & $i & "]", GUICtrlRead($cmd[$i]))
	Next
	GUIDelete($Options1)
EndFunc   ;==>_optionswrite

Func _optionssettodefault()
	$cmddef[1] = "ready"
	$cmddef[2] = "notready"
	$cmddef[3] = "info"
	$cmddef[4] = "thetime"
	$cmddef[5] = "warmup"
	$cmddef[6] = "restart match"
	$cmddef[7] = "resume script"
	$cmddef[8] = "stop script"
	$cmddef[9] = "setup"
	$cmddef[10] = "rdy"
	$cmddef[11] = "notrdy"
	For $i = 1 To 11
		GUICtrlSetData($cmd[$i], $cmddef[$i])
	Next
EndFunc   ;==>_optionssettodefault

Func _crypt() ;GEHEIME VERSCHLÜSSELUNG :D STRING TO HEX UND DANN WERDEN DIE JEWEILIGEN ZAHLEN MIT 2 ADDIERT.
	$rconcrypt = $RCON
	If $rconcrypt <> "" Then
;~ 		$rconcrypt = _StringEncrypt(1, $rconcrypt, $Cryptpassword)
	Else
		$rconcrypt = ""
	EndIf
EndFunc   ;==>_crypt

Func _encrypt() ;DER GANZE SPASS RÜCKWÄRTS. DER HEXWERT WIRD UM 2 ZURÜCKGESETZT UND WIEDER IN EINEN STRING UMGEWANDELT.
	$rconencrypt = IniRead("config.ini", "Server", "rcon", "")
	If $rconencrypt <> "" Then
;~ 		$RCON = _StringEncrypt(0, $rconencrypt, $Cryptpassword)
		$RCON = $rconcrypt
	Else
		$RCON = ""
	EndIf
EndFunc   ;==>_encrypt

Func _savetrans() ;EINTRAG IN DIE INI DATEI.
	If $Trans = False Then IniWrite("config.ini", "Config", "trans", "true")
	If $Trans = True Then IniWrite("config.ini", "Config", "trans", "false")
EndFunc   ;==>_savetrans

Func _readme() ;OEFFNET DIE README.TXT IM SCRIPTORDNER
	ShellExecute(@ScriptDir & "\readme.txt")
EndFunc   ;==>_readme

Func _button0()
	_save()
	If $IP = "" Then
		MsgBox(0, "", "Missing IP!")
		Return
	EndIf
	If Not StringInStr($IP, ":") Then
		MsgBox(0, "", "Missing Port!")
		Return
	EndIf
	GUIDelete($Form1)
	$IP = StringSplit($IP, ":", 0) ;DIE IP WIRD IN IN DIE IP UND PORT GESPLITTET
	For $i = 97 To 122
		If StringInStr($IP[1], Chr($i)) Then
			$IP[1] = TCPNameToIP($IP[1])
			ExitLoop
		EndIf
	Next
	_button()
EndFunc   ;==>_button0

Func _button() ;READYSCRIPT WIRD GESTARTET -> PROGRAMM LAEUFT IN DIE ERSTE RDY GO SCHLEIFE
	;GEWISSE UEBERPRUEFUNGEN, OB EINE IP, EIN PORT UND EIN RCON EXISTIERT
	_defaultmessages()
	If FileExists(@ScriptDir & "\config.ini") Then
		For $i = 1 To $messagesanzahl
			$scriptmessagestandard[$i] = IniRead(@ScriptDir & "\config.ini", "Messages", "$scriptmessage[" & $i & "]", "")
			If $scriptmessagestandard[$i] = "" Then IniWrite(@ScriptDir & "\config.ini", "Messages", "$scriptmessage[" & $i & "]", $defaultmessage[$i])
		Next
		For $i = 1 To 13
			$command[$i] = IniRead(@ScriptDir & "\config.ini", "Commands", "$command[" & $i & "]", "")
		Next
		If IniRead(@ScriptDir & "\config.ini", "Script", "roundrule", "") = "yes" Then
			$13rundenregelallow = True
		ElseIf IniRead(@ScriptDir & "\config.ini", "Script", "roundrule", "") = "no" Then
			$13rundenregelallow = False
		Else
			IniWrite(@ScriptDir & "\config.ini", "Script", "roundrule", "yes")
			$13rundenregelallow = True
		EndIf
	Else
		_defaultmessages()
		For $i = 1 To $messagesanzahl
			$scriptmessagestandard[$i] = $defaultmessage[$i]
		Next
		$command[1] = "ready"
		$command[2] = "notready"
		$command[3] = "info"
		$command[4] = "time"
		$command[5] = "warmup"
		$command[6] = "restart match"
		$command[7] = "resume script"
		$command[8] = "stop script"
		$command[9] = "setup"
		$command[10] = "rdy"
		$command[11] = "notrdy"
		$13rundenregelallow = True
	EndIf

	TrayItemSetState($ITEMHilfe, $GUI_DISABLE)
	TrayItemSetState($ITEMSave, $GUI_DISABLE)
	TrayItemSetState($ITEMTrans, $GUI_DISABLE)
	TrayItemSetState($ITEMSkins, $GUI_DISABLE)
	TrayItemSetState($ITEMOptions, $GUI_DISABLE)

	;STANDARDWERTE AUS DER CONFIG.INI WERDEN HERAUSGELESEN.
	$Maxplayers = IniRead("config.ini", "Script", "xonx", "")
	$maxrounds = IniRead("config.ini", "Script", "maxrounds", "")

	;ZUWEISUNG DER SETTINGSFILE FÜR DEN SERVER, DAMIT DIE RICHTIGEN SETTINGS GELADEN WERDEN KÖNNEN
	For $i = 1 To 5
		If $Maxplayers = $i & "on" & $i Then
			$Maxplayers = $i * 2
			$cfgfile = $i & "on" & $i & ".cfg"
		EndIf
	Next

	If $Maxplayers = '' Then
		$Maxplayers = "10"
		$cfgfile = "5on5.cfg"
	EndIf

	If $maxrounds = "12" Then
		$maxrounds = "12"
	ElseIf $maxrounds = "15" Then
		$maxrounds = "15"
	Else ;AUCH HIER, WENN DIE INI GESCHROTTET IST :D, DANN WERDEN DIE MAXROUNDS AUF 12 GESETZT
		$maxrounds = "12"
	EndIf

	_udpverbindung()
EndFunc   ;==>_button

Func _udpverbindung()

	$INETIP = _GetWanIp()
	UDPStartup()
	Dim $A2S_RCON_GETCHALLENGE = (_HexToString("FFFFFFFF") & 'challenge rcon') ;CHALLENGE PROTOKOLL
	$socket = UDPOpen($IP[1], $IP[2]) ;VERBINDUNG ZUM SERV WIRD AUFGEBAUT
	If @error Then MsgBox(0, "", "Error" & @error & @CRLF & "Maybe the server is offline!")
	UDPSend($socket, $A2S_RCON_GETCHALLENGE) ;CHALLENGE NR WIRD ANGEFORDERT

	While True
		$udprecv = UDPRecv($socket, 8096) ;ERHALTEN DER CHALLENGE NR
;~ 		If @error Then MsgBox(0, "", "Error" & @error & @CRLF & "Maybe the server is offline!")
		If $udprecv <> "" Then
			$udprecv = BinaryToString($udprecv)
			$udprecv = StringTrimLeft($udprecv, 19)
			$challenge = StringTrimRight($udprecv, 2) ;ZURECHTSCHNEIDEN DER CHALLENGE NR :p
			ExitLoop
		EndIf
	WEnd
	;SENDEN VON BEFEHL DIE ICH BENÖTIGE UM DIE TEXTE ZU ERHALTEN
	$A2S_RCON_SERVER = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" log on')
	UDPSend($socket, $A2S_RCON_SERVER)
	If @error Then MsgBox(0, "", @error)
	Sleep(1000)
	$A2S_RCON_SERVER = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" logaddress_add ' & $INETIP & ' ' & $PORT)
	UDPSend($socket, $A2S_RCON_SERVER)
	If @error Then MsgBox(0, "", @error)
	Sleep(1000)
	$A2S_RCON_SERVER = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" mp_logmessages 1')
	UDPSend($socket, $A2S_RCON_SERVER)
	If @error Then MsgBox(0, "", @error)

	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT) ;BAUT VERBINDUNG ZUM EIGENEN PC AUF, UM DIE NACHRICHTEN DIE HEREINKOMMEN VOM SERVER, ZU ERHALTEN
	_continuebutton()
EndFunc   ;==>_udpverbindung

Func _continuebutton()
	; SETZT WICHTIGE WERTE AUF LEER, DAMIT SIE BEIM ZWEITEN DURCHGANG NICHT NOCH WERTE ENTHALTEN
	For $i = 1 To 10
		$RdyP[$i] = ""
	Next

	$Playerready = "0"
	$13rundenregel = True
	$exitbedingung = "1"
	$timer = "0"
	$timersay = TimerInit()

	While True
		$read = UDPRecv($socket, 1000)
		If $read <> "" Then
			$read = BinaryToString($read)
			_ready() ;DORT WIRD DAS RECV AUSGEWERTET
			$read = ""
		EndIf
		If $Playerready = $Maxplayers Then _gamelive(); WENN GENÜGEND SPIELER FÜR DIE ANZAHL READY SIND, DANN KANNS LOSGEHEN :D GAMELIVE FUER DIE ERSTE HALBZEIT
		If TimerDiff($timersay) > 20000 Then
			_sayrdyifrdy()
			$timersay = TimerInit()
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_continuebutton

Func _defaultmessages()
	$defaultmessage[1] = 'Say ready if ready, say notready if not ready!'
	$defaultmessage[2] = '%Playername% is ready! - %Playerready% of %Maxplayers% Players ready!'
	$defaultmessage[3] = '%Playername% is not ready! - %Playerready% of %Maxplayers% Players ready!'
	$defaultmessage[4] = '%Playerready% of %Maxplayers% Players ready!'
	$defaultmessage[5] = '%Playername% you are already ready!'
	$defaultmessage[6] = 'Warmup settings have been loaded!'
	$defaultmessage[7] = '%xonx% mr%maxrounds% settings loaded!'
	$defaultmessage[8] = 'Script resumed!'
	$defaultmessage[9] = 'Script stopped!'
	$defaultmessage[10] = '%Playername% you are not admin!'
	$defaultmessage[11] = 'gg both teams!'
	$defaultmessage[12] = 'gh both teams!'
	$defaultmessage[13] = 'Match is LIVE - HF & GL'
	$defaultmessage[14] = 'All Players are ready - First half will start after 3 rrs!'
	$defaultmessage[15] = 'All Players are ready - Second half will start after 3 rrs!'
	$defaultmessage[16] = 'Time: %hour%:%min%:%sec%  %day%.%mon%.%year%'
	$defaultmessage[17] = 'Restarting match - First half will start after 3 restarts!'
	$defaultmessage[18] = 'Restarting match - Second half will start after 3 restarts!'
	$defaultmessage[19] = 'Score: CT %Score1% - %Score2% T'
	$defaultmessage[20] = 'Halftime: CT %Score1% - %Score2% T - Please switch teams!'
	$defaultmessage[21] = 'Score: T %NewScore1% - %NewScore2% CT  (Halftime: CT %OldScore1% - %OldScore2% T)'
	$defaultmessage[22] = 'Overall score: %Overall1% - %Overall2%'
	$defaultmessage[23] = 'All Players are ready - Overtime will start after 3 rrs!'
	$defaultmessage[24] = 'Draw: %Overall1% - %Overall2% - Overtime started!'
	$defaultmessage[25] = 'Overtime overall score: %Overall1% - %Overall2%'
EndFunc   ;==>_defaultmessages


Func _namechange() ; ÄNDERT DIE VARIALEN $RdyP[1] BIS $RdyP[1]0 IN DEN NEUEN NAMEN, WENN DER SPIELER SEINEN NAMEN GEAENDERT HAT

	; 	L 03/08/2008 - 18:07:26: "TEST<1><STEAM_0:0:5817353><CT>" changed name to "ready"
	;DORT WIRD DER ALTE UND NEUE NAME AUSGELESEN
	$read = StringRegExpReplace($read, "(\<\d+\><STEAM)", "ß")
	$OLDNAME = _StringBetween($read, '"', 'ß')
	$NEWNAME = _StringBetween($read, '"', '"')

	;DER ALTE NAME WIRD DURCH DEN NEUEN ERSETZT, DAMIT MAN NICHT 2x READY SCHREIBEN KANN
	For $i = 1 To 10
		If $RdyP[$i] = $OLDNAME[0] Then
			$RdyP[$i] = $NEWNAME[1]
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_namechange

Func _ready()
	;CHATAUSWERTUNG, JE NACHDEM WAS GESCHRIEBEN WURDE
	If StringInStr($read, '>" say "' & $command[1] & '"') Or StringInStr($read, '>" say "' & $command[10] & '"') Then
		_rdy()
	ElseIf StringInStr($read, '>" say "' & $command[3] & '"') Then
		_info()
	ElseIf StringInStr($read, '>" say "' & $command[2] & '"') Or StringInStr($read, '>" say "' & $command[11] & '"') Then
		_notrdy()
	ElseIf StringInStr($read, '>" say "' & $command[5] & '"') Then
		_warmup()
	ElseIf StringInStr($read, '>" say "' & $command[12] & '"') Then
		_rr()
	ElseIf StringInStr($read, '>" say "' & $command[13] & '"') Then
		_rdyforce()
	ElseIf StringInStr($read, '>" say "' & $command[9]) Then
		_setupcheck()
	ElseIf StringInStr($read, "changed name to") Then
		_namechange()
	ElseIf StringInStr($read, '>" say "' & $command[4] & '"') Then
		_time()
	ElseIf StringInStr($read, '>" say "' & $command[8] & '"') Then
		_stopscript()
	ElseIf StringInStr($read, '>" say "' & "map ") Then
		_changemap()
	ElseIf StringInStr($read, 'T>" disconnected') Then ; sag<1><STEAM_0:0:5817353><CT>" disconnected'
		_disconnected()
	ElseIf StringInStr($read, '>" say "irc ') And $IRCEnable = "yes" Then
		_IRCRun()
	ElseIf StringInStr($read, '>" say "scriptinfo"') Then ; ich :D
		_scriptinfo()
	EndIf
EndFunc   ;==>_ready

Func _changemap()
	_checkadmin()
	For $i = 1 To _FileCountLines(@ScriptDir & "\admins.txt")
		If $Admin[0] = FileReadLine(@ScriptDir & "\admins.txt", $i) Then
			UDPCloseSocket($socket)
			$socket = UDPOpen($IP[1], $IP[2])
			$mapnamesplit = StringSplit($read, "map ", 1)
			$Mapname = StringTrimRight($mapnamesplit[$mapnamesplit[0]], 2)
			$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" changelevel ' & $Mapname)
			UDPSend($socket, $A2S_RCON_SETTINGS)
			Sleep(100)
			UDPCloseSocket($socket)
			$socket = UDPBind($LANIP, $PORT)
		EndIf
	Next
EndFunc   ;==>_changemap

Func _disconnected()
	_playerauslesung() ;AUSLESUNG, WELCHER PLAYER DISCONNECTET IST
	For $i = 1 To 10 ;STELLT FEST OB DER DISCONNECTET PLAYER READY WAR, WENN JA DANN WIRD ER GELÖSCHT UND ES ENSTEHT EINE NOTREADY NACHRICHT
		If $Playername = $RdyP[$i] Then
			$RdyP[$i] = ""
			_playercheck()
			_sayservermessage(3)
			$socket = UDPBind($LANIP, $PORT)
		EndIf
	Next
EndFunc   ;==>_disconnected

Func _stopscript()
	_checkadmin()
	For $i = 1 To _FileCountLines(@ScriptDir & "\admins.txt")
		If $Admin[0] = FileReadLine(@ScriptDir & "\admins.txt", $i) Then
			UDPCloseSocket($socket)
			$socket = UDPOpen($IP[1], $IP[2])
			$scriptmessage[9] = $scriptmessagestandard[9]
			$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[9])
			UDPSend($socket, $A2S_RCON_SETTINGS)
			Sleep(100)
			UDPCloseSocket($socket)
			$socket = UDPBind($LANIP, $PORT)
			While True
				$read = UDPRecv($socket, 1000)
				If $read <> "" Then
					$read = BinaryToString($read)
					If StringInStr($read, '>" say "' & $command[7] & '"') Then
						_checkadmin()
						For $i = 1 To _FileCountLines(@ScriptDir & "\admins.txt")
							If $Admin[0] = FileReadLine(@ScriptDir & "\admins.txt", $i) Then
								UDPCloseSocket($socket)
								$socket = UDPOpen($IP[1], $IP[2])
								$scriptmessage[8] = $scriptmessagestandard[8]
								$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[8])
								UDPSend($socket, $A2S_RCON_SETTINGS)
								Sleep(100)
								UDPCloseSocket($socket)
								$socket = UDPBind($LANIP, $PORT)
								Return
							EndIf
						Next
					EndIf
				EndIf
				Sleep(50)
			WEnd
		EndIf
	Next
EndFunc   ;==>_stopscript

Func _rdy()
	$read = StringRegExpReplace($read, "(\<\d+\><STEAM)", "ß")
	$Player = _StringBetween($read, '"', 'ß')
	$Playername = $Player[0]
	_playerauslesung()

	; ÜBERPRÜFUNG ob der SPIELER der ready geschrieben hat, schonmal ready geschrieben hat. AUSLESEUNG DER RdyP[1] - 10 ob der NAME bereits gespeichert wurde.
	For $i = 1 To 10
		If $Playername = $RdyP[$i] Then
			_alreadyrdy()
			Return
		EndIf
	Next

	; SCHAUT WELCHER von RdyP[1] - RdyP[10] noch nicht einen SPIELERNAMEN enthält. TRÄGT ihn anschließend bei einem freien ein.
	For $i = 1 To 10
		If $RdyP[$i] = "" Then
			$RdyP[$i] = $Playername
			ExitLoop
		EndIf
	Next
	_playercheck()
	_sayservermessage(2)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_rdy

Func _checkadmin()
	$read = StringRegExpReplace($read, "(\<\d+\><STEAM_)", "ß")
	$Admin = _StringBetween($read, 'ß', '><')
EndFunc   ;==>_checkadmin

Func _time()
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	If @error Then MsgBox(0, "", @error)
	$scriptmessage[16] = $scriptmessagestandard[16]
	$scriptmessage[16] = StringReplace($scriptmessage[16], "%hour%", @HOUR)
	$scriptmessage[16] = StringReplace($scriptmessage[16], "%min%", @MIN)
	$scriptmessage[16] = StringReplace($scriptmessage[16], "%sec%", @SEC)
	$scriptmessage[16] = StringReplace($scriptmessage[16], "%day%", @MDAY)
	$scriptmessage[16] = StringReplace($scriptmessage[16], "%mon%", @MON)
	$scriptmessage[16] = StringReplace($scriptmessage[16], "%year%", @YEAR)
	$A2S_RCON_INFO = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[16])
	UDPSend($socket, $A2S_RCON_INFO)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_time

Func _warmup()
	_checkadmin()
	For $i = 1 To _FileCountLines(@ScriptDir & "\admins.txt")
		If $Admin[0] = FileReadLine(@ScriptDir & "\admins.txt", $i) Then
			_warmupsettings()
			Return
		EndIf
	Next
EndFunc   ;==>_warmup

Func _rr()
	_checkadmin()
	For $i = 1 To _FileCountLines(@ScriptDir & "\admins.txt")
		If $Admin[0] = FileReadLine(@ScriptDir & "\admins.txt", $i) Then
			UDPCloseSocket($socket)
			$socket = UDPOpen($IP[1], $IP[2])
			If @error Then MsgBox(0, "", @error)
			$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
			UDPSend($socket, $A2S_RCON_SETTINGS)
			UDPCloseSocket($socket)
			$socket = UDPBind($LANIP, $PORT)
			Return
		EndIf
	Next
EndFunc   ;==>_rr

Func _rdyforce()
	_checkadmin()
	For $i = 1 To _FileCountLines(@ScriptDir & "\admins.txt")
		If $Admin[0] = FileReadLine(@ScriptDir & "\admins.txt", $i) Then
			$Playerready = $Maxplayers
			Return
		EndIf
	Next
EndFunc   ;==>_rdyforce

Func _setupcheck()
	For $i = 1 To 5
		If StringInStr($read, '>" say "' & $command[9] & ' ' & $i & 'on' & $i & ' mr12"') Then
			$testAnzahl = $i + $i
			$testMaxrounds = "12"
			_setupxonxmr()
		EndIf
	Next
	For $i = 1 To 5
		If StringInStr($read, '>" say "' & $command[9] & ' ' & $i & 'on' & $i & ' mr15"') Then
			$testAnzahl = $i + $i
			$testMaxrounds = "15"
			_setupxonxmr()
		EndIf
	Next
EndFunc   ;==>_setupcheck

Func _setupxonxmr() ; setup 2on2 mr12
	_checkadmin()
	For $i = 1 To _FileCountLines(@ScriptDir & "\admins.txt")
		If $Admin[0] = FileReadLine(@ScriptDir & "\admins.txt", $i) Then
			_loadedsettings()
			Return
		EndIf
	Next
	_playerauslesung()
	_sayservermessage(10)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_setupxonxmr

Func _loadedsettings()
	$Maxplayers = $testAnzahl
	$maxrounds = $testMaxrounds
	$Spielart = $Maxplayers / 2
	$cfgfile = $Spielart & "on" & $Spielart & ".cfg"
	$xonx = $Spielart & "on" & $Spielart
;~ 	MsgBox(0, "", $xonx)
	_sayservermessage(7)
	$socket = UDPBind($LANIP, $PORT)
	_continuebutton()
EndFunc   ;==>_loadedsettings

Func _warmupsettings()
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	If @error Then MsgBox(0, "", @error)
	$WarmupSection = IniReadSection("config.ini", "Warmup")
	For $i = 1 To $WarmupSection[0][0]
		$RCON_WARMUP = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" ' & $WarmupSection[$i][1])
		UDPSend($socket, $RCON_WARMUP)
		Sleep(100)
	Next
	$scriptmessage[6] = $scriptmessagestandard[6]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[6])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(100)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_warmupsettings


Func _info()
	_playerauslesung()
	_playercheck()
	_sayservermessage(4)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_info

Func _scriptinfo()
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	If @error Then MsgBox(0, "", @error)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say The readyscript 2.0 was made by aquila! Quakenet - #readyscript')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_scriptinfo

Func _alreadyrdy()
	_sayservermessage(5)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_alreadyrdy

Func _playerauslesung()
	$read = StringRegExpReplace($read, "(\<\d+\><STEAM)", "ß")
	$Player = _StringBetween($read, '"', 'ß')
	$Playername = $Player[0]
EndFunc   ;==>_playerauslesung

Func _notrdy()
	_playerauslesung()
	; PRÜFT, welche VARIABLE von RdyP[1] - RdyP[10] bereits einen NAMEN hat der mit dem NAMEN übereinstimmt von DEM SPIELER der NOTREADY geschrieben hat.
	; WENN JA wird die VARIABLE ZURÜCKGESETZT und es dem SERVER mitgeteilt. WENN NEIN kehrt es zur SCHLEIFE zurück.
	For $i = 1 To 10
		If $RdyP[$i] = $Playername Then
			$RdyP[$i] = ""
			ExitLoop
		EndIf
		If $i = 10 Then Return
	Next
	_playercheck()
	_sayservermessage(3)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_notrdy


Func _playercheck()
	; PRÜFT, welche VARIABLE von RdyP[1] - RdyP[10] bereits einen NAMEN hat. WENN JA wird es zusammenaddiert. ANSCHLIEßEND IST $Playerready = ANZAHL DER LEUTE DIE RDY SIND
	$Playerready = "0"
	For $i = 1 To 10
		If $RdyP[$i] <> "" Then $Playerready += 1
	Next
EndFunc   ;==>_playercheck

Func _sayrdyifrdy() ; SAY READY IF READY MELDUNG, ALLE 20 SEKUNDEN, ABER NUR WENN NICHT ALLE SPIELER READY SIND
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	$scriptmessage[1] = $scriptmessagestandard[1]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[1])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_sayrdyifrdy


Func _gamelive() ; GAMESTART FUER ERSTE HÄLFTE, WIRD AUSGEFÜHRT WENN $PLAYERREADY = $Maxplayers IST.
	$IRC = False
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	Sleep(100)
	$scriptmessage[14] = $scriptmessagestandard[14]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[14])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(100)
	Call("_settingssend")
	Sleep(100)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(2000)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(2000)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 3')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(5000)
	$scriptmessage[13] = $scriptmessagestandard[13]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[13])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(300)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
	_gamelive1()
EndFunc   ;==>_gamelive

Func _gamelive1()
	$readold = ""

	While True
		$read = UDPRecv($socket, 1000)
		If $read <> "" And $read <> $readold Then
			$read = BinaryToString($read)
;~ 			ConsoleWrite($read)
			_roundcheck()
			$read = ""
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_gamelive1

Func _restartmatch()
	_checkadmin()
	For $i = 1 To _FileCountLines(@ScriptDir & "\admins.txt")
		If $Admin[0] = FileReadLine(@ScriptDir & "\admins.txt", $i) Then
			UDPCloseSocket($socket)
			$socket = UDPOpen($IP[1], $IP[2])
			Sleep(100)
			$livemsg = 17
			If $restart = 2 Then $livemsg = 18
			$scriptmessage[$livemsg] = $scriptmessagestandard[$livemsg]
			$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[$livemsg])
			UDPSend($socket, $A2S_RCON_SETTINGS)
			Sleep(100)
			Call("_settingssend")
			Sleep(100)
			$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
			UDPSend($socket, $A2S_RCON_SETTINGS)
			Sleep(2000)
			$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
			UDPSend($socket, $A2S_RCON_SETTINGS)
			Sleep(2000)
			$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 3')
			UDPSend($socket, $A2S_RCON_SETTINGS)
			Sleep(5000)
			$scriptmessage[13] = $scriptmessagestandard[13]
			$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[13])
			UDPSend($socket, $A2S_RCON_SETTINGS)
			Sleep(300)
			UDPCloseSocket($socket)
			$socket = UDPBind($LANIP, $PORT)
			If $restart = 1 Then _gamelive1()
			If $restart = 2 Then _gamelive2a()
		EndIf
	Next
EndFunc   ;==>_restartmatch

Func _roundcheck()
	If StringInStr($read, ' (CT "') And StringInStr($read, ') (T "') Then
		_auswertung()
	ElseIf StringInStr($read, '>" say "' & $command[9]) Then
		_setupcheck()
	ElseIf StringInStr($read, '>" say "' & $command[4] & '"') Then
		_time()
	ElseIf StringInStr($read, '>" say "' & $command[8] & '"') Then
		_stopscript()
	ElseIf StringInStr($read, '>" say "' & $command[6] & '"') Then
		$restart = 1
		_restartmatch()
	EndIf
EndFunc   ;==>_roundcheck


Func _auswertung()
	$splitErgebnis = StringRight($read, 17)
	$checkErgebnis = UBound(StringRegExp($splitErgebnis, "(\d+)", 3))
	If $checkErgebnis <> "2" Then Return
	$StringSplit = StringSplit($splitErgebnis, ") ", 1)
	$Ergebnis = _StringBetween($StringSplit[1], '"', '"')
	$Ergebnis2 = _StringBetween($StringSplit[2], '"', '"')
	$Score1 = $Ergebnis[0]
	$Score2 = $Ergebnis2[0]
	If $Score1 + $Score2 = $maxrounds Then ; DER BENOETIGTE INHALT DER PASSENDEN ZEILE WIRD HIER GESCHRIEBEN.
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$scriptmessage[12] = $scriptmessagestandard[12]
		$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[12])
		UDPSend($socket, $A2S_RCON_SETTINGS)
		Sleep(100)
		_sayservermessage(20)
		$OldScore1 = $Ergebnis[0]
		$Oldscore2 = $Ergebnis2[0]
		$readold = $read
		Sleep(2000)
		_warmupsettings()
		_readyschleife() ; MAXROUNDS WURDEN ABGESPIELT, KEHRT ZURUECK IN DEN SAY RDY STATUS.
	Else
		_sayservermessage(19)
		$socket = UDPBind($LANIP, $PORT)
		$readold = $read
	EndIf
EndFunc   ;==>_auswertung


Func _readyschleife() ; READYSCHLEIFE FUER DIE ZWEITE HALBZEIT
	For $i = 1 To 10
		$RdyP[$i] = ""
	Next

	$timer = ""
	$Playerready = "0"
	$readErgebnis = ""
	$splitErgebnis = ""
	$checkErgebnis = ""
	$Ergebnis = ""
	$Ergebnis2 = ""
	$timersay = TimerInit()

	While True
		$read = UDPRecv($socket, 1000)
		If $read <> "" Then
			$read = BinaryToString($read)
			_ready()
			$read = ""
		EndIf
		If $Playerready = $Maxplayers Then _gamelive2(); WENN GENÜGEND SPIELER FÜR DIE ANZAHL READY SIND, DANN KANNS LOSGEHEN :D GAMELIVE FUER DIE ERSTE HALBZEIT
		If TimerDiff($timersay) > 20000 Then
			_sayrdyifrdy()
			$timersay = TimerInit()
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_readyschleife



Func _gamelive2() ; GAMELIVE FUER ZWEITE HALBZEIT
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	Sleep(100)
	$scriptmessage[15] = $scriptmessagestandard[15]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[15])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(100)
	Call("_settingssend")
	Sleep(100)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(2000)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(2000)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 3')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(5000)
	$scriptmessage[13] = $scriptmessagestandard[13]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[13])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(300)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
	_gamelive2a()
EndFunc   ;==>_gamelive2

Func _gamelive2a()
	$readold = ""

	While True
		$read = UDPRecv($socket, 1000)
		If $read <> "" And $read <> $readold Then
			$read = BinaryToString($read)
			_roundcheck2()
			$read = ""
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_gamelive2a


Func _roundcheck2()
	If StringInStr($read, "Round_End") Or StringInStr($read, "Round_Start") Or StringInStr($read, "Round_Draw") Then
		Return
	ElseIf StringInStr($read, ' (CT "') And StringInStr($read, ') (T "') Then
		_auswertung2()
	ElseIf StringInStr($read, '>" say "' & $command[9]) Then
		_setupcheck()
	ElseIf StringInStr($read, '>" say "' & $command[4] & '"') Then
		_time()
	ElseIf StringInStr($read, '>" say "' & $command[8] & '"') Then
		_stopscript()
	ElseIf StringInStr($read, '>" say "' & $command[6] & '"') Then
		$restart = 2
		_restartmatch()
	EndIf
EndFunc   ;==>_roundcheck2

Func _auswertung2() ; AUSWERTUNG der RUNDEN VON DER ZWEITEN HALBZEIT

	; UEBERPRUEFT, WELCHE LINE DIE RICHTIGE IST

	$splitErgebnis = StringRight($read, 17)
	$checkErgebnis = UBound(StringRegExp($splitErgebnis, "(\d+)", 3))
	If $checkErgebnis <> "2" Then Return
	$StringSplit = StringSplit($splitErgebnis, ") ", 1)
	$Ergebnis = _StringBetween($StringSplit[1], '"', '"')
	$Ergebnis2 = _StringBetween($StringSplit[2], '"', '"')

	If $Ergebnis[0] + $Ergebnis2[0] = $maxrounds And $Ergebnis[0] + $Oldscore2 = $Ergebnis2[0] + $OldScore1 And $Overtime = True Then
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$Overall2 = $Ergebnis[0] + $Oldscore2
		$Overall1 = $Ergebnis2[0] + $OldScore1
		_sayservermessage(24)
		$readold = $read
		Sleep(2000)
		_warmupsettings()
		_Overtime()
	ElseIf $Ergebnis[0] + $Ergebnis2[0] = $maxrounds Then ; WENN BEIDE ERGEBNISSE 12/15 SIND DANN GG + OVERALL ERGEBNIS
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$scriptmessage[11] = $scriptmessagestandard[11]
		$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[11])
		UDPSend($socket, $A2S_RCON_SETTINGS)
		Sleep(100)
		$Overall2 = $Ergebnis[0] + $Oldscore2
		$Overall1 = $Ergebnis2[0] + $OldScore1
		_sayservermessage(22)
		$socket = UDPBind($LANIP, $PORT)
		$readold = $read
		_continuebutton()
	ElseIf $Ergebnis[0] + $Score2 = $maxrounds + 1 Or $Ergebnis2[0] + $Score1 = $maxrounds + 1 And $13rundenregel = True And $13rundenregelallow = True Then
		$13rundenregel = False
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$scriptmessage[11] = $scriptmessagestandard[11]
		$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[11])
		UDPSend($socket, $A2S_RCON_SETTINGS)
		Sleep(100)
		$NewScore1 = $Ergebnis2[0]
		$NewScore2 = $Ergebnis[0]
		_sayservermessage(21)
		$socket = UDPBind($LANIP, $PORT)
		$readold = $read
	Else ; WENN BEIDE ZAHLEN NICHT 12/15 SIND, DANN SCORE ANZEIGEN BEI RUNDENENDE
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$NewScore1 = $Ergebnis2[0]
		$NewScore2 = $Ergebnis[0]
		_sayservermessage(21)
		$socket = UDPBind($LANIP, $PORT)
		$readold = $read
	EndIf
EndFunc   ;==>_auswertung2

Func _Overtime()
	For $i = 1 To 10
		$RdyP[$i] = ""
	Next
	$timer = ""
	$Playerready = "0"
	$readErgebnis = ""
	$splitErgebnis = ""
	$checkErgebnis = ""
	$Ergebnis = ""
	$Ergebnis2 = ""
	$timersay = TimerInit()

	While True
		$read = UDPRecv($socket, 1000)
		If $read <> "" Then
			$read = BinaryToString($read)
			_ready()
			$read = ""
		EndIf
		If $Playerready = $Maxplayers Then _gameliveot1(); WENN GENÜGEND SPIELER FÜR DIE ANZAHL READY SIND, DANN KANNS LOSGEHEN :D GAMELIVE FUER DIE ERSTE HALBZEIT
		If TimerDiff($timersay) > 20000 Then
			_sayrdyifrdy()
			$timersay = TimerInit()
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_Overtime

Func _gameliveot1() ; GAMELIVE FUER ZWEITE HALBZEIT
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	Sleep(100)
	$scriptmessage[23] = $scriptmessagestandard[23]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[23])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(100)
	Call("_settingssend")
	Sleep(100)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" mp_startmoney ' & $ot_startmoney)
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(100)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(2000)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(2000)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 3')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(5000)
	$scriptmessage[13] = $scriptmessagestandard[13]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[13])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(300)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
	_gameliveot1a()
EndFunc   ;==>_gameliveot1

Func _gameliveot1a()
	$readold = ""
	While True
		$read = UDPRecv($socket, 1000)
		If $read <> "" And $read <> $readold Then
			$read = BinaryToString($read)
			_roundcheckot1()
			$read = ""
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_gameliveot1a

Func _roundcheckot1()
	If StringInStr($read, "Round_End") Or StringInStr($read, "Round_Start") Or StringInStr($read, "Round_Draw") Then
		Return
	ElseIf StringInStr($read, ' (CT "') And StringInStr($read, ') (T "') Then
		_auswertungot1()
	ElseIf StringInStr($read, '>" say "' & $command[9]) Then
		_setupcheck()
	ElseIf StringInStr($read, '>" say "' & $command[4] & '"') Then
		_time()
	ElseIf StringInStr($read, '>" say "' & $command[8] & '"') Then
		_stopscript()
	EndIf
EndFunc   ;==>_roundcheckot1

Func _auswertungot1()
	$splitErgebnis = StringRight($read, 17)
	$checkErgebnis = UBound(StringRegExp($splitErgebnis, "(\d+)", 3))
	If $checkErgebnis <> "2" Then Return
	$StringSplit = StringSplit($splitErgebnis, ") ", 1)
	$Ergebnis = _StringBetween($StringSplit[1], '"', '"')
	$Ergebnis2 = _StringBetween($StringSplit[2], '"', '"')
	$Score1 = $Ergebnis[0];CT
	$Score2 = $Ergebnis2[0]; T

	If $Score1 + $Score2 = $ot_maxrounds Then ; DER BENOETIGTE INHALT DER PASSENDEN ZEILE WIRD HIER GESCHRIEBEN.
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$scriptmessage[12] = $scriptmessagestandard[12]
		$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[12])
		UDPSend($socket, $A2S_RCON_SETTINGS)
		Sleep(100)
		_sayservermessage(20)
		$OldScore1 = $Ergebnis[0];CT
		$Oldscore2 = $Ergebnis2[0];T
		$readold = $read
		Sleep(2000)
		_warmupsettings()
		_Overtime2() ; MAXROUNDS WURDEN ABGESPIELT, KEHRT ZURUECK IN DEN SAY RDY STATUS.
	Else
		_sayservermessage(19)
		$socket = UDPBind($LANIP, $PORT)
		$readold = $read
	EndIf
EndFunc   ;==>_auswertungot1

Func _Overtime2()
	For $i = 1 To 10
		$RdyP[$i] = ""
	Next
	$timer = ""
	$Playerready = "0"
	$readErgebnis = ""
	$splitErgebnis = ""
	$checkErgebnis = ""
	$Ergebnis = ""
	$Ergebnis2 = ""
	$timersay = TimerInit()
	While True
		$read = UDPRecv($socket, 1000)
		If $read <> "" Then
			$read = BinaryToString($read)
			_ready()
			$read = ""
		EndIf
		If $Playerready = $Maxplayers Then _gameliveot2(); WENN GENÜGEND SPIELER FÜR DIE ANZAHL READY SIND, DANN KANNS LOSGEHEN :D GAMELIVE FUER DIE ERSTE HALBZEIT
		If TimerDiff($timersay) > 20000 Then
			_sayrdyifrdy()
			$timersay = TimerInit()
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_Overtime2

Func _gameliveot2() ; GAMELIVE FUER ZWEITE HALBZEIT
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	Sleep(100)
	$scriptmessage[23] = $scriptmessagestandard[23]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[23])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(100)
	Call("_settingssend")
	Sleep(100)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" mp_startmoney ' & $ot_startmoney)
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(100)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(2000)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 1')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(2000)
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_restart 3')
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(5000)
	$scriptmessage[13] = $scriptmessagestandard[13]
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[13])
	UDPSend($socket, $A2S_RCON_SETTINGS)
	Sleep(300)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
	_gameliveot2a()
EndFunc   ;==>_gameliveot2

Func _gameliveot2a()
	$readold = ""
	While True
		$read = UDPRecv($socket, 1000)
		If $read <> "" And $read <> $readold Then
			$read = BinaryToString($read)
			_roundcheckot2()
			$read = ""
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_gameliveot2a

Func _roundcheckot2()
	If StringInStr($read, "Round_End") Or StringInStr($read, "Round_Start") Or StringInStr($read, "Round_Draw") Then
		Return
	ElseIf StringInStr($read, ' (CT "') And StringInStr($read, ') (T "') Then
		_auswertungot2()
	ElseIf StringInStr($read, '>" say "' & $command[9]) Then
		_setupcheck()
	ElseIf StringInStr($read, '>" say "' & $command[4] & '"') Then
		_time()
	ElseIf StringInStr($read, '>" say "' & $command[8] & '"') Then
		_stopscript()
	EndIf
EndFunc   ;==>_roundcheckot2

Func _auswertungot2()
	$splitErgebnis = StringRight($read, 17)
	$checkErgebnis = UBound(StringRegExp($splitErgebnis, "(\d+)", 3))
	If $checkErgebnis <> "2" Then Return
	$StringSplit = StringSplit($splitErgebnis, ") ", 1)
	$Ergebnis = _StringBetween($StringSplit[1], '"', '"')
	$Ergebnis2 = _StringBetween($StringSplit[2], '"', '"')
	$NewScore2 = $Ergebnis[0];T
	$NewScore1 = $Ergebnis2[0];CT

	If $NewScore1 + $OldScore1 = $NewScore2 + $Oldscore2 And $NewScore1 + $NewScore2 = $ot_maxrounds Then ; DER BENOETIGTE INHALT DER PASSENDEN ZEILE WIRD HIER GESCHRIEBEN.
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$Overall2 = $NewScore1 + $OldScore1
		$Overall1 = $NewScore2 + $Oldscore2
		_sayservermessage(24)
		$readold = $read
		Sleep(2000)
		_warmupsettings()
		_Overtime() ; MAXROUNDS WURDEN ABGESPIELT, KEHRT ZURUECK IN DEN SAY RDY STATUS.
	ElseIf $NewScore1 + $NewScore2 = $ot_maxrounds Or $NewScore1 + $OldScore1 > $ot_maxrounds Or $NewScore2 + $Oldscore2 > $ot_maxrounds Then ; DER BENOETIGTE INHALT DER PASSENDEN ZEILE WIRD HIER GESCHRIEBEN.
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$scriptmessage[11] = $scriptmessagestandard[11]
		$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $scriptmessage[11])
		UDPSend($socket, $A2S_RCON_SETTINGS)
		Sleep(100)
		$Overall2 = $NewScore1 + $OldScore1
		$Overall1 = $NewScore2 + $Oldscore2
		_sayservermessage(25)
		$readold = $read
		Sleep(2000)
		_warmupsettings()
		_continuebutton() ; MAXROUNDS WURDEN ABGESPIELT, KEHRT ZURUECK IN DEN SAY RDY STATUS.
	Else
		_sayservermessage(21)
		$socket = UDPBind($LANIP, $PORT)
		$readold = $read
	EndIf
EndFunc   ;==>_auswertungot2
Func _sayservermessage($Messagenumber)
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	$scriptmessage[$Messagenumber] = $scriptmessagestandard[$Messagenumber]
	$btwn = _StringBetween($scriptmessage[$Messagenumber], "%", "%")
	For $j = 0 To UBound($btwn) - 1
		$scriptmessage[$Messagenumber] = StringReplace($scriptmessage[$Messagenumber], "%" & $btwn[$j] & "%", Eval($btwn[$j]))
	Next
	$RCON_SAY = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '"  say ' & $scriptmessage[$Messagenumber])
	UDPSend($socket, $RCON_SAY)
	UDPCloseSocket($socket)
EndFunc   ;==>_sayservermessage

Func _getserverpassword()
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	$RCON_SAY = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" sv_password')
	UDPSend($socket, $RCON_SAY)
	Global $read = '', $readold = ''
	While True
		$read = UDPRecv($socket, 2000)
		$read = BinaryToString($read)
		If $read <> "" And $read <> $readold Then
			If StringInStr($read, '"sv_password" is') Then
				$read = StringReplace($read, '"sv_password" is', 'ß')
				$read = _StringBetween($read, '"', '"')
				$serverpw = $read[0]
				ExitLoop
			EndIf
			$readold = $read
		EndIf
		Sleep(50)
	WEnd
EndFunc   ;==>_getserverpassword

Func _IRCRun()
	Global $Channel = ''
	$IRCmsgtimer = TimerInit()
	For $i = 1 To 5
		If StringInStr($read, $i & "on" & $i) Then
			$Channel = IniRead(@ScriptDir & "\config.ini", "IRC", $i & "on" & $i, "")
			If $Channel = "" Then $Channel = "#" & $i & "on" & $i
		EndIf
	Next
	If $Channel = '' Then
		_Serversayircmessages("IRC: No Channel found! Please try again!")
		_continuebutton()
	EndIf
	$read = StringReplace($read, '>" say "irc ', 'ß')
	$str = _StringBetween($read, "ß", '"')
	$ircsuchtext = $str[0]
	Global $server = IniRead(@ScriptDir & "\config.ini", "IRC", "server", "")
	If $server = '' Then $server = "irc.quakenet.org"
	Global $nick = 'rdy|' & IniRead(@ScriptDir & "\config.ini", "IRC", "nick", "")
	Global $IrcPort = IniRead(@ScriptDir & "\config.ini", "IRC", "port", "")
	If $IrcPort = '' Then $IrcPort = 6667
	Global $USER, $USER_alt, $text, $txt
	Global $joined = False
	Global $QUERYNAME = '', $QUERYNAMEOLD = ''
	Global $readold = ''
	If $nick = 'rdy|' Then
		For $i = 1 To 10
			$nick &= Chr(Random(97, 122, 1))
		Next
	EndIf
	TCPStartup()
	Global $sock = _IRCConnect($server, $IrcPort, $nick); Verbindung zu IRC und Identifizierung Nickname
	While 1
		$msg = GUIGetMsg()
		If $msg = -3 Then
			_IRCError()
		EndIf
		$recv = TCPRecv($sock, 8192); Empfängt vom Server
		If @error Then
			_IRCError()
		EndIf
		Local $sData = StringSplit($recv, @CRLF); Splittet die Nachrichten, wenn sie vom Server gruppiert werde
		For $i = 1 To $sData[0]
			If StringInStr($sData[$i], "PRIVMSG " & $nick) And Not StringInStr($sData[$i], "<CTCP>") Then
				$Split1 = StringSplit($sData[$i], "!", 1)
				$Split2 = StringSplit($sData[$i], $nick & " :", 1)
				If $QUERYNAME = '' Then
					$QUERYNAME = StringTrimLeft($Split1[1], 1)
					_Serversayircmessages("IRC: Enemy found!")
				EndIf
				If $QUERYNAME = StringTrimLeft($Split1[1], 1) Then
					$query = "<" & StringTrimLeft($Split1[1], 1) & "> " & $Split2[UBound($Split2) - 1]
					$query = StringReplace($query, "ä", "ae")
					$query = StringReplace($query, "ö", "oe")
					$query = StringReplace($query, "ü", "ue")
					_Serversayircmessages("IRC: " & $query)
				EndIf
			EndIf
		Next
		For $i = 1 To $sData[0] Step 1; behandelt jede Nachricht einzeln
			If StringInStr($sData[$i], "Welcome") And $joined = False Then
				_IRCJoinChannel($sock, $Channel)
				If StringInStr($server, "quakenet") Then _IRCJoinChannel($sock, "#readyscript")
				_Serversayircmessages("IRC joined Channel " & $Channel & "!")
				_IRCSendMessage($sock, $ircsuchtext, $Channel)
				_Serversayircmessages("IRC message: " & $ircsuchtext & "!")
				$joined = True
			EndIf
			Local $sTemp = StringSplit($sData[$i], " "); Splittet die Nachricht an den Leerzeichen
			If $sTemp[1] = "" Then ContinueLoop; Weiter, wenn leer
			If $sTemp[1] = "PING" Then _IRCPing($sock, $sTemp[2]); Prüft ob PING zurückgegeben wird
			If $sTemp[0] <= 2 Then ContinueLoop; meist nutzlose Informationen
		Next
		If $joined = True Then
			$read = UDPRecv($socket, 1000)
			If $read <> "" And $read <> $readold Then
				$read = BinaryToString($read)
				If StringInStr($read, '>" say "irc close"') Or StringInStr($read, '>" say "irc quit"') Then
					_IRCQuit($sock, "bye <3")
					_Serversayircmessages("IRC closed!")
					_continuebutton()
				EndIf
				If StringInStr($read, '>" say "irc next"') Then
					$QUERYNAME = ''
				EndIf
				If $QUERYNAME <> '' Then
					If StringInStr($read, '>" say "irc ip pw"') Then
						_getserverpassword()
						_Serversayircmessages("IRC message: ip " & $IP[1] & ":" & $IP[2] & " " & "pw: " & $serverpw)
						_IRCSendMessage($sock, "ip: " & $IP[1] & ":" & $IP[2] & " " & "pw: " & $serverpw, $QUERYNAME)
					EndIf
					If StringInStr($read, '>" say "irc ') Then
						$read = StringReplace($read, '>" say "irc ', 'ß')
						$str = _StringBetween($read, "ß", '"')
						$ircqrytext = $str[0]
						_IRCSendMessage($sock, $ircqrytext, $QUERYNAME)
						_Serversayircmessages("IRC message: " & $ircqrytext)
					EndIf
				EndIf
				$readold = StringToBinary($read)
			EndIf
		EndIf
		Sleep(50)
		If TimerDiff($IRCmsgtimer) > IniRead(@ScriptDir & "\config.ini", "IRC", "delay", "") * 1000 And $QUERYNAME = '' Then
			_IRCSendMessage($sock, $ircsuchtext, $Channel)
			_Serversayircmessages("IRC message: " & $ircsuchtext & "!")
			$IRCmsgtimer = TimerInit()
		EndIf
	WEnd
EndFunc   ;==>_IRCRun

Func _Serversayircmessages($NACHRICHT)
	UDPCloseSocket($socket)
	$socket = UDPOpen($IP[1], $IP[2])
	$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" say ' & $NACHRICHT)
	UDPSend($socket, $A2S_RCON_SETTINGS)
	UDPCloseSocket($socket)
	$socket = UDPBind($LANIP, $PORT)
EndFunc   ;==>_Serversayircmessages

Func _IRCError()

EndFunc   ;==>_IRCError

Func _IRCConnect($server, $PORT, $nick)
	Local $i = TCPConnect(TCPNameToIP($server), $PORT)
	If $i = -1 Then
		_IRCError()
	EndIf
	TCPSend($i, "NICK " & $nick & @CRLF)
	$ping = TCPRecv($i, 2048)
	If StringLeft($ping, 4) = "PING" Then
		$pong = StringReplace($ping, "PING :", "")
		TCPSend($i, "PONG " & $pong & @LF)
	EndIf
	TCPSend($i, "USER " & $nick & " 0 0 " & $nick & @CRLF)
	Return $i
EndFunc   ;==>_IRCConnect

Func _IRCQuit($IRC, $msg = "")
	If $IRC = -1 Then Return 0
	TCPSend($IRC, "QUIT :" & $msg & @CRLF)
	Return 1
EndFunc   ;==>_IRCQuit

Func _IRCJoinChannel($IRC, $chan)
	If $IRC = -1 Then Return 0
	TCPSend($IRC, "JOIN " & $chan & @CRLF)
	If @error Then
		_IRCError()
		Return -1
	EndIf
	Return 1
EndFunc   ;==>_IRCJoinChannel

Func _IRCSendMessage($IRC, $msg, $chan = "")
	If $IRC = -1 Then Return 0
	If $chan = "" Then
		TCPSend($IRC, $msg & @CRLF)
		If @error Then
			_IRCError()
			Return -1
		EndIf
		Return 1
	EndIf
	TCPSend($IRC, "PRIVMSG " & $chan & " :" & $msg & @CRLF)
	If @error Then
		_IRCError()
		Return -1
	EndIf
	Return 1
EndFunc   ;==>_IRCSendMessage

Func _IRCChangeMode($IRC, $mode, $chan = "")
	If $IRC = -1 Then Return 0
	If $chan = "" Then
		TCPSend($IRC, "MODE " & $mode & @CRLF)
		If @error Then
			_IRCError()
			Return -1
		EndIf
		Return 1
	EndIf
	TCPSend($IRC, "MODE " & $chan & " " & $mode & @CRLF)
	If @error Then
		_IRCError()
		Return -1
	EndIf
	Return 1
EndFunc   ;==>_IRCChangeMode

Func _IRCPing($IRC, $ret)
	If $IRC = -1 Then Return 0
	If $ret = "" Then Return -1
	TCPSend($IRC, "PONG " & $ret & @CRLF)
	If @error Then
		_IRCError()
		Return -1
	EndIf
	Return 1
EndFunc   ;==>_IRCPing

Func _GetWANIP()
	$WANIP = _INetGetSource("http://whatismyipaddress.com")
	$sWANIP = StringRegExp($WANIP, 'Proxy Reports IP as: (\d*.\d*.\d*.\d*)', 3)
	Return $sWANIP[0]
EndFunc   ;==>_GetWANIP

Func OnAutoItExit()
	If $exitbedingung = "1" Then
		UDPCloseSocket($socket)
		$socket = UDPOpen($IP[1], $IP[2])
		$A2S_RCON_SETTINGS = (_HexToString("FFFFFFFF") & 'rcon ' & $challenge & ' "' & $RCON & '" logaddress_del ' & $INETIP & ' ' & $PORT)
		UDPSend($socket, $A2S_RCON_SETTINGS)
		UDPCloseSocket($socket)
		UDPShutdown()
	ElseIf $loadingscreenbedingung = False Then
		Exit
	Else
		UDPCloseSocket($socket)
		UDPShutdown()
		Exit
	EndIf
EndFunc   ;==>OnAutoItExit