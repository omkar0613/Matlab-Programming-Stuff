function varargout = BER( obj1 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
noe2=[];
ber2=[];
%%%%%%%%%%%%%%  Design for transmitter considering ebn0%%%%%%%%%%%%%%%%%%%
   for ebn0db=1:1:51
sigplusnoisearray=obj1.binseqpattern+obj1.noisearrayfinal; 
%sigplusnoisearray=obj1.binseqpattern+obj1.varrn;
r=sigplusnoisearray-(ebn0db/0.51);
magdata=zeros(1,51);
       for k=1:51
          %magdata(k)=abs(sigplusnoisearray(k));
          magdata(k)=abs(r(k));
       end
       databits=zeros(1,51);
             for l=1:51
                if magdata(l)>1                          % max likelihood detection is used to determine 0 or 1
                databits(l)=1;
                l=l+1;
                else
                databits(l)=0;
                l=l+1;
                end
             end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %%%%%%%%%%%%%%  Design for receiver considering ebn0 loop %%%%%%%%%%%%%%%%
 compare=zeros(1,4000);
   for k=1:17
       compare((k-1)*3+1:k*3)=xor(databits((k-1)*3+1:k*3),obj1.binseqpattern((k-1)*3+1:k*3));  % 8-ary PSK detector is designed which compares 3 bits at a time
   end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %%%%%%%%%%%%%%%% Bit Error Calculation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   noe=0;
for k=1:1:4000
    if compare(k)==1
        noe=noe+1;
    end
end
noe2=[noe2,noe];
nod=51;
biterrorrate=noe2/nod;
%ber2=[ber2,ber];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   end
   ber2=[ber2,biterrorrate];
varargout{1}=ber2;
end

