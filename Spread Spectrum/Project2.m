%All the inputs
stage=10;
     %%%%% fliplr
ptap1=[3,10];

ptap2=[2,3,6,8,9,10];  % feedbacks generated according to the given polynomials

regi1=[1 0 0 0 0 0 0 1 0 0];
regi2=[1 1 1 0 1 0 0 1 1 0 ];

T=1e-3;
f=800;
n=1:4092;                                           % for multiplying the Doppler sinusoid with code of size 4092
ts=T/1023;
%ts=T/4092;

%m sequences generated
m1=mseq(stage,ptap1,regi1);
m2=mseq(stage,ptap2,regi2);

code=goldseq1(m1,m2,1);                             % Gold Seq Generated
codebin=code*2-1;
i=kron(codebin,ones(1 ,4));  
nd=1:1:8184;
 %%%%%%%%%%%%%%%%%%%%%%%%%% PROJECT-2 %%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%% Initial Declarations %%%%%%%%%%%%%%%%%%%%%%%%%%%
d=exp(2*pi*1i*n*1000*ts);             % Doppler Sinusoid with f=1kHz
GenSign=i.*d;                         % 4092 Samples with Doppler sinusoid

repl=kron(GenSign,ones(1 ,5));   % 5 periods of complex wave are considered by replicating 1st period  No. of Samples = 5*4092
repl1=repl(556:16923);           % Shifted Signal     No. of Samples=4*4092
p=fft(repl1);
phase=angle(p);
repl1plusnoise=awgn(repl1,10); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure();
stem(repl1plusnoise);
title('Acquired Signal');

%%%%%%%%%%%%%Correlator Structure%%%%%%%%%%%%

%%%%%%% repl1 is used as Received code edge having (4*4092) samples and
%%%%%%% shifted by 556 samples

GenSign2=kron(GenSign,ones(1,4));  % Signal of same length is created which has a different phases than that of repl1
% figure();
% plot(z,phase(GenSign2)-phase(repl1));
a=[];

complexsign=zeros(1,16368);
for l=1:16368
    a(l)=repl1(l).*GenSign2(l);
    complexsign(l)=a(l);           %%Elementwise Multiplication
end

%%%% Multiplied Signal division into smaller periods for further coherent
%%%% integration
complexsign1=complexsign(1:8184); % two periods are put together for coherent integration
complexsign2=complexsign(8185:16368);
%cohint1=pulsint(complexsign1,'coherent');  % integrated over certain limits
cohint1=intdump(complexsign1,8184);
%cohint2=pulsint(complexsign2,'coherent');  % integrated over certain limits
cohint2=intdump(complexsign2,8184);
y1=cohint1.*cohint1;                       % Non-coherent integration
y2=cohint2.*cohint2;                       % Non-coherent integration
yfin=(y1.*y1)+(y2.*y2);
inoise=randn(8184,1);
y=yfin+inoise;
figure();
stem(y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fd=-2000:0.4888:2000;

f1=-2000;
correlator1=y*exp(-2*pi*1i*f1*ts);
f2=-1500;
correlator2=y*exp(-2*pi*1i*f2*ts);
f3=-1000;
correlator3=y*exp(-2*pi*1i*f3*ts);
f4=0;
correlator4=y*exp(-2*pi*1i*f4*ts);
f5=1000;
correlator5=y*exp(-2*pi*1i*f5*ts);
f6=1500;
correlator6=y*exp(-2*pi*1i*f6*ts);
f7=2000;
correlator7=y*exp(-2*pi*1i*f7*ts);

figure();
plot3(nd,fd,correlator1);
hold on;
plot3(nd,fd,correlator2);
hold on;
plot3(nd,fd,correlator3);
hold on;
 plot3(nd,fd,correlator4);
hold on;
plot3(nd,fd,correlator5);
hold on;
plot3(nd,fd,correlator6);
hold on;
plot3(nd,fd,correlator7);
hold on;
figure();
% for f=-2000:2000
%     switch f
%         case -2000
%             correlator1=y*exp(-2*pi*1i*f*nd*ts);
%             
%             case -1500
%             correlator2=y*exp(-2*pi*1i*f*nd*ts);
%             case -1000
%             correlator3=y*exp(-2*pi*1i*f*nd*ts);
%             case 0
%             correlator4=y*exp(-2*pi*1i*f*nd*ts);
%             case 1000
%             correlator5=y*exp(-2*pi*1i*f*nd*ts);
%             case 1500
%             correlator6=y*exp(-2*pi*1i*f*nd*ts);
%             case 2000
%             correlator7=y*exp(-2*pi*1i*f*nd*ts);
%     end
% end
%correlator=[correlator1 correlator2 correlator3 correlator4 correlator5 correlator6 correlator7];

%%%%%%%%%%% MATCHED FILTER %%%%%%%%%%%%%%%%%%%%%%
GenSign3=GenSign2(1:4092);
for l=1:4092:16368
    finalsignal(l:l+4091)=(repl1(l:l+4091).*GenSign3);
end
%disp(finalsignal);
finalsignal1=finalsignal(1:8184);
finalsignal2=finalsignal(8185:16368);
coherentint1=pulsint(finalsignal1,'coherent');
coherentint2=pulsint(finalsignal2,'coherent');
z1=coherentint1.*coherentint1;
z2=coherentint2.*coherentint2;
z=(z1.*z1)+(z2.*z2);
stem(z);
title('Matched Filter Operation');
correlator=[];
fd=-2000:0.4888:2000;

corr1=z*exp(-2*pi*1i*f1*ts);

corr2=z*exp(-2*pi*1i*f2*ts);

corr3=z*exp(-2*pi*1i*f3*ts);

corr4=z*exp(-2*pi*1i*f4*ts);

corr5=z*exp(-2*pi*1i*f5*ts);

corr6=z*exp(-2*pi*1i*f6*ts);

corr7=z*exp(-2*pi*1i*f7*ts);
plot3(nd,fd,corr1);
hold on;
plot3(nd,fd,corr2);
hold on;
plot3(nd,fd,corr3);
hold on;
 plot3(nd,fd,corr4);
hold on;
plot3(nd,fd,corr5);
hold on;
plot3(nd,fd,corr6);
hold on;
plot3(nd,fd,corr7);
hold on;
figure();