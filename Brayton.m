function output = Brayton(input)
% This function calculates temperatures and pressures at each state in a 2
% turbine open brayton cyle.
% Authors: Aidan McDonald

%% Get Input Values/Assumed Values

% Compression ratio
if isfield(input,'beta')
    beta = input.beta;
else
    beta = 19.6 ;
end

% Expansion ratio 1
if isfield(input,'beta_esp1')
    beta_esp1 = input.beta_esp1;
else
    beta_esp1 = 3.77 ;
end

% Expansion ratio 2
if isfield(input,'beta_esp2')
    beta_esp2 = input.beta_esp2;
else
    beta_esp2 = 5.13;
end

% Don't know the name of this one
gamma = (1.38-1)/1.38; 

% Atmospheric incoming air
if isfield(input,'P_1')
    P_1 = input.P_1;
else
    P_1 = 101325; % [Pa]
end
if isfield(input,'T_1')
    T_1 = input.T_1;
else
    T_1 = 298; % [K]
end

% Polytropic efficiencies
if isfield(input,'eta_C')
    eta_C = input.eta_C;
else
    eta_C = .70; % compressor
end
if isfield(input,'eta_T1')
    eta_T1 = input.eta_T1;
else
    eta_T1 = .80; % high pressure turbine
end
if isfield(input,'eta_T2')
    eta_T2 = input.eta_T2;
else
    eta_T2 = .80; % low pressure turbine
end


% Work from HPT
if isfield(input,'Wdot_T1')
    Wdot_T1 = input.Wdot_T1;
else
    Wdot_T1 = 1e6; % [W]
end

% Work from LPT
if isfield(input,'Wdot_T2')
    Wdot_T2 = input.Wdot_T2;
else
    Wdot_T2 = 137.94E6; % [W]
end

% Pressure drops in heat exchanger
deltaP_1 = 0;
deltaP_2 = 0;

% Mass flowrate
if isfield(input,'mdot')
    mdot = input.mdot;
else
    mdot = 418; % [kg/s]
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
T_2 = T_1 * beta^(gamma/eta_C);

P_3 = P_2 - deltaP_1;
T_3 = (Wdot_T1) / (mdot * c_p * (1 - beta_esp1^(- gamma * eta_T1)) )

T_4 = T_3 * beta_esp1^(- gamma * eta_T1);
P_4 = P_3 / beta_esp1;

P_5 = P_4 - deltaP_2;
T_5 = (Wdot_T2) / (mdot * c_p * (1 - beta_esp2^(- gamma * eta_T2)) )

T_6 = T_5 * beta_esp2^(- gamma * eta_T2);
P_6 = P_5 / beta_esp2;

% Power
P_th1 = mdot * c_p * (T_3 - T_2);
P_th2 = mdot * c_p * (T_5 - T_4);


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
output.P_th1 = P_th1;
output.P_th2 = P_th2;
end