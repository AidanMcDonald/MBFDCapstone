

%% This file calculates the residual error for heater wall temp as a function of power input
clear;clc; close all
load resultant_heater_error.mat

figure
hold on

error = results.exp_ss_results- results.corrected_ss_results;

p_total = [5000:500:10000];
for i = 1:5
    plot(p_total,error(:,i),'-o')
end
title('Resultant error from MATLAB model and Exp. data')
legend('Position 1', 'Position 2', 'Position 3', 'Position 4','Position 5')
xlabel('Power')
ylabel(strcat('Error [',char(176), 'C]'))

%% Find the correlation between power input and error 

sections = [1:5];
coeff = zeros(5,2);
for i = 1:numel(sections)
    coeff(i,:) = polyfit(p_total',error(:,i),1);
end


A = 1;
%% Following portion shows the final results with raw data. Corrected with new Nu correlation and using the residual error difference.

%show 7.5 kW 
load 7.5kW_ss_data_split_power_w_headers.mat

figure
subplot(2,1,1)
hold on
%section 1
scatter([1:numel(data.ST_10)], data.ST_10,1,'filled');

%section 2
scatter([1:numel(data.ST_10)],data.ST_11,1,'filled')

%sensor_required = ["ST_10","ST_11","ST_12_SE","ST_13","ST_14_S","ST_12_N","ST_12_SW","ST_14_E","ST_14_W","ST_14_N"];

%section 3
data.average_ST_12 = (data.ST_12_SE + data.ST_12_N + data.ST_12_SW)./3;
scatter([1:numel(data.ST_10)],data.average_ST_12,1,'filled')



%Corrected data

%7500 power is the 6th row for coeff
%Find individual error terms

error_power = @(P) coeff(:,1).*P + coeff(:,2);
corrected_error = error_power(7500);



line_style_cycle = {'-' , '--', '-.'};
for k = 1:3
    y = (results.corrected_ss_results(6,k) + corrected_error(k))-273;
    line([1, numel(data.ST_10)],[y y],'Color','black','LineWidth',0.75,'LineStyle',line_style_cycle{k});
end

title('Final MATLAB model ss estimates for 7500 W comparison with raw data') 
xlim([1, numel(data.ST_10)]);
ax = gca
ax.XTick = [];
ylabel(strcat('Temperature [',char(176), 'C]'))
legend('Section 1','Section 2','Section 3','MATLAB section 1','MATLAB section 2','MATLAB section 3')
ylim([130 195])

subplot(2,1,2)


hold on
%section 4
scatter([1:numel(data.ST_10)],data.ST_13,1,'filled')

%section 5 
data.average_ST_14 = (data.ST_14_N + data.ST_14_E +data.ST_14_S +data.ST_14_W )./4;
scatter([1:numel(data.ST_10)],data.average_ST_14,1,'filled')
for k = 4:5
    y = (results.corrected_ss_results(6,k) + corrected_error(k))-273;
    line([1, numel(data.ST_10)],[y y],'Color','black','LineWidth',0.75,'LineStyle',line_style_cycle{k-2});
end
xlim([1, numel(data.ST_10)]);
ax = gca
ax.XTick = [];
ylabel(strcat('Temperature [',char(176), 'C]'))
ylim([165 180])

legend('Section 4','Section 5','MATLAB section 4','MATLAB section 5')
