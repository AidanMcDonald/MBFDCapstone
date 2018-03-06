%Hot leg losses

clear
clc
clf
close all
Power_total = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10];
load headers.mat
hot_leg_losses_storer = [];
c_p = @(T) 1518 + 2.82.*T;
for i = 1:11
    P = Power_total(i);
   load(strcat(num2str(P),'kW_ss_data.mat'));
   
   %Use double quotes for string, single will make it a char
   %BT_41 is the sensor right after CS; BT_43 is before the CS
   sensor_required = ["BT_11"; "BT_12"; "FM_40"; "BT_43"; "BT_41"];
       
       
       
   
   
   %Find index of required string
   for j = 1:numel(sensor_required)
       %Find the sensor required in the headers, Find index 
      indexC =  strfind(headings,sensor_required(j));
      index = find(not(cellfun('isempty',indexC)));
      
      %Extract and save the relevant data. 
      sensor_data.(char(sensor_required(j))) = data_power(:,index);
   end
   
   
   
   hot_leg_losses_calc = (sensor_data.FM_40).*c_p(0.5.*(sensor_data.BT_43 + sensor_data.BT_12)).*(-sensor_data.BT_43 + sensor_data.BT_12);
   
   %Append the cold_leg_losses into the storer
   hot_leg_losses_storer = [hot_leg_losses_storer;  hot_leg_losses_calc];
   
end   

mean_hot_leg_losses = mean(hot_leg_losses_storer);
var_hot_leg_losses = var(hot_leg_losses_storer);

figure

histogram(hot_leg_losses_storer,'Normalization','pdf')
title('Normalized PDF of Hot leg losses')
xlabel('Heater losses [W]');
ylabel('Probability');