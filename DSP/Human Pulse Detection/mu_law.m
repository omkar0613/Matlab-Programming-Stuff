function y=mu_law(x)
x_sign=sign(x);
x1=abs(x)/max(abs(x));
L=length(x);
y=zeros(L,1);
delta=1/(255*16);
for i=1:L
if(x1(i,1)>=0&&x1(i,1)<1/255)
value=floor(x1(i,1)/delta);
y(i,1)=delta*value;
end
if(x1(i,1)>=1/255&&x1(i,1)<3/255)
value=floor((x1(i,1)-1/255)/(2*delta));
y(i,1)=1/255+delta*2*value;
end
if(x1(i,1)>=3/255&&x1(i,1)<7/255)
value=floor((x1(i,1)-3/255)/(4*delta));
y(i,1)=3/255+delta*4*value;
end
if(x1(i,1)>=7/255&&x1(i,1)<15/255)
value=floor((x1(i,1)-7/255)/(8*delta));
y(i,1)=7/255+delta*8*value;
end
if(x1(i,1)>=15/255&&x1(i,1)<31/255)
value=floor((x1(i,1)-15/255)/(16*delta));
y(i,1)=15/255+delta*16*value;
end
if(x1(i,1)>=31/255&&x1(i,1)<63/255)
value=floor((x1(i,1)-31/255)/(32*delta));
y(i,1)=31/255+delta*32*value;
end
if(x1(i,1)>=63/255&&x1(i,1)<127/255)
value=floor((x1(i,1)-63/255)/(64*delta));
y(i,1)=63/255+delta*64*value;
end
if(x1(i,1)>=127/255&&x1(i,1)<=1)
value=floor((x1(i,1)-127/255)/(128*delta));
y(i,1)=127/255+delta*128*value;
end
end
y=x_sign.*y;
y=y*max(abs(x));