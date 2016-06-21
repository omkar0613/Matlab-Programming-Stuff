classdef PSK < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rcrolloff=[];
        symbolrate=[];
        NumSamplesTxPulse=[];
        SampleLaunchPeriod=[];
        b=[];
        noisearrayfinal=[];
       % inputdata=[];
      %  trans;
         ebn0db=[];
         yawgnbase=[];
         yawgnbasefinal=[];
         binary_sequence=[];
         y=[];
        % z=[];
        binseqpattern=[];
        varrn=[];
        receivedbits=[];
        txpulsefinal=[];
    end
    
    methods
        function obj1=PSK(varargin)
            for k=1:nargin
                switch k
                    case 1
                        obj1.rcrolloff=varargin{1}.rcrolloff;
                        obj1.symbolrate=varargin{1}.symbolrate;
                        obj1.NumSamplesTxPulse=varargin{1}.NumSamplesTxPulse;
                        obj1.SampleLaunchPeriod=varargin{1}.SampleLaunchPeriod;
                        
                    case 2
                        obj1.b=varargin{2};
                    case 3
                        obj1.yawgnbase=varargin{3}.yawgnbase;
                        obj1.yawgnbasefinal=varargin{3}.yawgnbasefinal;
                        obj1.binary_sequence=varargin{3}.binary_sequence;
                        obj1.y=varargin{3}.y;
                        obj1.binseqpattern=varargin{3}.binseqpattern;
                        obj1.varrn=varargin{3}.varrn;
                        obj1.ebn0db=varargin{3}.ebn0db;
                        obj1.receivedbits=varargin{3}.receivedbits;
                        obj1.noisearrayfinal=varargin{3}.noisearrayfinal;
                        obj1.txpulsefinal=varargin{3}.txpulsefinal;
                end
            end
        end
    end
    
end

