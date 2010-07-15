new=x_dialog('Please Enter a Name',['write there']);


bdr=length(th.Bnd);

if bdr>2,
  Boundary='Bnd'+string(1);
  eq_bnd='Id=0';
    for j=2:bdr
      Boundary=[Boundary;'Bnd'+string(j)];
      eq_bnd=[eq_bnd;'Id=0'];
    end
    
tri2d_show_bnd(th);
for i=1:bdr  
  Coor_str=mean(th.Coor(th.Bnd(i),:),'r');                    
  xstring(Coor_str(1),Coor_str(2),Boundary(i));
  
      end
          
       new_pb=x_mdialog(['Variables definition';'Name:  '+new],['Geometry';'Equation';Boundary],['p1_2d';'-Laplace=1';eq_bnd]);
       
u=p1_2d(th) ;      
new_edp=edp(u);
new_edp.Id=new;
new_edp.geo=new_pb(1);
new_edp.eq=new_pb(2);
close();

else
disp(' --- input wrong boundary definition ----');
end