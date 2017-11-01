%Returns the thermal conductivity k
%required inputs: material, temperature
%material = 'steel' or 'insul' or 'oil'
%temperature in Celsius [C]

function k = k_factor(material,T)
if strcmp(material,'oil')
    k = 0.142 - 0.00016*T;
end


if strcmp(material,'steel')
    k = 14.6 + 0.0127*T;
end

if strcmp(material,'insul')
    k = (7.702e-4)*T + 0.206;
end

end