%%%%%%%%%%%%%%%%%%%%%%%%%
%BasebandGen Script  EE5183
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%
clear classes;
clear all;
clc;
dbstop if error  % stop if an error occurs 
clear all  %  clears work space between runs

rcrolloff=1.0;   %rolloff Factor for nyquist pulse
%symbolrate=320e3;  %desired symbol rate
symbolrate=64e3;  %desired symbol rate
%NumSamplesTxPulse=200; %Warning the program can modify this value (pulse length)!
NumSamplesTxPulse=64; %Warning the program can modify this value (pulse length)!
SampleLaunchPeriod=63;  % period in samples between symbol launches
EbNodB=10;   
ebn0db=(1:1:51);   % array is considered to plot agaist BER
receivedbits=[];
ebn0dblin=10.^(ebn0db/10);
varrn=(1/2)./(ebn0dblin);                  % array of noise created for plotting BER graph
%txfinal=obj.txpulse;
%NumBitsPerSymbol=2;  %2-Tupple bit QPSK
NumBitsPerSymbol=3;  %3-Tupple bit PSK
%NumberSourceBits=40;
NumberSourceBits = 4000; %information source
%NumberSourceBits = 500; %information source
Es=1;  % energy per symbol
EbNoLin=10^(EbNodB/10);
%vn=(1/2)/EbNoLin;

% fc is set below: carrier frequency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = RandStream('mt19937ar','Seed',0);  %Do not modify this line
%disp(s);
savedState=s.State;  %Do not modify this line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
binary_sequence=randi(s,[0,1],1, NumberSourceBits);
binseqpattern=binary_sequence(1:51);                 % 10 bits of pattern are generated for testing purpose ( 51 bits )
%sigplusnoisearray=binseqpattern+varrn;               % 10 bit signal added with noise
NumSymbs1=length(binary_sequence)/NumBitsPerSymbol;  %Number of symbols 
NumSymbs=round(NumSymbs1);            % rounded of as the above division giving ans in decimals
b=zeros(1, NumSymbs);
inputdata=[];
for k=1:NumSymbs
    %n-tupple: (e.g. 2-tupple b1,b0 --> 2*b1+b0 mapping to complex coeff.)
    switch binary_sequence((k-1)*NumBitsPerSymbol+1:k*NumBitsPerSymbol)*[4,2,1]';
        % QPSK Mapping Defined
        case 0
            b(k)=exp(1i*((2*pi/8)*0));
        case 2
            b(k)=exp(1i*((2*pi/8)*1));
        case 3
            b(k)=exp(1i*((2*pi/8)*2));
        case 7
            b(k)=exp(1i*((2*pi/8)*3));
        case 6
            b(k)=exp(1i*((2*pi/8)*4));
        case 4
            b(k)=exp(1i*((2*pi/8)*5));
        case 5
            b(k)=exp(1i*((2*pi/8)*6));
        case 1
            b(k)=exp(1i*((2*pi/8)*7));
    end
end
%%%%%%%%%
%%%%%%%%%%%%%%%%%
p.rcrolloff=rcrolloff;
p.symbolrate=symbolrate;
p.NumSamplesTxPulse=NumSamplesTxPulse;
p.SampleLaunchPeriod=SampleLaunchPeriod;
                          %%%%%%%%%%%%%%%%%%%%%%% added recently
a=BasebandGenNew(p,Es,b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
upsamp=1;
y=resample(a.basebandsig, upsamp, 1);
vn=(1/2)/EbNoLin;
txpulse_ts2=resample(a.txpulse, upsamp, 1);
Ts2=a.Ts/upsamp;
yawgnbase=y+sqrt(vn/2)*randn(size(y))+1i*sqrt(vn/2)*randn(size(y));
txpulsefinal=a.txpulse;
for t=1:1:51
    yawgnbaseforloop=y+sqrt(varrn(t)/2)*randn(size(y))+1i*sqrt(varrn(t)/2)*randn(size(y));
end
noisearray=yawgnbaseforloop;
noisearrayfinal=noisearray(1:51);               %noise to be added in loop with parameters 51
yawgnbasefinal=yawgnbase(1:4000);   
%yawgnbasefinal=yawgnbase(1:NumberSourceBits);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  q.yawgnbasefinal=yawgnbasefinal;
 %q.vn=vn;
 q.binary_sequence=binary_sequence;
 q.yawgnbase=yawgnbase;
 q.ebn0db=ebn0db;
 q.y=y;
 q.binseqpattern=binseqpattern;
 q.varrn=varrn;
 q.receivedbits=receivedbits;
 q.noisearrayfinal=noisearrayfinal;
 q.txpulsefinal=txpulsefinal;
%a=BasebandGenNew(p,Es,b);
r=PSK(p,b,q);

%%%%%%%%%%%%%%%%%%%%%%%%%%

% upsamp=1;
% y=resample(a.basebandsig, upsamp, 1);
% 
% txpulse_ts2=resample(a.txpulse, upsamp, 1);
% Ts2=a.Ts/upsamp;
z=[];
z=transmit(r);                         % data transmission with AWGN Noise
disp(z);

%%%%%%%%%%%%%%%%  Modifications for Receiver Function %%%%%%%%%%%%%%%%%%%%
rdata=receiver(r,z);                   % transmitted data with AWGN noise added is input to the receiver
disp(rdata);
p=0;
for k=1:1:4000
    if rdata(k)==1
        p=p+1;
    end
end
disp(p);                      % no of 1's in a matrix = no. of errors
errorcal=[];
errorcal=BER(r);
length(errorcal);

%q.z=z;
%rdata=PSK(z);
%receiveddata=receiver(r);
%FOR BASEBAND MODE USE the AWGN Channel
% EbNoLin=10^(EbNodB/10);
% vn=(1/2)/EbNoLin;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Modifications for BER function%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%yawgnbase=y+sqrt(vn/2)*randn(size(y))+1i*sqrt(vn/2)*randn(size(y));

figure(6);
xax1=Ts2*(0:length(yawgnbase)-1);
subplot(2,1,1), plot(xax1, real(yawgnbase));
xlabel('sample time (sec)');
ylabel('Real');
titletext=strcat({'Baseband Signal in AWGN, EbNo='},{num2str(EbNodB)},...
    {'dB, SamplingFrequency= '}, {num2str(1/Ts2)});
title(titletext);
subplot(2,1,2), plot(xax1, imag(yawgnbase));
xlabel('sample time (sec)');
ylabel('Imag');


figure(7);
fs=1/Ts2;
NumPointsFFT=2048;
xax = ([0:NumPointsFFT-1]/NumPointsFFT)*fs;
yaxdB=20*log10(abs(fft(yawgnbase,NumPointsFFT)));
plot([xax-xax(end)/2], [yaxdB(NumPointsFFT/2+1:NumPointsFFT),yaxdB(1:NumPointsFFT/2)], 'b');
titletext=strcat({'FFT of QPSK Baseband Signal: Rsymb='},{num2str(a.symbolrate)},{' Rolloff= '}, {num2str(a.rcrolloff)},...
    {' SamplingRate= '}, {num2str(fs)});
xtext='Frequency in Hz';
ytext='Baseband Signal Power in dB';
xlabel(xtext);
ylabel(ytext);
title(titletext);

x=1:1:1326;
  figure(10);
  semilogy(ebn0db,errorcal);
%%%%%%%%%%%%%%Add a Method BasebandDemod to Class BasebandGenNew%%%%%%%%%%
%We can alternatively add a function to the Basebandmodel if desired


% %ccc=BasebandDemod(arg1, arg2, ...argN);                 
% %numerrors=sum(xor(ccc.brecov, binary_sequence))
    