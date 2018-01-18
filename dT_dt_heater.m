function output = dT_dt_heater(T,T_inlet,p_total,mass_flow_fluid) 

%This file is meant to be used with the CIETstep.m file 
%Format of T: [T_heater_1 T_fluid_1; T_heater_2 T_fluid_2;...T_heater_n
%T_fluid_n]
%returns: n,2 dT_dt matrix for each of the components 

%Inputs required:
% T: Instantaneous Temperature of heater and fluid,2 x n matrix [K]
% p_total: Instantaneous Power, scalar [W]
% T_inlet: Instantaneous Temp of inlet fluid, scalar [K]


%% The following constants DO NOT have to be reevaluated at each time step:
%n_segments, x_step, x_profile, D_hydraulic,r_inner, r_outer,
%r_insulation_thickness, A_ring,volume_heater, inner_assembly_mass,
%vol_fluid, A_HS, A_insulation, density_steel, T_air, k_insulation,
%U_insulation, 

%Number of segments of 1D model in x direction
n_segments = size(T,1);

%Heater and n-segment dimensions
total_x = 1.924; %[m] Height of heater
x_step = total_x/n_segments;%[m] 
x_profile = linspace(0,total_x,n_segments);
D_hydraulic = 2.725e-2; %[m]
r_inner = 0.0381/2; %[m]
r_outer = 0.04/2; %[m]
r_insulation_thickness = 0.05; %[m]
A_ring = pi*(r_outer^2 - r_inner^2);%[m^2] Area for the ring section for conductive heat transfer 
volume_heater = A_ring*x_step; %[m^3] Volume of heater portion in each n segment 
inner_assembly_mass = 3.120/n_segments ;%[kg] Mass of inner assembly 
density_steel = 8030; %[kg/m3] Assumed to be constant
vol_fluid = pi*(r_inner^2)*x_step - (inner_assembly_mass/density_steel); %[m^3] Difference between inner cylinder vol and the vol of the inner steel assembly
A_HS = 2*pi*r_inner*x_step; %[m^2] Surface area of contact of Heater and fluid of n segment
A_insulation = 2*pi*r_outer*x_step; %[m^2] Surface area of contact of Heater and insulation of n segment


%input initial temperature profile in both portions and air temperature
T_air = 273 + 18; %[K]

%Temp indepedent properties of insulation. T in Kelvin
k_insulation = 0.206 + (7.702e-4)* 80; %Thermal conductivity [W/m C]
U_insulation = ((log((r_insulation_thickness+r_outer)/r_outer))/(k_insulation))^-1;

%input heater power profile. 
p_profile = ones(n_segments,1).*p_total/n_segments; %[W/ segment]

%% Start
T_heater = T(:,1);
T_fluid = T(:,2);

%%Temp dependent properties
%Temp dependent properties of dowtherm A. T in Kelvin
density_oil = @(T) 1078-(0.85.*(T-273)); %[kg/m^3]
viscosity_oil = @(T) 0.130./((T-273).^1.072); %Dynamic viscosity [kg/m s]
k_oil = @(T) 0.142 - (0.00016.*(T-273)); %Thermal conductivity [W/m C]
c_p_oil = @(T) 1518 + 2.82.*(T-273); %Specific heat capacity [J/kg C]

%Temp dependent properties of steel. T in Kelvin
c_p_steel = @(T)  450 + 0.28.*(T-273); %Specific heat capacity [J/kg C]
k_steel = @(T) 14.6 + (0.0127.*(T-273)); %Thermal conductivity [W/m C]

%% Other variables definition
h = @(Nu,k,D_hydraulic) Nu.*k./D_hydraulic; %[W/m^2 K]
velocity = @(mass_flow_fluid,density,D_hydraulic) (mass_flow_fluid./density)/(pi*(D_hydraulic^2)/4); %[m/s]

%% Using central difference method to calculate d2T/dt2 and central point method requires i-2 and i+2 values. 
    d2T_dx2 = ones(n_segments,1);
    d2T_data = [T_heater(1);T_heater;T_heater(end)];
   for i = 2:n_segments+1
    d2T_dx2 (i-1) = (-d2T_data(i+1)+2.*d2T_data(i)-d2T_data(i-1))/(x_step);
    end
    
%% Convective resistance calculation
Re = @(density, viscosity, velocity, length) density.*velocity.*length./viscosity;
Pr = @(heat_capacity, viscosity, thermal_conductivity) heat_capacity.*viscosity./thermal_conductivity;
Nu = @(Re,Pr) 0.024.*(Re.^0.8).*(Pr.^0.55); %Nu correlation for turbulent flow
%Nu = @(Re,Pr) 5.44 + 0.034.*(Re.^0.82).*(Pr.^0);

Re_calc = Re(density_oil(T_fluid), viscosity_oil(T_fluid), velocity(mass_flow_fluid,density_oil(T_fluid),D_hydraulic), D_hydraulic);
Pr_calc = Pr(c_p_oil(T_fluid), viscosity_oil(T_fluid), k_oil(T_fluid));
Nu_calc = Nu(Re_calc,Pr_calc);
h_convec_calc = h(Nu_calc,k_oil(T_fluid),D_hydraulic);

%% Radiative resistance calculation 
emissitivity_steel = 0.80;
h_radiative_calc = emissitivity_steel.*(5.67e-8).*((T_heater).^2 + T_air^2).*(T_heater + T_air);

%% Calculate output
%rate of accumulation of energy within heater = diffusion within heater in
%x-direction + power source + convec heat loss to fluid + conduc heat loss to insulation-
%iar + radiative heat loss
dT_dt_heater = (1./(density_steel.*volume_heater.*c_p_steel(T_heater))).*((-A_ring.*k_steel(T_heater).*d2T_dx2) + p_profile - h_convec_calc.*A_HS.*(T_heater - T_fluid) - (U_insulation + h_radiative_calc).*A_insulation.*(T_heater - T_air));
T_fluid_calc = [T_inlet; T_fluid(1:end-1)]; %This line is to calculate the thermal changes due to mass flow into CV
heat_cap_fluid =  vol_fluid.*density_oil(T_fluid).*c_p_oil(T_fluid) + inner_assembly_mass*(c_p_steel(T_fluid));
dT_dt_fluid = (1./heat_cap_fluid).*((mass_flow_fluid.*c_p_oil(T_fluid).*(T_fluid_calc-T_fluid)) + h_convec_calc.*A_HS.*(T_heater - T_fluid));

%output is a structure. recorded variables: dT_dt for all segments, ave temp of heater surface
output = [dT_dt_heater dT_dt_fluid];

end