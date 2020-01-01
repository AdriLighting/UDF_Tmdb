#include-Once
#include <_TMDb_Required.au3>

; #CURRENT# =====================================================================================================================
; _TMDb_GetListByClassment
; _TMDb_FilmSearch
; _TMDb_FilmID_GetDetails
; _TMDb_FilmID_GetImages
; _TMDb_FilmID_GetVideos
; _TMDb_FilmID_GetDetailByKey
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; _TMDb_FilmSearch_Display
; _TMDb_FilmSearch_SavToIni
; _TMDb_FilmID_GetDetails_Display
; _TMDb_FilmID_GetDetails_SavToIni
; _TMDb_FilmID_GetImages_SavToIni
; _TMDb_FilmID_GetVideos_Display
; _TMDb_FilmID_GetVideos_SavToIni
; _TMDb_FilmSearch_GetDetails
; _TMDb_FilmSearch_Create2DArray
; _TMDb_FilmSearch_GetColCount
; _TMDb_StringLR
; _TMDb_StringJson_Genre
; _TMDb_JsonRead_V1
; _EncodeToUrl
; ===============================================================================================================================

Global $_TMDb_ApiKey = "6137480d1f5c743c3fa069c9929c0f01"

; #GLOBAL CONSTANTS KEY# ========================================================================================================
Global $TMDb_ArrAy_RF[11][2] = [["vote_count", ""], ["id", ""], ["vote_average", ""], _ ; Key pour la recherche des films
		["title", ""], ["popularity", ""], ["poster_path", ""], _
		["original_language", ""], ["original_title", ""], ["backdrop_path", ""], _
		["overview", ""], ["release_date", ""]]
Global Const $TMDb_ArrAy_RF_Id = 1
Global Const $TMDb_ArrAy_RF_Title = 3
Global $TMDb_ArrAy_RFD[15][2] = [["backdrop_path", ""], ["homepage", ""], ["imdb_id", ""], _ ; Key pour la recherche des details film
		["original_language", ""], ["original_title", ""], ["overview", ""], _
		["popularity", ""], ["poster_path", ""], ["release_date", ""], _
		["runtime", ""], ["status", ""], ["title", ""], _
		["vote_average", ""], ["vote_count", ""], ["genres", ""]]
Global Const $TMDb_ArrAy_RFD_Background = 0
Global Const $TMDb_ArrAy_RFD_Webpage = 1
Global Const $TMDb_ArrAy_RFD_IMDbs = 2
Global Const $TMDb_ArrAy_RFD_Jacket = 7
Global Const $TMDb_ArrAy_RFD_Rdate = 8
Global Const $TMDb_ArrAy_RFD_Dure = 9
Global Const $TMDb_ArrAy_RFD_Statu = 10
Global Const $TMDb_ArrAy_RFD_Title = 11
Global Const $TMDb_ArrAy_RFD_Genre = 14
Global $TMDb_ArrAy_RV[8][2] = [["id", ""], ["iso_639_1", ""], ["iso_3166_1", ""], _ ; Key pour la recherche des videos
		["key", ""], ["name", ""], ["site", ""], _
		["size", ""], ["type", ""]]
Global Const $TMDb_ArrAy_RV_Key = 3
Global Const $TMDb_ArrAy_RV_Name = 4
Global Const $TMDb_ArrAy_RV_Site = 5
; ===============================================================================================================================


; #FONCTIONS# ===================================================================================================================

Func _TMDb_GetListByClassment(ByRef $aArraySBC, $aMaxPage = 1, $aType = 'top_rated', $sOutFilePath = @ScriptDir & '\TMDb_ListByClassment.txt')
	If FileExists($sOutFilePath) Then FileDelete($sOutFilePath)

	Local $api
	Local $NbrPage = 1
	If $aMaxPage > 1 Then
		For $j = 1 To $aMaxPage
			Local $api = "https://api.themoviedb.org/3/movie/" & $aType & "?api_key=6137480d1f5c743c3fa069c9929c0f01&language=fr-FR&page=" & $NbrPage

			_ADFunc_Inet_InetGet($api, @ScriptDir & '\Temp' & $NbrPage & '.txt')

			$NbrPage += 1
		Next
		$NbrPage = 1
		Local $FW
		For $j = 1 To $aMaxPage
			$FW &= FileReadLine(@ScriptDir & '\Temp' & $NbrPage & '.txt', 1) & ' '
			$NbrPage += 1
		Next
		FileWrite($sOutFilePath, $FW)
		$NbrPage = 1
		For $j = 1 To $aMaxPage
			FileDelete(@ScriptDir & '\Temp' & $NbrPage & '.txt')
			$NbrPage += 1
		Next
	Else
		$api = "https://api.themoviedb.org/3/movie/" & $aType & "?api_key=" & $_TMDb_ApiKey & "&language=fr-FR&page=" & $NbrPage
		_ADFunc_Inet_InetGet($api, $sOutFilePath)
	EndIf
	If Not FileExists($sOutFilePath) Then Return SetError(1)

	Local $FR = FileReadLine($sOutFilePath, 1)
	FileDelete($sOutFilePath)
	Local $count = _TMDb_FilmSearch_GetColCount($FR)
	If $count = 0 Then Return SetError(1)

	Dim $TempArray2d[$count][UBound($aArraySBC)]
	For $i = 0 To UBound($aArraySBC) - 1
		$JR = _TMDb_JsonRead_V1($FR, $aArraySBC[$i][0])
		_TMDb_FilmSearch_Create2DArray($JR, $TempArray2d, $i)
	Next
	If UBound($TempArray2d) = 0 Then Return SetError(1)
	Return $TempArray2d
EndFunc   ;==>_TMDb_GetListByClassment
;	Fair une recherche d'un film et rechercher les infos des films trouver
;	Retun FilmInfos in 2D Array
Func _TMDb_FilmSearch(ByRef $aArraySF, $aSearch, $sOutFilePath = @ScriptDir & '\TMDb_Search.txt')
	If FileExists($sOutFilePath) Then FileDelete($sOutFilePath)

	Local $api = "https://api.themoviedb.org/3/search/movie?api_key="& $_TMDb_ApiKey & "&query=" & _EncodeToUrl($aSearch)

	_ADFunc_Inet_InetGet($api, $sOutFilePath)
	If Not FileExists($sOutFilePath) Then Return SetError(1)

	Local $FR = FileReadLine($sOutFilePath, 1)
	FileDelete($sOutFilePath)
	Local $count = _TMDb_FilmSearch_GetColCount($FR)
	If $count = 0 Then Return SetError(1)
	Dim $TempArray2d[$count][UBound($aArraySF)]
	For $i = 0 To UBound($aArraySF) - 1
		$JR = _TMDb_JsonRead_V1($FR, $aArraySF[$i][0])
		_TMDb_FilmSearch_Create2DArray($JR, $TempArray2d, $i)
	Next
	If UBound($TempArray2d) = 0 Then Return SetError(1)
	Return $TempArray2d
EndFunc   ;==>_TMDb_FilmSearch
;Return Array2D : 0 = title, 1 = id, 3 = Array FilmDetail
Func _TMDb_FilmSearch_GetDetails(ByRef $aArrAySG, ByRef $aArraySGF, $ArrayDisplay = False)
	ProgressOn("Chargements en cour", "Chargements en cour, Veuillez patientez", '0%')
	Local $id, $title
	Local $sRet[UBound($aArraySGF)][3]
	Local $Total = UBound($aArraySGF)
	For $i = 0 To UBound($aArraySGF) - 1
		ProgressSet(Int($i * 100 / $Total), Int($i * 100 / $Total) & "%")
		$id = $aArraySGF[$i][$TMDb_ArrAy_RF_Id]
		$title = $aArraySGF[$i][$TMDb_ArrAy_RF_Title]
		$film = _TMDb_FilmID_GetDetails($aArrAySG, $id)
		$sRet[$i][0] = $title
		$sRet[$i][1] = $id
		$sRet[$i][2] = $film
		If $ArrayDisplay Then _ADFunc_Divers_Upd(1, $title & ' - ' & $id)
		If $ArrayDisplay Then _ADFunc_Divers_Upd(1, $film, '', 0, 0, 1)
	Next
	ProgressOff()
	Return $sRet
EndFunc   ;==>_TMDb_FilmSearch_GetDetails
Func _TMDb_FilmSearch_Create2DArray(ByRef $aArray, ByRef $aArray2D, $aItem)
	For $A = 0 To UBound($aArray) - 1
		$aArray2D[$A][$aItem] = _TMDb_StringLR($aArray[$A])
	Next
EndFunc   ;==>_TMDb_FilmSearch_Create2DArray
Func _TMDb_FilmSearch_GetColCount($aFile, $aSearch = "id")
	$array = StringRegExp($aFile, '"' & $aSearch & '":(.*?),"', 3)
	Return UBound($array)
EndFunc   ;==>_TMDb_FilmSearch_GetColCount
Func _TMDb_FilmSearch_Display(ByRef $aArray, $aGuiTitle = "TMDb - Result Search") ; Array2D : 0 = title, 1 = id, 2 = Array FilmDetail
	Local $GUI_Lbl[20]
	Local $GUI_Inp[20]
	Local $mGui = GUICreate($aGuiTitle, 520, (20 * 25) + 80)
	Local $GUI_Cmb = GUICtrlCreateCombo("", 5, 16, 505, 25)
	Local $sCmbData = ''

	For $i = 0 To UBound($aArray) - 1
		$sCmbData &= $aArray[$i][0] & ' ' & $aArray[$i][1] & '|'
	Next
	GUICtrlSetData($GUI_Cmb, $sCmbData, $aArray[0][0] & ' ' & $aArray[0][1])
	Local $sTop = 45
	GUICtrlCreateLabel('TMDb Id', 5, $sTop, 150, 20)
	Local $GUI_InpID = GUICtrlCreateInput('', 160, $sTop, 350, 20)
	$sTop += 25
	For $i = 0 To UBound($GUI_Lbl) - 1
		$GUI_Lbl[$i] = GUICtrlCreateLabel('', 5, $sTop, 150, 20)
		$GUI_Inp[$i] = GUICtrlCreateInput('', 160, $sTop, 350, 20)
		$sTop += 25
	Next
	GUISetState(@SW_SHOW)
	Local $TMDb
	Local $sArrD = $aArray[0][2]


	Local $sSplit
	Local $sDiff
	GUICtrlSetData($GUI_InpID, $aArray[0][1])
	For $j = 0 To UBound($GUI_Lbl) - 1
		If $j >= UBound($sArrD) Then
			GUICtrlSetData($GUI_Lbl[$j], '')
			GUICtrlSetData($GUI_Inp[$j], '')
		Else
			Switch $sArrD[$j][0]
				Case 'genres'
					$sSplit = $sArrD[$j][1]
					$sSplit = _TMDb_StringJson_Genre($sSplit)
					GUICtrlSetData($GUI_Inp[$j], $sSplit)
				Case 'release_date'
					If StringInStr($sArrD[$j][1], '"') Then
						$sSplit = StringSplit($sArrD[$j][1], '"')[1]
						GUICtrlSetData($GUI_Inp[$j], $sSplit)
					Else
						GUICtrlSetData($GUI_Inp[$j], $sArrD[$j][1])
					EndIf
				Case 'backdrop_path', 'poster_path'
					GUICtrlSetData($GUI_Inp[$j], "https://image.tmdb.org/t/p/original" & $sArrD[$j][1])

				Case Else
					GUICtrlSetData($GUI_Inp[$j], $sArrD[$j][1])
			EndSwitch
			If $j > 0 Then
				If $sArrD[$j - 1][0] = $sArrD[$j][0] Then
					$sDiff = StringRight($sArrD[$j][0], 1)
					If IsNumber($sDiff) Then
						$sDiff += 1
						$sDiff = ' ' & $sDiff
					Else
						$sDiff = ' ' & 2
					EndIf
					GUICtrlSetData($GUI_Lbl[$j], $sArrD[$j][0] & $sDiff)
					$sDiff = ''
				Else
					GUICtrlSetData($GUI_Lbl[$j], $sArrD[$j][0])
				EndIf
			Else
				GUICtrlSetData($GUI_Lbl[$j], $sArrD[$j][0])
			EndIf
		EndIf
	Next
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_Cmb
				Local $sDiff = ""
				For $i = 0 To UBound($aArray) - 1
					If GUICtrlRead($GUI_Cmb) = $aArray[$i][0] & ' ' & $aArray[$i][1] Then
						$sArrD = $aArray[$i][2]
						GUICtrlSetData($GUI_InpID, $aArray[$i][1])
						If UBound($sArrD) < 3 Then
							ConsoleWrite($aArray[$i][0] & @LF)
							$TMDb = _TMDb_FilmID_GetDetails($TMDb_ArrAy_RFD, $aArray[$i][1])
							If Not @error Then
								$sArrD = $TMDb
							EndIf
						EndIf
						For $j = 0 To UBound($GUI_Inp) - 1
							If $j >= UBound($sArrD) Then
								GUICtrlSetData($GUI_Lbl[$j], '')
								GUICtrlSetData($GUI_Inp[$j], '')
							Else
								Switch $sArrD[$j][0]
									Case 'genres'
										$sSplit = $sArrD[$j][1]
										$sSplit = _TMDb_StringJson_Genre($sSplit)
										GUICtrlSetData($GUI_Inp[$j], $sSplit)
									Case 'release_date'
										If StringInStr($sArrD[$j][1], '"') Then
											$sSplit = StringSplit($sArrD[$j][1], '"')[1]
											GUICtrlSetData($GUI_Inp[$j], $sSplit)
										Else
											GUICtrlSetData($GUI_Inp[$j], $sArrD[$j][1])
										EndIf
									Case 'backdrop_path', 'poster_path'
										GUICtrlSetData($GUI_Inp[$j], "https://image.tmdb.org/t/p/original" & $sArrD[$j][1])
									Case Else
										GUICtrlSetData($GUI_Inp[$j], $sArrD[$j][1])
								EndSwitch
								If $j > 0 Then
									If $sArrD[$j - 1][0] = $sArrD[$j][0] Then
										$sDiff = StringRight($sArrD[$j][0], 1)
										If IsNumber($sDiff) Then
											$sDiff += 1
											$sDiff = ' ' & $sDiff
										Else
											$sDiff = ' ' & 2
										EndIf
										GUICtrlSetData($GUI_Lbl[$j], $sArrD[$j][0] & $sDiff)
										$sDiff = ''
									Else
										GUICtrlSetData($GUI_Lbl[$j], $sArrD[$j][0])
									EndIf
								Else
									GUICtrlSetData($GUI_Lbl[$j], $sArrD[$j][0])
								EndIf
							EndIf
						Next
					EndIf
				Next
			Case $GUI_EVENT_CLOSE
				GUIDelete($mGui)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_TMDb_FilmSearch_Display
Func _TMDb_FilmSearch_SavToIni(ByRef $aArray, $aIni = @ScriptDir & '\TMDb_SearchFilm.ini') ; Array2D : 0 = title, 1 = id, 2 = Array FilmDetail
	Local $sDiff = ""
	Local $sKey = ""
	Local $sVal = ""
	Local $sSection = ""
	For $i = 0 To UBound($aArray) - 1
		$sSection = $aArray[$i][1]
		$sArrD = $aArray[$i][2]
		IniWrite($aIni, $sSection, 'TMDb Id', $aArray[$i][1])
		$sKey = ""
		$sVal = ""
		For $j = 0 To UBound($sArrD) - 1
			Switch $sArrD[$j][0]
				Case 'genres'
					$sSplit = $sArrD[$j][1]
					$sSplit = _TMDb_StringJson_Genre($sSplit)
					$sVal = $sSplit
				Case 'release_date'
					If StringInStr($sArrD[$j][1], '"') Then
						$sSplit = StringSplit($sArrD[$j][1], '"')[1]
						$sVal = $sSplit
					Else
						$sVal = $sArrD[$j][1]
					EndIf
				Case 'backdrop_path', 'poster_path'
					$sVal = "https://image.tmdb.org/t/p/original" & $sArrD[$j][1]
				Case Else
					$sVal = $sArrD[$j][1]
			EndSwitch
			If $j > 0 Then
				If $sArrD[$j - 1][0] = $sArrD[$j][0] Then
					$sDiff = StringRight($sArrD[$j][0], 1)
					If IsNumber($sDiff) Then
						$sDiff += 1
						$sDiff = ' ' & $sDiff
					Else
						$sDiff = ' ' & 2
					EndIf
					$sKey = $sArrD[$j][0] & $sDiff
					$sDiff = ''
				Else
					$sKey = $sArrD[$j][0]
				EndIf
			Else
				$sKey = $sArrD[$j][0]
			EndIf
			If $sVal <> '' Then IniWrite($aIni, $sSection, $sKey, $sVal)
		Next
	Next
	Local $TMDb
	Local $aIrSN = IniReadSectionNames($aIni)
	For $i = 1 To UBound($aIrSN) - 1
		$aIrS = IniReadSection($aIni, $aIrSN[$i])
		If UBound($aIrS) < 3 Then
			$TMDb = _TMDb_FilmID_GetDetails($TMDb_ArrAy_RFD, $aIrSN[$i])
			If Not @error Then
				_TMDb_FilmID_GetDetails_SavToIni($TMDb, $aIrSN[$i], $aIni)
			EndIf
		EndIf
	Next
EndFunc   ;==>_TMDb_FilmSearch_SavToIni
Func _TMDb_FilmID_GetDetailByKey($aKey, $aFilmId, $sOutFilePath = @ScriptDir & '\TMDb_FilmID.txt')
	If FileExists($sOutFilePath) Then FileDelete($sOutFilePath)
	Local $sApiUrl = "https://api.themoviedb.org/3/movie/" & $aFilmId & "?api_key=" & $_TMDb_ApiKey & "&language=fr-FR"
	_ADFunc_Inet_InetGet($sApiUrl, $sOutFilePath)
	If Not FileExists($sOutFilePath) Then Return SetError(1)
	Local $sFR = FileReadLine($sOutFilePath, 1)
	FileDelete($sOutFilePath)
	Local $sStringLR
	$JR = _TMDb_JsonRead_V1($sFR, $aKey)
	$sStringLR = _TMDb_StringLR($JR[0])
	Return $sStringLR
EndFunc   ;==>_TMDb_FilmID_GetDetailByKey
;	Rechercher les infos d'un film avec l'id d'un film
;	Retun FilmInfos in Array2D : 0 = Value Name, 1 = Value
Func _TMDb_FilmID_GetDetails(ByRef $aArray, $aFilmId, $sOutFilePath = @ScriptDir & '\TMDb_FilmID.txt')
	If FileExists($sOutFilePath) Then FileDelete($sOutFilePath)
	Local $sApiUrl = "https://api.themoviedb.org/3/movie/" & $aFilmId & "?api_key=" & $_TMDb_ApiKey & "&language=fr-FR"
	_ADFunc_Inet_InetGet($sApiUrl, $sOutFilePath)
	If Not FileExists($sOutFilePath) Then Return SetError(1)
	Local $sFR = FileReadLine($sOutFilePath, 1)
	FileDelete($sOutFilePath)
	Local $sDataName
	Local $sStringLR
	Dim $sRet[0][2]
	For $i = 0 To UBound($aArray) - 1
		$JR = _TMDb_JsonRead_V1($sFR, $aArray[$i][0])
		$sDataName = $aArray[$i][0]
		For $j = 0 To UBound($JR) - 1
			$sStringLR = _TMDb_StringLR($JR[$j])
			_ArrayAdd($sRet, $sDataName & '|' & $sStringLR)
		Next
	Next
	Return $sRet
EndFunc   ;==>_TMDb_FilmID_GetDetails
Func _TMDb_FilmID_GetDetails_Display(ByRef $aArray, $aFilmId) ; Array2D : 0 = Value Name, 1 = Value
	Local $GUI_Lbl[UBound($aArray)]
	Local $GUI_Inp[UBound($aArray)]
	Local $mGui = GUICreate("TMDb - FilmId " & $aFilmId, 520, (UBound($aArray) * 25) + 45)
	Local $sTop = 16
	GUICtrlCreateLabel('FilmId', 5, $sTop, 150, 20)
	Local $GUI_InpID = GUICtrlCreateInput('', 160, $sTop, 350, 20)
	$sTop += 25
	For $i = 0 To UBound($GUI_Lbl) - 1
		$GUI_Lbl[$i] = GUICtrlCreateLabel('', 5, $sTop, 150, 20)
		$GUI_Inp[$i] = GUICtrlCreateInput('', 160, $sTop, 350, 20)
		$sTop += 25
	Next
	GUISetState(@SW_SHOW)
	GUICtrlSetData($GUI_InpID, $aFilmId)
	For $j = 0 To UBound($aArray) - 1
		Switch $aArray[$j][0]
			Case 'release_date'
				If StringInStr($aArray[$j][1], '"') Then
					$sSplit = StringSplit($aArray[$j][1], '"')[1]
					GUICtrlSetData($GUI_Inp[$j], $sSplit)
				Else
					GUICtrlSetData($GUI_Inp[$j], $aArray[$j][1])
				EndIf
			Case 'genres'
				Local $sSplit = $aArray[$j][1]
				$sSplit = _TMDb_StringJson_Genre($sSplit)
				GUICtrlSetData($GUI_Inp[$j], $sSplit)
			Case 'backdrop_path', 'poster_path'
				GUICtrlSetData($GUI_Inp[$j], "https://image.tmdb.org/t/p/original" & $aArray[$j][1])
			Case Else
				GUICtrlSetData($GUI_Inp[$j], $aArray[$j][1])
		EndSwitch
		If $j > 0 Then
			If $aArray[$j - 1][0] = $aArray[$j][0] Then
				$sDiff = StringRight($aArray[$j][0], 1)
				If IsNumber($sDiff) Then
					$sDiff += 2
					$sDiff = ' ' & $sDiff
				Else
					$sDiff = ' ' & 2
				EndIf
				GUICtrlSetData($GUI_Lbl[$j], $aArray[$j][0] & $sDiff)
				$sDiff = ''
			Else
				GUICtrlSetData($GUI_Lbl[$j], $aArray[$j][0])
			EndIf
		Else
			GUICtrlSetData($GUI_Lbl[$j], $aArray[$j][0])
		EndIf
	Next
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($mGui)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_TMDb_FilmID_GetDetails_Display
Func _TMDb_FilmID_GetDetails_SavToIni(ByRef $aArray, $aFilmId, $aIni = @ScriptDir & '\TMDb_FilmID_Details.ini') ; Array2D : 0 = Value Name, 1 = Value
	Local $sKey
	Local $sVal
	Local $sSection
	For $j = 0 To UBound($aArray) - 1
		If $j > 0 Then
			If $aArray[$j - 1][0] = $aArray[$j][0] Then
				$sDiff = StringRight($aArray[$j][0], 1)
				If IsNumber($sDiff) Then
					$sDiff += 2
					$sDiff = ' ' & $sDiff
				Else
					$sDiff = ' ' & 2
				EndIf
				$sKey = $aArray[$j][0] & $sDiff
				$sDiff = ''
			Else
				$sKey = $aArray[$j][0]
			EndIf
		Else
			$sKey = $aArray[$j][0]
		EndIf
		Switch $aArray[$j][0]
			Case 'release_date'
				If StringInStr($aArray[$j][1], '"') Then
					$sSplit = StringSplit($aArray[$j][1], '"')[1]
					$sVal = $sSplit
				Else
					$sVal = $aArray[$j][1]
				EndIf
			Case 'genres'
				Local $sSplit = $aArray[$j][1]
				$sSplit = _TMDb_StringJson_Genre($sSplit)
				$sVal = $sSplit
			Case 'backdrop_path', 'poster_path'
				$sVal = "https://image.tmdb.org/t/p/original" & $aArray[$j][1]
			Case Else
				$sVal = $aArray[$j][1]
		EndSwitch
		IniWrite($aIni, $aFilmId, $sKey, $sVal)
	Next
EndFunc   ;==>_TMDb_FilmID_GetDetails_SavToIni
Func _TMDb_FilmID_GetVideos(ByRef $aArray, $aFilmId, $sOutFilePath = @ScriptDir & '\TMDb_FilmID_GetVideos.txt')
	If FileExists($sOutFilePath) Then FileDelete($sOutFilePath)

	Local $api = "https://api.themoviedb.org/3/movie/" & $aFilmId & "/videos?api_key=" & $_TMDb_ApiKey & "&language=fr-FR"

	_ADFunc_Inet_InetGet($api, $sOutFilePath)
	If Not FileExists($sOutFilePath) Then Return SetError(1)

	Local $FR = FileReadLine($sOutFilePath, 1)
	FileDelete($sOutFilePath)

	$FR = StringReplace($FR, '{"id":' & $aFilmId & ',"results":', '')

	Local $count = _TMDb_FilmSearch_GetColCount($FR)
	If $count = 0 Then Return SetError(1)
	Dim $TempArray2d[$count][UBound($aArray)]
	For $i = 0 To UBound($aArray) - 1
		$JR = _TMDb_JsonRead_V1($FR, $aArray[$i][0])
		_TMDb_FilmSearch_Create2DArray($JR, $TempArray2d, $i)
	Next
	If UBound($TempArray2d) = 0 Then Return SetError(1)

	Return $TempArray2d
EndFunc   ;==>_TMDb_FilmID_GetVideos
Func _TMDb_FilmID_GetVideos_Display(ByRef $aArray, ByRef $aArrayData, $id)
	Local $GUI_Lbl[UBound($aArrayData)]
	Local $GUI_Inp[UBound($aArrayData)]
	Local $mGui = GUICreate("TMDb - SearchVideos For FilmId " & $id, 520, (UBound($aArrayData) * 25) + 80)
	Local $GUI_Cmb = GUICtrlCreateCombo("", 5, 16, 505, 25)
	Local $sCmbData = ''
	For $i = 0 To UBound($aArray) - 1
		$sCmbData &= $aArray[$i][$TMDb_ArrAy_RV_Name] & '|'
	Next
	GUICtrlSetData($GUI_Cmb, $sCmbData, $aArray[0][$TMDb_ArrAy_RV_Name])
	Local $sTop = 45
	GUICtrlCreateLabel('FilmId', 5, $sTop, 150, 20)
	Local $GUI_InpID = GUICtrlCreateInput($id, 160, $sTop, 350, 20)
	$sTop += 25
	For $i = 0 To UBound($GUI_Lbl) - 1
		$GUI_Lbl[$i] = GUICtrlCreateLabel($aArrayData[$i][0], 5, $sTop, 150, 20)
		$GUI_Inp[$i] = GUICtrlCreateInput('', 160, $sTop, 350, 20)
		$sTop += 25
	Next
	GUISetState(@SW_SHOW)
	For $j = 0 To UBound($aArray, 2) - 1
		GUICtrlSetData($GUI_Inp[$j], $aArray[0][$j])
	Next
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_Cmb
				For $i = 0 To UBound($aArray) - 1
					If GUICtrlRead($GUI_Cmb) = $aArray[$i][$TMDb_ArrAy_RV_Name] Then
						For $j = 0 To UBound($aArray, 2) - 1
							GUICtrlSetData($GUI_Inp[$j], $aArray[$i][$j])
						Next
					EndIf
				Next
			Case $GUI_EVENT_CLOSE
				GUIDelete($mGui)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_TMDb_FilmID_GetVideos_Display
Func _TMDb_FilmID_GetVideos_SavToIni(ByRef $aArray, $aFilmId, $sIni = @ScriptDir & '\TMDb_FilmID_GetVideos.ini')
	Local $sVal = ''
	Local $sVal2 = ''
	Local $sKey = ''
	Local $sSection = ''
	For $i = 0 To UBound($aArray) - 1
		$sSection = $aArray[$i][$TMDb_ArrAy_RV_Name]
		For $j = 0 To UBound($aArray, 2) - 1
			$sVal = $aArray[$i][$TMDb_ArrAy_RV_Key]
			$sVa2 = $aArray[$i][$TMDb_ArrAy_RV_Site]
			Switch $sVa2
				Case 'YouTube'
					IniWrite($sIni, $aFilmId, $sSection, "https://www.youtube.com/watch?v=" & $sVal)
				Case Else
					IniWrite($sIni, $aFilmId, $sSection, $sVal & '|' & $sVa2)
			EndSwitch
		Next
	Next
EndFunc   ;==>_TMDb_FilmID_GetVideos_SavToIni
;	Rechercher les Images d'un film avec l'id d'un film
;	Retun 2 1d array , 1st = poster, 2st = backdrops
Func _TMDb_FilmID_GetImages($aFilmId, $sOutFilePath = @ScriptDir & '\TMDb_GetImages.txt')
	If FileExists($sOutFilePath) Then FileDelete($sOutFilePath)
	Local $sApiUrl = "https://api.themoviedb.org/3/movie/" & $aFilmId & "/images?api_key=" & $_TMDb_ApiKey
	_ADFunc_Inet_InetGet($sApiUrl, $sOutFilePath, '', False)
	If Not FileExists($sOutFilePath) Then Return SetError(1)
	Local $sFR = FileReadLine($sOutFilePath, 1)
	FileDelete($sOutFilePath)
	Dim $sRet[2]
	Local $sSB1 = _StringBetween($sFR, '"backdrops":[', ',"posters":[')
	If UBound($sSB1) > 0 Then
		$sSB1 = _StringBetween($sSB1[0], '"file_path":"', '",')
		If UBound($sSB1) > 0 Then $sRet[1] = $sSB1
	EndIf
	Local $sSB2 = _StringBetween($sFR, ',"posters":[', ']}')
	If UBound($sSB2) > 0 Then
		$sSB2 = _StringBetween($sSB2[0], '"file_path":"', '",')
		If UBound($sSB2) > 0 Then
			$sRet[0] = $sSB2
		EndIf
	EndIf
	Return $sRet
EndFunc   ;==>_TMDb_FilmID_GetImages
Func _TMDb_FilmID_GetImages_SavToIni(ByRef $aArray, $aFilmId, $aVal, $sIni = @ScriptDir & '\TMDb_FilmID_GetImages.ini')
	For $i = 0 To UBound($aArray) - 1
		IniWrite($sIni, $aFilmId, 'https://image.tmdb.org/t/p/original' & $aArray[$i], $aVal)
	Next
EndFunc   ;==>_TMDb_FilmID_GetImages_SavToIni
; ===============================================================================================================================
Func _TMDb_StringLR($sString)
	If StringLeft($sString, 1) = '"' Then $sString = StringTrimLeft($sString, 1)
	If StringRight($sString, 1) = '"' Then $sString = StringTrimRight($sString, 1)
	If StringRight($sString, 2) = '"}' Then $sString = StringTrimRight($sString, 2)
	Return $sString
EndFunc   ;==>_StringLR
Func _TMDb_StringJson_Genre($string)
	If StringLeft($string, 6) = '[{"id"' Then
		If StringRight($string, 1) <> ',' Then $string = $string & '"}'
		$string = _StringBetween($string, '"name":"', '"')
		Local $sDataInp = ''
		For $K = 0 To UBound($string) - 1
			$sDataInp &= $string[$K] & ' '
		Next
		$string = $sDataInp
	Else
		$string = ''
	EndIf
	Return $string
EndFunc   ;==>_StringJson_Genre
Func _TMDb_JsonRead_V1($sFile, $sSearch)
	Switch $sSearch
		Case 'release_date'
			$array = StringRegExp($sFile, '"' & $sSearch & '":(.*?)"},{', 3)
			If UBound($array) = 0 Then $array = StringRegExp($sFile, '"' & $sSearch & '":(.*?),"', 3)
		Case 'genres'
			$array = StringRegExp($sFile, '"' & $sSearch & '":(.*?)}],', 3)
		Case 'type'
			$array = StringRegExp($sFile, '"' & $sSearch & '":(.*?)"}', 3)
		Case Else
			$array = StringRegExp($sFile, '"' & $sSearch & '":(.*?),"', 3)
	EndSwitch
	Return $array
EndFunc   ;==>_JsonRead_V1
; ===============================================================================================================================
