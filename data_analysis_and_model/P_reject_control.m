function output = P_reject_control(setpoint_temperature, T_cold_sink,T_hot_leg,mass_flow_oil)
%This file determines what the CTAH frequency should be given a desired
%set-point temperature, comparing it to the cold sink.

c_p_oil = @(T) 1518 + 2.82.*(T-273); 


if T_cold_sink <= setpoint_temperature
    power_reject_needed = 0;
    output = [0  0]; %If the cold sink oil temp is less than the desired then stop CTAH fan (fan freq = 0). Power reject is 0. 

%If cold sink oil temp is higher than the desired. Control is proportional
%in nature.
else 
power_reject_needed = mass_flow_oil.*(c_p_oil(0.5.*(T_hot_leg + setpoint_temperature))).*(T_hot_leg - setpoint_temperature);
power_reject_divided_hot_oil_ambient = power_reject_needed./(T_hot_leg - (21+273));
CTAH_frequency_needed = (power_reject_divided_hot_oil_ambient - 17.0729)./0.4228;

%output is the power rejection calculated using the P_reject and inputing
%the desired frequency
output = P_reject(CTAH_frequency_needed, T_hot_leg);
end
end