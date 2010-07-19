if isdef('pb')==%t
  if bdr==4
    xedp(pb);
  else
    editvar pb.eq
    editvar pb.BndVal
  end
  else
  disp('   --- no variable ---');
end