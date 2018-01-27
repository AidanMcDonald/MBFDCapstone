function output = Rankine(input)
% This function calculates temperatures, pressures, and enthalpies at each
% point in a single-turbine Rankine cycle.
%% Get Input Values/Assumed Values
% Operating pressures
if(isfield(input,'P_5'))
    P_5 = input.P_5;
else
    P_5 = 1000; % [Pa]
end
if(isfield(input,'P_1'))
    P_1 = input.P_1;
else
    P_1 = 1E6; % [Pa]
end

% Turbine inlet temp/heat exchanger output temp
if(isfield(input,'T_4'))
    T_4 = input.T_4;
elseif(isfield(input,'T_airIn') && isfield(input,'deltaT_pp'))
    T_4 = input.T_airIn - input.deltaT_pp;
else
    T_4 = 1000; % [K]
end

% Turbine and pump efficiencies
if(isfield(input,'eta_T'))
    eta_T = input.eta_T;
else
    eta_T = .95;
end
if(isfield(input,'eta_P'))
    eta_P = input.eta_P;
else
    eta_P = .95;
end

%% Calculations
% Note: units of pressure in XSteam are bar (10^5 Pa), units of temperature
% are C
P_4 = P_1;
s_4 = XSteam('s_pT',P_4/10^5,T_4-273);
h_4 = XSteam('h_pT',P_4/10^5,T_4-273);

h_5s = XSteam('h_ps',P_5/10^5,s_4);
h_5 = h_4-eta_T*(h_4-h_5s);
T_5 = XSteam('T_ph',P_5/10^5,h_5)+273;

P_6 = P_5;
h_6 = XSteam('h_px',P_6/10^5,0);
T_6 = XSteam('Tsat_p',P_6/10^5)+273;
v_6 = XSteam('vL_p',P_6/10^5);

h_1s = h_6+v_6*(P_1-P_6); % Need to check units

h_1 = h_6+(h_1s-h_6)/eta_P;
T_1 = XSteam('T_ph',P_1/10^5,h_1)+273;

%% Assemble Output
output.P_1 = P_1;
output.T_1 = T_1;
output.h_1 = h_1;

output.P_4 = P_4;
output.T_4 = T_4;
output.h_4 = h_4;

output.P_5 = P_5;
output.T_5 = T_5;
output.h_5 = h_5;

output.P_6 = P_6;
output.T_6 = T_6;
output.h_6 = h_6;
end