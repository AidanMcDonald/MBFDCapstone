%Find error
ssCutoffs = [61342 66736 71217 77732 83158 87048   91038 95227 99415 104103 109189; 64386 69770 73519 80968 86249 90140 94131 98317 102506 107192 112383];
ss_start = ssCutoffs(1,1); ss_end =ssCutoffs(2,1);

ss_start = ss_start - 4;
ss_end = ss_end - 4;
ss_start = ss_start -1; %Because first row was header
ss_end = ss_end - 1;

load new_data.mat

A = data(ss_start:ss_end,:);
fluid_in = A(:,10);
fluid_out = A(:,11);
ave_Temp = (fluid_in + fluid_out)./2;
c_p = @(T) 1518 + 2.82.*T;
ave_c_p = c_p(ave_Temp);
mass_flow = A(:,62);
power_loss = 5000 - mass_flow.*ave_c_p.*(fluid_out-fluid_in);


