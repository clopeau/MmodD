set i [open names r]
set f 0
while {$f != ""} {
	set f [gets $i]
	if {$f != ""} then {source $f.tcl}
}
close $i
puts "Finish loading tkgui library"

