clear;clc

load('7kW_ss_data_split_power_w_headers.mat')


 %BT-12 (HL-1)
    A1 = data.BT_12;
    A1(1:1000)=[]; %deleting first 1000 rows
    dT1=diff(A1)/.1;
    v1=std(A1)

    %BT-43 (HL2)
    A2 = data.BT_43;
    A2(1:1000)=[]; %deleting first 1000 rows
    dT2=diff(A2)/.1;
    v2=std(A2)
    
    %BT-41 (CL1)
    A3 = data.BT_41;
    A3(1:1000)=[]; %deleting first 1000 rows
    dT3=diff(A3)/.1;
    v3=std(A3)

    
    %BT-11 (CL2)
    A4 = data.BT_11;
    A4(1:1000)=[]; %deleting first 1000 rows
    dT4=diff(A4)/.1;
    v4=std(A4)

t4=[1:numel(A1)];
    
%BELOW SHOWS THE EFFECTS OF AVERAGING EVERY COUPLE OF VALUES

m = 3; % average every m values
z1 = arrayfun(@(i) mean(A1(i:i+m-1)),1:m:length(A1)-m+1)'; % vector by averaging every m elements
z2 = arrayfun(@(i) mean(A2(i:i+m-1)),1:m:length(A2)-m+1)'; % vector by averaging every m elements
z3 = arrayfun(@(i) mean(A3(i:i+m-1)),1:m:length(A3)-m+1)'; % vector by averaging every m elements
z4 = arrayfun(@(i) mean(A4(i:i+m-1)),1:m:length(A4)-m+1)'; % vector by averaging every m elements
t3=[1:1:numel(z1)];
vz1=std(z1)
vz2=std(z2)
vz3=std(z3)
vz4=std(z4)

m = 30; % average every m values
y1 = arrayfun(@(i) mean(dT1(i:i+m-1)),1:m:length(dT1)-m+1)'; % vector by averaging every m elements
y2 = arrayfun(@(i) mean(dT2(i:i+m-1)),1:m:length(dT2)-m+1)'; % vector by averaging every m elements
y3 = arrayfun(@(i) mean(dT3(i:i+m-1)),1:m:length(dT3)-m+1)'; % vector by averaging every m elements
y4 = arrayfun(@(i) mean(dT4(i:i+m-1)),1:m:length(dT4)-m+1)'; % vector by averaging every m elements
vy1=std(y1)
vy2=std(y2)
vy3=std(y3)
vy4=std(y4)


figure
plot(t4,A1);
title('T vs Time')
legend('BT-12 (HL1)')

figure
plot(t4,A1-mean(A1),t4,A2-mean(A2),t4,A3-mean(A3),t4,A4-mean(A4));
title('Normalized T vs Time')
legend('BT-12 (HL1)','BT-43 (HL2)','BT-41 (CL1)','BT-11 (CL2)')

figure
plot(t3,z1-mean(z1),t3,z2-mean(z2),t3,z3-mean(z3),t3,z4-mean(z4));
title('Normalized T vs Time averaging every 3 values')
legend('BT-12 (HL1)','BT-43 (HL2)','BT-41 (CL1)','BT-11 (CL2)')



t1=[1:1:numel(dT1)];
figure
plot(t1,dT1,t1,dT2,t1,dT3,t1,dT4);
title('dT vs Time')
legend('BT-12 (HL1)','BT-43 (HL2)','BT-41 (CL1)','BT-11 (CL2)')

t2=[1:1:numel(y1)];
figure
plot(t2,y1,t2,y2,t2, y3,t2, y4);
title('dT vs. time averaging every 10 values') %value number depends on m
ylabel('dT') % y-axis label
legend('BT-12 (HL1)','BT-43 (HL2)','BT-41 (CL1)','BT-11 (CL2)')
