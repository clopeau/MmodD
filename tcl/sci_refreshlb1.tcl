proc sci_refreshlb1 {listbox lbl} {
	$listbox delete 0 end
	foreach i $lbl {
		$listbox insert end [lindex $i 0]
	}
}
