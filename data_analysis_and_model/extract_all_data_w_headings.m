%convert the data_power files into the headers
clear;clc;clf
load headers.mat

p_total = [5:0.5:10];
data = struct();
for i = 1:numel(p_total)
    P = p_total(i);
    load(strcat(num2str(P),'kW_ss_data.mat'));
for j = 1:numel(headings)
    data.(char(headings{j})) = data_power(:,j);
end

save (strcat(num2str(P),'kW_ss_data_split_power_w_headers.mat'),'data');

end