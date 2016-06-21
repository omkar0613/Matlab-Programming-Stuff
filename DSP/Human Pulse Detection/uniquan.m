function out_seq=uniquan(fftbright,bits)
 in_max=max(abs(fftbright));           % fftbright is final fft signal of Project 1
in_min=0;
step=(in_max-in_min)/(2^bits);
fftbright=floor((fftbright-in_min)/step);
delta=in_min+(step/2);
L=length(fftbright);
out_seq = zeros(size(fftbright), 'double');
for y=1:L
out_seq(y) = ((double(fftbright(y)) * step) + delta)*100;
%figure(4);
%hold on;
%plot(y,out_seq(y));
xlabel('Frequency');
 ylabel('Amplitude');
 title('Quantized Output, Number of bits=2');
display(out_seq(y));
display(y);
end
 end