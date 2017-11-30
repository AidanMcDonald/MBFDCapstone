function T_nplus1 = CIETstep(input)
% This function takes temperatures in CIET at a time t_n and calculates the
% temperatures at the next time t_n+1

%% Read input/set constants
% time step
dt = input.dt;

% Density as a function of temperature
rho = @(T) ;

% Controllable inputs -------------------------------
% Power flux from heat source (+ve is energy into system)
P_in = input.P_in;

% Power flux into cold sink (+ve is energy taken away from system)
P_reject = input.P_reject;

% Heat flux from pump
Qdot_pump = input.Qdot_pump;

% Temperatures at previous t
% Elements of T:
% T(1) = T_HS = Temperature of heat source
% T(2) = T_HE1 = Temperature in hot heat exchanger
% T(3) = T_HL = Temperature in hot leg piping
% T(4) = T_HE2 = Temperature in cold heat exchanger
% T(5) = T_CS = Temperature of the cold sink
% T(6) = T_CL1 = Temperature of the cold leg before pump
% T(7) = T_P = Temperature at the pump
% T(8) = T_CL2 = Temperature in cold leg after pump
T = input.T;

% Volumes -----------------------------------
% Volume of Heat Exchanger 1 unit
V_HE1 = ;

% Volume of hot leg unit
V_HL = ;

% Volume of heat exchanger 2 unit
V_HE2 = ;

% Volume of cold leg 1 unit
V_CL1 = ;

% Volume of pump unit
V_P = ;

% Volume of cold leg 2 unit
V_CL2 = ;

% Masses ----------------------------------
% Mass in heat source unit
m_HS = rho(T(1)*V_HS);

% Mass in Heat Exchanger 1 unit
m_HE1 = rho(T(2)*V_HE1);

% Mass in hot leg unit
m_HL = rho(T(3)*V_HL);

% Mass in heat exchanger 2 unit
m_HE2 = rho(T(4)*V_HE2);

% Mass in cold sink unit
m_CS = rho(T(5)*V_CS);

% Mass in cold leg 1 unit
m_CL1 = rho(T(6)*V_CL1);

% Mass in pump unit
m_P = rho(T(7)*V_P);

% Mass in cold leg 2 unit
m_CL2 = rho(T(8)*V_CL2);

% Mass flowrates --------------------------------
% Mass flowrate in Heat Exchanger 1 unit
mdot_HE1 = ;

% Mass flowrate in hot leg unit
mdot_HL = ;

% Mass flowrate in heat exchanger 2 unit
mdot_HE2 = ;

% Mass flowrate in cold leg 1 unit
mdot_CL1 = ;

% Mass flowrate in pump unit
mdot_P = ;

% Mass flowrate in cold leg 2 unit
mdot_CL2 = ;

% Heat transfer coefficients ---------------------------------
% Thermal conductivity of the heat source unit
U_HS = 1000; % Arbitrarily chosen, in W/(m^2 K)

% Effective surface area of the heat source unit
A_HS = 1; % Arbirarily chosen, in m^2

% Thermal conductivity of pipelines for heat losses to surrounding air in 
% HL, CL 1 and CL2 units. Assume that all the pipes have the same thermal properties
U_pipe = 10; % Arbitrarily chosen, in W/(m^2 K)

% Effective surface area of pipes for heat losses to surrounding air in 
% HL, CL 1 and CL2 units. Assume that all the pipes have the same thermal properties.
A_pipe = 3; % Arbitrarily chosen, in m^2

% Thermal conductivity of the cold sink unit
U_CS = 1000; % Arbitrarily chosen, in W/(m^2 K)

% Effective surface area of the cold sink unit
A_CS = 1; % Arbirarily chosen, in m^2

% Ambient air temperature
T_air = 273+22; % K

% Specific heat capacities ----------------------------------
% specific heat capacities dependence on T and material
F_c_p_core = @(T) 450 + 0.28*(T-273); % T in K
F_c_p_c = @(T) 1518 + 2.82*(T-273); % T in K

% specific heat capacities in control volumes
c_p_core = F_c_p_core(T(1));
c_p_c_HE1 = F_c_p_c(T(2));
c_p_c_HL = F_c_p_c(T(3));
c_p_c_HE2 = F_c_p_c(T(4));
c_p_c_CS = F_c_p_c(T(5));
c_p_c_CL1 = F_c_p_c(T(6));
c_p_c_P = F_c_p_c(T(7));
c_p_c_CL2 = F_c_p_c(T(8));


%% Perform Calculations
% Define matrices for AT'+BT+C=0 form
A = [c_p_core*m_HS 0 0 0 0 0 0 0;
     0 .5*c_p_c_HE1 0 0 0 0 0 .5*c_p_c*m_HE1;
     0 .5*c_p_c_HL*m_HL .5*c_p_c_HL*m_HL 0 0 0 0 0;
     0 0 .5*c_p_c_HE2*m_HE2 .5*c_p_c_HE2*m_HE2 0 0 0 0;
     0 0 0 0 c_p_c_CS*m_CS 0 0 0;
     0 0 0 .5*c_p_c_CL1*m_CL1 0 .5*c_p_c_CL1*m_CL1 0 0;
     0 0 0 0 0 .5*c_p_c_P*m_P .5*c_p_c_P*m_P 0;
     0 0 0 0 0 0 .5*c_p_c_CL2*m_CL2 .5*c_p_c_CL2*m_CL2];
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














