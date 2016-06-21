           function varargout=RunBasebandGen(obj, xin)
                dbstop if error
                xdat1  = RunBinaryMap(obj, xin);
                xdat2= conv(xdat1, obj.Pulse);
                z=conv(obj.h, xdat2);
                vnoise=sqrt(obj.v)*randn(size(z));
                obj.y=z+vnoise;
                varargout{1}=obj;
            
