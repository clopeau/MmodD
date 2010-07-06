proc sci_listdialog {w hdr lb str {var mvar} {pos {200 200}} {idx 0}} {
##		Should be called from sci_dialog. The part to 
##		display a scilab list and enter data to it in a dialog.
##		idx is an index number to indicate the first element to be
##		display. Should be 0 for list, 1 for tlist.
	upvar #0 sci_lv lv

	set l [parseywl $str]
	set listty [lindex $l 0]
	set dim [lindex $l 1]
	set nc 1
	set nr [expr $dim-$idx]
	set rlabel $lb
	set elements [lindex $l 2]
##		Format the arguments for calling tk_gridentries
##		Temporary increase the nesting level for correct parsing
	incr lv
	for {set i 0} {$i < $nr} {incr i} {
		set e [lindex $elements [expr $i+$idx]]
		set l [parseywl $e]
		set ety [lindex $l 0]
		set edm [lindex $l 1]
		set ecn [lindex $l 2]
		lappend etylist $ety
##			'Simple' or 'Complex' elements
##			Only matrices with one element will have dimension {1 1}
##			list or tlist will have {1} if it has only one element
		if {[string compare $edm "1 1"]==0} then {
			lappend simple 1
			lappend defaults [getywlcontents $e]
			
			switch -glob $ety {
				con		-
				int1 	-
				int2 	-
				int4		-
				int11	-
				int12	-
				int14	-
				str		{lappend type str}
				enum*	{lappend type $ety}
				boo		{lappend type boo}
			}			
		} else {
			lappend simple 0
			lappend defaults $e
			lappend type sci
		}
		if {$lb==""} {lappend rlabel [expr $i+1]}
		switch -glob $ety {
			con		{set tlb number}
			boo		{set tlb boolean}
			int1		{set tlb int1}
			int2		{set tlb int2}
			int4 	{set tlb int4}
			int11	{set tlb +int1}
			int12	{set tlb +int2}
			int14	{set tlb +int4}
			str		{set tlb string}
			enum*	{set tlb enum}
			list		{set tlb list}
			tlis		{set tlb tlist}
		}
		lappend rlabel2 ($tlb)
	}
#		Restore nesting level
	incr lv -1

	set l [tk_gridentries $w $nr $nc $defaults -title Scilab -header $hdr \
		-rlabel $rlabel -rlabel2 $rlabel2 -pos $pos -type $type -var $var \
		-background [sci_wbk] -entrybackground [sci_ebk] \
		-buttoncolor [sci_btn] ]
	if {$l!=""} then {
##			The first four characters are either 'list' or 'tlis'
##			Keep them.
		for {set i $idx} {$i < $dim} {incr i} {
##			'Simple' elements are passed as a simple string
##			Need to convert it back to ywl format. So put the
##			data type and dimension (1|1) back to 'simple' element.
			set j [expr $i-$idx]
			if {[lindex $simple $j]} {
				set ety [lindex $etylist $j]
				switch -glob $ety {
					enum* {incr lv
						  set sep @$lv@
						  set l2 [join [concat str 1 1 [lindex $l $j]] |]
						  set e [split1 [lindex $elements $i] $sep]
						  set e [lreplace $e 3 3 $l2]
						  set e [join $e $sep]
						  incr lv -1
						 }
					default {set e [join [list $ety 1 1 [lindex $l $j]] |]}
				}
			} else {
				set e [lindex $l $j]
			}
			set elements [lreplace $elements $i $i $e]
		}
		set sep @$lv@		
		return [join [concat $listty $elements] $sep]
	} else {
		return ""
	}
}
