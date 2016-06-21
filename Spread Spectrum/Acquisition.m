%All the inputs
stage=10;
     %%%%% fliplr
ptap1=[3,10];

ptap2=[2,3,6,8,9,10];  % feedbacks generated according to the given polynomials

regi1=[1 0 0 0 0 0 0 1 0 0];
regi2=[1 1 1 0 1 0 0 1 1 0 ];

T=1e-3;
f=1000;
n=1:4092;                                           % for multiplying the Doppler sinusoid with code of size 4092
ts=T/1023;
%ts=T/4092;

%m sequences generated
m1=mseq(stage,ptap1,regi1);
m2=mseq(stage,ptap2,regi2);

code=goldseq1(m1,m2,1);                             % Gold Seq Generated   size 1023
codebin=code*2-1;
i=kron(codebin,ones(1 ,4));                         % size 4092
figure();
subplot(2,1,1);
stem(i);
axis([0 200 -1 1]);
title('Signal without Doppler');
d=exp(2*pi*1i*n*f*ts);                           % Doppler's Sinusoid
GenSign=i.*d;                                       % 4092 sampled gold code with Doppler's Sinusoid
subplot(2,1,2);
stem(GenSign);
axis([0 2000 -1 1]);
title('Signal with Doppler');
repl=kron(GenSign,ones(1 ,5));                      % 20460 sampled gold code with Doppler's Sinusoid ( 5 repititive periods of GenSign )
% phaseshiftedrepl=repl(556:16923);                              % Shifted repl signal ( 4 periods )
% nd=1:1:16368;
% for f=-2000:2000
%     switch f
%         case -2000
%             complexsignal1=phaseshiftedrepl.*exp(-2*pi*1i*f*nd*ts);
%             figure();
%             stem(complexsignal1);
%             axis([0 200 -1 1]);
%             title('F=-2000');
%         case -1500
%             complexsignal2=phaseshiftedrepl.*exp(-2*pi*1i*f*nd*ts);
%         case -1000
%             complexsignal3=phaseshiftedrepl.*exp(-2*pi*1i*f*nd*ts);
%             figure();
%             stem(complexsignal3);
%             axis([0 200 -1 1]);
%             title('F=-1000');
%         case 0
%             complexsignal4=phaseshiftedrepl.*exp(-2*pi*1i*f*nd*ts);
%             
%         case 1000
%             complexsignal5=phaseshiftedrepl.*exp(-2*pi*1i*f*nd*ts);
%             figure();
%             stem(complexsignal5);
%             axis([0 200 -1 1]);
%             title('F=1000');
%         case 1500
%             complexsignal6=phaseshiftedrepl.*exp(-2*pi*1i*f*nd*ts);
%             
%         case 2000
%             complexsignal7=phaseshiftedrepl.*exp(-2*pi*1i*f*nd*ts);
%             figure();
%             stem(complexsignal7);
%             axis([0 200 -1 1]);
%             title('F=2000');
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Conventional
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Correlator%%%%%%%%%%
% replicatedcode=repl(1:16368);     % Original signal with doppler's sinu having length of 4*4092
% complexsign=zeros(1,16368);
% for l=1:16368
%     a(l)=phaseshiftedrepl(l).*replicatedcode(l);
%     complexsign(l)=a(l);           %%Elementwise Multiplication
% end
% %for ib=1:1:4092
% complexsignpart1=complexsign(1:8184);
% complexsignpart2=complexsign(8185:16368);
% coherentcomb1=intdump(complexsignpart1,8184);  % coherent combination
% coherentcomb2=intdump(complexsignpart2,8184);
% z=(coherentcomb1.*coherentcomb1)+(coherentcomb2.*coherentcomb2); % Non coherent Integration
% freqadjust=-2000:4000/4092:1999.95;
% codephase=1:1:4092;
% %end
% nd2=1:1:4092;
% 
% for frequ=-2000:2000
%     switch frequ
%         case -2000
%             corr1conv=exp(-2*pi*1i*frequ*nd2*ts)*z;
%             case -1500
%             corr2conv=exp(-2*pi*1i*frequ*nd2*ts)*z;
%             case -1000
%             corr3conv=exp(-2*pi*1i*frequ*nd2*ts)*z;
%             case 0
%             corr4conv=exp(-2*pi*1i*frequ*nd2*ts)*z;
%             case 1000
%             corr5conv=exp(-2*pi*1i*frequ*nd2*ts)*z;
%             case 1500
%             corr6conv=exp(-2*pi*1i*frequ*nd2*ts)*z;
%             case 2000
%             corr7conv=exp(-2*pi*1i*frequ*nd2*ts)*z;
%     end
% end
% plot3(codephase,freqadjust,corr1conv);
% hold on;plot3(codephase,freqadjust,corr2conv);
% hold on;plot3(codephase,freqadjust,corr3conv);
% hold on;plot3(codephase,freqadjust,corr4conv);
% hold on;plot3(codephase,freqadjust,corr5conv);
% hold on;plot3(codephase,freqadjust,corr6conv);
% hold on;plot3(codephase,freqadjust,corr7conv);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Matched Filter%%%%%%%%%%%%%%
% 
% replicasignal=repl(1:4092);       % or this can be the first period of phaseshiftedrepl
% circcorr=conv(phaseshiftedrepl,fliplr(replicasignal)); % length= 20459 (16368+4092-1)
% 
% circcorrfinal=circcorr(1:16368);
% signalpart1=circcorrfinal(1:8184);
% signalpart2=circcorrfinal(8185:16368);
% coherentint1=intdump(signalpart1,8184);        % Coherent Combining
% coherentint2=intdump(signalpart2,8184);
% y=(coherentint1.*coherentint1)+(coherentint2.*coherentint2); % Non coherent Integration
% freqadj=-2000:4000/4092:1999.95;
% codephases=1:1:4092;
% b=randn(1,4092);
% ndi=1:1:4092;
% for freq=-2000:2000
%     switch freq
%         case -2000
%             corr1=exp(-2*pi*1i*freq*ndi*ts)*y;
%             case -1500
%             corr2=exp(-2*pi*1i*freq*ndi*ts)*y;
%             case -1000
%             corr3=exp(-2*pi*1i*freq*ndi*ts)*y;
%             case 0
%             corr4=exp(-2*pi*1i*freq*ndi*ts)*y;
%             case 1000
%             corr5=exp(-2*pi*1i*freq*ndi*ts)*y;
%             case 1500
%             corr6=exp(-2*pi*1i*freq*ndi*ts)*y;
%             case 2000
%             corr7=exp(-2*pi*1i*freq*ndi*ts)*y;
%     end
% end
% figure();
% 
% plot3(codephases,freqadj,corr1);
% hold on;plot3(codephases,freqadj,corr2);
% hold on;plot3(codephases,freqadj,corr3);
% hold on;plot3(codephases,freqadj,corr4);
% hold on;plot3(codephases,freqadj,corr5);
% hold on;plot3(codephases,freqadj,corr6);
% hold on;plot3(codephases,freqadj,corr7);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Project 3 Tracking %%%%%%%%%

j=kron(i,ones(1 ,2));
singleperiod=repl(1:4092);
signal=zeros(1,4092);
signalsummation=zeros(1,20460);
for f=f-20:10:f+20
    m=1;
 for l=1:4092
     a(l)=singleperiod(l).*i(l);
     signal(m)=a(l);           %%Elementwise Multiplication
 end
 signalsummation=[signal signalsummation];  % getting doubled size matrix , somethig wrong
 m=m+1;
end