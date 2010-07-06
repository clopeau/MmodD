proc tk_gridentries {w nr nc defaults args} {
##		Present a dialog window for Editing a Scilab Matrix

##		Find out the values of the different options
	set opt {-title -header -rlabel -rlabel2 -clabel -pos     -type -var \
		-background -entrybackground -buttoncolor}
	set vn  {tle    hdr     rlb     rlb2     clb     pos       typ  mvar \
		wbk		 ebk 		    btn} 
	set def {Dialog {}      {}      {}       {}      {200 200} {}   mvar \
		#d9d9d9    #d9d9d9           #d9d9d9}
	
	foreach o $opt v $vn d $def {
		set i [lsearch $args $o]
		if {$i != -1} then {
			incr i
			set $v [lindex $args $i]
		} else {
			set $v $d
		}
	}

###
#		Special treatment for the typ arguments. If less than required
#		are given, recycle them.
###
	set nty [llength $typ]
	set nen [llength $defaults]
	if {$nty!=0 && $nty<$nen} then {
		set l ""
		for {set i 0} {$i < $nen} {incr i} {
			lappend l [lindex $typ [expr $i % $nty]]
		}
		set typ $l
	}
###
#		Widgets
##
	toplevel $w -background $wbk
	wm title $w $tle

##		Dialog Heading
	if {$hdr != ""} then {
		label $w.h -text $hdr -background $wbk
	}

##		Entries and labels
	frame $w.f1 -background $wbk
#		Column labels
	if {$clb != ""} then {
		for {set c 0} {$c < $nc} {incr c} {
			label $w.f1.clb$c -text [lindex $clb $c] -background $wbk
			grid $w.f1.clb$c -row 0 -column [expr 2+$c]
		}
	}
#		Row labels 1 (Right aligned)
	if {$rlb != ""} then {
		for {set r 0} {$r < $nr} {incr r} {
			label $w.f1.rlb$r -text [lindex $rlb $r] -background $wbk 
			grid $w.f1.rlb$r -row [expr 1+$r] -column 0 -sticky w
		}
	}
#		Row Labels 2 (Left algined)
	if {$rlb2 != ""} then {
		for {set r 0} {$r < $nr} {incr r} {
			label $w.f1.rlb2$r -text [lindex $rlb2 $r] -background $wbk
			grid $w.f1.rlb2$r -row [expr 1+$r] -column 1 -sticky e
		}
	}
	
#		Entries
	upvar #0 $mvar mvarloc
	for {set c 0} {$c < $nc} {incr c} {
		for {set r 0} {$r < $nr} {incr r} {
			set i [expr $c*$nr+$r]		
			set t [lindex $typ $i]
			if {$t==""} then {set t str}
			set e [lindex $defaults $i]
			set mvarloc($c,$r) $e
#				Variable name concated with index
			set vn [join "$mvar ($c,$r)" ""]
#				Draw entry widgets according to its types
#				sci - scilab complex objects (matrix, list)
#				enu - enumerate, multiple choice, choices in global enum_def
#				boo - boolean
#				str - just a simple string
			switch -glob $t {
				scilab -
				sci	{button $w.f1.e$c$r -text More -background $btn \
						-width 7 -height 1 -padx 0 -pady 0 \
						-command "set $vn \[sci_dialog1 {} {} {} \$$vn\]"
					}
				enu* {global enum_def
					 set om [eval [concat tk_optionMenu $w.f1.e$c$r \
						$vn $enum_def([lindex $t 1])]]
					 $w.f1.e$c$r configure -background $btn
					 $om configure -background $btn
					 }
				boo*	{checkbutton $w.f1.e$c$r -textvariable $vn \
					 -variable $vn -background $wbk}
				str -
				string	-
				default {
					entry $w.f1.e$c$r -background $ebk -width 8 \
						-textvariable $vn
				}
			}
			grid $w.f1.e$c$r -row [expr 1+$r] -column [expr 2+$c] \
				-sticky news
		}
	}
	
####	
#		OK and Cancel Buttons
####
#		Variable to store the response
	regsub -all {\.} $w _ temp
	set ansvar ans$temp
	upvar #0 $ansvar ansloc
	set ansloc 0
#			Response code for closing window
	bind $w <Destroy> "set $ansvar 99"

#		Buttons width and height
	set wd 7
	set hg 1
	button $w.b1 -text OK -underline 0 -background $btn 	\
		-command "set $ansvar 1" 	\
		-height $hg -width $wd -padx 0 -pady 0
	button $w.b2 -text Cancel -background $btn 	\
		-command "set $ansvar 2" 	\
		-height $hg -width $wd -padx 0 -pady 0
	 
#		Now draw everything
	if {$hdr != ""} then {
		grid $w.h -
	}
	$w configure -borderwidth 5
	bind $w <Alt-o> "$w.b1 invoke"
	$w.f1 configure -borderwidth 3
	grid $w.f1 -
	grid $w.b1 -row 2 -column 0 -sticky w
	grid $w.b2 -row 2 -column 1 -sticky e
	wm geometry $w +[lindex $pos 0]+[lindex $pos 1]

##	
#		Wait for key-pressed
##
	grab set $w
	tkwait variable $ansvar
	
##
#		Return the right value
##
#		Concatenate the strings if 'OK', emptry matrix otherwise
	set l ""
	if {$ansloc == 1} then {
		for {set c 0} {$c < $nc} {incr c} {
			for {set r 0} {$r < $nr} {incr r} {
				lappend l $mvarloc($c,$r)
			}
		}
	}
##
#		Clean up
##
	grab release $w
	destroy $w
	unset mvarloc
	unset ansloc
	return $l
}
