function output = Brayton(input)
% This function calculates temperatures and pressures at each state in a 2
% turbine open brayton cyle.
% Authors: Aidan McDonald

%% Get Input Values/Assumed Values
% Compression ratio
if isfield(input,'beta')
    beta = input.beta;
else
    beta = 20;
end

% Gamma of air - intrinsic property of air
gamma = (1.4-1)/1.4;

% Atmospheric incoming air
if isfield(input,'P_1')
    P_1 = input.P_1;
else
    P_1 = 101325; % [Pa]
end
if isfield(input,'T_1')
    T_1 = input.T_1;
else
    T_1 = 293; % [K]
end

% HPT inlet temp
if isfield(input,'T_3')
    T_3 = input.T_3;
else
    T_3 = 1000; % [K]
end

% LPT inlet temp
if isfield(input,'T_5')
    T_5 = input.T_5;
else
    T_5 = 1000; % [K]
end

% Efficiencies
if isfield(input,'eta_C')
    eta_C = input.eta_C;
else
    eta_C = .95; % compressor
end
if isfield(input,'eta_T1')
    eta_T1 = input.eta_T1;
else
    eta_T1 = .95; % high pressure turbine
end
if isfield(input,'eta_T2')
    eta_T2 = input.eta_T2;
else
    eta_T2 = .95; % low pressure turbine
end

% Work from HPT
if isfield(input,'Wdot_T1')
    Wdot_T1 = input.Wdot_T1;
else
    Wdot_T1 = 100E6; % [W]
end

% Work from LPT
if isfield(input,'Wdot_T2')
    Wdot_T2 = input.Wdot_T2;
else
    Wdot_T2 = 100E6; % [W]
end

% Pressure drops in heat exchangers
if isfield(input,'deltaP_1')
    deltaP_1 = input.deltaP_1;
else
    deltaP_1 = 0;
end
if isfield(input,'deltaP_2')
    deltaP_2 = input.deltaP_2;
else
    deltaP_2 = 0;
end

% Mass flowrate
if isfield(input,'mdot')
    mdot = input.mdot;
else
    mdot = 150; % [kg/s]
end

% Specific heat
if isfield(input,'c_p')
    c_p = input.c_p;
else
    c_p = 1000; % [J/kg*K]
end

%% Calculations
P_2s = beta*P_1;
T_2s = beta^gamma*T_1;

P_2 = P_2s;
T_2 = (T_2s-T_1)/eta_C+T_1;

P_3 = P_2 - deltaP_1;

T_4 = T_3 - Wdot_T1/(mdot*c_p);
T_4s = T_3 - (T_3-T_4)/eta_T1;
P_4s = P_3*(T_4s/T_3)^(1/gamma);
P_4 = P_4s;

P_5 = P_4 - deltaP_2;

T_6 = T_5 - Wdot_T2/(mdot*c_p);
T_6s = T_5 - (T_5-T_6)/eta_T2;
P_6s = beta*P_5*(T_6s/T_5)^(1/gamma);
P_6 = P_6s;

%% Assemble Output
output.P_1 = P_1;
output.T_1 = T_1;
output.P_2 = P_2;
output.T_2 = T_2;
output.P_3 = P_3;
output.T_3 = T_3;
output.P_4 = P_4;
output.T_4 = T_4;
output.P_5 = P_5;
output.T_5 = T_5;
output.P_6 = P_6;
output.T_6 = T_6;
end