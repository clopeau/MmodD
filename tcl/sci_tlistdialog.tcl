proc sci_tlistdialog {w hdr lb str {var mvar} {pos {200 200}} } {
##		Should be called from sci_dialog. Similar to sci_listdialog - 
##		display a scilab tlist and allow enter data.

	set c [getywlcontents $str]
#		First elements of the list contain tist-type and element name
	set l [getywlcontents [lindex $c 0]]
#		Use them for labels if none is given
	if {$hdr==""} {set hdr [lindex $l 0]}
	if {$lb==""} {set lb [lrange $l 1 end]}
	return [sci_listdialog $w $hdr $lb $str $var $pos 1]
}
