proc sci_strdialog {w hdr rlabel clabel str {var mvar} {pos {200 200}} } {
##		Present a scilab string matrix (good for number, intergers too)
##		for editing.

	set l [parseywl $str]
	set ty [lindex $l 0]
	set dim [lindex $l 1]
	set nr [lindex $dim 0]
	set nc [lindex $dim 1]
	set defaults [lindex $l 2]
	set l [tk_gridentries $w $nr $nc $defaults -title Scilab -header $hdr \
		-rlabel $rlabel -clabel $clabel -pos $pos -type str -var $var \
		-background [sci_wbk] -entrybackground [sci_ebk] \
		-buttoncolor [sci_btn] ]
	if {$l!=""} then {
		return [join [concat $ty $nr $nc $l] |]
	} else {
		return ""
	}
}
