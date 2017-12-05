clear all;
close all;

tstart = tic;
numSteps = 1000000;
a.T = [200;102;101;80;20;80;80;79] + 273;
%a.T = [290;290;290;290;290;290;290;290];

for i = 1:numSteps
a.dt = .01;
a.mdot = 0.18;
a.P_in = 8000;
a.P_reject = 7900;
a.Qdot_pump = 100;

newT = CIETstep(a);

T_1(i) = newT(1);
T_2(i) = newT(2);
T_3(i) = newT(3);
T_4(i) = newT(4);
T_5(i) = newT(5);
T_6(i) = newT(6);
T_7(i) = newT(7);
T_8(i) = newT(8);
a.T = newT;

end
telapsed = toc(tstart);

t = 1:numSteps;
plot(t,T_1,t,T_2,t,T_3,t,T_4,t,T_5,t,T_6,t,T_7,t,T_8)