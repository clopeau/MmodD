proc sci_enumdialog {w hdr rlabel clabel str {var mvar} {pos {200 200}} } {
##		Present a scilab boolean matrix for editing

	set l [parseywl $str]
	set ty [lindex $l 0]
	set enumty [lindex $ty 1]
	set dim [lindex $l 1]
	set nr [lindex $dim 0]
	set nc [lindex $dim 1]
	set defaults [lindex $l 2]
	set l [tk_gridentries $w $nr $nc $defaults -title Scilab -header $hdr \
		-rlabel $rlabel -clabel $clabel -pos $pos -type [list $ty] \
		-var $var -background [sci_wbk] -entrybackground [sci_ebk] \
		-buttoncolor [sci_btn] ]
	if {$l!=""} then {
		set l2 [join [concat str $nr $nc $l] |]
		global sci_lv
		set sep @$sci_lv@
		set l3 [split1 $str $sep]
		set l3 [lreplace $l3 3 3 $l2]
		return [join $l3 $sep]
	} else {
		return ""
	}
}
