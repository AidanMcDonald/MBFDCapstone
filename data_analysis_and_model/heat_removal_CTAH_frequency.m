%Cooler heat rejection as a function of CTAH frequency

clear
clc
clf
close all
load headers.mat
Power_total = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10];
sensor_required = ["ctah_frequency";"BT_43"; "BT_41";"FM_40"; "AT_02"];
heat_removal_cooler_storer = [];
CTAH_frequency_storer = []; 
p_rej_divided_temp_diff_storer = [];
c_p = @(T) 1518 + 2.82.*T;
for i = 1:11
P = Power_total(i);
load(strcat(num2str(P),'kW_ss_data.mat'));    
for j = 1:numel(sensor_required)
       %Find the sensor required in the headers, Find index 
      indexC =  strfind(headings,sensor_required(j));
      index = find(not(cellfun('isempty',indexC)));
      %Extract and save the relevant data. 
      sensor_data.(char(sensor_required(j))) = data_power(:,index);
end    
    
%Power Reject
heat_removal_cooler = (sensor_data.FM_40).*c_p(0.5.*(sensor_data.BT_43 + sensor_data.BT_41)).*(sensor_data.BT_43 - sensor_data.BT_41);

%Temp difference. T_hot_oil - T_ambient_air
temp_diff = sensor_data.BT_43 - sensor_data.AT_02;

%Power rejection divided by temp difference
p_rej_divided_temp_diff = heat_removal_cooler./temp_diff ;

p_rej_divided_temp_diff_storer = [p_rej_divided_temp_diff_storer ;p_rej_divided_temp_diff];
heat_removal_cooler_storer = [heat_removal_cooler_storer;heat_removal_cooler];
CTAH_frequency_storer = [CTAH_frequency_storer; sensor_data.ctah_frequency];
end

sample_number = numel(CTAH_frequency_storer);
coeffs = fit(CTAH_frequency_storer,p_rej_divided_temp_diff_storer,'Poly1');
ci = confint(coeffs,0.95);
coeff_more_digits = coeffvalues(coeffs);

figure
hold on

scatter(CTAH_frequency_storer,p_rej_divided_temp_diff_storer,3,'filled')
x = [130:1:360];
y = @(x) coeff_more_digits(1).*x + coeff_more_digits(2);
plot(x,y(x),'k')
title('Heat rejection of CTAH')
xlabel('CTAH frequency [Hz]')
ylabel('P_{reject}/(T_{hot oil} - T_{ambient}) [W/K]')
legend('Data points','Estimated heat rejection using equation')
text(250,70,'P_{reject} = 0.2264 f_{CTAH freq} + 31.2908');


