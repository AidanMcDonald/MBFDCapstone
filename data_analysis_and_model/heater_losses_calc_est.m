function output = heater_losses_calc_est(T_heater)
T_ave = mean(T_heater);

if T_ave <= 162+273
    output = 1.810903123742793*(T_ave-273) - 2.294041714711115;
end

if T_ave > 162 + 273
    output = 293.634971752202;
end

end