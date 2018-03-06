clear;clc;clf
close all
% Calcualte ambient air temperature
Power_total = [5:0.5:10];

mean_ambient_air = zeros(numel(Power_total),1);
var_ambient_air = zeros(numel(Power_total),1);
mean_CTAH_air_outlet = zeros(numel(Power_total),1);
var_CTAH_air_outlet = zeros(numel(Power_total),1);

ambient_air_storer = [];
CTAH_air_outlet_storer = [];

figure 
hold on

for i = 1:numel(Power_total)
   P = Power_total(i);
   load(strcat(num2str(P),'kW_ss_data_split_power_w_headers.mat')); 
   
   
   scatter(ones(1,numel(data.AT_02)).*P,data.AT_02,3,'b','filled')
   title('Ambient Air temperature vs Power')
   xlabel('Power [kW]')
   ylabel(strcat('Ambient Air temperature [',char(176),'C]'));
   
   
   
   
   
   
   
   
   mean_ambient_air(i) = mean(data.AT_02);
   var_ambient_air(i) = var(data.AT_02);
   mean_CTAH_air_outlet(i) = mean(data.AT_01);
   var_CTAH_air_outlet(i) = var(data.AT_01);
   ambient_air_storer = [ambient_air_storer; data.AT_02];
   CTAH_air_outlet_storer = [CTAH_air_outlet_storer; data.AT_01];
end



%Plot results
figure
hold on
histogram(ambient_air_storer,'Normalization','pdf')
title('PDF of Ambient Air')
xlabel(strcat('Ambient Air temperature [',char(176),'C]'));

