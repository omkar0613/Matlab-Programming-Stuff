m=100;
t=-pi:0.001:pi;
n=length(t);
disp(n);
Chi=zeros(1,n);

for j=1:n;
if abs(t(j))<.5,
Chi(j)=1;
end
end;

S(1,:)=1/(2*pi)*ones(size(t));
Ces(1,:)=S(1,:);

for k=1:m;
    S(k+1,:)=S(k,:)+2*sin(k/2)/(k*pi)*cos(k*t);
    lambda=1/(k+1);
Ces(k+1,:) = lambda * S(k+1,:) + (1-lambda) * Ces(k,:);
hold off
plot(t,Chi,'r',t,Ces(k+1,:),'b',t,S(k+1,:),'g',t,zeros(size(t)),'k');
axis manual; axis([-pi,pi,-.1,1.1]);
text(-2.5,.9,['n =',num2str(k)],'fontsize',12,'fontweight','bold');
hold on;
pause(.2);
end;