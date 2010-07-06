proc sci_choose {hdr items {buttons {OK Cancel}} {multi 0} {hg -1}} {
##		Present a listbox for selection
##		Items is a list separated by |

#		Background Color of Entry fields
	set ebk [sci_ebk]
#		Button Color
	set btn [sci_btn]
#		Window Background Color
	set wbk [sci_wbk]
#		Window path
	set w .scilab

#		Make sure that characters like \n are interpret correctly
	set hdr [subst -nocommand -novariable $hdr]

##
#		Widgets
##
	toplevel $w -background $wbk
	wm title $w Scilab
	bind $w <Destroy> "set ans 99"
	
##		Dialog Heading
	if {$hdr != ""} {label $w.h -text $hdr}
##		Listbox
	listbox $w.lb -background $ebk -height $hg -width 16
	foreach i $items {
		$w.lb insert end $i
#		Set listbox width to automatic if any one is too long
		if {[string length $i] > 15} then {
			$w.lb configure -width 0
		}
	}
	expr {$multi ? [$w.lb configure -selectmode extended] : \
		[$w.lb configure -selectmode browse] }

#		Buttons
	set wd [maxstrlen $buttons]
	set hg 1
	button $w.b1 -text [lindex $buttons 0] -background $btn \
		-command "set ans 1" -height $hg -width $wd -padx 0 -pady 0
	button $w.b2 -text [lindex $buttons 1] -background $btn \
		-command "set ans 2" -height $hg -width $wd -padx 0 -pady 0
	
	$w configure -borderwidth 5
	if {$hdr != ""} then {grid $w.h -}
	grid $w.lb -
	grid $w.b1 -row 2 -column 0 -sticky w
	grid $w.b2 -row 2 -column 1 -sticky e
	wm geometry $w +200+200
	
##
#		Wait for key-press
##
	global ans
	grab set $w
	set ans 0
	tkwait variable ans
	
	if {$ans == 1} {
		set l [$w.lb curselection]
	} else {
		set l ""
	}
	
##
#		Clean up
##
	grab release $w
	destroy $w
	unset ans
	return $l
}

	
	
	
	
	
