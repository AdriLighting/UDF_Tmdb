#include '_TMDb.au3'

;~ Local $TMDb = _TMDb_FilmID_GetDetailByKey('title', 550)
;~ _ADFunc_Divers_Upd(3, $TMDb)

;~ _TMDb_GetListByClassment_Exemple()
;~ _TMDb_FilmSearch_Exemple()
;~ _TMDb_FilmID_GetDetails_Exemple()
_TMDb_FilmID_GetVideos_Exemple()
_TMDb_FilmID_GetImages_Exemple()

Func _TMDb_GetListByClassment_Exemple()
	Local $TMDb
	Local $ComboBox
	;	Fair une recherche des films populaire et rechercher les infos des films trouver
	_ADFunc_Divers_Upd(3, "Fair une recherche de films par type de vue et rechercher les infos des films trouver")
	$ComboBox = _ADFunc_Gui_ComboBox('Classement des films', 'top_rated|popular|now_playing|latest|upcoming', 'popular', 'Type de Classement : ', '1|2|3|4|5', '1', 'Nbr de page : ')
	If Not @error Then
		Local $TMDb = _TMDb_GetListByClassment($TMDb_ArrAy_RF, $ComboBox[1], $ComboBox[0])
		If Not @error Then
			$TMDb = _TMDb_FilmSearch_GetDetails($TMDb_ArrAy_RFD, $TMDb, False)
			_TMDb_FilmSearch_Display($TMDb)
			_TMDb_FilmSearch_SavToIni($TMDb, @ScriptDir & '\TMDb_GetListByClassment_' & $ComboBox[0] & '.ini')
		EndIf
	EndIf
EndFunc   ;==>_TMDb_GetListByClassment_Exemple
Func _TMDb_FilmSearch_Exemple()
	Local $TMDb
	Local $InputBox
	;	Fair une recherche d'un film et rechercher les infos des films trouver
	_ADFunc_Divers_Upd(3, "Fair une recherche d'un film et rechercher les infos des films trouver")
	$InputBox = InputBox("Rechercher", "Film a rechercher ?", "Tomb Raider", "", 500, 135)
	If Not @error And $InputBox <> '' Then
		$TMDb = _TMDb_FilmSearch($TMDb_ArrAy_RF, $InputBox)
		If Not @error Then
			$TMDb = _TMDb_FilmSearch_GetDetails($TMDb_ArrAy_RFD, $TMDb, False)
			_TMDb_FilmSearch_Display($TMDb)
			_TMDb_FilmSearch_SavToIni($TMDb)
		EndIf
	EndIf
EndFunc   ;==>_TMDb_FilmSearch_Exemple
Func _TMDb_FilmID_GetDetails_Exemple()
	Local $TMDb
	Local $TMDb_FilmId = 550
	;	https://api.themoviedb.org/3/movie/343611?api_key={api_key}
	;	https://api.themoviedb.org/3/movie/343611?api_key={api_key}&append_to_response=videos
	;	Rechercher les infos d'un film avec l'id d'un film
	_ADFunc_Divers_Upd(3, "Rechercher les infos d'un film avec l'id d'un film")
	$TMDb = _TMDb_FilmID_GetDetails($TMDb_ArrAy_RFD, $TMDb_FilmId)
	If Not @error Then
		_TMDb_FilmID_GetDetails_Display($TMDb, $TMDb_FilmId)
		_TMDb_FilmID_GetDetails_SavToIni($TMDb, $TMDb_FilmId)
	EndIf
EndFunc   ;==>_TMDb_FilmID_GetDetails_Exemple
Func _TMDb_FilmID_GetVideos_Exemple()
	Local $TMDb
	Local $InputBox
	;	Rechercher les videos d'un film avec l'Id d'un film
	_ADFunc_Divers_Upd(3, "Rechercher les videos d'un film avec l'Id d'un film")
	$InputBox = InputBox("Rechercher", "Id du film : ", "550", "", 500, 135)
	If Not @error And $InputBox <> '' Then
		$TMDb = _TMDb_FilmID_GetVideos($TMDb_ArrAy_RV, $InputBox)
		If Not @error Then _TMDb_FilmID_GetVideos_Display($TMDb, $TMDb_ArrAy_RV, $InputBox)
		If Not @error Then _TMDb_FilmID_GetVideos_SavToIni($TMDb, $InputBox)
	EndIf
EndFunc   ;==>_TMDb_FilmID_GetVideos_Exemple
Func _TMDb_FilmID_GetImages_Exemple()
	Local $TMDb
	Local $TMDb_FilmId = 456154
	Local $InputBox
	Local $ComboBox
	;	Rechercher les images d'un film avec l'id d'un film
	_ADFunc_Divers_Upd(3, "Rechercher les images d'un film avec l'id d'un film")
	$TMDb = _TMDb_FilmID_GetImages($TMDb_FilmId)
	If Not @error Then
		_ADFunc_Divers_Upd(1, "posters")
		_ADFunc_Divers_Upd(1, $TMDb[0], 'https://image.tmdb.org/t/p/original', 0, -1)
		_ADFunc_Divers_Upd(1, "backdrops")
		_ADFunc_Divers_Upd(1, $TMDb[1], 'https://image.tmdb.org/t/p/original', 0, -1)
		_TMDb_FilmID_GetImages_SavToIni($TMDb[0], $TMDb_FilmId, "posters")
		_TMDb_FilmID_GetImages_SavToIni($TMDb[1], $TMDb_FilmId, "backdrops")
	EndIf
EndFunc   ;==>_TMDb_FilmID_GetImages_Exemple
