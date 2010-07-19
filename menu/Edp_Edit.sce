if isdef('pb')==%t
  editvar pb.eq;
  disp( ' --- please to confirm your choice in editor by pressing Enter then update and quit ---')
else
  disp('   --- no variable ---');
end