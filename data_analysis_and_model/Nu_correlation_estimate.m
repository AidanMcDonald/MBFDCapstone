
clear;clc;
close all 

%% Preamble to calculate the steady state values
n_segments = 10;

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





%% Calculate steady state values
%Steady state values from experiment 
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

];



%Combined with k_solve
load k_solve_Nu_steel.mat



p_input_total = [5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000];
T_fluid_steady_MATLAB = zeros(10,10);
T_wall_steady_MATLAB = zeros(10,10);
T_wall_steady_MATLAB_reduced = zeros(10,5);
T_fluid_steady_MATLAB_reduced = zeros(10,5);


for i = 1:numel(p_input_total)
    field_name = strcat('power_',num2str(p_input_total(i)));
    % Extract data from k_solve 
    %Each row is a different power 
    h_exp(i,:) = (k_solve.(field_name)(:,1))';
    p_total = p_input_total(i); %[W]
    p_profile = ones(n_segments,1).*p_total/n_segments;

    T_heater_initial = linspace(steady_state_temp_profile_complete(i,1),steady_state_temp_profile_complete(i,end),n_segments);
    T_fluid_initial = T_heater_initial - 25;
    T = [T_heater_initial' T_fluid_initial'];
    T_steady = lsqnonlin(@(T) dT_dt_k_solver_ver3(T,T_inlet,p_profile,D_hydraulic,r_inner,x_step,volume_heater,density_steel, A_HS,vol_fluid, inner_assembly_mass,mass_flow_fluid,n_segments,A_insulation, U_insulation,T_air,k_solve.(field_name)) ,T);
    %T_steady format: column 1 is the heater, column 2 is the fluid
    
    %Storer values. Each row is a different power
    T_wall_steady_MATLAB(i,:) = (T_steady(:,1))';
    T_fluid_steady_MATLAB(i,:) = (T_steady(:,2))';
   for j = 1:5
       %Each row is a different power. Convert to Celsius  
    T_wall_steady_MATLAB_reduced(i,j) =  ((T_wall_steady_MATLAB(i,(2*j)) + T_wall_steady_MATLAB(i,(2*j)-1))./2)-273;
    T_fluid_steady_MATLAB_reduced(i,j) = ((T_fluid_steady_MATLAB(i,(2*j)) + T_fluid_steady_MATLAB(i,(2*j)-1))./2)-273;
   end
    
end


T_wall_steady_MATLAB = T_wall_steady_MATLAB - 273;
T_fluid_steady_MATLAB = T_fluid_steady_MATLAB - 273;

steady_state_final.T_wall_steady_MATLAB = T_wall_steady_MATLAB;
steady_state_final.T_fluid_steady_MATLAB = T_fluid_steady_MATLAB;
steady_state_final.T_wall_steady_MATLAB_reduced = T_wall_steady_MATLAB_reduced;
steady_state_final.T_fluid_steady_MATLAB_reduced = T_fluid_steady_MATLAB_reduced; 
save('steady_state_MATLAB_est_results.mat','steady_state_final')


%% compare with steady state experimental values and plot curve for 5000, 7500, 10000
hold on 
figure
subplot(3,1,1)
plot([1:5],T_wall_steady_MATLAB_reduced(1,:),[1:5],steady_state_temp_profile_complete(1,:))
title('Steady state comparison of MATLAB values and exp. values at 5000 W')
legend('Experimental values','Model estimates')


subplot(3,1,2)
plot([1:5],T_wall_steady_MATLAB_reduced(6,:),[1:5],steady_state_temp_profile_complete(6,:))
title('Steady state comparison of MATLAB values and exp. values at 7500 W')
legend('Experimental values','Model estimates')

subplot(3,1,3)
plot([1:5],T_wall_steady_MATLAB_reduced(end,:),[1:5],steady_state_temp_profile_complete(end,:))
title('Steady state comparison of MATLAB values and exp. values at 10000 W')

legend('Experimental values','Model estimates')


%% correlation for Nu
%h param(eter) guess is from turbulent correlation

T_fluid = T_fluid_steady_MATLAB; %

h_param_guess = [200   0.0190    0.8647    0.6723];
options = optimoptions(@lsqnonlin,'FunctionTolerance',1e-6,'OptimalityTolerance',1e-6,'StepTolerance',1e-16,'MaxFunctionEvaluations',1e4,'MaxIterations',1e4);
Nu_correlation_param = lsqnonlin( @(h_param) lsq_Nu_correlation(T_fluid,h_exp,h_param),h_param_guess,[],[],options)
resultant_error = sqrt(lsq_Nu_correlation(T_fluid,h_exp,Nu_correlation_param));

