            function varargout=RunBinaryMap(obj, xin)
               
                switch obj.MappingType
                    case 'BPSK'
                        %Mapping
                        % b0-->-1
                         %b1-->+1;
                        dataout1=2*xin-1; 
                    case 'QPSK'
                        %Currently unsupported
                end
           dataout2= upsample(dataout1, obj.LupSample) ;
           varargout{1}=dataout2;
