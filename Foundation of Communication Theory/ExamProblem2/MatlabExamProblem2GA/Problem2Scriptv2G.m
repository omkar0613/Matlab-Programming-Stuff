%EE 5183: Foundations of Communications Exam Problem 2
clear all
clear classes;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SNR IN dB
%Students Can modify SNR Value and #BPSK Phasors generated
%Baseband Pulse
gsimcase=0;
stattype= 'statistical';
InfoNumStages=500;
Tsymb=1/128e3;
Ts=1/640e3;
p=Tsymb/Ts;
isiquant=[];
hq=[];
nr=1:1:5;
for n=1:1:p
    r=n*Tsymb;
    hq=[hq,r];
end
for n=1:1:p
l=conv(hq,rectangularPulse(n/Tsymb));
isiquant=[isiquant,l];
end
EbNodB=8;  % in dB
Es=1;
NumBitsPerSymbol=1;  %1-Tupple bits
SimCase = 'BPSK';
plot_baseband_figs= 'no'; %'yes', 'no' % affects class plots only
zfield=3;
h_unormal= [4.0825e-01, zeros(1,4), 8.1650e-01, zeros(1,4), 4.0825e-01];

%Baseband Equivalent Channel is typically complex
hc = h_unormal/norm(h_unormal);  %Normalized channel

NumStages=InfoNumStages+10;
binarysequence= [zeros(1,5), randi([0,1],1,InfoNumStages),zeros(1,5)];

NumSymbs=length(binarysequence)/NumBitsPerSymbol;
b=zeros(1, NumSymbs);
for k=1:NumSymbs
    % 1-tupple: b0 --> b0 mapping to complex coefficient
    switch binarysequence((k-1)*NumBitsPerSymbol+1:k*NumBitsPerSymbol)*[1]';
    % BPSK Mapping Defined
        case 0
            b(k)=-1;
        case 1
            b(k)=1;
    end
end

axis([0,40,-1,1]);
%instantiate the object a:  "a" is of class BasbandeGenNew
%you must create a folder @BasebandGenNew and place class constructor and
p.rcrolloff=1.0;  %structure p
p.symbolrate=128e3;
p.NumSamplesTxPulse=21;
p.SampleLaunchPeriod=5;
p.Plotfig='no';
%p.hc=hc;                    % modification
a=BasebandGenNew(p, Es,b);  %constructor
%pulse has even symmetry;
matchedfilter=a.txpulse;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%DO NOT MODIFY HERE%%%%%%%%%%%%%%%%%%%%
%
basebandsig=a.basebandsig;
bkphasors=a.bkphasors;
Ts=a.Ts;
EbNoLin=10^(EbNodB/10);
nvar=(1/NumBitsPerSymbol)/EbNoLin;  
isisig=conv(basebandsig,hc);
y=isisig+sqrt(nvar)*randn(size(isisig)); %ISI observation in AWGN is vector y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ISIlength=conv(hc,a.txpulse);
L=length(ISIlength);
N=L*(Ts/Tsymb);
Nfinal=round(N);
hqn=[];
i=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% switch gsimcase   %conv(g(n), delta(n-d))
%     case 0
%        conv_g_delta=[zeros(1,20),1,zeros(1,20)].';  %size <=wlen+hlin-1
%        wlen=31;
%     case 1
%        conv_g_delta=[0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,1,1,1,1,1,0,0,0,0,0].'; %size <=wlen+h-1
%     case 2
%        conv_g_delta=[0,0,0,0,0,1,0,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,0,0,0].';  %size <=wlen+h-1
%        wlen=15;   
%     case 3
%        conv_g_delta=(conv([0,0,0,0,0,0,0,1,0,0,0,0,0,0,0], matchedfilter)).';
%        wlen=25;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%h=quantize(ISIlength);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Equalizer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P=256;
%dptr=length(hc)+wlen;
br=basebandsig.';

%[eqobj, rhsvec]=AdvEqual(hc,br,conv_g_delta,wlen,P,dptr, nvar,stattype);
for k=1:1:length(hc)
  for t=1:1:N-1
     % hqn(t)=hc(t).*dirac(0-k*Tsymb);
  %    hqn(t)=
  end
end
figure(1)
subplot(2,1,1), plot(real(hc))
xlabel('sample index');
ylabel('Real');
title('Real Part of hc[n]');
subplot(2,1,2), plot(imag(hc))
xlabel('sample index');
ylabel('Imag');
title('Imag Part of hc[n]');

figure(2)
plot(a.txpulse)
xlabel('sample index');
ylabel('Amplitude');
title('Prototype Pulse');

figure(3)
subplot(2,1,1), plot(real(conv(hc,a.txpulse)))
xlabel('sample index');
ylabel('Real');
title('Real Part of ISI Pulse');
subplot(2,1,2), plot(imag(conv(hc,a.txpulse)))
xlabel('sample index');
ylabel('Imag');
title('Imag Part of ISI Pulse');

figure(4)
subplot(2,1,1), plot(real(basebandsig))
xlabel('sample time index');
ylabel('Real');
title('Real Part of Tx Complex Baseband Signal');
subplot(2,1,2), plot(imag(basebandsig))
xlabel('sample time index');
ylabel('Imag');
title('Imag Part of Tx Complex Baseband Signal');

figure(5)
subplot(2,1,1), plot(real(y))
xlabel('sample time index');
ylabel('Real');
title('Real Part of Received  Complex Baseband Signal: After Channel');
subplot(2,1,2), plot(imag(y))
xlabel('sample time index');
ylabel('Imag');
title('Imag Part of Received  Complex Baseband Signal: After Channel');

figure(8)
subplot(2,1,1), plot(real(isiquant));
subplot(2,1,2), plot(imag(isiquant));
%%%%%%%%%%%%%%%%%%%%%%%STUDENT CODE BELOW%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Add a Method ViterbiEqualDetect to Class BasebandGenNew%%%%%%%%%%
%We can alternatively add a function to the Basebandmodel if desired

% %ccc=ViterbiEqualDetect(arg1, arg2, ...argN);                 
% %numerrors=sum(xor(ccc.brecov, binary_sequence))