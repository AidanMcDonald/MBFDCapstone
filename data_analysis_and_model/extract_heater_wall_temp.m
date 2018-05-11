%Extract heater wall temperatures and find averages where necessary
load new_data.mat
load headers.mat
load data_seperated.mat

sensor_required = ["ST_10","ST_11","ST_12_SE","ST_13","ST_14_S","ST_12_N","ST_12_SW","ST_14_E","ST_14_W","ST_14_N"];
Power_total = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10];

      temp_1_wall = data_split.(char(sensor_required(1)));
      temp_2_wall = data_split.(char(sensor_required(2)));
      temp_4_wall = data_split.(char(sensor_required(4)));
      temp_3_wall = zeros(11,2);
      temp_5_wall = zeros(11,2);
      
      
      for j = 1:11
          P = Power_total(j);
          load(strcat(num2str(P),'kW_ss_data.mat'));
          ST_12_1 = data_power(:,47);
          ST_12_2 = data_power(:,52);
          ST_12_3 = data_power(:,53);
          ave_temp_ST_12 = (ST_12_1 + ST_12_2 + ST_12_3)./3;
          temp_3_wall(j,:) = [mean(ave_temp_ST_12) var(ave_temp_ST_12)];
          
          ST_14_1 =data_power(:,49);
          ST_14_2 =data_power(:,54);
          ST_14_3 =data_power(:,55);
          ST_14_4 = data_power(:,56);
          ave_temp_ST_14 = (ST_14_1 + ST_14_2 + ST_14_3 + ST_14_4)./4;
          temp_5_wall(j,:) = [mean(ave_temp_ST_14) var(ave_temp_ST_14)];

      end
      
      
     