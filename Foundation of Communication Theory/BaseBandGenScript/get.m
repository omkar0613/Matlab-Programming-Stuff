function value = get(obj,property)

switch property
case 'Hf'
    value = fft(obj.h, obj.NFREQ);
case 'v2'
    value = (obj.v)^2;
end