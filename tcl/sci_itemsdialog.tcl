proc sci_itemsdialog {hdr lbl} {
##		Present a list of items, allow editing, rearranging and sorting.
#		Return the rearranged list after done.
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
	
##		Dialog Heading
	if {$hdr != ""} {label $w.h -text $hdr}
	
##		Listbox
	set lhg 6
	set lwd 16
	frame $w.f -background $wbk
	listbox $w.f.lb -background $ebk -height $lhg -width $lwd \
		-xscrollcommand "$w.f.sx set" -yscrollcommand "$w.f.sy set"
	foreach i $lbl {
		$w.f.lb insert end $i
#		Set listbox width to automatic if any label is too long
		if {[string length $i] > 15} then {
			$w.f.lb configure -width 0
		}
	}
	scrollbar $w.f.sy -command "$w.f.lb yview"
	scrollbar $w.f.sx -command "$w.f.lb xview" -orient horizontal
	grid $w.f.lb -column 0 -row 0 -columnspan 4 -sticky nswe
	grid $w.f.sy -column 4 -row 0 -sticky ns
	grid $w.f.sx -column 0 -row 1 -columnspan 4 -sticky ew
	
#		Field entries and related buttons
	set wd 4
	set hg 1
	set pdx 0
	set pdy 0
	entry $w.f.en -background $ebk
#		Insert the Entry content while <Enter> / <Return> is pressed
	bind $w.f.en <Return> "$w.f.ba invoke"
	grid $w.f.en -column 0 -row 2 -columnspan 4 -sticky ew
	button $w.f.ba -text Add -underline 0 -background $btn 		\
		-height $hg -width $wd -padx $pdx -pady $pdy		\
		-command "$w.f.lb insert active \[$w.f.en get]; $w.f.en delete 0 end"
	grid $w.f.ba -column 0 -row 3
	button $w.f.bd -text Del -underline 0 -background $btn		\
		-height $hg -width $wd -padx $pdx -pady $pdy		\
		-command "$w.f.lb delete active"
	grid $w.f.bd -column 1 -row 3
	button $w.f.bc -text Copy -underline 0 -background $btn		\
		-height $hg -width $wd -padx $pdx -pady $pdy		\
		-command "$w.f.en delete 0 end; $w.f.en insert 0 \
			\[$w.f.lb get active]"
	grid $w.f.bc -column 2 -row 3
	button $w.f.bs -text Set -underline 0 -background $btn		\
		-height $hg -width $wd -padx $pdx -pady $pdy		\
		-command "set i \[$w.f.lb index active]; $w.f.lb delete \$i; \
			$w.f.lb insert \$i \[$w.f.en get]; $w.f.lb selection set \$i; \
			$w.f.lb activate \$i"
	grid $w.f.bs -column 3 -row 3
		
##		Buttons (many)
	set wd 7
	frame $w.f.fb
#		Move to the top Button
	button $w.f.fb.b0 -text Begin -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "listboxmove $w.f.lb active 0"
	grid $w.f.fb.b0 -column 0 -row 0
#		Move up
	button $w.f.fb.b1 -text "- 1" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "listboxmove $w.f.lb active -1"
	grid $w.f.fb.b1 -column 0 -row 1
#		Move down
	button $w.f.fb.b2 -text "+ 1" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "listboxmove $w.f.lb active +1"
	grid $w.f.fb.b2 -column 0 -row 2
#		Move down
	button $w.f.fb.b3 -text "End" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "listboxmove $w.f.lb active end"
	grid $w.f.fb.b3 -column 0 -row 3
#		Sort Up
	button $w.f.fb.b4 -text "Sort Up" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "sci_refreshlb $w.f.lb \[lsort \[$w.f.lb get 0 end]]"
	grid $w.f.fb.b4 -column 0 -row 4
#		Sort Down
	button $w.f.fb.b5 -text "Sort Dn" -background $btn \
		-height $hg -width $wd -padx $pdx -pady $pdy  \
		-command "sci_refreshlb $w.f.lb \
			\[lsort -decreasing \[$w.f.lb get 0 end]]"
	grid $w.f.fb.b5 -column 0 -row 5
	
	for {set i 0} {$i < 6} {incr i} {grid rowconfigure $w.f.fb $i -weight 1}
	grid $w.f.fb -column 5 -row 0 -rowspan 3 -sticky ns
	
#		OK and Cancel buttons
	button $w.b1 -text OK -underline 0 -background $btn \
		-command "set ans 1" -height $hg -width $wd -padx 0 -pady 0
	button $w.b2 -text Cancel -background $btn \
		-command "set ans 2" -height $hg -width $wd -padx 0 -pady 0
	
	$w configure -borderwidth 5
	bind $w <Destroy> "set ans 99"
	bind $w <Alt-a> "$w.f.ba invoke"
	bind $w <Alt-d> "$w.f.bd invoke"
	bind $w <Alt-c> "$w.f.bc invoke"
	bind $w <Alt-s> "$w.f.bs invoke"
	bind $w <Alt-o> "$w.b1 invoke"
	if {$hdr != ""} then {grid $w.h -}
	$w.f configure -borderwidth 3
	grid $w.f -
	grid $w.b1 -row 2 -column 0 -sticky w
	grid $w.b2 -row 2 -column 1 -sticky e
	wm geometry $w +200+200

##
#		Wait for response
##
	global ans
	grab set $w
	set ans 0
	tkwait variable ans

	if {$ans == 1} then {
		set l [$w.f.lb get 0 end]
	} else {
		set l $lbl
	}

##
#		Clean up
##
	grab release $w
	destroy $w
	unset ans
	return $l
}
