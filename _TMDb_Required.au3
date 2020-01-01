#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>
#include <Array.au3>
#include <String.au3>
#include <GDIPlus.au3>
#include <File.au3>
#include <Date.au3>

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
Func _StringSaveFileName($string, $Sextend = 0)
	$string = StringReplace($string, ':', '')
	$string = StringReplace($string, '\', '')
	$string = StringReplace($string, '/', '')
	$string = StringReplace($string, '*', '')
	$string = StringReplace($string, '?', '')
	$string = StringReplace($string, '"', '')
	$string = StringReplace($string, '<', '')
	$string = StringReplace($string, '>', '')
	$string = StringReplace($string, '|', '')
	$string = StringReplace($string, '"', '')
	$string = StringReplace($string, "’", '')
	$string = _ExtendedASCIIcharactersV2($string, $Sextend)
	$string = StringStripWS($string, 1 + 2 + 4)
	Return $string
EndFunc   ;==>_StringFicheFilm
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
Func _ADFunc_Files_FileGetFullNameByFullPath($sFullPath)
	Local $aFilename = StringSplit($sFullPath, '\')
	If Not @error Then Return $aFilename[$aFilename[0]]
	Return SetError(1)
EndFunc   ;==>_ADFunc_Files_FileGetFullNameByFullPath
Func _ADFunc_Files_FileGetFullNameByUrl($sFileUrl)
	Local $aFilename = StringSplit($sFileUrl, '/')
	If Not @error Then Return $aFilename[$aFilename[0]]
EndFunc   ;==>_ADFunc_Files_FileGetFullNameByUrl
Func _ADFunc_Array_ArrayAdd_2D(ByRef $avArray, $vValue, $x, $y)

	If $x > UBound($avArray) - 1 Then
		ReDim $avArray[$x + 1][UBound($avArray, 2)]
	EndIf

	If $y > UBound($avArray, 2) - 1 Then
		ReDim $avArray[UBound($avArray)][$y + 1]
	EndIf

	$avArray[$x][$y] = $vValue

	Return True
EndFunc   ;==>_ADFunc_Array_ArrayAdd_2D
Func _ASCIIDecode($Data)
	Local $Content
	$Content = $Data
;~ 	$Content = StringReplace($Content, '&lt;br&gt;', ' ')
	$Content = StringReplace($Content, '&lt;', '<')
	$Content = StringReplace($Content, '&gt;', '>')
	$Content = StringReplace($Content, '&nbsp;', ' ')
	$Content = StringReplace($Content, '&copy;', '©')
	$Content = StringReplace($Content, '&ldquo;', '"')
	$Content = StringReplace($Content, '&raquo;', '»')
	$Content = StringReplace($Content, '&laquo;', '«')
	$Content = StringReplace($Content, '&rdquo;', '"')
	$Content = StringReplace($Content, '&quot;', '"')
	$Content = StringReplace($Content, '&amp;', '&')
	$Content = StringReplace($Content, '&#149;', '•')
	$Content = StringReplace($Content, '&bull;', '•')
	$Content = StringReplace($Content, '&#8249;', '')
	$Content = StringReplace($Content, '&#8250;', '')
	$Content = StringReplace($Content, "&#8217;", "'")
	$Content = StringReplace($Content, "&#39;", "'")
	$Content = StringReplace($Content, '&#039;', "'")
	$Content = StringReplace($Content, '&ecirc;', "ê")
	$Content = StringReplace($Content, '^[', ' [')
	$Content = StringReplace($Content, ']^', ' ]')
	$Content = StringReplace($Content, ' , ', ', ')
	$Content = StringReplace($Content, ' : ', ': ')
	$Content = StringReplace($Content, ' . ', '. ')
	$Content = StringReplace($Content, ' ? ', '? ')
	$Content = StringReplace($Content, ' ! ', '! ')
	$Content = StringReplace($Content, ' ; ', '; ')
	$Content = StringReplace($Content, '<b>', '')
;~ 	$Content = StringReplace($Content, '<br>', @LF)
	$Content = StringReplace($Content, '</b>', '')
	$Content = StringReplace($Content, '&#222;', 'p')
	$Content = StringReplace($Content, '&#223;', 'b')
	$Content = StringReplace($Content, '&#243;', 'ó')
	$Content = StringReplace($Content, '%27s', "s")
	$Content = StringReplace($Content, '&#234', "ê")
	$Content = StringReplace($Content, '&#233;', "é")
	$Content = StringReplace($Content, '&#239;', "ï")
	$Content = StringReplace($Content, '&#232;', "è")
	$Content = StringReplace($Content, '&#251;', "û")
;~ 	$Content = StringReplace($Content, '&#233', "è")
	$Content = _ExtendedASCIIcharactersV2($Content, 1)
	$Content = StringStripWS($Content, 1 + 2 + 4)
	Return $Content
EndFunc   ;==>_ASCIIDecode
Func _URIEncode($urlText)
	Local $url = ""
	For $i = 1 To StringLen($urlText)
		$acode = Asc(StringMid($urlText, $i, 1))
		Select
			Case ($acode >= 48 And $acode <= 57) Or _
					($acode >= 65 And $acode <= 90) Or _
					($acode >= 97 And $acode <= 122)
				$url = $url & StringMid($urlText, $i, 1)
			Case $acode = 32
				$url = $url & "+"
			Case Else
				$url = $url & "%" & Hex($acode, 2)
		EndSelect
	Next
	Return $url
EndFunc   ;==>_URIEncode
Func _ANSI2UNICODE($sString = "")
	Return BinaryToString(StringToBinary($sString, 1), 4)
EndFunc   ;==>_ANSI2UNICODE
Func _ExtendedASCIIcharactersV2($Chr, $sMod = 0)
	Local $Arr[66][5] = [["á", "&aacute;", "&#225;", "Alt+0225", "a"], ["Á", "&Aacute;", "&#193;", "Alt+0193", "A"], ["â", "&acirc;", "&#226;", "Alt+0226", "a"], ["Â", "&Acirc;", "&#194;", "Alt+0194", "A"], ["à", "&agrave;", "&#224;", "Alt+0224", "a"], ["À", "&Agrave;", "&#192;", "Alt+0192", "A"], ["å", "&aring;", "&#229;", "Alt+0229", ""], ["Å", "&Aring;", "&#197;", "Alt+0197", ""], ["ã", "&atilde;", "&#227;", "Alt+0227", "a"], ["Ã", "&Atilde;", "&#195;", "Alt+0195", "A"], ["ä", "&auml;", "&#228;", "Alt+0228", "a"], ["Ä", "&Auml;", "&#196;", "Alt+0196", "A"], ["æ", "&aelig;", "&#230;", "Alt+0230", "æ"], ["Æ", "&AElig;", "&#198;", "Alt+0198", "AE"], ["ç", "&ccedil;", "&#231;", "Alt+0231", "c"], ["Ç", "&Ccedil;", "&#199;", "Alt+0199", "C"], ["é", "&eacute;", "&#233;", "Alt+0233", "e"], ["É", "&Eacute;", "&#201;", "Alt+0201", "e"], ["ê", "&ecirc;", "&#234;", "Alt+0234", "e"], ["Ê", "&Ecirc;", "&#202;", "Alt+0202", "E"], ["è", "&egrave;", "&#232;", "Alt+0232", "e"], ["È", "&Egrave;", "&#200;", "Alt+0200", "E"], ["ë", "&euml;", "&#235;", "Alt+0235", "e"], ["Ë", "&Euml;", "&#203;", "Alt+0203", "E"], ["í", "&iacute;", "&#237;", "Alt+0237", ""], ["Í", "&Iacute;", "&#205;", "Alt+0205", ""], ["î", "&icirc;", "&#238;", "Alt+0238", "i"], ["Î", "&Icirc;", "&#206;", "Alt+0206", "I"], ["ì", "&igrave;", "&#236;", "Alt+0236", ""], ["Ì", "&Igrave;", "&#204;", "Alt+0204", ""], ["ï", "&iuml;", "&#239;", "Alt+0239", "i"], ["Ï", "&Iuml;", "&#207;", "Alt+0207", "I"], ["ñ", "&ntilde;", "&#241;", "Alt+0241", "n"], ["Ñ", "&Ntilde;", "&#209;", "Alt+0209", "N"], ["ó", "&oacute;", "&#243;", "Alt+0243", ""], ["Ó", "&Oacute;", "&#211;", "Alt+0211", ""], ["ô", "&ocirc;", "&#244;", "Alt+0244", "o"], ["Ô", "&Ocirc;", "&#212;", "Alt+0212", "O"], ["ò", "&ograve;", "&#242;", "Alt+0242", "O"], ["Ò", "&Ograve;", "&#210;", "Alt+0210", "o"], ["ø", "&oslash;", "&#248;", "Alt+0248", "o"], ["Ø", "&Oslash;", "&#216;", "Alt+0216", "O"], ["õ", "&otilde;", "&#245;", "Alt+0245", ""], ["Õ", "&Otilde;", "&#213;", "Alt+0213", ""], ["ö", "&ouml;", "&#246;", "Alt+0246", "o"], ["Ö", "&Ouml;", "&#214;", "Alt+0214", "O"], ["œ", "&oelig;", "&#156;", "Alt+0156", "oe"], ["Œ", "&OElig;", "&#140;", "Alt+0140", "OE"], ["š", "&scaron;", "&#353;", "Alt+0253", ""], ["Š", "&Scaron;", "&#352;", "Alt+0252", ""], ["ß", "&szlig;", "&#223;", "Alt+0223", ""], ["ð", "&eth;", "&#240;", "Alt+0240", ""], ["Ð", "&ETH;", "&#208;", "Alt+0208", ""], ["þ", "&thorn;", "&#254;", "Alt+0254", "thorn"], ["Þ", "&THORN;", "&#222;", "Alt+0222", "Thorn"], ["ú", "&uacute;", "&#250;", "Alt+0250", ""], ["Ú", "&Uacute;", "&#218;", "Alt+0218", ""], ["û", "&ucirc;", "&#251;", "Alt+0251", "u"], ["Û", "&Ucirc;", "&#219;", "Alt+0219", "U"], ["ù", "&ugrave;", "&#249;", "Alt+0249", "u"], ["Ù", "&Ugrave;", "&#217;", "Alt+0217", "U"], ["ü", "&uuml;", "&#252;", "Alt+0252", "u"], ["Ü", "&Uuml;", "&#220;", "Alt+0220", "U"], ["ý", "&yacute;", "&#253;", "Alt+0253", ""], ["Ý", "&Yacute;", "&#221;", "Alt+0221", ""], ["ÿ", "&yuml;", "&#255;", "Alt+0255", "y"]]
	Local $Arr2[53][5] = [['"', "&quot;", "&#34;", "Alt+034", "Guillemet"], ["«", "&laquo;", "&#171;", "Alt+0171", "Guillemet"], ["»", "&raquo;", "&#187;", "Alt+0187", "Guillemet"], ["“", "&ldquo;", "&#8220;", "Alt+0147", "Guillemet"], ["”", "&rdquo;", "&#8221;", "Alt+0148", "Guillemet"], ["'", "&apos;", "&#39;", "Alt+039", "Guillemet"], ["‘", "&lsquo;", "&#8216;", "Alt+0145", "Guillemet"], ["’", "&rsquo;", "&#8217;", "Alt+0146", "Guillemet"], ["!", "!", "&#33;", "Alt+033", "Point"], ["¡", "&iexcl;", "&#161;", "Alt+173", "Point"], ["?", "?", "&#63;", "Alt+063", "Point"], ["¿", "&iquest;", "&#191;", "Alt+0191", "Point"], ["(", "(", "&#40;", "Alt+040", "Parenthése"], [")", ")", "&#41;", "Alt+041", "Parenthése"], ["[", "[", "&#91;", "Alt+091", "Crochet"], ["]", "]", "&#93;", "Alt+093", "Crochet"], ["{", "{", "&#123;", "Alt+0123", "Accolade"], ["}", "}", "&#125;", "Alt+0124", "Accolade"], ["¨", "&uml;", "&#168;", "Alt+0168", "Tréma"], ["´", "&acute;", "&#180;", "Alt+0180", "Accent"], ["`", "`", "&#96;", "Alt+096", "Accent"], ["^", "^", "&#94;", "Alt+094", "Accent"], ["~", "~", "&#126;", "Alt+0126", "Tilde"], ["¸", "&cedil;", "&#184;", "Alt+0184", "Cédille"], ["#", "#", "&#35;", "Alt+035", "Dièse"], ["*", "*", "&#42;", "Alt+042", "Etoile"], [",", ",", "&#44;", "Alt+044", "Virgule"], [".", ".", "&#46;", "Alt+046", "Point"], [":", ":", "&#58;", "Alt+058", "Deux-points"], [";", ";", "&#59;", "Alt+059", "Point-virgule"], ["·", "&middot;", "&#183;", "Alt+0183", "Point"], ["•", "&bull;", "&#8226;", "Alt+7", "Gros"], ["¯", "&macr;", "&#175;", "Alt+0175", "Macron"], ["-", "-", "&#45;", "Alt+045", "Tiret"], ["_", "_", "&#95;", "Alt+095", "Tiret"], ["|", "|", "&#124;", "Alt+0124", "Séparateur"], ["¦", "&brvbar;", "&#166;", "Alt+0166", "Barre"], ["§", "&sect;", "&#167;", "Alt+0167", "Section"], ["¶", "&para;", "&#182;", "Alt+0182", "Paragraphe"], ["©", "&copy;", "&#169;", "Alt+0169", "Copyright"], ["®", "&reg;", "&#174;", "Alt+0174", "Marque"], ["&", "&amp;", "&#38;", "Alt+038", "Et"], ["@", "@", "&#64;", "Alt+064", "Arobase"], ["/", "/", "&#47;", "Alt+047", "Slash"], ["\", "", "\", "&#92;", "Alt+092"], ["?", "&spades;", "&#9824;", "Alt+6", "Pique"], ["?", "&clubs;", "&#9827;", "Alt+5", "Trèfle"], ["?", "&hearts;", "&#9829;", "Alt+3", "Cœur"], ["?", "&larr;", "&#8592;", "Alt+27", "Flèche"], ["?", "&uarr;", "&#8593;", "Alt+24", "Flèche"], ["?", "&rarr;", "&#8594;", "Alt+26", "Flèche"], ["?", "&darr;", "&#8595;", "Alt+25", "Flèche"], ["?", "&harr;", "&#8596;", "Alt+29", "Flèche"]]
	Switch $sMod
		Case 0 ; &#233
			For $i = 0 To UBound($Arr) - 1
				$Chr = StringReplace($Chr, $Arr[$i][0], $Arr[$i][4])
			Next
		Case 1 ; &#233
			For $i = 0 To UBound($Arr) - 1
				$Chr = StringReplace($Chr, $Arr[$i][2], $Arr[$i][0])
			Next
;~ 			For $i = 0 To UBound($Arr2) - 1
;~ 				$Chr = StringReplace($Chr, $Arr2[$i][1], $Arr2[$i][0])
;~ 			Next
		Case 3 ; &#233
			For $i = 0 To UBound($Arr) - 1
				$Chr = StringReplace($Chr, $Arr[$i][0], $Arr[$i][4])
			Next
			For $i = 0 To UBound($Arr2) - 1
				$Chr = StringReplace($Chr, $Arr2[$i][0], '')
			Next

	EndSwitch
	Return $Chr

EndFunc   ;==>_ExtendedASCIIcharactersV2
Func _ScaleImage($sInFile, $sOutFile, $iOutWidth, $iOutHeight, $iCrop = 1, $quality = 50, $sFormat = 'JPG')

	Local $hInHandle, $iInWidth, $iInHeight, $iRatio, $hOutHandle, $hGraphic, $CLSID, $iInX = 0, $iInY = 0
	Local $sRet

	_GDIPlus_Startup()

	$hInHandle = _GDIPlus_ImageLoadFromFile($sInFile)
	If $hInHandle = 0 Then Return SetError(1)
	$iInWidth = _GDIPlus_ImageGetWidth($hInHandle)
	$iInHeight = _GDIPlus_ImageGetHeight($hInHandle)

	If $iCrop = 1 Then
		If $iOutWidth / $iInWidth > $iOutHeight / $iInHeight Then
			$iRatio = $iOutWidth / $iInWidth
		Else
			$iRatio = $iOutHeight / $iInHeight
		EndIf
		$iInX = Int(($iInWidth - $iOutWidth / $iRatio) / 2)
		$iInY = Int(($iInHeight - $iOutHeight / $iRatio) / 4)
		$iInWidth = Int($iOutWidth / $iRatio)
		$iInHeight = Int($iOutHeight / $iRatio)
	Else
		If $iOutWidth / $iInWidth < $iOutHeight / $iInHeight Then
			$iRatio = $iOutWidth / $iInWidth
		Else
			$iRatio = $iOutHeight / $iInHeight
		EndIf
		If $iRatio > 1 Then
			$iRatio = 1
		EndIf
		$iOutWidth = Int($iInWidth * $iRatio)
		$iOutHeight = Int($iInHeight * $iRatio)
	EndIf

	$hOutHandle = _GDIPlus_BitmapCreateFromScan0($iOutWidth, $iOutHeight)
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hOutHandle)
	_GDIPlus_GraphicsDrawImageRectRect($hGraphic, $hInHandle, $iInX, $iInY, $iInWidth, $iInHeight, 0, 0, $iOutWidth, $iOutHeight)
	$CLSID = _GDIPlus_EncodersGetCLSID($sFormat)
	$tParams = _GDIPlus_ParamInit(1)
	$tData = DllStructCreate("int Quality")
	DllStructSetData($tData, "Quality", $quality) ;quality 0-100
	$pData = DllStructGetPtr($tData)
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, $pData)
	$pParams = DllStructGetPtr($tParams)
	_GDIPlus_ImageSaveToFileEx($hOutHandle, $sOutFile, $CLSID, $pParams)
;~ 	If @error Then Return SetError(1)
	_GDIPlus_ImageDispose($hInHandle)
	_GDIPlus_BitmapDispose($hOutHandle)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
EndFunc   ;==>_ScaleImage
Func __FileGetFullNameByUrl($sFileUrl)
	Local $aFilename = StringSplit($sFileUrl, '=')
	If Not @error Then Return $aFilename[$aFilename[0]]
EndFunc   ;==>__FileGetFullNameByUrl
