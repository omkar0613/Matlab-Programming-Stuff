%EE5183: You do not neet to modify unless you wish to experiment
function[txpulseEs, basebandsig, bkphasors, Ts] =...
    BasebandGen(b, rcrolloff, symbolrate, NumSamplesTxPulse, SampleLaunchPeriod,Es, plotfig)
% clear all
R=rcrolloff;  %rollof off of raised cosine pulse
Rsymb0=symbolrate; %Symbol Rate in kysymbols/second 
Tsymb=1/Rsymb0;  %time duration in seconds between symbol launches
RATE=SampleLaunchPeriod; %Number of discrete samples between successive symbol launches
OLEN=NumSamplesTxPulse;  %approximate value of the desired filter length
OLENP=RATE*( 2*ceil( ceil((OLEN-1)/RATE)/2))+1;  %minimum constraint filter greater than OLEN
FLEN=(OLENP-1)/RATE +1;
N_T=(FLEN-1)/2;

Ts=(1/Rsymb0)/RATE;  %sampling resolution of pulse filter

FilterType='normal'; % raised cosine
Bp = rcosfir(R, N_T, RATE, Ts, FilterType);  %Matlab raise cosine
Bp = Bp/sum(Bp.^2); %normalize pulse energy to 1
txpulse=Bp; 
%%%%%%%%%%%%%%%%%%%% Modifications done by me in this file
figure(7)
stem(txpulse);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^10; % FFT Size for analysis of puse frequency response
Fb=(1/Ts);


xaxf=((0:N-1)/N)*(Fb);
yaxfp=20*log10(abs(fft(Bp,N)));


Borig=Bp/10^(abs(yaxfp(1))/20);
%%%%%%%%%%%%%%%
%Use normalized pulse Energy
%
B=sqrt(Es)*Borig/sqrt(sum(Borig.*conj(Borig)));
txpulseEs=B;
%%%%%%%%%%%%%%%
if plotfig==1;
figure(1)
plot(1:2*N_T*RATE+1,B,'.');
xlabel('sample index')
ylabel('Raised Cosine Pulse Amplitude');
title('Discrete Time Domain Plot of Raised Cosine Pulse');


figure(2)
yaxf=yaxfp-yaxfp(1);
plot([xaxf-xaxf(end)/2], [yaxf(N/2+1:N),yaxf(1:N/2)], 'b');
xlabel('frequency in Hz');
ylabel('Frequency Spectrum Amplidtude in dB');
title('Frequency Plot of Raised Cosine Pulse');
end

b_dirac=upsample(b,RATE); %create bk*dirac function (see plot)
bkphasors=b_dirac;
svec=b(1)*B;  %Very 1st baseband pulse
yvec=conv(b_dirac, B); %sequence of baseband pulses
basebandsig=yvec;
xax0=[0:length(b_dirac)-1]*(1/Fb);
xax1=[0:length(svec)-1]*(1/Fb);
xax2=[0:length(yvec)-1]*(1/Fb);

if plotfig==1;
figure(3)
subplot(2,1,1), plot(xax1, real(svec),'.');
xlabel('sample time (sec)');
ylabel('Real');
title('1st Complex Baseband');
subplot(2,1,2), plot(xax1, imag(svec),'.');
xlabel('sample time (sec)');
ylabel('Imag');

figure(4)
subplot(2,1,1), plot(xax0, real(b_dirac),...
'--bs','LineWidth',0.1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','r',...
                'MarkerSize',3);
xlabel('sample time (sec)');
ylabel('Real');
title('Sequence of Complex Dirac Impulses');
subplot(2,1,2), plot(xax0, imag(b_dirac), ...
    '--bs','LineWidth',0.1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','r',...
                'MarkerSize',3);
xlabel('sample time (sec)');
ylabel('Imag');

figure(5)
subplot(2,1,1), plot(xax2, real(yvec),'.');
xlabel('sample time (sec)');
ylabel('Real');
title('Sequence of Complex Baseband Pulses');
subplot(2,1,2), plot(xax2, imag(yvec),'.');
xlabel('sample time (sec)');
ylabel('Imag');
end



