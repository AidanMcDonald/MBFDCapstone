%Calculate heater loss correlation

%Do an overall plot using ALL the values. From 5000 W to 8000 W

clear; clf
close all
Power_total = [5,5.5,6,6.5,7,7.5,8];
load headers.mat
heater_losses_5000_8000 = [];
ave_heater_wall_temp_storer = [];

c_p = @(T) 1518 + 2.82.*T;

for i = 1:numel(Power_total)
    P = Power_total(i);
   load(strcat(num2str(P),'kW_ss_data.mat'));
   
   %Use double quotes for string, single will make it a char
   %BT_41 is the sensor right after CS; BT_43 is before the CS
   sensor_required = ["BT_11"; "BT_12"; "FM_40"; "BT_43"; "BT_41" ;"ST_10";"ST_11";"ST_12_SE";"ST_13";"ST_14_S";"ST_12_N";"ST_12_SW";"ST_14_E";"ST_14_W";"ST_14_N"];
       
   
   %Find index of required string
   for j = 1:numel(sensor_required)
       %Find the sensor required in the headers, Find index 
      indexC =  strfind(headings,sensor_required(j));
      index = find(not(cellfun('isempty',indexC)));
      %Extract and save the relevant data. 
      sensor_data.(char(sensor_required(j))) = data_power(:,index);
   end
   
   ave_c_p_heater = c_p(0.5.*(sensor_data.BT_11 + sensor_data.BT_12));
   
   power_loss = P.*1000 - (sensor_data.FM_40).*(ave_c_p_heater).*(sensor_data.BT_12 - sensor_data.BT_11);
   heater_losses_5000_8000 = [heater_losses_5000_8000; power_loss];
   
   %Compute heater average
   ave_temp_ST_12 = (sensor_data.ST_12_SE + sensor_data.ST_12_N + sensor_data.ST_12_SW)./3;
   ave_temp_ST_14 = (sensor_data.ST_14_N + sensor_data.ST_14_S + sensor_data.ST_14_E + sensor_data.ST_14_W)./4;
   ave_heater_wall_temp = (sensor_data.ST_10 + sensor_data.ST_11 +  ave_temp_ST_12 + sensor_data.ST_13 + ave_temp_ST_14)./5;
   ave_heater_wall_temp_storer = [ave_heater_wall_temp_storer ; ave_heater_wall_temp];
end
samples_5000_8000 = numel(heater_losses_5000_8000);
%Find parameter. x values is heater wall temp, y is heat loss
coeffs = fit(ave_heater_wall_temp_storer, heater_losses_5000_8000,'Poly1');
ci = confint(coeffs,0.95);
coeff_more_digits = coeffvalues(coeffs);

%Plot results
figure
hold on
ylim([0 400]);
scatter(ave_heater_wall_temp_storer,heater_losses_5000_8000',3,'+')
x = [130:1:165];
y = @(x) coeff_more_digits(1).*x + coeff_more_digits(2)
plot(x,y(x),'k')
title('Heater thermal losses vs. Average heater wall temperature')
xlabel(strcat('Average heater wall temperature [', char(176),'C]'))
ylabel('Heater thermal losses [W]')
legend('Data points','Estimated heat loss using equation')
text(140,100,strcat('P_{loss} = 1.8109 T {heater wall temp} [',char(176),'C] -2.2940'))


Power_total = [8.5,9,9.5,10];
heater_losses_8000_10000 = [];
for i = 1:numel(Power_total)
    P = Power_total(i);
   load(strcat(num2str(P),'kW_ss_data.mat'));
   
   %Use double quotes for string, single will make it a char
   %BT_41 is the sensor right after CS; BT_43 is before the CS
sensor_required = ["BT_11"; "BT_12"; "FM_40"; "BT_43"; "BT_41"; "ST_10";"ST_11";"ST_12_SE";"ST_13";"ST_14_S";"ST_12_N";"ST_12_SW";"ST_14_E";"ST_14_W";"ST_14_N"];
       
   
   %Find index of required string
   for j = 1:numel(sensor_required)
       %Find the sensor required in the headers, Find index 
      indexC =  strfind(headings,sensor_required(j));
      index = find(not(cellfun('isempty',indexC)));
      
      %Extract and save the relevant data. 
      sensor_data.(char(sensor_required(j))) = data_power(:,index);
   end
   
   ave_c_p_heater = c_p(0.5.*(sensor_data.BT_11 + sensor_data.BT_12));
   
   power_loss = P.*1000 - (sensor_data.FM_40).*(ave_c_p_heater).*(sensor_data.BT_12 - sensor_data.BT_11);
   heater_losses_8000_10000 = [heater_losses_8000_10000; power_loss];
   
   %Compute heater average
   %ave_temp_ST_12 = (sensor_data.ST_12_1 + sensor_data.T_12_2 + sensor_data.ST_12_3)./3;
   %ave_temp_ST_14 = (sensor_data.ST_14_1 + sensor_data.ST_14_2 + sensor_data.ST_14_3 + sensor_data.ST_14_4)./4;
   %ave_heater_wall_temp = (sensor_data.ST_10 + sensor_data.ST_11 +  ave_temp_ST_12 + sensor_data.ST_13 + ave_temp_ST_14 + sensor_data.ST_15)./5;
   
end

stats_heater_losses_8000_1000 = [mean(heater_losses_8000_10000) var(heater_losses_8000_10000)];
figure 
histogram(heater_losses_8000_10000,'Normalization','pdf')
title(strcat('Normalized PDF of Heater losses from 162',char(176),'C'))
xlabel('Heater losses [W]');
ylabel('Probability');

samples_8000_10000 = numel(heater_losses_8000_10000);