clear;clc;
close all

%load data and headers
load headers.mat
load new_data.mat
%Extract

ssCutoffs = [61342 66736 71217 77732 83158 87048   91038 95227 99415 104103 109189; 64386 69770 73519 80968 86249 90140 94131 98317 102506 107192 112383];

%extract data into excel file
%[data,headings] = xlsread('trainingData_removed_restarts.xlsx','A1:BM119635');

Power_total = [5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10];
average_values = zeros(11,65);
var_values = zeros(11,65);
data_split = struct();
num_samples = zeros(11,1);
for i = 1:11
    ss_start = ssCutoffs(1,i);
    ss_end = ssCutoffs(2,i);
    
    ss_start = ss_start -1; %Because first row was header
    ss_end = ss_end - 1;
    %This is to account for the restarts
    if i <= 3
        ss_start = ss_start - 3;
        ss_end = ss_end - 3;
    end
    
    if i > 3 
        ss_start = ss_start - 4;
        ss_end = ss_end - 4;
    end
    
    data_power = data(ss_start:ss_end,:);
    average_values(i,:) = mean(data_power);
    var_values(i,:) = var(data_power);
    
    P = Power_total(i);
    size_matrix = size(data_power);
    num_samples(i) = size_matrix(1);
    %Save in individual files

    save (strcat(num2str(P),'kW_ss_data.mat'),'data_power');
    
    
end
    
%Data split is a structure with fields of the sensor mean and variance. Each row is a
%different power.
for j = 1:numel(headings)
    data_split.(char(headings{j})) = [average_values(:,j) var_values(:,j)];
end

%save('data_seperated.mat','data_split','num_samples')