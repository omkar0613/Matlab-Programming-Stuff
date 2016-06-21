classdef BasebandGen < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        h=[1,3,1];  % channel
        Pulse=[1, 2, 1]; %baseband pulse
        v=0.1;  % noise
        y=[];
        MappingType = 'BPSK';
        NFREQ=256;
        LupSample = 7;
    end
    
    methods
        function obj=BasebandGen(varargin)
            for k=1:nargin
                switch k
                    case 1
                        obj.h=varargin{1};
                    case 2
                        obj.v=varargin{2};
                    case 3
                        obj.Pulse=varargin{3};
                end
            end
        end
            

    end

end
            
       
