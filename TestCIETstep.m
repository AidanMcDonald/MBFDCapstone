a.T = [800;300;300;300;273;300;300;300];

for i = 1:10000
a.dt = 0.1;
a.mdot = 0.18;
a.P_in = 1000;
a.P_reject = 1000;
a.Qdot_pump = 10;

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