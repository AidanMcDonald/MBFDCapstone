%Find heater losses w/o using the combined stats method
clear;clc
close all
Power_total = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10];
%ssCutoffs = [61342 66736 71217 77732 83158 87048   91038 95227 99415 104103 109189; 64386 69770 73519 80968 86249 90140 94131 98317 102506 107192 112383];
%load new_data.mat
load headers.mat

%Define C_p_ function 
c_p = @(T) 1518 + 2.82.*T;

power_loss_total = zeros(11,2); %results will go into this matrix
hot_leg_losses_total = zeros(11,2);
cold_leg_losses_total = zeros(11,2);
heat_removal_cooler_total = zeros(11,2);
ctah_frequency_total = zeros(11,2);

heater_out_fluid = zeros(11,2);
hot_leg_out_fluid = zeros(11,2);
CTAH_out_fluid = zeros(11,2);
cold_leg_out_fluid = zeros(11,2);


for i = 1:11
    P = Power_total(i);
   load(strcat(num2str(P),'kW_ss_data.mat'));
   
   %Use double quotes for string, single will make it a char
   %BT_41 is the sensor right after CS; BT_43 is before the CS
   sensor_required = ["BT_11"; "BT_12"; "FM_40"; "BT_43"; "BT_41"; "ctah_frequency"];
       
       
       
   
   
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
   
   
   hot_leg_losses = (sensor_data.FM_40).*c_p(0.5.*(sensor_data.BT_43 + sensor_data.BT_12)).*(sensor_data.BT_43 - sensor_data.BT_12);
   heat_removal_cooler = (sensor_data.FM_40).*c_p(0.5.*(sensor_data.BT_43 + sensor_data.BT_41)).*(sensor_data.BT_43 - sensor_data.BT_41);
   cold_leg_losses = (sensor_data.FM_40).*c_p(0.5.*(sensor_data.BT_11 + sensor_data.BT_41)).*(sensor_data.BT_41 - sensor_data.BT_11);
   
   
   power_loss_total(i,:) = [mean(power_loss) var(power_loss)];
   hot_leg_losses_total(i,:) = [mean(hot_leg_losses) var(hot_leg_losses)];
   heat_removal_cooler_total(i,:) = [mean(heat_removal_cooler) var(heat_removal_cooler)];
   cold_leg_losses_total(i,:) = [mean(cold_leg_losses) var(cold_leg_losses)];
   ctah_frequency_total(i,:) = [mean(sensor_data.ctah_frequency) var(sensor_data.ctah_frequency)];
   
   heater_out_fluid(i,:)= [mean(sensor_data.BT_12) var(sensor_data.BT_12)];
   hot_leg_out_fluid(i,:) = [mean(sensor_data.BT_43) var(sensor_data.BT_43)];
    CTAH_out_fluid(i,:) = [mean(sensor_data.BT_41) var(sensor_data.BT_41)];
    cold_leg_out_fluid(i,:) = [mean(sensor_data.BT_11) var(sensor_data.BT_11)];

end    

A = [heater_out_fluid hot_leg_out_fluid CTAH_out_fluid cold_leg_out_fluid];
    