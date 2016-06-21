% syms t1 z;
 
% x1=cos(t1);
% figure(1);
% plot(t1,x1);
% z1=ztrans(x1);
% figure(2);
% stem(z1);
syms k x
f = sin(k);
ztrans(f, k, x)
