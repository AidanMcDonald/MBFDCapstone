%% This is the final heater dT_dt model with corrections

function output = dT_dt_heater(T_wall_temp,T_fluid_temp,T_inlet,P_input,mass_flow_fluid) 

T_heater = T_wall_temp';
T_fluid = T_fluid_temp';

%% input resistive heater dimensions
n_segments = 10;
total_x = 1.924; %[m] Height of heater
x_step = total_x/n_segments;
x_profile = linspace(0,total_x,n_segments);

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




%% Temp dependent properties
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

    %try the other method to see if theres a difference
    d2T_data = [T_heater(1);T_heater;T_heater(end)];
    for i = 2:n_segments+1;
    d2T_dx2 (i-1) = (-d2T_data(i+1)+2.*d2T_data(i)-d2T_data(i-1))/(x_step^2);
    end
    
%% Convective resistance calculation
Re = @(density, viscosity, velocity, length) density.*velocity.*length./viscosity;
Pr = @(heat_capacity, viscosity, thermal_conductivity) heat_capacity.*viscosity./thermal_conductivity;
Nu = @(Re,Pr) 193.9458816251344 - (0.0049543681563.*(Re.^0.8848736764747).*(Pr.^0.6893590101706));

k = @(Nu,h,L) h.*L./Nu;

Re_calc = Re(density_oil(T_fluid), viscosity_oil(T_fluid), velocity(mass_flow_fluid,density_oil(T_fluid),D_hydraulic), D_hydraulic);
Pr_calc = Pr(c_p_oil(T_fluid), viscosity_oil(T_fluid), k_oil(T_fluid));
Nu_calc = Nu(Re_calc,Pr_calc);
h_heat_coefficient = h(Nu_calc,k_oil(T_fluid),D_hydraulic);



%% Calculate output
%rate of accumulation of energy within heater = diffusion within heater in
%x-direction + power source + convec heat loss to fluid + conduc heat loss to insulation-
%iar + radiative heat loss

%Assume that the power input is distributed uniformly across the heater
p_profile = ones(n_segments,1).*(P_input/n_segments);


%Power loss in heater section from estimates
total_heater_power_loss = ones(n_segments,1).*(heater_losses_calc_est(T_heater)./n_segments);





dT_dt_heater = (1./(density_steel.*volume_heater.*c_p_steel(T_heater))).*((-volume_heater.*k_steel(T_heater).*d2T_dx2) + (p_profile-total_heater_power_loss) - (h_heat_coefficient.*A_HS).*(T_heater - T_fluid));
T_fluid_calc = [T_inlet; T_fluid(1:end-1)]; %This line is to calculate the thermal changes due to mass flow into CV
heat_cap_fluid =  vol_fluid.*density_oil(T_fluid).*c_p_oil(T_fluid) + inner_assembly_mass*(c_p_steel(T_fluid));
dT_dt_fluid = (1./heat_cap_fluid).*((mass_flow_fluid.*c_p_oil(T_fluid).*(T_fluid_calc-T_fluid)) + (h_heat_coefficient.*A_HS).*(T_heater - T_fluid));
output = [dT_dt_heater dT_dt_fluid];


end