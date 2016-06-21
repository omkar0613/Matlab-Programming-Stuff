function obj = set(obj,property,value)

switch property
case 'himp'
    obj.h  = value;
case 'vcoef'
    obj.v  = value;
case 'NFREQ'
    obj.NFREQ =value;
end

