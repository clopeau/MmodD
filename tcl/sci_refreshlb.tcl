proc sci_refreshlb {listbox lbl} {
	$listbox delete 0 end
	foreach i $lbl {
		$listbox insert end $i
	}
}
