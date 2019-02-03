Func _EncodeToUrl($searchstring)
;~ 	$searchstring = StringReplace($searchstring, "é", "&eacute;")
;~ 	$searchstring = StringReplace($searchstring, "é", "&eacute;")
	$searchstring = StringReplace($searchstring, "é", "%C3%A9")
	$searchstring = StringReplace($searchstring, "%", "%25")
	$searchstring = StringReplace($searchstring, "!", "%21")
	$searchstring = StringReplace($searchstring, '"', "%22")
	$searchstring = StringReplace($searchstring, '#', "%23")
	$searchstring = StringReplace($searchstring, '$', "%24")
	$searchstring = StringReplace($searchstring, '&', "%26")
	$searchstring = StringReplace($searchstring, "'", "%27")
	$searchstring = StringReplace($searchstring, "(", "%28")
	$searchstring = StringReplace($searchstring, ")", "%29")
	$searchstring = StringReplace($searchstring, "+", "%2B")
	$searchstring = StringReplace($searchstring, ",", "%2C")
	$searchstring = StringReplace($searchstring, "/", "%2F")
	$searchstring = StringReplace($searchstring, ":", "%3A")
	$searchstring = StringReplace($searchstring, ";", "%3B")
	$searchstring = StringReplace($searchstring, "<", "%3C")
	$searchstring = StringReplace($searchstring, "=", "%3D")
	$searchstring = StringReplace($searchstring, ">", "%3E")
	$searchstring = StringReplace($searchstring, "?", "%3F")
	$searchstring = StringReplace($searchstring, "@", "%40")
	$searchstring = StringReplace($searchstring, '[', "%5B")
	$searchstring = StringReplace($searchstring, '\', "%5C")
	$searchstring = StringReplace($searchstring, ']', "%5D")
	$searchstring = StringReplace($searchstring, '^', "%5E")
	$searchstring = StringReplace($searchstring, "`", "%60")
	$searchstring = StringReplace($searchstring, '{', "%7B")
	$searchstring = StringReplace($searchstring, '|', "%7C")
	$searchstring = StringReplace($searchstring, '}', "%7D")
	$searchstring = StringReplace($searchstring, "~", "%7E")
	$searchstring = StringReplace($searchstring, " ", "+")
	Return $searchstring
EndFunc   ;==>_EncodeToUrl
Func _ADFunc_Divers_Upd($mod = 0, $string = '', $sFstring = '', $sArrStart = 0, $sArrDim = '', $sArrDim2 = '', $sArrMod = ' ', $sPrint = '')
	Local $sData = ''
	Local $sData2 = ''
	Local $sFch = ''
	Local $sLch = ''
	If $sArrMod = '|' Then
		If StringInStr($string, '|') Then
			Local $split = StringSplit($string, '|')
			$string = ''
			$sArrStart = 0
			Dim $string[0]
			For $i = 1 To UBound($split) - 1
				_ArrayAdd($string, $split[$i])
			Next
		EndIf
	EndIf
	Switch $mod
		Case 0
			If $string = '' Then
				ConsoleWrite(@LF)
			Else
				If IsArray($string) Then
					For $i = $sArrStart To UBound($string) - 1

						Switch $sArrDim
							Case -1
								If $string[$i] = '' Then ContinueLoop
								$sData &= $sFstring & $string[$i] & @LF
								$sData2 &= $string[$i] & @LF
							Case Else
								If $string[$i][$sArrDim] = '' Then ContinueLoop
								Switch $sArrDim2
									Case ''
										$sData &= $sFstring & $string[$i][$sArrDim] & @LF
										$sData2 &= $string[$i][$sArrDim] & @LF
									Case Else
										$sData &= $sFstring & $string[$i][$sArrDim] & $sArrMod & $string[$i][$sArrDim2] & @LF
										$sData2 &= $string[$i][$sArrDim] & $sArrMod & $string[$i][$sArrDim2] & @LF
								EndSwitch
						EndSwitch

					Next
					$sData = StringTrimRight($sData, 1)
;~ 					If $sArrMod <> '' Then $sData = StringTrimRight($sData, StringLen($sArrMod))
					ConsoleWrite($sData & @LF)
					If $sPrint <> '' Then FileWrite($sPrint, $sData2 & @CRLF)
				Else
					ConsoleWrite($sFstring & $string & @LF)
					If $sPrint <> '' Then FileWrite($sPrint, $string & @CRLF)
				EndIf
			EndIf

		Case 1, 2, 3
			If $string = '' Then
				ConsoleWrite(@LF)
			Else
				Switch $mod
					Case 1
						$sFch = "+"
						$sLch = "-"
					Case 2
						$sFch = "!"
						$sLch = "!"
					Case 3
						$sFch = "+"
						$sLch = "+"
				EndSwitch
				If IsArray($string) Then
					For $i = $sArrStart To UBound($string) - 1
						Switch $sArrDim
							Case -1
								If $string[$i] = '' Then ContinueLoop
								$sData &= $sFstring & $string[$i] & @LF
								$sData2 &= $string[$i] & @LF
							Case Else
								If $string[$i][$sArrDim] = '' Then ContinueLoop
								Switch $sArrDim2
									Case ''
										$sData &= $sFstring & $string[$i][$sArrDim] & @LF
										$sData2 &= $string[$i][$sArrDim] & @LF
									Case Else
										$sData &= $sFstring & $string[$i][$sArrDim] & $sArrMod & $string[$i][$sArrDim2] & @LF
										$sData2 &= $string[$i][$sArrDim] & $sArrMod & $string[$i][$sArrDim2] & @LF
								EndSwitch
						EndSwitch
					Next
					$sData = StringTrimRight($sData, 1)
					$sData2 = StringTrimRight($sData2, 1)
;~ 					If $sArrMod <> '' Then $sData = StringTrimRight($sData, StringLen($sArrMod))
					ConsoleWrite($sFch & "===========================================================" & @LF & _
							$sData & @LF & _
							$sLch & "===========================================================" & @LF)
					If $sPrint <> '' Then FileWrite($sPrint, $sData2 & @CRLF)
				Else
					ConsoleWrite($sFch & "===========================================================" & @LF & _
							$sFstring & $string & @LF & _
							$sLch & "===========================================================" & @LF)
					If $sPrint <> '' Then FileWrite($sPrint, $string & @CRLF)
				EndIf
			EndIf
	EndSwitch
EndFunc   ;==>_ADFunc_Divers_Upd
Func _ADFunc_Gui_ComboBox($sTiltle = 'titre', $sDataCmb = 'ComboBox', $sDefaultCmb = '', $sDataLbl = 'ComboBox', $sDataCmb2 = "", $sDefaultCmb2 = "", $sDataLbl2 = "", $sW = 500)
	Local $data
	Local $sh = 100

	If $sDataCmb2 <> '' Then
		$sh = $sh + 70
	EndIf

	Local $GuiComboBox = GUICreate($sTiltle, $sW, $sh, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	WinSetOnTop($GuiComboBox, '', 1)

	Local $sTop = 8
	GUICtrlCreateLabel($sDataLbl, 8, $sTop, $sW - 16, 17, $SS_CENTER)
	$sTop += 24
	Local $GuiComboBox_Cmb = GUICtrlCreateCombo("", 8, $sTop, $sW - 16, 25, BitOR($gui_ss_default_combo, $cbs_dropdownlist, $ws_hscroll))
	If IsArray($sDataCmb) Then
		$data = ''
		For $i = 0 To UBound($sDataCmb) - 1
			$data &= $sDataCmb[$i] & '|'
		Next
		$data = StringTrimRight($data, 1)
		If $sDefaultCmb = '' Then $sDefaultCmb = $sDataCmb[0]
		GUICtrlSetData($GuiComboBox_Cmb, $data, $sDefaultCmb)
	Else
		If $sDefaultCmb = '' And StringInStr($sDataCmb, '|') Then
			$sDefaultCmb = StringSplit($sDataCmb, '|')[1]
		ElseIf $sDefaultCmb = '' And StringInStr($sDataCmb, '|') = 0 Then
			$sDefaultCmb = $sDataCmb
		EndIf
		GUICtrlSetData($GuiComboBox_Cmb, $sDataCmb, $sDefaultCmb)
	EndIf

	Local $GuiComboBox_Cmb2
	If $sDataCmb2 <> '' Then
		$sTop += 35
		GUICtrlCreateLabel($sDataLbl2, 8, $sTop, $sW - 16, 17, $SS_CENTER)
		$sTop += 24
		$GuiComboBox_Cmb2 = GUICtrlCreateCombo("", 8, $sTop, $sW - 16, 25, BitOR($gui_ss_default_combo, $cbs_dropdownlist, $ws_hscroll))
		If IsArray($sDataCmb2) Then
			$data = ''
			For $i = 0 To UBound($sDataCmb2) - 1
				$data &= $sDataCmb2[$i] & '|'
			Next
			$data = StringTrimRight($data, 1)
			If $sDefaultCmb2 = '' Then $sDefaultCmb2 = $sDataCmb2[0]
			GUICtrlSetData($GuiComboBox_Cmb2, $data, $sDefaultCmb2)
		Else
			If $sDefaultCmb2 = '' And StringInStr($sDataCmb2, '|') Then
				$sDefaultCmb2 = StringSplit($sDataCmb2, '|')[1]
			ElseIf $sDefaultCmb2 = '' And StringInStr($sDataCmb2, '|') = 0 Then
				$sDefaultCmb2 = $sDataCmb2
			EndIf
			GUICtrlSetData($GuiComboBox_Cmb2, $sDataCmb2, $sDefaultCmb2)
		EndIf
	EndIf

	$sTop += 40
	Local $GuiComboBox_BtnOk = GUICtrlCreateButton("Valider", 8, $sTop, ($sW / 2) - 8, 25)
	GUICtrlSetCursor(-1, 0)
	Local $GuiComboBox_BtnCancell = GUICtrlCreateButton("Anuller", ($sW / 2) + 2, $sTop, ($sW / 2) - 8, 25)
	GUICtrlSetCursor(-1, 0)

	GUISetState(@SW_SHOW, $GuiComboBox)

	Local $nMsg, $sRet[2], $sSetError = 0
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GuiComboBox_BtnOk
				$sRet[0] = GUICtrlRead($GuiComboBox_Cmb)
				If $sDataCmb2 <> '' Then
					$sRet[1] = GUICtrlRead($GuiComboBox_Cmb2)
					If GUICtrlRead($GuiComboBox_Cmb2) = '' And GUICtrlRead($GuiComboBox_Cmb) = '' Then $sSetError = 1
				Else
					If GUICtrlRead($GuiComboBox_Cmb) = '' Then $sSetError = 1
				EndIf
				ExitLoop
			Case $GuiComboBox_BtnCancell
				$sSetError = 1
				ExitLoop
			Case $GUI_EVENT_CLOSE
				$sSetError = 1
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($GuiComboBox)

	Switch $sSetError
		Case 1
			Return SetError(1)
		Case 0
			Return $sRet
	EndSwitch
EndFunc   ;==>_ADFunc_Gui_ComboBox
Func _ADFunc_Inet_InetGet($sUrl, $sOutPath, $sTitle = '', $sProgress = False)
	Local $pourcentage, $totalsize, $kbrecu, $hDownload = InetGet($sUrl, $sOutPath, 1, 1)
	If $sTitle == '' Then $sTitle = _ADFunc_Files_FileGetFullNameByUrl($sUrl)
	If $sProgress Then ProgressOn("Telechargment en cour", "", "0%")
	Do
		$totalsize = 0
		$kbrecu = InetGetInfo($hDownload, 0)
		If $kbrecu > 0 Then
			If $totalsize = 0 Then
				$totalsize = InetGetInfo($hDownload, 1)
			EndIf
			$pourcentage = Round($kbrecu * 100 / $totalsize)
			If $sProgress Then ProgressSet($pourcentage, $pourcentage & '%', $sTitle)
		EndIf
		Sleep(50)
	Until InetGetInfo($hDownload, 2)
	If $sProgress Then ProgressOff()
	InetClose($hDownload)
EndFunc   ;==>_ADFunc_Inet_InetGet
Func _ADFunc_Files_FileGetFullNameByUrl($sFileUrl)
	Local $aFilename = StringSplit($sFileUrl, '/')
	If Not @error Then Return $aFilename[$aFilename[0]]
EndFunc   ;==>_ADFunc_Files_FileGetFullNameByUrl
