function varargout = transmit( obj1 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mixeddata=conv(obj1.binary_sequence,a.txpulse);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
convdata=conv(obj1.binary_sequence,obj1.txpulsefinal);
convdatafinal=convdata(1:4000);
%data=obj1.binary_sequence+obj1.yawgnbasefinal;           % data multiplied with AWGN Noise & value of the matrix returned in variable z
data=convdatafinal+obj1.yawgnbasefinal;           % data multiplied with AWGN Noise & value of the matrix returned in variable z
matcheddata=conv(data,obj1.txpulsefinal);
matcheddatafinal=matcheddata(1:4000);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

magdata=zeros(1,4000);
 for k=1:4000
    magdata(k)=abs(matcheddatafinal(k));
 end
 databits=zeros(1,4000);
 for l=1:4000
     if magdata(l)>1                          % max likelihood detection is used to determine 0 or 1
         databits(l)=1;
         l=l+1;
     else
         databits(l)=0;
         l=l+1;
     end
 end
%varargout{1}=databits;                        % detected o/p is passed to varb z
varargout{1}=databits;
end

