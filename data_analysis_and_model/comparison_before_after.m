%This file is to plot the temp differences result

%%Preamble 
clear;clc;clf; close all
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

%Temp indepedent properties of insulation. T in Kelvin
k_insulation = 0.206 + (7.702e-4)* 80; %Thermal conductivity [W/m C]
U_insulation = ((log((r_insulation_thickness+r_outer)/r_outer))/(k_insulation))^-1;

%input inlet temperature of fluid. Assume that this is a constant
T_inlet = 273+79.1558863018218; %[K] 



%% Before
Nu_param = [0 0.024 0.8 0.33];



p_total = [5000:500:10000];

%Each row is a different power
wall_results_storer_original = zeros(numel(p_total),5);
steady_state_temp_profile_complete = [
117.537112095337	128.370029306272	135.319669355304	141.785981066043	140.013326118219
121.161176739934	132.742614277562	140.459607280561	147.273420043888	145.808390503188
124.842258347330	137.021331365176	145.703495895658	152.641995066565	151.636128507393
128.343431567902	141.245234416404	151.006941997797	158.393654938276	157.833600206441
131.751855222025	145.530073581889	156.033421513993	163.805556371507	163.727984969922
135.528664438216	149.796634866279	161.381895890441	169.314716705432	169.836807519100
138.742605197479	154.261788019716	166.552291399558	174.860105322495	175.812218022197
142.238809257392	158.292601322064	171.708899541572	180.152758622356	181.692358824871
145.807783963228	162.493632844340	176.737890933883	185.884339301326	187.726780577951
149.250302635761	166.439466076861	181.700669736720	191.035579858479	193.213878420607
152.822706389295	170.585631201940	186.922353632321	196.231361168544	199.314290955962
]+273;


T_wall_heater = zeros(1,5);



for i = 1:numel(p_total)

p_profile = ones(10,1).*(0.1.*p_total(i));
%store results each row is a different power
T_heater_initial = linspace(steady_state_temp_profile_complete(i,1),steady_state_temp_profile_complete(i,end),n_segments);
T_fluid_initial = T_heater_initial - 40;
T = [T_heater_initial' T_fluid_initial'];
T_steady = lsqnonlin(@(T) dT_dt_k_compare(T,T_inlet,p_profile,D_hydraulic,r_inner,x_step,volume_heater,density_steel, A_HS,vol_fluid, inner_assembly_mass,mass_flow_fluid,n_segments,A_insulation, U_insulation,T_air,Nu_param) ,T);
for j = 1:5
T_wall_heater(j) = 0.5*(T_steady((2*j)-1,1) + T_steady(2*j,1));
end
wall_results_storer_original(i,:) = T_wall_heater;
end


figure
subplot(3,1,1)
plot([1:5],wall_results_storer_original(1,:)-273,[1:5],steady_state_temp_profile_complete(1,:)-273)
title({'Original Steady state comparison of MATLAB values and exp. values' ; '5000 W'})
legend('Experimental values','Model estimates')


subplot(3,1,2)
plot([1:5],wall_results_storer_original(6,:)-273,[1:5],steady_state_temp_profile_complete(6,:)-273)
title('7500 W')
%legend('Experimental values','Model estimates')
ylabel(strcat('Temperature [',char(176),'C]'))

subplot(3,1,3)
plot([1:5],wall_results_storer_original(end,:)-273,[1:5],steady_state_temp_profile_complete(end,:)-273)
title('10000 W')
xlabel('Position on heater')
%legend('Experimental values','Model estimates')
%% Plot with new data
Nu_param_new = [193.9458816251344 -0.0049543681563 0.8848736764747 0.6893590101706];

%Each row is a different power
wall_results_storer_new = zeros(numel(p_total),5);

for i = 1:numel(p_total)

p_profile = ones(10,1).*(0.1.*p_total(i));
%store results each row is a different power
T_heater_initial = linspace(steady_state_temp_profile_complete(i,1),steady_state_temp_profile_complete(i,end),n_segments);
T_fluid_initial = T_heater_initial - 40;
T = [T_heater_initial' T_fluid_initial'];
T_steady = lsqnonlin(@(T) dT_dt_k_compare(T,T_inlet,p_profile,D_hydraulic,r_inner,x_step,volume_heater,density_steel, A_HS,vol_fluid, inner_assembly_mass,mass_flow_fluid,n_segments,A_insulation, U_insulation,T_air,Nu_param_new) ,T);
for j = 1:5
T_wall_heater(j) = 0.5*(T_steady((2*j)-1,1) + T_steady(2*j,1));
end
wall_results_storer_new(i,:) = T_wall_heater;
end



figure
subplot(3,1,1)
plot([1:5],wall_results_storer_new(1,:)-273,[1:5],steady_state_temp_profile_complete(1,:)-273)
title({'Corrected Steady state comparison of MATLAB values and exp. values' ; '5000 W'})
legend('Experimental values','Model estimates')


subplot(3,1,2)
plot([1:5],wall_results_storer_new(6,:)-273,[1:5],steady_state_temp_profile_complete(6,:)-273)
title('7500 W')
ylabel(strcat('Temperature [',char(176),'C]'))
%legend('Experimental values','Model estimates')

subplot(3,1,3)
plot([1:5],wall_results_storer_new(end,:)-273,[1:5],steady_state_temp_profile_complete(end,:)-273)
title('10000 W')
xlabel('Position on heater')
%legend('Experimental values','Model estimates')

%% calculate error
error_original = wall_results_storer_original - steady_state_temp_profile_complete;
sqrt_error_original = sqrt(sum(sum(error_original.^2)));

error = wall_results_storer_new - steady_state_temp_profile_complete;
sqrt_error = sqrt(sum(sum(error.^2)));

results = struct();
results.original_ss_results = wall_results_storer_original;
results.corrected_ss_results = wall_results_storer_new;
results.exp_ss_results = steady_state_temp_profile_complete;
results.error = error;
save('resultant_heater_error.mat','results')

