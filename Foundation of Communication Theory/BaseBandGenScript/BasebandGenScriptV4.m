%BasebandGen Script
aa=0;
bb=1;
vzero=0.1;

Chanc=2;
switch Chanc
    case 0
hinit=[1, 0, 0, 0];
    case 1
hinit=[1, 0.2, -0.7, 0.25];
    case 2
hinit=[1+1i, 0.2-0.1i, -0.7, 0.25+0.15i];
end

%hinit = 1;
pulseP=[0.05, 0.1, 0.15, 0.45, 0.5, 0.45, 0.15, 0.1, 0.05];
a=BasebandGen(hinit,vzero, pulseP, aa, bb);
b=BasebandGen();

xin=[0,0,1,0,0,1,1,0,1];
%BEFORE
%a=RunBasebandGen(a,xin);
% NOW
RunBasebandGen(a,xin);
fs=20e3;
GoodPlot(a)
plotnum=2;
GoodPlotFreq(a, fs, plotnum);
Nval=512;
%BEFORE
%a=set(a, 'NFREQ',Nval); 
%NEW
set(a, 'NFREQ',Nval)
GoodPlotFreq(a, fs*10, plotnum+1)
