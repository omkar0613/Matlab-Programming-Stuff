a=[1 2 3 4 5 6 7 8 9];
counter=1;
for n=-4:2:-2
    b=circshift(a,[0,n]);
    TotalSum1(:,counter)=b;
    counter=counter+1;
end

counter=1;
for n=2:2:4
    b=circshift(a,[0,n]);
    TotalSum2(:,counter)=b;
    counter=counter+1;
end
EarlyMinusLate=TotalSum1-TotalSum2;
EarlyPlusLate=TotalSum1+TotalSum2;
Data=EarlyMinusLate/EarlyPlusLate;
x=(-4:1:4);
plot(x,Data);
