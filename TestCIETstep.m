clear all;
%close all;

tstart = tic;
numSteps = 10000;
a.T = [168;103;103;80;80;80;80;79] + 273;
% start heater fluid temps as linearly increasing from 79 to 102, heater temps as linearly decreasing from 200 to 190 
for i = 1:10
    a.T_heater(i,:) = [138.6+i*(175.5-138.6)/10, (79+i*(103-79)/10)]+273; 
end
    %a.T = [290;290;290;290;290;290;290;290];

for i = 1:numSteps
a.dt = .04;
a.mdot = 0.18;
a.P_in = 8000;
a.P_reject = 7900; %This is a problem because in reality P_reject is limited by ambient air temperature
%a.P_reject = ((a.T(4) - 358)/(398)).*8000;

a.Qdot_pump = 100;

newT = CIETstep(a);

%T_1(i) = newT(1);
%T_2(i) = newT(2);
T_1(i) = newT.T_heater(5,1);
T_2(i) = newT.T_heater(10,2);
T_3(i) = newT.T(3);
T_4(i) = newT.T(4);
T_5(i) = newT.T(5);
T_6(i) = newT.T(6);
T_7(i) = newT.T(7);
T_8(i) = newT.T(8);
a.T = newT.T;
a.T_heater = newT.T_heater;
%a.T(1) = a.T_heater(end,1); 
%a.T(2) = a.T_heater(end,2); %Input of hot oil into hot leg

end
telapsed = toc(tstart);

t = 1:numSteps;
plot(t,T_1,t,T_2,t,T_3,t,T_4,t,T_5,t,T_6,t,T_7,t,T_8)
legend('T_1','T_2','T_3','T_4','T_5','T_6','T_7','T_8')
xlabel('Time (not necessarily in s)')
ylabel('Temperature (K)')
title('Model-predicted CIET temperatures')