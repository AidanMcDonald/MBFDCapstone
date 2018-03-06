function output = dT_dt_modules(T_modules, T_heater_output_fluid, mass_flow_oil,CTAH_freq,CTAH_control_set)

%T(1) is the hot leg. T(2) is the output from the CTAH. T(3) is the cold
%leg. 
T_hot_leg = T_modules(1); 
T_cold_sink = T_modules(2);
T_cold_leg = T_modules(3);

%Heat capacity of oil. T is in K. 
c_p_oil = @(T)  1518 + 2.82.*(T-273); 

%Density of oil, T is in K
density_oil = @(T)1078-(0.85.*(T-273)); %[kg/m^3]

%% Module inner volume

vol_hot_leg = 2.01E-3; % [m^3]
vol_cold_sink = 2.08E-4; % [m^3]
vol_cold_leg = 2.77E-3 + 2.37E-4 + 2.49E-3; % [m^3]

% Calculate mass of fluids in each of the modules: mass = vol .* density(T)
mass_hot_leg = vol_hot_leg.*density_oil(T_hot_leg);
mass_cold_sink = vol_cold_leg.*density_oil(T_cold_sink);
mass_cold_leg = vol_cold_leg.*density_oil(T_cold_leg);







%% Hot Leg energy balance equation
 
%Hot leg losses has a mean of 30.9347 W with variance of 463.195
hot_leg_power_losses = 30.934707516726835; 

dT_dt_hot_leg = (1./(mass_hot_leg.*c_p_oil(T_hot_leg))).*((c_p_oil(0.5*(T_heater_output_fluid + T_hot_leg)).*mass_flow_oil.*(T_heater_output_fluid - T_hot_leg)) - hot_leg_power_losses);

%% Cold Sink energy balance equation
% Calculate P reject. The following correlation was obtained from the
% second steady state test. 

%First case: Control is off
if strcmp(CTAH_control_set{1},'off')
   power_reject = P_reject(CTAH_freq,T_hot_leg); %Element 1 is the power rejected from calculations, Element 2 is the CTAH frequency
dT_dt_cold_sink = (1./(mass_cold_sink.*c_p_oil(T_cold_sink))).*((c_p_oil(0.5*(T_hot_leg + T_cold_sink)).*mass_flow_oil.*(T_hot_leg - T_cold_sink)) - power_reject(1));
end 

%Second case: Control is on
if strcmp(CTAH_control_set{1},'on')
   power_reject = P_reject_control(CTAH_control_set{2},T_cold_sink,T_hot_leg,mass_flow_oil); %Element 1 is the power rejected from calculations, Element 2 is the CTAH frequency
dT_dt_cold_sink = (1./(mass_cold_sink.*c_p_oil(T_cold_sink))).*((c_p_oil(0.5*(T_hot_leg + T_cold_sink)).*mass_flow_oil.*(T_hot_leg - T_cold_sink)) - power_reject(1));
end 

%% Cold Leg energy balance equation 

%Cold leg losses has a mean of 278.9726 W with variance of 3140.8768
cold_leg_power_losses = 278.9726150303513;

dT_dt_cold_leg = (1./(mass_cold_leg.*c_p_oil(mass_cold_leg))).*((c_p_oil(0.5*(T_cold_leg+ T_cold_sink)).*mass_flow_oil.*(T_cold_sink - T_cold_leg)) - cold_leg_power_losses);

%% Final Output
output = [dT_dt_hot_leg; dT_dt_cold_sink; dT_dt_cold_leg];
end 