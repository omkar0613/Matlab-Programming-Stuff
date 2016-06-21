 function varargout = receiver(obj1, z )
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
 receiveddata=z;
 compare=zeros(1,4000);
 %noiseremoval=receiveddata-obj1.yawgnbasefinal;     % Noise removed from the received data
       for k=1:1333
           compare((k-1)*3+1:k*3)=xor(receiveddata((k-1)*3+1:k*3),obj1.binary_sequence((k-1)*3+1:k*3));  % 8-ary PSK detector is designed which compares 3 bits at a time
       end
 
 varargout{1}=compare;    % comparison between transmitted & received bits   (XOR o/p is found out) & passed in variable rdata
 a=obj1.symbolrate;

 end

