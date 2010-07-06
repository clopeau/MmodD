proc sci_choices {hdr lbl choices {defaults ""} {flg 0}} {
##		Present a window to perform multiple choices

#		Background Color of Entry fields
	set ebk [sci_ebk]
#		Button Color
	set btn [sci_btn]
#		Window background
	set wbk [sci_wbk]
#		Window path
	set w .scilab

	if {$defaults == ""} then {
		foreach i $choices {lappend defaults 0}
	}
		
##
#		Widgets
##
	toplevel $w -background $wbk
	wm title $w Scilab
##		Dialog Heading
	if {$hdr != ""} then {label $w.h -text $hdr}

##		Labels
	frame $w.f
	set n [llength $choices]	
	if {$lbl != ""} then {
		frame $w.f.fl
		for {set i 0} {$i < $n} {incr i} {
			label $w.f.fl.$i -text [lindex $lbl $i]
			grid $w.f.fl.$i -column 0 -row $i -sticky w
		}
		grid $w.f.fl -row 0 -column 0 -rowspan $n
	}
	
##		Radio Buttons for choices
	if $flg then {
#			The buttons are aligned when flg==1
		frame $w.f.fb
		for {set i 0} {$i < $n} {incr i} {
			global ans$i
			set ans$i [lindex $defaults $i]
			set l [lindex $choices $i]
			set nit [llength $l]
			for {set j 0} {$j < $nit} {incr j} {
				radiobutton $w.f.fb.$i$j -text [lindex $l $j] \
					-value $j -variable ans$i
				grid $w.f.fb.$i$j -row $i -column $j -sticky w
			}
			grid $w.f.fb -row 0 -column 1 -stick we
		}
	} else {
#			Otherwise, packed the buttons closer
		for {set i 0} {$i < $n} {incr i} {
			frame $w.f.f$i
			global ans$i
			set ans$i [lindex $defaults $i]
			set l [lindex $choices $i]
			set nit [llength $l]
			for {set j 0} {$j < $nit} {incr j} {
				radiobutton $w.f.f$i.$j -text [lindex $l $j] \
					-value $j  -variable ans$i
				grid $w.f.f$i.$j -row 0 -column $j -sticky w
				grid columnconfig $w.f.f$i $j -weight 1
			}		
			grid $w.f.f$i -row $i -column 1 -sticky we
		}

	}

#		Buttons
#		Variable to store the response
	global ans
	set ans 0
#			Response code for closing window
	bind $w <Destroy> "set ans 99"
	set wd 7
	set hg 1
	button $w.b1 -text OK -underline 0 -background $btn \
		-command "set ans 1" -height $hg -width $wd -padx 0 -pady 0
	button $w.b2 -text Cancel -background $btn \
		-command "set ans 2" -height $hg -width $wd -padx 0 -pady 0
	
	$w configure -borderwidth 5
	bind $w <Alt-o> "$w.b1 invoke"
	if {$hdr != ""} then {grid $w.h -}
	grid $w.f -
	grid $w.b1 -row 2 -column 0 -sticky w
	grid $w.b2 -row 2 -column 1 -sticky e
	wm geometry $w +200+200
	
##
#		Wait for key-press
##
	grab set $w
	tkwait variable ans

	if {$ans == 1} {
		set l ""
		for {set i 0} {$i < $n} {incr i} {
			upvar #0 ans$i r
			lappend l $r
		}
	} else {
		set l $defaults
	}

##
#		Clean up
##
	grab release $w
	for {set i 0} {$i < $n} {incr i} {unset ans$i}
	destroy $w
	unset ans
	return $l
}


