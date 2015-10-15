
#cs
	 by Orkhan.Alikhanov to use only for BrokenBot
#ce

Global $tesseract_Path = @ScriptDir & "\COCBot\functions\Custom Functions\Tesseract\"
Func _TesseractCheck()
	Local $Command=$tesseract_Path&"tesseract.exe"
	Local $Convert=$tesseract_Path&"convert.exe"
	Local $Str
	$FileName = @TempDir&"\check.log"
	If Not FileExists($Convert) Then
		SetLog("Check for file "&$Convert)
		Return False
	EndIf
	If Not FileExists($Command) Then
		SetLog("Check for file "&$Command)
		Return False
	EndIf
	RunWait(@ComSpec & " /c " & $Command & " > " & $FileName, "", @SW_HIDE)
 	$Str = FileRead($FileName)
	If @error Then
		FileDelete($FileName)
		Return False
	EndIf
	If StringInStr($Str,"Error opening") Then
		SetLog("Check settings for tesseract and directory "&$tesseract_Path)
		Return False
	EndIf

	FileDelete($FileName)
	Return True
EndFunc
Func _TesseractReadText($iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $ConvertOptions = "", $Lang = "BrokenBot", $Debug = False)
	If StatusCheck(False) Then Return ""

	$scale = 2
	$Date = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "." & @MIN & "." & @SEC
	$FileName = "temp\"&$Date & Random()
	$ocr_filename = $tesseract_Path & $FileName
	_FileCreate($ocr_filename & ".tif")
	$ocr_filename_and_ext = $ocr_filename & ".txt"
	If StatusCheck(False) Then Return ""

	CaptureToTIFF($ocr_filename & ".tif", $iLeft, $iTop, $iRight, $iBottom)


	If StatusCheck(False) Then Return ""
	$cdCMD = "cd " & $tesseract_Path
	$CMD = "convert.exe " & $FileName & ".tif -resize " & $scale * 100 & "% " & $ConvertOptions & " " & $FileName & ".tiff"
	RunWait(@ComSpec & " /c " & $cdCMD & " && " & $CMD, "", @SW_HIDE)

	If StatusCheck(False) Then Return ""
	$CMD = "tesseract.exe " & $FileName & ".tiff " & $FileName & " -l " & $Lang
	RunWait(@ComSpec & " /c " & $cdCMD & " && " & $CMD, "", @SW_HIDE)



	$result = FileRead($ocr_filename_and_ext)


	If $Debug = True Or $DebugMode = 1 Then
		;FileDelete($ocr_filename & ".tif")
		FileDelete($ocr_filename & ".txt")

		If $DebugMode = 1 Then SetLog("text: " & $result)
	Else
		FileDelete($ocr_filename & ".tiff")
		FileDelete($ocr_filename & ".tif")
		FileDelete($ocr_filename & ".txt")
	EndIf


	Return $result
EndFunc   ;==>_TesseractReadText


; #FUNCTION# ;===============================================================================
;
; Name...........:	CaptureToTIFF()
; Description ...:	Captures an image of the screen, a window or a control, and saves it to a TIFF file.
; Syntax.........:	CaptureToTIFF($win_title = "", $win_text = "", $ctrl_id = "", $sOutImage = "", $scale = 1, $left_indent = 0, $top_indent = 0, $right_indent = 0, $bottom_indent = 0)
; Parameters ....:	$win_title		- The title of the window to capture an image of.
;					$win_text		- Optional: The text of the window to capture an image of.
;					$ctrl_id		- Optional: The ID of the control to capture an image of.
;										An image of the window will be returned if one isn't provided.
;					$sOutImage		- The filename to store the image in.
;					$scale			- Optional: The scaling factor of the capture.
;					$left_indent	- A number of pixels to indent the screen capture from the
;										left of the window or control.
;					$top_indent		- A number of pixels to indent the screen capture from the
;										top of the window or control.
;					$right_indent	- A number of pixels to indent the screen capture from the
;										right of the window or control.
;					$bottom_indent	- A number of pixels to indent the screen capture from the
;										bottom of the window or control.
; Return values .: 	None
; Author ........:	seangriffin
; Modified.......:  by Orkhan Alikhanov for own purposes
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:	No
;
; ;==========================================================================================


Func CaptureToTIFF($sOutImage = "", $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0)
	Local $Ext = StringUpper(StringMid($sOutImage, StringInStr($sOutImage, ".", 0, -1) + 1))
	Local $giTIFColorDepth = 24
	Local $giTIFCompression = $GDIP_EVTCOMPRESSIONNONE


	_GDIPlus_Startup()
	$hImage1 = _CaptureRegion($iLeft, $iTop, $iRight, $iBottom, True)


	; $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)
	;_GDIPLus_GraphicsDrawImageRect($hGraphic, $hImage1, 0 - $iLeft, 0 - ($iTop *), ($pos[2] * $scale) + $iLeft, ($pos[3] * $scale) + $iTop)
	$CLSID = _GDIPlus_EncodersGetCLSID($Ext)

	; Set TIFF parameters
	$tParams = _GDIPlus_ParamInit(2)
	$tData = DllStructCreate("int ColorDepth;int Compression")
	DllStructSetData($tData, "ColorDepth", $giTIFColorDepth)
	DllStructSetData($tData, "Compression", $giTIFCompression)
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOLORDEPTH, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "ColorDepth"))
	_GDIPlus_ParamAdd($tParams, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "Compression"))
	If IsDllStruct($tParams) Then $pParams = DllStructGetPtr($tParams)

	; Save TIFF and cleanup
	_GDIPlus_ImageSaveToFileEx($hImage1, $sOutImage, $CLSID, $pParams)
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_Shutdown()

EndFunc   ;==>CaptureToTIFF
