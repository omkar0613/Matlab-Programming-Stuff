classdef BasebandGenNew < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    %hinit, b, EbNodB, Es, rcrolloff,symbolrate,NumSamplesTxPulse,SampleLaunchPeriod
    properties
        txpulse=[1, 2, 1]; %baseband pulse
        v=0.1;  % noise
        y=[];
        MappingType = 'QPSK';
        NFREQ=256;
        LupSample = 7;
        rcrolloff=[];
        symbolrate=[];
        NumSamplesTxPulse=[];
        SampleLaunchPeriod=[];
        Es=[];
        basebandsig=[];
        bkphasors=[];
        Ts=[];
        b=[];
        Plotfig='no';
     %   hc=[];           %modification
    end


    methods
        function obj=BasebandGenNew(varargin)

            for k=1:nargin
                switch k
                    case 1               
                    obj.rcrolloff=varargin{1}.rcrolloff;
                    obj.symbolrate=varargin{1}.symbolrate;
                    obj.NumSamplesTxPulse=varargin{1}.NumSamplesTxPulse;
                    obj.SampleLaunchPeriod=varargin{1}.SampleLaunchPeriod;
                    obj.Plotfig=varargin{1}.Plotfig;
               %     obj.hc=varargin{1}.hc;                            %modification
                    case 2
                        obj.Es=varargin{2};
                    case 3
                        obj.b=varargin{3};
                end
            end
     

[obj.txpulse, obj.basebandsig, obj.bkphasors, obj.Ts] =...
    BasebandGen(obj.b, obj.rcrolloff, obj.symbolrate, obj.NumSamplesTxPulse, ...
    obj.SampleLaunchPeriod, obj.Es, obj.Plotfig);

                
        end
    end

end

   
  
            
       
