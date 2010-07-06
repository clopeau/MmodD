##		Three wrappers of parseywl - to make the code more eligible
proc getywltype {str} {
	return [lindex [parseywl $str] 0]
}

proc getywldim {str} {
	return [lindex [parseywl $str] 1]
}

proc getywlcontents {str} {
	return [lindex [parseywl $str] 2]
}


##		ywl is a format of string I defined for translating a scilab 
##		variable into a single string, so that data movement between
##		Scilab and Tcl can be easier.
##		This procedure parse a ywl string and return three arguments
##		as a list: {type dimension contents}
##		It can be done in individual procedures but putting this in
##		a centralized place seems to make it more organized...
proc parseywl {str} {
#		sci_lv store the current nesting level of list
	upvar #0 sci_lv lv
	set sep @$lv@
	
##		Detect data type
#			Typed list need special treatments
#			Second element (first element of the tlist) of the 
#			tliststring is a string matrix containing the type
#			and the name of elements (check Scilab help)
#			Return this name if it's one of those type supported
	set ty [string range $str 0 2]
	if {![string compare $ty int]} then {set ty [string range $str 0 4]}
	switch $ty {
		int1| {set type int1}
		int2| {set type int2}
		int4| {set type int4}
		lis   {set type list}
		tli   {set l [split1 $str $sep]
			  set ty2 [lindex [getywlcontents [lindex $l 1]] 0]
			  set tlist_supported {enum}
			  set i [lsearch $tlist_supported $ty2]
			  if {$i==-1} {set type tlis} {set type $ty2}
			  }
		default {set type $ty}
	}
	
	switch $type {
		con	 -
		boo	 -
		int1  -
		int2  -
		int4  -
		int11 -
		int12 -
		int14 -
		str	{set l [split $str |]
			 set dim [lrange $l 1 2]
			 set contents [lrange $l 3 end]
			 }
		list	{set l [split1 $str $sep]
			set contents [lrange $l 1 end]
		 	set dim [llength $contents]
			}
		tlis	{set l [split1 $str $sep]
			set contents [lrange $l 1 end]
			set dim [llength $contents]		
			}
		enum	{set l [lrange [split1 $str $sep] 1 3]
			set enumty [getywlcontents [lindex $l 1]]
			lappend type $enumty
			set temp [parseywl [lindex $l 2]]
			set dim [lindex $temp 1]
			set contents [lindex $temp 2]
			}
		}
	return [list $type $dim $contents]
}
