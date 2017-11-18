%This file is simply to demo dT_dt_heater function
p_total = 5000;
T = ones(10,2).*(273+50);
T(:,1) = T(:,1) + 60;
T_inlet = 90+273;
mass_flow_fluid = 10;
A= dT_dt_heater(T,T_inlet,p_total,mass_flow_fluid);