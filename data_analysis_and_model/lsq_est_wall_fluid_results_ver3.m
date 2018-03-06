%Find T heater and T fluid after solving for k_solve 


%%Calculate 1D axial heater. Each segment acts as a homogeneous control
%%volume. The heater is divided into n_segments, and seperated into the
%%fluid portion and the resistive-heater portion
clear;clc;clf
n_segments = 10;

%% input resistive heater dimensions
total_x = 1.924; %[m] Height of heater
x_step = total_x/n_segments;
x_profile = linspace(0,total_x,n_segments);
d2T_dx2 = ones(n_segments,1);
%D_hydraulic = 6.6e-3; %[m]
D_hydraulic = 2.725e-2;
r_inner = 0.0381/2; %[m]
r_outer = 0.04/2; %[m]
r_insulation_thickness = 0.05; %[m]
A_ring = pi*(r_outer^2 - r_inner^2);%Area for the ring section for conductive heat transfer 
volume_heater = A_ring*x_step; %[m^2] %Volume of heater portion in each n segment 
A_HS = 2*pi*r_inner*x_step; %[m^2] Surface area of contact of Heater and fluid of n segment
A_insulation = 2*pi*r_outer*x_step; %[m^2] Surface area of contact of Heater and insulation of n segment
density_steel = 8030; % treated as constnat [kg/m3]

%Inner perforated steel and twisted metal contributes to thermal inertia
inner_assembly_mass = 3.120/n_segments ;%[kg]
vol_fluid = pi*(r_inner^2)*x_step - (inner_assembly_mass/density_steel); %m3 Difference between inner cylinder vol and the vol of the inner steel assembly

%% input fluid flow
mass_flow_fluid = 0.18; %[kg/s]


%input initial temperature profile in both portions and air temperature

T_air = 273 + 18; %[K]
%initial_homogeneous_temp_heater_side = 273+80; %[K]
%initial_homogeneous_temp_fluid_side = 273+80; %[K]
%T_heater_initial = ones(n_segments,1).*initial_homogeneous_temp_heater_side;


%Temp indepedent properties of insulation. T in Kelvin
k_insulation = 0.206 + (7.702e-4)* 80; %Thermal conductivity [W/m C]
U_insulation = ((log((r_insulation_thickness+r_outer)/r_outer))/(k_insulation))^-1;

%input inlet temperature of fluid. Assume that this is a constant
T_inlet = 273+80; %[K] 

%input heater power profile. 
%Assume that heater power is a constant 
heater_efficiency = @(P) (-0.9376e-9 * (P^2)) + (187.8e-7 * P) + 0.8767;
p_input_total = [5000 5500 6000 6500 7000 7500 8000 8500 9500 10000];


steady_state_temp_profile_complete = [
    116.9398332	127.896662	134.9296665	141.0191603	139.4164146
120.7941841	132.4945754	140.541486	146.970456	145.6349827
124.4025798	136.7972744	145.7693198	152.3815977	151.3976504
127.8940466	141.0999304	150.8648334	157.873345	157.3144034
131.7411989	145.6297526	156.2455022	163.5289516	163.4586625
134.6639403	149.574971	161.2457555	169.0739455	169.3753285
138.6120552	153.8553643	166.6653805	174.8668779	175.5180055
142.0912752	158.1338556	171.8751749	180.2789204	181.3680246
148.9846537	166.3598769	182.1134861	190.7828291	193.0989432
152.4979809	169.9714517	186.8727415	195.931777	198.7379407
];
steady_state_temp_profile_complete = steady_state_temp_profile_complete+273;

%results of k_ver_3
load('k_solve.mat');
%load('k_solve_ver2.mat');

%T is in K
%k_correction = @(T) 0.007940742218978.*(T-273) + 0.691772537330441;
T_wall_heater = numel(1,5);
T_wall_heater_storer = zeros(n_segments,numel(p_input_total));
T_fluid_steady = numel(1,5);
T_fluid_steady_storer = zeros(n_segments,numel(p_input_total));


for i = 1:numel(p_input_total)

p_total = p_input_total(i); %[W]
p_loss_section_1 = (1-heater_efficiency(p_input_total(i)))*p_input_total(i);
p_profile = ones(n_segments,1).*p_total/n_segments;
p_profile(1) = p_profile(1) - p_loss_section_1;

%p_total = p_input_total(i)*heater_efficiency(p_input_total(i)); %[W]
%p_profile = ones(n_segments,1).*p_total/n_segments;

T_heater_initial = linspace(steady_state_temp_profile_complete(i,1),steady_state_temp_profile_complete(i,end),n_segments);
T_fluid_initial = T_heater_initial - 25;

T = [T_heater_initial' T_fluid_initial'];

k = k_solve(i,:);

%B = lsq_solver(T,T_inlet,p_profile,D_hydraulic,r_inner,x_step,volume_heater,density_steel, A_HS,vol_fluid, inner_assembly_mass,mass_flow_fluid,n_segments,A_insulation, U_insulation,T_air,k,steady_state_profile);
%T_steady = lsqnonlin(@(T) dT_dt_k_solver(T,T_inlet,p_profile,D_hydraulic,r_inner,x_step,volume_heater,density_steel, A_HS,vol_fluid, inner_assembly_mass,mass_flow_fluid,n_segments,A_insulation, U_insulation,T_air,k),T);

%calculate steady state values. 
T_steady = lsqnonlin(@(T) dT_dt_k_solver_ver3(T,T_inlet,p_profile,D_hydraulic,r_inner,x_step,volume_heater,density_steel, A_HS,vol_fluid, inner_assembly_mass,mass_flow_fluid,n_segments,A_insulation, U_insulation,T_air,k),T);



T_wall_heater_storer(:,i) = T_steady(:,1);
T_fluid_steady_storer(:,i) = T_steady(:,2);

end

%Each row is a different power
T_wall_heater_storer = T_wall_heater_storer'-273;
T_fluid_steady_storer = T_fluid_steady_storer' -273;
