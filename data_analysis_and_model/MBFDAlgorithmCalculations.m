clear;clc
P = [5:0.5:10];

dv1_storer = zeros(1,numel(P));
v1_storer=zeros(1,numel(P));

dTdv1_storer = zeros(1,numel(P));
dTv1_storer=zeros(1,numel(P));

for i = 1:numel(P)
   p = P(i);
   p_string = num2str(p);
   filename=strcat (p_string,'kW_ss_data_split_power_w_headers.mat');
    load (filename)
    
    %BT-12 (HL-1)
    A1 = data.BT_12;
    x1=max(A1);
    n1=min(A1);
    g1=mean(A1);
    v1=sqrt(var(A1));
    xv1=(x1-g1)/v1;
    nv1=abs((n1-g1)/v1); 
    dv1=max(xv1,nv1); %outlier stdev distances from the mean
    
    dv1_storer(i) = dv1;
    v1_storer(i)=v1;
    
    dT1=diff(A1)/.1;
    
    dTx1=max(dT1);
    dTn1=min(dT1);
    dTg1=mean(dT1);
    dTv1=sqrt(var(dT1));
    dTxv1=(dTx1-dTg1)/dTv1;
    dTnv1=abs((dTn1-dTg1)/dTv1);
    dTdv1=max(dTxv1,dTnv1);
    
    dTdv1_storer(i) = dTdv1;
    dTv1_storer(i)=dTv1;
    
    
    %BT-43 (HL2)
    A2 = data.BT_43;
    x2=max(A2);
    n2=min(A2);
    g2=mean(A2);
    v2=sqrt(var(A2));
    xv2=(x2-g2)/v2;
    nv2=abs((n2-g2)/v2);
    dv2=max(xv2,nv2);
    
    dv2_storer(i) = dv2;
    v2_storer(i)=v2;
    
    dT2=diff(A2)/.1;
    
    dTx2=max(dT2);
    dTn2=min(dT2);
    dTg2=mean(dT2);
    dTv2=sqrt(var(dT2));
    dTxv2=(dTx2-dTg2)/dTv2;
    dTnv2=abs((dTn2-dTg2)/dTv2);
    dTdv2=max(dTxv2,dTnv2);
    
    dTdv2_storer(i) = dTdv2;
    dTv2_storer(i)=dTv2;
    
    
    %BT-41 (CL1)
    A3 = data.BT_41;
    x3=max(A3);
    n3=min(A3);
    g3=mean(A3);
    v3=sqrt(var(A3));
    xv3=(x3-g3)/v3;
    nv3=abs((n3-g3)/v3);
    dv3=max(xv3,nv3);
    
    dv3_storer(i) = dv3;
    v3_storer(i)=v3;
    
    dT3=diff(A3)/.1;
    
    dTx3=max(dT3);
    dTn3=min(dT3);
    dTg3=mean(dT3);
    dTv3=sqrt(var(dT3));
    dTxv3=(dTx3-dTg3)/dTv3;
    dTnv3=abs((dTn3-dTg3)/dTv3);
    dTdv3=max(dTxv3,dTnv3);
    
    dTdv3_storer(i) = dTdv3;
    dTv3_storer(i)=dTv3;
    
    
    %BT-11 (CL2)
    A4 = data.BT_11;
    x4=max(A4);
    n4=min(A4);
    g4=mean(A4);
    v4=sqrt(var(A4));
    xv4=(x4-g4)/v4;
    nv4=abs((n4-g4)/v4);
    dv4=max(xv4,nv4);
    
    dv4_storer(i) = dv4;
    v4_storer(i)=v4;
    
    dT4=diff(A4)/.1;
    
    dTx4=max(dT4);
    dTn4=min(dT4);
    dTg4=mean(dT4);
    dTv4=sqrt(var(dT4));
    dTxv4=(dTx4-dTg4)/dTv4;
    dTnv4=abs((dTn4-dTg4)/dTv4);
    dTdv4=max(dTxv4,dTnv4);
    
    dTdv4_storer(i) = dTdv4;
    dTv4_storer(i)=dTv4;
    
end

m = 3; % average every m values
z1 = arrayfun(@(i) mean(A1(i:i+m-1)),1:m:length(A1)-m+1)'; % vector by averaging every m elements
z2 = arrayfun(@(i) mean(A2(i:i+m-1)),1:m:length(A2)-m+1)'; % vector by averaging every m elements
z3 = arrayfun(@(i) mean(A3(i:i+m-1)),1:m:length(A3)-m+1)'; % vector by averaging every m elements
z4 = arrayfun(@(i) mean(A4(i:i+m-1)),1:m:length(A4)-m+1)'; % vector by averaging every m elements
t3=[1:1:numel(z1)];


m = 10; % average every m values
y1 = arrayfun(@(i) mean(dT1(i:i+m-1)),1:m:length(dT1)-m+1)'; % vector by averaging every m elements
y2 = arrayfun(@(i) mean(dT2(i:i+m-1)),1:m:length(dT2)-m+1)'; % vector by averaging every m elements
y3 = arrayfun(@(i) mean(dT3(i:i+m-1)),1:m:length(dT3)-m+1)'; % vector by averaging every m elements
y4 = arrayfun(@(i) mean(dT4(i:i+m-1)),1:m:length(dT4)-m+1)'; % vector by averaging every m elements

figure
plot(P,v1_storer,P, v2_storer,P,v3_storer,P,v4_storer);
title('\sigmas of T for given power levels')
xlabel('Power Levels (kW)') % x-axis label
ylabel('\sigma') % y-axis label
legend('BT-12 (HL1)','BT-43 (HL2)','BT-41 (CL1)','BT-11 (CL2)')

figure
plot(P,dv1_storer,P,dv2_storer,P,dv3_storer,P,dv4_storer);
title('Furthest outlier \sigmas from the mean for T at given power levels')
xlabel('Power Levels (kW)') % x-axis label
ylabel('\sigmas from mean') % y-axis label
legend('BT-12 (HL1)','BT-43 (HL2)','BT-41 (CL1)','BT-11 (CL2)')


figure
plot(P,dTv1_storer,P,dTv2_storer,P,dTv3_storer,P,dTv4_storer);
title('\sigmas of dT for given power levels')
xlabel('Power Levels (kW)') % x-axis label
ylabel('\sigma') % y-axis label
legend('BT-12 (HL1)','BT-43 (HL2)','BT-41 (CL1)','BT-11 (CL2)')

figure
plot(P,dTdv1_storer,P,dTdv2_storer,P,dTdv3_storer,P,dTdv4_storer);
title('Furthest outlier \sigmas from the mean for dT at given power levels')
xlabel('Power Levels (kW)') % x-axis label
ylabel('\sigmas from mean') % y-axis label
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

%The max standard deviation of T for all powers for each thermocouple 
Vcomb=[max(v1_storer),max(v2_storer),max(v3_storer),max(v4_storer)]

%The max standard deviation of dT for all powers for each thermocouple
dTVcomb=[max(dTv1_storer),max(dTv2_storer),max(dTv3_storer),max(dTv4_storer)]