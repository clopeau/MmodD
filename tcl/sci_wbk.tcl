proc sci_wbk {} {
##		Return the background color of windows
	global sci_WinBackground
	if {[info global sci_WinBackground] == ""} then {
		set sci_WinBackground #d9d9d9
	}
	return $sci_WinBackground
}
