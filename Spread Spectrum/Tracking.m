%All the inputs
clear all;
clc;
stage=10;
     %%%%% fliplr
ptap1=[3,10];

ptap2=[2,3,6,8,9,10];  % feedbacks generated according to the given polynomials

 regi1=[1 0 0 0 0 0 0 1 0 0];
 regi2=[1 1 1 0 1 0 0 1 1 0 ];

T=1e-3;
n=1:4092;                                           % for multiplying the Doppler sinusoid with code of size 4092
ts=1e-3/1023;
z=1:8184;
%m sequences generated
m1=mseq(stage,ptap1,regi1);
m2=mseq(stage,ptap2,regi2);

code=goldseq1(m1,m2,1);                             % Gold Seq Generated   size 1023
codebin=code*2-1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Costas Loop %%%%%%%%%%%%%%%%%%%%%%%%%%%
i=kron(codebin,ones(1 ,4));                         % size 4092
noisechannel=1e5*randn(1,length(i));

r=1;
no=1;
for noise=1:2
    if noise==1
        noisechannel=1;
        name='No Noise';
    elseif noise==2
        noisechannel=1e-16*randn(1,length(i));
        name='Noise included';
    end
for f=-500:10:500
    
    d=exp(2*pi*1i*n*f*ts);                          % Doppler Freq varied from -250 to 250
    GenSign(r:r+4091)=i.*d.*noisechannel;                         % Signal multiplied with Doppler Freq
    CohInt(r:r+4091)=GenSign(r:r+4091).*i;          % Elementwise Multiplication
    Intvalues(no)=intdump(CohInt(r:r+4091),4092);
    RealIntvalues(no)=real(Intvalues(no));
    ImgIntvalues(no)=imag(Intvalues(no));
    angle(no)=atan(RealIntvalues(no)./ImgIntvalues(no));
    angleindeg(no)=radtodeg(angle(no));
    
   % plot(angleindeg);
   % hold on;
    r=r+4092;
    no=no+1;
end
figure();
plot(angleindeg);
title(sprintf('%c',name));
end
figure();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Frequency Locked Loop %%%%%%%%%%%%%%%%%%%%%%
j=kron(codebin,ones(1 ,8));                         % size 8184
l=1;
k=1;
noisechannel1=1e5*randn(1,length(j));
for noise1=1:2
    if noise1==1
        noisechannel1=1;
        name='No Noise';
    elseif noise==2
        noisechannel1=1e-16*randn(1,length(j));
        name='Noise included';
    end
for f=-250:10:250
    dopp=exp(2*pi*1i*z*f*ts);                       % Doppler Freq Gen
    MixedSignal(l:l+8183)=j.*dopp;                            % Signal with Doppler Freq
    
    Mix1(l:l+4091)=MixedSignal(l:l+4091);                       % 1 period of 4092 samples
    Mix2(l:l+4091)=MixedSignal(l+4092:l+8183);                       % 1 period of 4092 samples
    j1=j(1:4092);
    j2=j(4093:8184);
    Samplewisemult1(l:l+4091)=Mix1(l:l+4091).*j1;
    Samplewisemult2(l:l+4091)=Mix2(l:l+4091).*j2;
    IntegratedSignal1(k)=intdump(Samplewisemult1(l:l+4091),4092);
    IntegratedSignal2(k)=intdump(Samplewisemult2(l:l+4091),4092);
    Realpart1(k)=real(IntegratedSignal1(k));
    Realpart2(k)=real(IntegratedSignal2(k));
    Imgpart1(k)=imag(IntegratedSignal1(k));
    Imgpart2(k)=imag(IntegratedSignal2(k));
    angle1(k)=atan(Realpart1(k)./Imgpart1(k));
    angle2(k)=atan(Realpart2(k)./Imgpart2(k));
    Diffangle(k)=angle2(k)-angle1(k);
    Diffangleindeg(k)=radtodeg(Diffangle(k));
    l=l+8184;
    k=k+1;
end
figure();
plot(Diffangleindeg);
title(sprintf('%c',name));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Code Discriminator%%%%%%%%
counter=1;
for n=-4:2:-2
    x=sum(i.*circshift(i,[0,n]));
    Sig1(:,counter)=x;
    counter=counter+1;
end

counter=1;
for n=2:2:4
    x=sum(i.*circshift(i,[0,n]));
    Sig2(:,counter)=x;
    counter=counter+1;
end
 Sig1final=[Sig1 0 0 ];
 Sig2final=[ 0 0 Sig2];
     EarlyMinusLate=Sig2final-Sig1final; 
     EarlyPlusLate=Sig1final+Sig2final;
     Data=EarlyMinusLate./EarlyPlusLate;
     figure();
     plot(Data);
     axis([1 4 -2 2]);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      noisegen=100*randn(1,4);
%      Sig1finalplusnoise=Sig1final.*noisegen;
%      Sig2finalplusnoise=Sig2final.*noisegen;
%      EarlyMinusLate1=Sig2finalplusnoise-Sig1finalplusnoise; 
%      EarlyPlusLate1=Sig1finalplusnoise+Sig2finalplusnoise;
%      Data1=EarlyMinusLate1./EarlyPlusLate1;