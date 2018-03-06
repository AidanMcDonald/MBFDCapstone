function output = P_reject(CTAH_frequency, T_hot_leg)

%Linear fit P_reject
k = [ 0.422809767053714  17.072916739641418];
T_air = 21.711 + 273;
P_reject_calc = (CTAH_frequency.*k(1) + k(2)).*(T_hot_leg - T_air);
output = [P_reject_calc CTAH_frequency];
end