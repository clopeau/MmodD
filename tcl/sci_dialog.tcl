proc sci_dialog {hdr rlabel clabel defaults {cancel_result ""}} {

##		sci_lv store the nesting level
	upvar #0 sci_lv w
	incr w

##		Detect data type
	set ty [getywltype $defaults]
	set co [expr 200+$w*20]
	set pos [list $co $co]
	set var mvar$w
	
	switch -glob $ty {
		boo*		{set str [sci_booldialog .$w $hdr $rlabel $clabel \
					$defaults $var $pos]}
		enum*	{set str [sci_enumdialog .$w $hdr $rlabel $clabel \
					$defaults $var $pos]}
		list		{set str [sci_listdialog .$w $hdr $rlabel $defaults \
					$var $pos]}
		tlis		{set str [sci_tlistdialog .$w $hdr $rlabel $defaults \
					$var $pos]}
		con		-
		int1		-
		int2		-
		int4		-
		int11	-
		int12	-
		int14	-
		str		-
		default	{set str [sci_strdialog .$w $hdr $rlabel $clabel \
					$defaults $var $pos]}
	}
	
	incr w -1
	if {$str!=""} {return $str} {return $cancel_result}	
}


proc sci_dialog1 {hdr rlb clb defaults} {
#		Identical to sci_dialog, except that the defaults will be returned
##		if 'Cancel' is pressed.
	return [sci_dialog $hdr $rlb $clb $defaults $defaults]
}
