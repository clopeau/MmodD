proc sci_message {msg {buttons {OK Cancel}} {just center}} {
##		Present a message and await for response
##		The same as tk_messageBox but I can find of a way to
##		to customize the color and size of their buttons only :(. 
##		So I implement one here.

#		Button Color
	set btn [sci_btn]
#		Window Background Color
	set wbk [sci_wbk]
#		Window Path
	set w .scilab

#		Button labels
	if {$buttons==""} {set buttons {OK Cancel}}
#		Find out the maximum length of the buttons and message widgets
	set bwd [maxstrlen $buttons]
	incr bwd
	set nb [llength $buttons]
	set mwd [expr $bwd*$nb>20 ? $bwd*$nb*8 : 160]
	
##
#		Widgets
##
	toplevel $w -background $wbk -borderwidth 5
	wm title $w Scilab
	wm geometry $w +200+200
	bind $w <Destroy> "set ans 99"

##		Message
	set msg [subst -nocommand -novariable $msg]
	message $w.m -width $mwd -text $msg -background $wbk -justify $just
	grid $w.m -columnspan $nb -sticky ew

##		Buttons
	for {set i 0} {$i < $nb} {incr i} {
		button $w.b$i -background $btn -height 1 -width $bwd \
			-text [lindex $buttons $i] -command "set ans $i" \
			-padx 0 -pady 0
		grid $w.b$i -row 1 -column $i
	}
	
##
#		Wait for response
##
	global ans
	grab set $w
	set ans 0
	tkwait variable ans
	
##
#		Clean up
##
	set result $ans
	grab release $w
	destroy $w
	unset ans
	return $result
}
	
			
		
