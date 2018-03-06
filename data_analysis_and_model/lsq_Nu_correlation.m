function output = lsq_Nu_correlation(T_fluid,h_exp,h_param)
D_hydraulic = 2.725e-2;
mass_flow_fluid = 0.18;
%h definition
h = @(Nu,k,D_hydraulic) Nu.*k./D_hydraulic;

%Temp dependent properties
density_oil = @(T) 1078-(0.85.*(T-273)); %[kg/m^3]
viscosity_oil = @(T) 0.130./((T-273).^1.072); %Dynamic viscosity [kg/m s]
k_oil = @(T) 0.142 - (0.00016.*(T-273)); %Thermal conductivity [W/m C]
c_p_oil = @(T) 1518 + 2.82.*(T-273); %Specific heat capacity [J/kg C]
velocity = @(mass_flow_fluid,density,D_hydraulic) (mass_flow_fluid./density)/(pi*(D_hydraulic^2)/4); %[m/s]

Re = @(density, viscosity, velocity, length) density.*velocity.*length./viscosity;
Pr = @(heat_capacity, viscosity, thermal_conductivity) heat_capacity.*viscosity./thermal_conductivity;
%Nu = @(Re,Pr) 0.024.*(Re.^0.8).*(Pr.^0.33); %Nu correlation for turbulent flow

%Calculations
Re_est = Re(density_oil(T_fluid), viscosity_oil(T_fluid), velocity(mass_flow_fluid,density_oil(T_fluid),D_hydraulic), D_hydraulic);
Pr_est = Pr(c_p_oil(T_fluid), viscosity_oil(T_fluid), k_oil(T_fluid));

Nu_exp = (h_exp.*D_hydraulic)./k_oil(T_fluid);

log_Nu_exp = log(Nu_exp);
log_Re_est = log(Re_est);
log_Pr_est = log(Pr_est);

%log_Nu_est = h_param(1)+ (log_Re_est.*(h_param(2))) + (log_Pr_est.*(h_param(3)));
%output = abs(log_Nu_est - log_Nu_exp);

Nu_est = h_param(1) + h_param(2).*(Re_est.^h_param(3)).*(Pr_est.^h_param(4));
output = abs(Nu_est - Nu_exp);
end