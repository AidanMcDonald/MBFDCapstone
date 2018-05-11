function output = lsq_solver_ver3(T,T_inlet,p_profile,D_hydraulic,r_inner,x_step,volume_heater,density_steel, A_HS,vol_fluid, inner_assembly_mass,mass_flow_fluid,n_segments,A_insulation, U_insulation,T_air,k,steady_state_profile)
options = optimoptions(@lsqnonlin,'FunctionTolerance',1e-10,'OptimalityTolerance',1e-10,'display','none');
T_steady = lsqnonlin(@(T) dT_dt_k_solver_ver3(T,T_inlet,p_profile,D_hydraulic,r_inner,x_step,volume_heater,density_steel, A_HS,vol_fluid, inner_assembly_mass,mass_flow_fluid,n_segments,A_insulation, U_insulation,T_air,k) ,T,[],[],options);

%because there are 10 axial divisions
T_wall_heater = ones(5,1);
for j = 1:5
T_wall_heater(j) = 0.5*(T_steady((2*j)-1,1) + T_steady(2*j,1));
end

%Least squares method
output = (((T_wall_heater - steady_state_profile).^1)); %Returns a scaler value which should be minimised 
end
