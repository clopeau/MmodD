new=x_dialog('Please Enter a Name',['write there']);

bdr=length(th.Bnd);

if bdr>2,
 
    
//delmenu('Editor')    
//addmenu('Editor',['Edit Var','Edit Edp'])    


          
          new_var=x_mdialog(['Variables definition';'Name:  '+new],['Geometry';'Equation'],['tri2d';'-Laplace(u)=b*u+1']);
new_var=[new;new_var] ;         
          
      
   Boundary='Bnd'+string(1);
  eq_bnd='Id(u)=0';
   eq_type='D';
    for j=2:bdr
      Boundary=[Boundary;'Bnd'+string(j)];
      eq_bnd=[eq_bnd;'Id(u)=0'];
       eq_type=['D';eq_type];
          end     
              tri2d_show_bnd(th);
          
          for i=1:bdr  
  Coor_str=mean(th.Coor(th.Bnd(i),:),'r');                    
  xstring(Coor_str(1),Coor_str(2),Boundary(i));
       end 
           new_pb=x_mdialog(['Boundary Definition';'D=diriclet';'N=neumann'],[Boundary],['Equation','type'],[eq_bnd, eq_type]);
u=p1_2d(th) ;      
pb=edp(u);
pb.Id=string(new);
pb.eq=new_var(3);
for i=1:bdr 
  pb.BndVal(i)=new_pb(i) ; 
   pb.TypBnd(i)=new_pb(i+bdr)  ;
end

close();

else
disp(' --- input wrong boundary definition ----');
end
