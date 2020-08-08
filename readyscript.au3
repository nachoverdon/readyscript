#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\icons\cmd.exe_SIDI_APPICON_0409.ico
#AutoIt3Wrapper_outfile=readyscript.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment= 
#AutoIt3Wrapper_Res_Description= 
#AutoIt3Wrapper_Res_Fileversion=3.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=aquila
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <INet.au3>
#include <string.au3>
#include <GuiEdit.au3>

;==============================================================================================================

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
#ce

;===============================================================================================================

$GUI = GUICreate(@ScriptFullPath, 800, 500)
$Label = GUICtrlCreateLabel("", -10, -10, 1, 1)
Global $Edit = GUICtrlGetHandle(GUICtrlCreateEdit("", 0, 0, 800, 500, 0x00200000 + 0x0800))
GUICtrlSetFont(-1, 12, 800, -1, "Courier New")
GUICtrlSetBkColor(-1, "0x" & IniRead("config.ini", "Script", "bgcol", 0x000000))
GUICtrlSetColor(-1, "0x" & IniRead("config.ini", "Script", "col", 0xFFFFFF))
GUICtrlSetState($Label, 256)
GUISetState()

_GUICtrlEdit_InsertText($Edit, "*** Readyscript 3.0 - by aquila ***" & @CRLF & "#readyscript - QuakeNet" & @CRLF & @CRLF)

Global $Commands[27]
For $i = 1 To 26
	$Commands[$i] = IniRead("config.ini", "Commands", "command[" & $i & "]", "")
	If $Commands[$i] = '' Then _ConsoleError("Commands incorrect..." & @CRLF)
Next

Global $FullIP = IniRead("config.ini", "Script", "ip", "")
Global $Rcon = IniRead("config.ini", "Script", "rcon", "")
Global $UDPPort = IniRead("config.ini", "Script", "udpport", "")
Global $LanIP = IniRead("config.ini", "Script", "lanip", "")
Global $WanIP = IniRead("config.ini", "Script", "wanip", "")

For $i = 1 To $CmdLine[0] Step +2
	If $CmdLine[$i] = '-ip' Then $FullIP = $CmdLine[$i + 1]
	If $CmdLine[$i] = '-rcon' Then $Rcon = $CmdLine[$i + 1]
	If $CmdLine[$i] = '-udpport' Then $UDPPort = $CmdLine[$i + 1]
	If $CmdLine[$i] = '-lanip' Then $LanIP = $CmdLine[$i + 1]
	If $CmdLine[$i] = '-wanip' Then $WanIP = $CmdLine[$i + 1]
Next

If $LanIP = '' Then
	$LanIP = @IPAddress1
	If $LanIP = "0.0.0.0" Or $LanIP = "" Then $LanIP = @IPAddress2
	If $LanIP = "0.0.0.0" Or $LanIP = "" Then $LanIP = @IPAddress3
	If $LanIP = "0.0.0.0" Or $LanIP = "" Then $LanIP = @IPAddress4
EndIf
If $WanIP = '' Then $WanIP = _GetIP()

_GUICtrlEdit_InsertText($Edit, "Server:" & @TAB & $FullIP & @CRLF & "Rcon:" & @TAB & $Rcon & @CRLF & "UDPPort:" & $UDPPort & @CRLF & "LanIP:" & @TAB & $LanIP & @CRLF & "WanIP:" & @TAB & $WanIP & @CRLF & @CRLF)

Global $IP[3], $HLTV = False
Global $LoopTimer = -1
Global $Socket, $ChallengeNr, $ReadyStatus = 0
Global $OldScore1, $OldScore2, $CurrentScore = ''
Global $Ready[IniRead("config.ini", "Script", "players", 10) + 1]
OnAutoItExitRegister("_ReadyScriptExit")

If StringRegExp($FullIP, "\d*.\d*.\d*.\d*:\d*") Then
	$aRegExp = StringRegExp($FullIP, "(\d*.\d*.\d*.\d*):(\d*)", 3)
	If Not IsArray($aRegExp) Then Exit
	$IP[1] = $aRegExp[0]
	$IP[2] = $aRegExp[1]
ElseIf StringRegExp($FullIP, ".+?:\d*") Then
	$RegExp = StringRegExp($FullIP, "(.+?):(\d*)")
	If Not IsArray($aRegExp) Then Exit
	$IP[1] = TCPNameToIP($aRegExp[0])
	$IP[2] = $aRegExp[1]
Else
	_ConsoleError("IP incorrect..." & @CRLF)
EndIf

_GUICtrlEdit_InsertText($Edit, "Challenging Server..." & @CRLF & @CRLF)
_GameServerContact()

UDPCloseSocket($Socket)
$Socket = UDPBind($LanIP, $UDPPort)
While True
	$msg = GUIGetMsg()
	If $msg = -3 Then Exit
	$UDP_Recv = UDPRecv($Socket, 8096 * 2)
	If $UDP_Recv <> "" Then
		$UDP_Recv = BinaryToString($UDP_Recv)
		_GUICtrlEdit_InsertText($Edit, StringTrimLeft($UDP_Recv, 10))
		If $ReadyStatus = 1 Or $ReadyStatus = 3 Or $ReadyStatus = 5 Or $ReadyStatus = 7 Then
			If StringInStr($UDP_Recv, '" say "' & $Commands[1] & '"') Or StringInStr($UDP_Recv, '" say "' & $Commands[3] & '"') Then _EvaluatePaketReady($UDP_Recv)
			If StringInStr($UDP_Recv, '" say "' & $Commands[2] & '"') Or StringInStr($UDP_Recv, '" say "' & $Commands[4] & '"') Then _EvaluatePaketNotReady($UDP_Recv)
			If StringInStr($UDP_Recv, '" say "' & $Commands[17] & '"') Then _EvaluatePaketReady($UDP_Recv, True)
			If StringInStr($UDP_Recv, '" say "' & $Commands[5] & '"') Then _EvaluatePaketInfo()
			If StringInStr($UDP_Recv, '" say "' & $Commands[7] & '"') Then _GameServerSetWarmup($UDP_Recv)
			If StringInStr($UDP_Recv, '" say "' & $Commands[14] & '"') Then _GameServerRestartRound($UDP_Recv)
			If StringInStr($UDP_Recv, '" say "' & $Commands[13]) Then _GameServerChangeMap($UDP_Recv)
			If StringInStr($UDP_Recv, '" say "' & $Commands[18]) Then _IRCRun($UDP_Recv)
			If StringInStr($UDP_Recv, '" say "' & $Commands[22] & '"') Then _GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[41]", ""))
			If StringInStr($UDP_Recv, '" disconnected') Then _EvaluatePaketNotReady($UDP_Recv)
		ElseIf $ReadyStatus = 2 Or $ReadyStatus = 4 Or $ReadyStatus = 6 Or $ReadyStatus = 8 Then
			If StringInStr($UDP_Recv, '" say "' & $Commands[8]) Then _EvaluatePaketReady($UDP_Recv, True, True)
			If StringInStr($UDP_Recv, '" say "' & $Commands[22] & '"') Then _GameServerSendMessage($CurrentScore)
			If StringRegExp($UDP_Recv, '\(CT "\d*"\) \(T "\d*"\)') Then _EvaluatePaketScore($UDP_Recv, $ReadyStatus)
		EndIf
		If StringInStr($UDP_Recv, '" say "' & $Commands[6] & '"') Then _GameServerSendTime()
		If StringInStr($UDP_Recv, '" say "' & $Commands[9] & '"') Then _GameServerStop($UDP_Recv)
		If StringInStr($UDP_Recv, '" say "' & $Commands[16] & '"') Then _GameServerStopHLTV($UDP_Recv)
		If StringInStr($UDP_Recv, '" say "' & $Commands[26] & '"') Then _GameServerShowAdmins()
		If StringInStr($UDP_Recv, '" say "' & $Commands[11]) Then _GameServerSetMaxRounds($UDP_Recv)
		If StringInStr($UDP_Recv, '" say "' & $Commands[12]) Then _GameServerKickAndAdmin($UDP_Recv, 1)
		If StringInStr($UDP_Recv, '" say "' & $Commands[23]) Then _GameServerKickAndAdmin($UDP_Recv, 2)
		If StringInStr($UDP_Recv, '" say "' & $Commands[24]) Then _GameServerKickAndAdmin($UDP_Recv, 3)
		If StringInStr($UDP_Recv, '" say "' & $Commands[15]) Then _GameServerRunHLTV($UDP_Recv)
		If StringInStr($UDP_Recv, '" say "' & $Commands[25]) Then _GameServerSetPass($UDP_Recv)
		_GameServerManualCmds($UDP_Recv)
		Sleep(50)
		$UDP_Recv = ''
	EndIf
	If TimerDiff($LoopTimer) > IniRead("config.ini", "Script", "rdyloop", "") * 1000 And ($ReadyStatus = 1 Or $ReadyStatus = 3 Or $ReadyStatus = 5 Or $ReadyStatus = 7) Then
		$sMessage = "say " & IniRead("config.ini", "Messages", "message[1]", "")
		_GameServerSendMessage($sMessage)
		$LoopTimer = TimerInit()
	EndIf
WEnd

Func _EvaluatePaketReady($sPaket, $bForce = False, $bRestart = False)
	If $bForce = True Then
		If _IsAdmin($sPaket) = False Then Return
	Else
		$iMaxPlayers = IniRead("config.ini", "Script", "players", "")
		$SteamId = StringRegExp($sPaket, ".+<\d*><STEAM_(\d:\d:\d+)", 3)
		$aName = StringRegExp($sPaket, '"(.+)<\d*><STEAM_\d:\d:\d+', 3)
		If Not IsArray($aName) Or Not IsArray($SteamId) Then Return
		For $i = 1 To IniRead("config.ini", "Script", "players", "")
			If $Ready[$i] = $SteamId[0] Then
				$sMessage = "say " & StringReplace(IniRead("config.ini", "Messages", "message[5]", ""), "%Player%", $aName[0])
				_GameServerSendMessage($sMessage)
				Return
			EndIf
		Next
		$iCount = 0
		For $i = 1 To $iMaxPlayers
			If $Ready[$i] <> '' Then $iCount += 1
		Next
		For $i = 1 To $iMaxPlayers
			If $Ready[$i] = "" Then
				$Ready[$i] = $SteamId[0]
				$iCount += 1
				$sMessage = "say " & StringReplace(IniRead("config.ini", "Messages", "message[2]", ""), "%Player%", $aName[0])
				_GameServerSendMessage($sMessage)
				Sleep(50)
				$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[4]", ""), "%Count%", $iCount), "%MaxPlayers%", $iMaxPlayers)
				_GameServerSendMessage($sMessage)
				ExitLoop
			EndIf
		Next
		For $i = 1 To $iMaxPlayers
			If $Ready[$i] = "" Then Return
		Next
	EndIf
	UDPCloseSocket($Socket)
	$Socket = UDPOpen($IP[1], $IP[2])
	If $bRestart = False Then
		$ReadyStatus += 1
		If $ReadyStatus = 2 Then
			$sMessage = "say " & IniRead("config.ini", "Messages", "message[14]", "")
			_GameServerSendMessage($sMessage)
			Sleep(10)
		ElseIf $ReadyStatus = 4 Then
			$sMessage = "say " & IniRead("config.ini", "Messages", "message[15]", "")
			_GameServerSendMessage($sMessage)
			Sleep(10)
		ElseIf $ReadyStatus = 6 Then
			$sMessage = "say " & IniRead("config.ini", "Messages", "message[46]", "")
			_GameServerSendMessage($sMessage)
			Sleep(10)
		ElseIf $ReadyStatus = 8 Then
			$sMessage = "say " & IniRead("config.ini", "Messages", "message[47]", "")
			_GameServerSendMessage($sMessage)
			Sleep(10)
		EndIf
	Else
		If $ReadyStatus = 2 Or $ReadyStatus = 6 Then
			$sMessage = "say " & IniRead("config.ini", "Messages", "message[17]", "")
			_GameServerSendMessage($sMessage)
			Sleep(10)
		ElseIf $ReadyStatus = 4 Or $ReadyStatus = 8 Then
			$sMessage = "say " & IniRead("config.ini", "Messages", "message[18]", "")
			_GameServerSendMessage($sMessage)
			Sleep(10)
		EndIf
	EndIf
	_GameServerSetSettings()
	If $ReadyStatus = 6 Or $ReadyStatus = 8 Then
		UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" mp_startmoney ' & IniRead("config.ini", "Script", "otmoney", 10000))
		Sleep(10)
		$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[48]", ""), "%otmr%", _
				IniRead("config.ini", "Script", "otmr", "")), "%otmoney%", IniRead("config.ini", "Script", "otmoney", ""))
		_GameServerSendMessage($sMessage)
		UDPCloseSocket($Socket)
		$Socket = UDPOpen($IP[1], $IP[2])
	EndIf
	Sleep(2500)
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" sv_restart 1')
	Sleep(2000)
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" sv_restart 1')
	Sleep(2000)
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" sv_restart 3')
	Sleep(5000)
	$sMessage = "say " & IniRead("config.ini", "Messages", "message[13]", "")
	_GameServerSendMessage($sMessage)
	Sleep(100)
	$sMessage = "say " & IniRead("config.ini", "Messages", "message[19]", "")
	_GameServerSendMessage($sMessage)
EndFunc   ;==>_EvaluatePaketReady

Func _EvaluatePaketNotReady($sPaket)
	$iMaxPlayers = IniRead("config.ini", "Script", "players", "")
	$SteamId = StringRegExp($sPaket, ".+<\d*><STEAM_(\d:\d:\d*)", 3)
	$aName = StringRegExp($sPaket, '"(.+)<\d*><STEAM_\d:\d:\d*', 3)
	If Not IsArray($SteamId) Or Not IsArray($aName) Then Return
	$iCount = 0
	For $i = 1 To $iMaxPlayers
		If $Ready[$i] <> '' Then $iCount += 1
	Next
	For $i = 1 To $iMaxPlayers
		If $Ready[$i] = $SteamId[0] Then
			$Ready[$i] = ""
			UDPCloseSocket($Socket)
			$Socket = UDPOpen($IP[1], $IP[2])
			$iCount -= 1
			$sMessage = "say " & StringReplace(IniRead("config.ini", "Messages", "message[3]", ""), "%Player%", $aName[0])
			_GameServerSendMessage($sMessage)
			Sleep(50)
			$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[4]", ""), "%Count%", $iCount), "%MaxPlayers%", $iMaxPlayers)
			_GameServerSendMessage($sMessage)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_EvaluatePaketNotReady

Func _EvaluatePaketInfo()
	$iMaxPlayers = IniRead("config.ini", "Script", "players", "")
	$iCount = 0
	For $i = 1 To IniRead("config.ini", "Script", "players", "")
		If $Ready[$i] <> '' Then $iCount += 1
	Next
	$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[4]", ""), "%Count%", $iCount), "%MaxPlayers%", $iMaxPlayers)
	_GameServerSendMessage($sMessage)
EndFunc   ;==>_EvaluatePaketInfo

Func _EvaluatePaketScore($sPaket, $iNr)
	$sAdd = ''
	$aScoreRead = StringRegExp($sPaket, '\(CT "(\d*)"\) \(T "(\d*)"\)', 3)
	If Not IsArray($aScoreRead) Then Return
	If $iNr = 6 Or $iNr = 8 Then $sAdd = "ot"
	If $iNr = 2 Or $iNr = 6 Then
		If $aScoreRead[0] + $aScoreRead[1] = IniRead("config.ini", "Script", $sAdd & "mr", "") Then
			$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[20]", ""), "%Score1%", $aScoreRead[0]), "%Score2%", $aScoreRead[1])
			$CurrentScore = $sMessage
			_GameServerSendMessage($sMessage)
			$OldScore1 = $aScoreRead[0]
			$OldScore2 = $aScoreRead[1]
			_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[11]", ""))
			$ReadyStatus += 1
			$CurrentScore = ''
			Sleep(1000)
			_GameServerSetWarmup('')
			For $i = 1 To IniRead("config.ini", "Script", "players", "")
				$Ready[$i] = ""
			Next
		Else
			$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[20]", ""), "%Score1%", $aScoreRead[0]), "%Score2%", $aScoreRead[1])
			$CurrentScore = $sMessage
			_GameServerSendMessage($sMessage)
		EndIf
	ElseIf $iNr = 4 Or $iNr = 8 Then
		If $aScoreRead[1] + $OldScore1 = IniRead("config.ini", "Script", $sAdd & "mr", "") And $aScoreRead[0] + $OldScore2 = IniRead("config.ini", "Script", $sAdd & "mr", "") Then
			$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[45]", ""), "%SumScore1%", $aScoreRead[1] + $OldScore1), "%SumScore2%", $aScoreRead[0] + $OldScore2)
			_GameServerSendMessage($sMessage)
			$CurrentScore = "Team A  " & $OldScore1 + $aScoreRead[1] & " - " & $OldScore2 + $aScoreRead[0] & "  Team B"
			$ReadyStatus += 1
			If $ReadyStatus = 9 Then $ReadyStatus = 5
			Sleep(1000)
			For $i = 1 To IniRead("config.ini", "Script", "players", "")
				$Ready[$i] = ""
			Next
		ElseIf $aScoreRead[1] + $OldScore1 = IniRead("config.ini", "Script", $sAdd & "mr", "") + 1 Or $aScoreRead[0] + $OldScore2 = IniRead("config.ini", "Script", $sAdd & "mr", "") + 1 Then
			$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[22]", ""), "%Score1%", $aScoreRead[1] + $OldScore1), "%Score2%", $aScoreRead[0] + $OldScore2)
			_GameServerSendMessage($sMessage)
			$ReadyStatus = 1
			$CurrentScore = ''
			Sleep(1000)
			For $i = 1 To IniRead("config.ini", "Script", "players", "")
				$Ready[$i] = ""
			Next
		Else
			$sMessage = "say " & StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[21]", ""), "%Score2%", $aScoreRead[1]), "%Score1%", $aScoreRead[0])
			$sMessage = StringReplace(StringReplace($sMessage, "%SumScore1%", $OldScore1 + $aScoreRead[1]), "%SumScore2%", $OldScore2 + $aScoreRead[0])
			$CurrentScore = $sMessage
			_GameServerSendMessage($sMessage)
		EndIf
	EndIf
EndFunc   ;==>_EvaluatePaketScore

Func _GameServerContact()
	Local $iTimer = TimerInit()
	UDPStartup()
	$Socket = UDPOpen($IP[1], $IP[2])
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'challenge rcon')
	While TimerDiff($iTimer) <= 5000
		$Challenge_recv = UDPRecv($Socket, 8096)
		If $Challenge_recv <> "" Then
			$ChallengeNr = StringRegExpReplace(BinaryToString($Challenge_recv), "[^\d+]", '$1')
			ExitLoop
		EndIf
	WEnd
	If TimerDiff($iTimer) >= 5000 Then
		_GUICtrlEdit_InsertText($Edit, "Failed to contact server...")
		Do
			$msg = GUIGetMsg()
		Until $msg = -3
		Exit
	EndIf
	$ReadyStatus = 1
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" logaddress_add ' & $WanIP & ' ' & $UDPPort)
	Sleep(1000)
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" log on')
	Sleep(1000)
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" mp_logmessages 1')
	Sleep(1000)
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" status')
	Do
		$UDP_Recv = UDPRecv($Socket, 8096)
	Until StringInStr(BinaryToString($UDP_Recv), 'hostname')
	$UDP_Recv = BinaryToString($UDP_Recv)
	_GUICtrlEdit_InsertText($Edit, StringReplace(StringTrimLeft($UDP_Recv, 5), @LF, @CRLF))
	_GUICtrlEdit_InsertText($Edit, @CRLF)
EndFunc   ;==>_GameServerContact

Func _GameServerGetPass()
	UDPCloseSocket($Socket)
	$Socket = UDPOpen($IP[1], $IP[2])
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" sv_password')
	Do
		$UDP_Recv = UDPRecv($Socket, 2048)
	Until BinaryToString($UDP_Recv) <> ''
	$aPass = StringRegExp(BinaryToString($UDP_Recv), '"sv_password" is "(.+)"', 3)
	If IsArray($aPass) Then Return $aPass[0]
	Return -1
EndFunc   ;==>_GameServerGetPass

Func _GameServerSendMessage($sMessage)
	UDPCloseSocket($Socket)
	$Socket = UDPOpen($IP[1], $IP[2])
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" ' & $sMessage)
	UDPCloseSocket($Socket)
	$Socket = UDPBind($LanIP, $UDPPort)
EndFunc   ;==>_GameServerSendMessage

Func _GameServerSendTime()
	$sMessage = StringReplace(StringReplace(IniRead("config.ini", "Messages", "message[16]", ""), "%hour%", @HOUR), "%min%", @MIN)
	$sMessage = "say " & StringReplace(StringReplace(StringReplace(StringReplace($sMessage, "%sec%", @SEC), "%day%", @MDAY), "%mon%", @MON), "%year%", @YEAR)
	_GameServerSendMessage($sMessage)
EndFunc   ;==>_GameServerSendTime

Func _GameServerSetWarmup($sPaket)
	If $sPaket <> '' Then
		If _IsAdmin($sPaket) = False Then Return
	EndIf
	$aWarmupCmds = StringSplit(FileRead("warmup.cfg"), @CRLF, 1)
	For $i = 1 To UBound($aWarmupCmds) - 1
		_GameServerSendMessage($aWarmupCmds[$i])
		Sleep(25)
	Next
	$sMessage = "say " & IniRead("config.ini", "Messages", "message[6]", "")
	_GameServerSendMessage($sMessage)
	Sleep(100)
	_GameServerSendMessage("sv_restart 1")
EndFunc   ;==>_GameServerSetWarmup

Func _GameServerSetSettings()
	UDPCloseSocket($Socket)
	$Socket = UDPOpen($IP[1], $IP[2])
	$aSettingsCmds = StringSplit(FileRead("settings.cfg"), @CRLF, 1)
	For $i = 1 To UBound($aSettingsCmds) - 1
		UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" ' & $aSettingsCmds[$i])
		Sleep(25)
	Next
EndFunc   ;==>_GameServerSetSettings

Func _GameServerRestartRound($sPaket)
	If _IsAdmin($sPaket) = False Then Return
	_GameServerSendMessage("sv_restart 1")
EndFunc   ;==>_GameServerRestartRound

Func _GameServerSetPass($sPaket)
	If _IsAdmin($sPaket) = False Then Return
	$aPass = StringRegExp($sPaket, IniRead("config.ini", "Commands", "command[25]", "") & ' (.+?)"', 3)
	If Not IsArray($aPass) Then Return
	_GameServerSendMessage("sv_password " & $aPass[0])
	_GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[44]", ""), "%Pass%", $aPass[0]))
EndFunc   ;==>_GameServerSetPass

Func _GameServerChangeMap($sPaket)
	If _IsAdmin($sPaket) = False Then Return
	$aMap = StringRegExp($sPaket, IniRead("config.ini", "Commands", "command[13]", "") & ' (.+?)"', 3)
	If Not IsArray($aMap) Then Return
	UDPCloseSocket($Socket)
	$Socket = UDPOpen($IP[1], $IP[2])
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" maps *')
	Do
		$UDP_Recv = UDPRecv($Socket, 8096)
	Until $UDP_Recv <> ""
	UDPCloseSocket($Socket)
	$Socket = UDPBind($LanIP, $UDPPort)
	$sMaps = BinaryToString($UDP_Recv)
	Local $aMaps = StringRegExp($sMaps, "(.+?).bsp", 3), $bBool = False
	For $i = 0 To UBound($aMaps) - 1
		If StringInStr($aMaps[$i], $aMap[0]) Then
			If $bBool = True Then
				$bBool = False
				ExitLoop
			EndIf
			$bBool = True
			$sMap = $aMaps[$i]
			If $aMaps[$i] = $aMap[0] Then ExitLoop
		EndIf
	Next
	If $bBool = False Then
		_GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[39]", ""), "%Map%", $aMap[0]))
	Else
		_GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[40]", ""), "%Map%", $sMap))
		Sleep(2000)
		_GameServerSendMessage("changelevel " & $sMap)
	EndIf
EndFunc   ;==>_GameServerChangeMap

Func _GameServerStop($sPaket)
	If _IsAdmin($sPaket) = False Then Return
	$sMessage = "say " & IniRead("config.ini", "Messages", "message[8]", "")
	_GameServerSendMessage($sMessage)
	Do
		$UDP_Recv = UDPRecv($Socket, 8096)
	Until StringInStr(BinaryToString($UDP_Recv), '" say "' & $Commands[10] & '"')
	$sMessage = "say " & IniRead("config.ini", "Messages", "message[9]", "")
	_GameServerSendMessage($sMessage)

EndFunc   ;==>_GameServerStop

Func _GameServerSetMaxRounds($sPaket)
	If _IsAdmin($sPaket) = False Then Return
	$aRegExp = StringRegExp($sPaket, "setup (\d*)on(\d*) mr(\d*)", 3)
	If UBound($aRegExp) <> 3 Then Return -1
	If $aRegExp[0] <> $aRegExp[1] Or $aRegExp[0] = "0" Then Return -1
	If $aRegExp[2] > 20 Then
		$sMessage = "say " & IniRead("config.ini", "Messages", "message[42]", "")
		_GameServerSendMessage($sMessage)
		Return
	EndIf
	IniWrite("config.ini", "Script", "mr", $aRegExp[2])
	IniWrite("config.ini", "Script", "players", $aRegExp[1] * 2)
	$sMessage = IniRead("config.ini", "Messages", "message[7]", "")
	$sMessage = "say " & StringReplace(StringReplace($sMessage, "%xonx%", $aRegExp[0] & "on" & $aRegExp[0]), "%mr%", $aRegExp[2])
	Global $Ready[IniRead("config.ini", "Script", "players", 10) + 1]
	For $i = 1 To IniRead("config.ini", "Script", "players", "")
		$Ready[$i] = ''
	Next
	_GameServerSendMessage($sMessage)
	If $ReadyStatus <> 1 And $ReadyStatus <> 3 Then _GameServerSetWarmup('')
	$ReadyStatus = 1
EndFunc   ;==>_GameServerSetMaxRounds

Func _GameServerKickAndAdmin($sPaket, $iNr)
	If _IsAdmin($sPaket) = False Then Return
	If $iNr = 1 Then $aName = StringRegExp($sPaket, IniRead("config.ini", "Commands", "command[12]", "") & ' (.+?)"', 3)
	If $iNr = 2 Then $aName = StringRegExp($sPaket, IniRead("config.ini", "Commands", "command[23]", "") & ' (.+?)"', 3)
	If $iNr = 3 Then $aName = StringRegExp($sPaket, IniRead("config.ini", "Commands", "command[24]", "") & ' (.+?)"', 3)
	If Not IsArray($aName) Then Return
	Local $bBool = False, $iKickNr = '', $sPlayer = ''
	UDPCloseSocket($Socket)
	$Socket = UDPOpen($IP[1], $IP[2])
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" status')
	Do
		$UDP_Recv = UDPRecv($Socket, 8096)
	Until $UDP_Recv <> ""
	UDPCloseSocket($Socket)
	$Socket = UDPBind($LanIP, $UDPPort)
	$Status = BinaryToString($UDP_Recv)
	$aPlayers = StringRegExp($Status, '"(.+?)" (\d*) STEAM_(\d:\d:\d*) ', 3)
	If Not IsArray($aPlayers) Then Return
	For $i = 0 To UBound($aPlayers) - 1 Step +3
		If StringInStr($aPlayers[$i], $aName[0]) Then
			If $bBool = True Then
				$bBool = False
				ExitLoop
			EndIf
			$bBool = True
			$sPlayer = $aPlayers[$i]
			$iKickNr = $aPlayers[$i + 1]
			$sSteamId = $aPlayers[$i + 2]
			If $aPlayers[$i] = $aName[0] Then ExitLoop
		EndIf
	Next
	If $bBool = False Then
		_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[23]", ""))
	Else
		If $iNr = 1 Then
			Local $aIni = IniReadSection("config.ini", "Admins")
			For $i = 1 To UBound($aIni) - 1
				If $aIni[$i][1] = $sSteamId & "*" Then
					_GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[37]", ""), "%Player%", $sPlayer))
					Return
				EndIf
			Next
			_GameServerSendMessage('kick #' & $iKickNr)
			_GameServerSendMessage('say ' & StringReplace(IniRead("config.ini", "Messages", "message[24]", ""), "%Player%", $sPlayer))
		ElseIf $iNr = 2 Then
			If _IsAdmin($sPaket, True) = False Then
				_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[38]", ""))
				Return
			EndIf
			Local $aIni = IniReadSection("config.ini", "Admins")
			For $i = 1 To UBound($aIni) - 1
				If $aIni[$i][1] = $sSteamId Or $aIni[$i][1] = $sSteamId & "*" Then
					_GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[34]", ""), "%Player%", $sPlayer))
					Return
				EndIf
			Next
			IniWrite("config.ini", "Admins", "admin[" & UBound($aIni) & "]", $sSteamId)
			_GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[35]", ""), "%Player%", $sPlayer))
		ElseIf $iNr = 3 Then
			If _IsAdmin($sPaket, True) = False Then
				_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[38]", ""))
				Return
			EndIf
			Local $aIni = IniReadSection("config.ini", "Admins"), $iCount = 1, $bMaster = False
			IniDelete("config.ini", "Admins")
			For $i = 1 To UBound($aIni) - 1
				If $aIni[$i][1] = $sSteamId Then ContinueLoop
				If $aIni[$i][1] = $sSteamId & "*" Then
					$bMaster = True
					_GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[37]", ""), "%Player%", $sPlayer))
				EndIf
				IniWrite("config.ini", "Admins", "admin[" & $iCount & "]", $aIni[$i][1])
				$iCount += 1
			Next
			If $bMaster = False Then _GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[36]", ""), "%Player%", $sPlayer))
		EndIf
	EndIf
EndFunc   ;==>_GameServerKickAndAdmin

Func _GameServerShowAdmins()
	Local $sText = ''
	UDPCloseSocket($Socket)
	$Socket = UDPOpen($IP[1], $IP[2])
	UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" status')
	Do
		$UDP_Recv = UDPRecv($Socket, 8096)
	Until $UDP_Recv <> ""
	UDPCloseSocket($Socket)
	$Socket = UDPBind($LanIP, $UDPPort)
	$Status = BinaryToString($UDP_Recv)
	Local $aPlayers = StringRegExp($Status, '"(.+?)" \d* STEAM_(\d:\d:\d*) ', 3)
	If Not IsArray($aPlayers) Then Return
	$aIni = IniReadSection("config.ini", "Admins")
	For $i = 0 To UBound($aPlayers) - 1 Step +2
		For $j = 1 To UBound($aIni) - 1
			If $aIni[$j][1] = $aPlayers[$i + 1] Then $sText &= $aPlayers[$i] & ", "
			If $aIni[$j][1] = $aPlayers[$i + 1] & "*" Then $sText &= $aPlayers[$i] & " (M), "
		Next
	Next
	If $sText <> '' Then _GameServerSendMessage("say " & StringReplace(IniRead("config.ini", "Messages", "message[43]", ""), "%Admins%", StringTrimRight($sText, 2)))
EndFunc   ;==>_GameServerShowAdmins

Func _GameServerManualCmds($sPaket)
	$aIniCmds = IniReadSection("config.ini", "ManualCommands")
	If Not IsArray($aIniCmds) Then Return
	For $i = 1 To UBound($aIniCmds) - 1
		If StringInStr($sPaket, '" say "' & $aIniCmds[$i][0] & '"') Then
			If _IsAdmin($sPaket) = False Then Return
			$aSplitCmds = StringSplit($aIniCmds[$i][1] & ";", ";")
			For $j = 1 To UBound($aSplitCmds) - 1
				If $aSplitCmds[$j] = '' Then ContinueLoop
				_GameServerSendMessage($aSplitCmds[$j])
			Next
		EndIf
	Next
EndFunc   ;==>_GameServerManualCmds

Func _GameServerRunHLTV($sPaket)
	If _IsAdmin($sPaket) = False Then Return
	$aDemo = StringRegExp($sPaket, IniRead("config.ini", "Commands", "command[15]", "") & ' (.+?)"', 3)
	If Not IsArray($aDemo) Then Return
	If $HLTV = True Then
		_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[26]", ""))
		Return
	EndIf
	$sServerPassword = _GameServerGetPass()
	$HLTV = True
	$sPath = IniRead("config.ini", "Script", "hltvpath", "")
	$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", "", -1))
	$sPath = StringTrimRight($sPath, StringLen($sFile))
	If FileExists($sPath & "rdy.cfg") Then FileDelete($sPath & "rdy.cfg")
	If Not FileExists($sPath & "steam_appid.txt") Then FileWrite($sPath & "steam_appid.txt", "10")
	$sCfg = 'delay "' & IniRead("config.ini", "Script", "hltvdelay", "90") & '"' & @CRLF & _
			'name "' & IniRead("config.ini", "Script", "hltv", "HLTV Proxy") & '"' & @CRLF & _
			'hostname "' & IniRead("config.ini", "Script", "hltv", "HLTV Proxy") & '"' & @CRLF & _
			'serverpassword "' & $sServerPassword & '"' & @CRLF & _
			'record "' & $aDemo[0] & '"' & @CRLF & _
			'connect "' & $IP[1] & ":" & $IP[2] & '"' & @CRLF
	FileWrite($sPath & "rdy.cfg", $sCfg)
	$sRead = FileRead($sPath & "hltv.cfg")
	If Not StringInStr($sRead, "exec rdy.cfg") Then FileWrite($sPath & "hltv.cfg", @CRLF & "exec rdy.cfg" & @CRLF)
	ShellExecute($sPath & $sFile, "", "", "", @SW_MINIMIZE)
	_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[25]", ""))
EndFunc   ;==>_GameServerRunHLTV

Func _GameServerStopHLTV($sPaket)
	If _IsAdmin($sPaket) = False Then Return
	If $HLTV = False Then
		_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[28]", ""))
		Return
	EndIf
	$HLTV = False
	ControlSend(WinGetTitle("HLTV - " & $IP[1] & ":" & $IP[2]), "", "", "stoprecording;quit{ENTER}")
	_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[27]", ""))
EndFunc   ;==>_GameServerStopHLTV

Func _IRCRun($sPaket, $bError = False)
	If $bError = True Then Return
	If _IsAdmin($sPaket) = False Then Return
	UDPCloseSocket($Socket)
	$Socket = UDPBind($LanIP, $UDPPort)
	If IniRead("config.ini", "Script", "irc", "") = "False" Then
		_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[31]", ""))
		Return
	EndIf
	$aText = StringRegExp($sPaket, $Commands[18] & ' (\d)on(\d) (.+?)"', 3)
	If UBound($aText) <> 3 Then _IRCError()
	If $aText[0] <> $aText[1] Then _IRCError()

	Local $IRCMsgTimer = TimerInit(), $sRndm
	Local $Channel = IniRead("config.ini", "Script", $aText[0] & "on" & $aText[1], "")
	Local $IRCServer = IniRead("config.ini", "Script", "ircserver", "irc.quakenet.org")
	For $i = 1 To 6
		$sRndm &= Chr(Random(97, 122, 1))
	Next
	Local $Nick = 'rdy|' & IniRead("config.ini", "Script", "ircnick", $sRndm)
	Local $IrcPort = IniRead("config.ini", "Script", "ircport", "6667")
	Local $bJoined = False, $sQueryName = '', $sSearchText = $aText[2], $sBlackList = ''

	TCPStartup()
	Local $sock = _IRCConnect($IRCServer, $IrcPort, $Nick); Verbindung zu IRC und Identifizierung Nickname
	While True
		$recv = TCPRecv($sock, 8192 * 2)
		Local $sData = StringSplit($recv, @CRLF)
		For $i = 1 To UBound($sData) - 1 Step 1
			If StringInStr($sData[$i], "PRIVMSG " & $Nick) Then
				$sData[$i] = StringTrimLeft($sData[$i], 1)
				$sName = StringLeft($sData[$i], StringInStr($sData[$i], "!") - 1)
				$sText = StringTrimLeft($sData[$i], StringInStr($sData[$i], ":"))
				If $sQueryName <> '' And $sQueryName <> $sName Then ContinueLoop
				If StringInStr($sBlackList, "|" & $sName & "|") Then ContinueLoop
				If $sQueryName = '' Then _GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[33]", ""))
				$sQueryName = $sName
				_GameServerSendMessage("say <" & $sQueryName & "> " & $sText)
			EndIf
			If (StringInStr($sData[$i], "Welcome") Or TimerDiff($IRCMsgTimer) > 10000) And $bJoined = False Then
				Sleep(500)
				_IRCJoinChannel($sock, $Channel)
				$sMessage = "say " & StringReplace(IniRead("config.ini", "Messages", "message[29]", ""), "%channel%", $Channel)
				_GameServerSendMessage($sMessage)
				Sleep(500)
				_IRCSendMessage($sock, $sSearchText, $Channel)
				_GameServerSendMessage("say <IRC> " & $sSearchText)
				$bJoined = True
			EndIf
			Local $sTemp = StringSplit($sData[$i], " "); Splittet die Nachricht an den Leerzeichen
			If $sTemp[1] = "" Then ContinueLoop; Weiter, wenn leer
			If $sTemp[1] = "PING" Then _IRCPing($sock, $sTemp[2]); Prüft ob PING zurückgegeben wird
			If $sTemp[0] <= 2 Then ContinueLoop; meist nutzlose Informationen
		Next

		If TimerDiff($IRCMsgTimer) >= IniRead("config.ini", "Script", "ircloop", "") * 1000 And $bJoined = True And $sQueryName = '' Then
			_IRCSendMessage($sock, $sSearchText, $Channel)
			_GameServerSendMessage("say <IRC> " & $sSearchText)
			$IRCMsgTimer = TimerInit()
		EndIf

		$UDP_Recv = UDPRecv($Socket, 8096)
		If $UDP_Recv <> "" Then
			$UDP_Recv = BinaryToString($UDP_Recv)
			If StringInStr($UDP_Recv, '" say "' & $Commands[21] & '"') Then
				$sServerPassword = _GameServerGetPass()
				_IRCSendMessage($sock, "connect " & $IP[1] & ":" & $IP[2] & "; password " & $sServerPassword, $sQueryName)
				_GameServerSendMessage("say <IRC> connect " & $IP[1] & ":" & $IP[2] & "; password " & $sServerPassword)
			ElseIf StringInStr($UDP_Recv, '" say "' & $Commands[19] & '"') Then
				_IRCQuit($sock)
				_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[32]", ""))
				ExitLoop
			ElseIf StringInStr($UDP_Recv, '" say "' & $Commands[20] & '"') Then
				$sBlackList &= "|" & $sQueryName & "|"
				$sQueryName = ''
				_IRCSendMessage($sock, $sSearchText, $Channel)
				_GameServerSendMessage("say <IRC> " & $sSearchText)
				$IRCMsgTimer = TimerInit()
			ElseIf StringInStr($UDP_Recv, '" say "' & $Commands[18]) Then
				If $sQueryName = '' Then ContinueLoop
				$aRegExp = StringRegExp($UDP_Recv, '" say "' & $Commands[18] & ' (.+?)"', 3)
				If IsArray($aRegExp) Then
					_IRCSendMessage($sock, $aRegExp[0], $sQueryName)
					_GameServerSendMessage("say <IRC> " & $aRegExp[0])
				EndIf
			EndIf
		EndIf
	WEnd
EndFunc   ;==>_IRCRun

Func _IRCError()
	_GameServerSendMessage("say " & IniRead("config.ini", "Messages", "message[30]", ""))
	_IRCRun('', True)
EndFunc   ;==>_IRCError

Func _IRCConnect($server, $PORT, $Nick)
	Local $i = TCPConnect(TCPNameToIP($server), $PORT)
	If $i = -1 Then
		_IRCError()
	EndIf
	TCPSend($i, "NICK " & $Nick & @CRLF)
	$ping = TCPRecv($i, 2048)
	If StringLeft($ping, 4) = "PING" Then
		$pong = StringReplace($ping, "PING :", "")
		TCPSend($i, "PONG " & $pong & @LF)
	EndIf
	TCPSend($i, "USER " & $Nick & " 0 0 " & $Nick & @CRLF)
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

Func _ConsoleError($sError)
	_GUICtrlEdit_InsertText($Edit, StringReplace($sError, @LF, @CRLF))
	Sleep(3000)
	Exit
EndFunc   ;==>_ConsoleError

Func _IsAdmin($sPaket, $bMaster = False)
	$aName = StringRegExp($sPaket, '"(.+)<\d*><STEAM_\d:\d:\d+', 3)
	$SteamId = StringRegExp($sPaket, ".+<\d*><STEAM_(\d:\d:\d*)", 3)
	If Not IsArray($aName) Or Not IsArray($SteamId) Then Return False
	$aIniReadSection = IniReadSection("config.ini", "Admins")
	For $i = 1 To UBound($aIniReadSection) - 1
		If $bMaster = False Then
			If $aIniReadSection[$i][1] = $SteamId[0] Or $aIniReadSection[$i][1] = $SteamId[0] & "*" Then Return True
		Else
			If $aIniReadSection[$i][1] = $SteamId[0] & "*" Then Return True
		EndIf
	Next
	If $bMaster = False Then
		$sMessage = "say " & StringReplace(IniRead("config.ini", "Messages", "message[10]", ""), "%Player%", $aName[0])
		_GameServerSendMessage($sMessage)
	EndIf
	Return False
EndFunc   ;==>_IsAdmin

Func _ReadyscriptExit()
	If $ReadyStatus > 0 Then
		UDPCloseSocket($Socket)
		$Socket = UDPOpen($IP[1], $IP[2])
		UDPSend($Socket, _HexToString("FFFFFFFF") & 'rcon ' & $ChallengeNr & ' "' & $Rcon & '" logaddress_del ' & $WanIP & ' ' & $UDPPort)
		UDPCloseSocket($Socket)
		UDPShutdown()
	EndIf
	Exit
EndFunc   ;==>_ReadyscriptExit