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
m1=mseq(stage,ptap1,regi1,n);
m2=mseq(stage,ptap2,regi2,n);

code=goldseq1(m1,m2,1);                             % Gold Seq Generated
codebin=code*2-1;
%z=autocorr(codebin);                                   % Autocorrelation of a Gold Code
% figure();
% stem(code);
% title('Obtained Gold Seq');

% figure();
% stem(z);
% 
% title('Autocorrelation of gold code');

i=kron(codebin,ones(1 ,4));                             % Number of Samples per chip increased to 4 -size 4092 Samples
% 
% 
% a=autocorr(i);
% figure();
% stem(a);
% title('Autocorrelation of Sampled Gold Seq');
% 
% b=exp(2*pi*1i*n*f*ts);
% 
%  figure();
%  stem(b);                   % Generation of Doppler Sinusoid
%  title('Doppler Sinusoid');
%  
%  comp=i.*b;                 % Complex Signal is generated which has a size of 4092 Samples
%  figure();
%  stem(comp);
%  axis([0 4092 -1.5 1.5  ]);
%  title('Complex Wave');
%  
%  comp1=kron(comp,ones(1 ,5));   % 5 periods of complex wave are considered by replicating 1st period
%  figure();
%  stem(comp1);
%  axis([0 8000 -1.5 1.5]);
%  %axis([-1 1 -1 1]);
%  title('5 Periods of Complex Wave');
%  
% 
% 
%   comp2=comp1(500:16867);        % Arbitarily 4 periods are considered starting from sample no. 500
%   figure();
%   stem(comp2);
%   axis([500 16868 -1.5 1.5]);    % time shifted Complex Wave
%   %axis([-1 1 -1 1]);
%   title('Time Shifted Complex Wave');
%  
% 
%  %y=awgn(comp2,10);              % S/N is set as 10
%  inoise=randn(1,length(comp2));
%  y= comp2+inoise;
%  figure();
%  stem(imag(y));
%  axis([1 16868 -1.5 1.5]);
%  title('Time Shifted Complex Wave with AWGN');
%  
%  
%  %%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%
%  
%  cr=crosscorr(comp(1,:),i(1,:));          % Cross-Correlation between the oversampled signal with Doppler Sin & oversampled Signal
%  figure();
%  stem(cr);
%  axis([0 45 -0.08 0.08]);
%  title('Crosscorrelation of Signals');
%  figure();
%  z=1;
%  for q=0:50000:700000
%         
%         b=exp(2*pi*1i*n*q*ts);             % Effect of Doppler Sinusoid on peak degradation
%         complex=i.*b;
%         p=autocorr(complex);
%         subplot(4,4,z);
%         plot(p);
%         axis([0 25 -1.5 1.5]);
%         str=sprintf('DF= %d', q);
%         title(str);
%         z=z+1;
%  end
%  %%%% Shrinking and Expanding of a wave due to code doppler
%  signal1=i.*exp(2*pi*1i*n*0*ts);         % no sinusoidal doppler
%  signal2=i.*exp(2*pi*1i*n*100000*ts);    % signal with doppler frequency
%  signal3=i.*exp(2*pi*1i*n*200000*ts);
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  tr=(0:T/4091:T);
%  figure();
%  subplot(2,2,1);
%  plot(tr,i);
%  title('Org Signal w/o Doppler');
%  axis([0 0.00002 -2 2]);
%  subplot(2,2,2);
%  plot(tr,signal1);
%  title('signal1 with DF 0');
%  axis([0 0.00002 -2 2]);
%  %figure();
%  subplot(2,2,3);
%  plot(tr,signal2);
%  title('signal2 with DF 100000');
%  axis([0 0.00002 -2 2]);
%  %figure();
%  subplot(2,2,4);
%  plot(tr,signal3);
%  title('signal3 200000');
%  axis([0 0.00002 -2 2]);
%  degrad=crosscorr(signal1(1,:),signal2(1,:));   % degradation due to Doppler Code 
%  
%  figure();
% plot(degrad);
%  title('Cross-Corelation of Signal1 and Signal2');

 
 
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
figure();
z=1:1:16368;                     % parameter set as per new number of samples
%%%%%%% Above steps are the repetiton of Project 1 for the Purpose to set
%%%%%%% freq as 1kHz
%finsiggen=zeros(1,16368);
ca=zeros(1,16368);             % 7 matrices are equal size are considered for multiplying with different doppler freq
cb=zeros(1,16368);
cc=zeros(1,16368);
cd=zeros(1,16368);
ce=zeros(1,16368);
cf=zeros(1,16368);
cg=zeros(1,16368);
for df=-2000:2000
    switch df
        case -2000
           ca =repl1plusnoise.*exp(-2*pi*1i*z*(-2000)*ts);
           p1=fft(ca);
           phase1=angle(p1);
           phasechange1=phase1-phase;
    
            
        case -1500
            cb=repl1plusnoise.*exp(-2*pi*1i*z*(-1500)*ts);
             p2=fft(cb);
            phase2=angle(p2);
           phasechange2=phase2-phase;
         
            
        case -1000
            cc=repl1plusnoise.*exp(-2*pi*1i*z*(-1000)*ts);
            p3=fft(cc);
           phase3=angle(p3);
           phasechange3=phase3-phase;
%            
        case 0
            cd=repl1plusnoise.*exp(-2*pi*1i*z*(0)*ts);
            p4=fft(cd);
           phase4=angle(p4);
           phasechange4=phase4-phase;

        case 1000
            ce=repl1plusnoise.*exp(-2*pi*1i*z*(1000)*ts);
            p5=fft(ce);
           phase5=angle(p5);
           phasechange5=phase5-phase;

            
        case 1500
            cf=repl1plusnoise.*exp(-2*pi*1i*z*(1500)*ts);
            p6=fft(cf);
           phase6=angle(p6);
           phasechange6=phase6-phase;

            
        case 2000
            cg=repl1plusnoise.*exp(-2*pi*1i*z*(2000)*ts);
            p7=fft(cg);
           phase7=angle(p7);
           phasechange7=phase7-phase;
           

    end
end
phasechange=phasechange1+phasechange2+phasechange3+phasechange4+phasechange5+phasechange6+phasechange7;

%%%%%%%%%%%%%%%%%%%%%%%%% Crosscorrelation with signal of 1khz
hcorr=dsp.Crosscorrelator;
q1=step(hcorr,repl1,ca);
q2=step(hcorr,repl1,cb);
q3=step(hcorr,repl1,cc);
q4=step(hcorr,repl1,cd);
q5=step(hcorr,repl1,ce);
q6=step(hcorr,repl1,cf);
q7=step(hcorr,repl1,cg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure();
% plot(z,q7);

q=q1.*q2.*q3.*q4.*q5.*q6.*q7;    % Total crosscorrelation
abc=zeros(1,16361);
qfinal=[q abc];

 df1=-2000:0.2444:2000.222;
phasechangefinal=phasechange(1:4092);
plot3(phasechange,df1,q);         % 3D Plot
fd=-2000:0.9776:2000;
qfinal=q(1:4092);
%plot3(n,fd,qfinal);
figure();
%axis=[-40 40 -2000 2000 0 100];
%surf(z,df,finsiggen);

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
cohint1=pulsint(complexsign1,'coherent');  % integrated over certain limits

cohint2=pulsint(complexsign2,'coherent');  % integrated over certain limits
y1=cohint1.*cohint1;                       % Non-coherent integration
y2=cohint2.*cohint2;                       % Non-coherent integration
y=(y1.*y1)+(y2.*y2);
corr=[];
for rt=-2000:2000
    k=1;
    switch rt
    case -2000
    corr(k)=y*exp(-2*pi*1i*rt*ts);
    case -1500
    corr(k+1)=y*exp(-2*pi*1i*rt*ts);
    case -1000
    corr(k)=y*exp(-2*pi*1i*rt*ts);
    case 0
    corr(k)=y*exp(-2*pi*1i*rt*ts);
    case 1000
    corr(k)=y*exp(-2*pi*1i*rt*ts);
    case 1500
    corr(k)=y*exp(-2*pi*1i*rt*ts);
    case 2000
    corr(k)=y*exp(-2*pi*1i*rt*ts);
    end
end
ndp=1:1:8184;
fd=-2000:0.4888:2000;
for k=1:1:7
    plot3(ndp,fd,corr(k));
    hold on;
end
stem(y); 
figure();
title('Conventional Correlator Operation');

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

