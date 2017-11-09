function T_nplus1 = CIETstep(input)
% Questions for Yi Meng + Priya:
% Difference between m and mdot?
% difference between c_p and C_p? I.E. is C_p_c = mass of coolant in the
%   section times c_p_c?

%% Read input/set constants
% time step
dt = input.dt;

% Temperatures at previous t
T = input.T;

% Specific heat capacity of heat source/core
c_p_core = ;

% Specific heat capacity of coolant/oil
c_p_c = ;

% Mass in heat source unit
m_HS = ;

% Mass in Heat Exchanger 1 unit
m_HE1 = ;

% Mass in hot leg unit
m_HL = ;

% Mass in heat exchanger 2 unit
m_HE2 = ;

% Mass in cold sink unit
m_CS = ;

% Mass in cold leg 1 unit
m_CL1 = ;

% Mass in pump unit
m_P = ;

% Mass in cold leg 2 unit
m_CL2 = ;

% Mass flowrate in heat source unit
mdot_HS = ;

% Mass flowrate in Heat Exchanger 1 unit
mdot_HE1 = ;

% Mass flowrate in hot leg unit
mdot_HL = ;

% Mass flowrate in heat exchanger 2 unit
mdot_HE2 = ;

% Mass flowrate in cold sink unit
mdot_CS = ;

% Mass flowrate in cold leg 1 unit
mdot_CL1 = ;

% Mass flowrate in pump unit
mdot_P = ;

% Mass flowrate in cold leg 2 unit
mdot_CL2 = ;

% Thermal conductivity of the heat source unit
U_HS = ;

% Effective surface area of the heat source unit
A_HS = ;

% Thermal conductivity of pipelines for heat losses to surrounding air in 
% HL, CL 1 and CL2 units. Assume that all the pipes have the same thermal properties
U_pipe = ;

% Effective surface area of pipes for heat losses to surrounding air in 
% HL, CL 1 and CL2 units. Assume that all the pipes have the same thermal properties.
A_pipe = ;

% Thermal conductivity of the cold sink unit
U_CS = ;

% Effective surface area of the cold sink unit
A_CS = ;

% Power flux from heat source (+ve is energy into system)
P_in = ;

% Power flux into cold sink (+ve is energy taken away from system)
P_reject = ;

% Heat flux from pump
Qdot_pump = ;

% Ambient air temperature
T_air = ;

%% Perform Calculations
% Define matrices for AT'+BT+C=0 form
A = [c_p_core*m_HS 0 0 0 0 0 0 0;
     0 .5*c_p_c 0 0 0 0 0 .5*c_p_c*m_HE1;
     0 .5*c_p_c*m_HL .5*c_p_c*m_HL 0 0 0 0 0;
     0 0 .5*c_p_c*m_HE2 .5*c_p_c*m_HE2 0 0 0 0;
     0 0 0 0 c_p_c*m_CS 0 0 0;
     0 0 0 .5*c_p_c*m_CL1 0 .5*c_p_c*m_CL1 0 0;
     0 0 0 0 0 .5*c_p_c*m_P .5*c_p_c*m_P 0;
     0 0 0 0 0 0 .5*c_p_c*m_CL2 .5*c_p_c*m_CL2];
B = [U_HS*A_HS -.5*U_HS*A_HS 0 0 0 0 0 -.5*U_HS*A_HS;
     -U_HS*A_HS mdot_HE1*c_p_c+.5*U_HS*A_HS 0 0 0 0 0 -mdot_HE1*c_p_c+.5*U_HS*A_HS;
     0 .5*U_pipe*A_pipe-mdot_HL*c_p_c .5*U_pipe*A_pipe+mdot_HL*c_p_c 0 0 0 0 0;
     0 0 .5*U_CS*A_CS-mdot_HE2*c_p_c .5*U_CS*A_CS+mdot_HE2*c_p_c -U_CS*A_CS 0 0 0;
     0 0 -.5*U_CS*A_CS -.5*U_CS*A_CS U_CS*A_CS 0 0 0;
     0 0 0 .5*U_pipe*A_pipe-mdot_CL1*c_p_c 0 .5*U_pipe*A_pipe+mdot_CL1*c_p_c 0 0;
     0 0 0 0 0 -mdot_P*c_p_c mdot_P*c_p_c 0;
     0 0 0 0 0 0 .5*U_pipe*A_pipe-mdot_CL2*c_p_c .5*U_pipe*A_pipe+mdot_CL2*c_p_c];
C = [-P_in;
     0;
     -U_pipe*A_pipe*T_air;
     0;
     P_reject;
     -U_pipe*A_pipe*T_air;
     -Qdot_pump;
     -U_pipe*A_pipe*T_air];
 
 % Solve for T'
 T_prime = A\(-C-B*T);
 
 % Step T values forward using Euler method
 T_nplus1 = T+dt*T_prime;
end














