orgImage=imread('C:\Users\User\Desktop\Spring\DSP\Final Project pdfs\studyImage.jpg');

image(orgImage);


guassNoise=imnoise(orgImage,'gaussian',1,0.5);
figure(1);
image(guassNoise);
title('Gaussian Noise with Mean 1 & Variance 0.5');



grayGuassNoise=rgb2gray(guassNoise);
figure(2);
image(grayGuassNoise);
title('Noise Image converted to gray Image');

fftorgImage=abs(fft(rgb2gray(orgImage)));
figure(3);
plot(fftorgImage);
axis([0 600 0 20000]);
title('Abs value of FFT of gray scaled original image');

fftNoiseImage=abs(fft((grayGuassNoise)));
figure(4);
plot(fftNoiseImage);
axis([0 600 0 20000]);
title('Abs value of FFT of gray scaled Noise added Image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot first half of DFT %%%%%%%%%%%%%%%%
% num_bins=length(fftNoiseImage);
% figure(5);
% plot([0:1/(num_bins/2 -1):1],fftNoiseImage(1:num_bins/2));
% title('Normalized Frequency');

%%%% Designing 2nd order Butterworth %%%%%%%%%%%%%%%%%%%%%%%%
[b a]=butter(2,0.5,'low');
H=freqz(b,a,floor(num_bins/2));
hold on
%figure(7);
%plot([0:1/(num_bins/2 -1):1],abs(H),'r');
%%%%%%%%%%% Filtering the signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%
filtered_Image=filter(b,a,fftNoiseImage);
figure(6);
plot(filtered_Image,'r');
axis([0 600 0 20000]);
invfiltered_Image=abs((filtered_Image));
figure(7);
image(invfiltered_Image);

[m n r]=size(invfiltered_Image);
rgb=zeros(m,n,3); 
rgb(:,:,1)=invfiltered_Image;
rgb(:,:,2)=rgb(:,:,1);
rgb(:,:,3)=rgb(:,:,2);
invfiltered_Image=rgb/256; 
figure(8);
imshow(invfiltered_Image);


% saltAndpepperNoise=imnoise(orgImage,'salt & pepper',1);
% figure(3);
% image(saltAndpepperNoise);
% title('Salt & Pepper Noise with density 1');


% figure(4);
% scatter(rand(1,20)-0.5,rand(1,20)-0.5);  %# Plot some random data
% hold on;                                 %# Add to the plot
% image([-0.1 0.1],[0.1 -0.1],orgImage); 
