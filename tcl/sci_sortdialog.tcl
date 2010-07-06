proc sci_sortdialog {hdr lbl {idx ""}} {
##		Present a list of items, allow rearrangement of the items
#		Index give a list to keep track of the order of the items.
#		The indices in the list will be rearrange in synchrony with
#		the items in the list of label.

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

#		Maintain a global list to keep trace of the order of the
#		indices
	global l
	set l ""
	set n [llength $lbl]
	for {set i 0} {$i < $n} {incr i} {
		lappend l "{[lindex $lbl $i]} {[lindex $idx $i]}"
	}

##
#		Widgets
##
	toplevel $w -background $wbk
	wm title $w Scilab
	bind $w <Destroy> "set ans 99"
	
##		Dialog Heading
	if {$hdr != ""} {label $w.h -text $hdr}
	
##		Listbox
	set hg 8
	frame $w.f -background $wbk
	listbox $w.f.lb -background $ebk -height $hg -width 16 \
		-xscrollcommand "$w.f.sx set" -yscrollcommand "$w.f.sy set"
	foreach i $lbl {
		$w.f.lb insert end $i
#		Set listbox width to automatic if any one is too long
		if {[string length $i] > 15} then {
			$w.f.lb configure -width 0
		}
	}
	scrollbar $w.f.sy -command "$w.f.lb yview"
	scrollbar $w.f.sx -command "$w.f.lb xview" -orient horizontal
	grid $w.f.lb -column 0 -row 0 -rowspan 6
	grid $w.f.sy -column 1 -row 0 -rowspan 6 -sticky ns
	grid $w.f.sx -column 0 -row 6 -sticky ew
	
##		Buttons (many)
	set wd 7
	set hg 1
	set pdx 0
	set pdy 0
#		Move to the top Button
	button $w.f.b0 -text Begin -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "set i \[$w.f.lb curselection]; set l \[lmove \$l \$i 0]; \
			listboxmove $w.f.lb \$i 0"
	grid $w.f.b0 -column 2 -row 0 
#		Move up
	button $w.f.b1 -text "- 1" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "set i \[$w.f.lb curselection]; set l \[lmove \$l \$i -1]; \
			listboxmove $w.f.lb \$i -1"
	grid $w.f.b1 -column 2 -row 1
#		Move down
	button $w.f.b2 -text "+ 1" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "set i \[$w.f.lb curselection]; set l \[lmove \$l \$i +1]; \
			listboxmove $w.f.lb \$i +1"
	grid $w.f.b2 -column 2 -row 2
#		Move down
	button $w.f.b3 -text "End" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "set i \[$w.f.lb curselection]; set l \[lmove \$l \$i end]; \
			listboxmove $w.f.lb \$i end"
	grid $w.f.b3 -column 2 -row 3
#		Sort Up
	button $w.f.b4 -text "Sort Up" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "set l \[lsort -index 0 \$l]; sci_refreshlb1 $w.f.lb \$l"
	grid $w.f.b4 -column 2 -row 4	
#		Sort Down
	button $w.f.b5 -text "Sort Dn" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "set l \[lsort -decreasing -index 0 \$l];  \
			sci_refreshlb1 $w.f.lb \$l"
	grid $w.f.b5 -column 2 -row 5
	
#		OK and Cancel buttons
	button $w.b1 -text OK -underline 0 -background $btn \
		-command "set ans 1" -height $hg -width $wd -padx 0 -pady 0
	button $w.b2 -text Cancel -background $btn \
		-command "set ans 2" -height $hg -width $wd -padx 0 -pady 0
	
	$w configure -borderwidth 5
	bind $w <Alt-o> "$w.b1 invoke"
	if {$hdr != ""} then {grid $w.h -}
	$w.f configure -borderwidth 3
	grid $w.f -
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
		set r ""
		set i ""
		for {set j 0} {$j < $n} {incr j} {
			lappend r [lindex [lindex $l $j] 0]
			lappend id [lindex [lindex $l $j] 1]
		}
		if {$idx != ""} then {set r "{$r} {$id}"}
	} else {
		set r $lbl
		if {$idx != ""} then {set r "{$r} {$idx}"}
	}

##
#		Clean up
##
	grab release $w
	destroy $w
	unset ans
	unset l
	return $r
}
