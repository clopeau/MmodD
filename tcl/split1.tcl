proc split1 {lst sep} {
##		A fix for split with multiple-character separaters
	regsub -all $sep $lst "\} \{" l
	return "\{$l\}" 
}
