%% This file sets the initial conditions
clear;clc;clf
close all
%% Set initial and final time steps. This file will save each time step
t_start = 0; %[s]
t_end = 1700; %[s]
t = 0; 
t_step = 0.1; %[s]



%% Define structure of variables

%Format: Each row is a new time step. Each column is a different heater
%wall/ fluid section temperature
T_system = struct();
%Cell 1 is the T of heater wall
T_system.T_heater{1} = zeros(floor((t_end - t_start)./t_step),10);
%Cell 2 is the T of heater fluid
T_system.T_heater{2} = zeros(floor((t_end - t_start)./t_step),10);

% Store dT_dt_of_heater
%dT_dt_T_heater_storer cell 1 is dT_dt for heater wall
T_system.dT_dt_T_heater_storer{1} = zeros(floor((t_end - t_start)./t_step),10);
%dT_dt_T_heater_storer cell 1 is dT_dt for heater fluid
T_system.dT_dt_T_heater_storer{2} = zeros(floor((t_end - t_start)./t_step),10);


%Assign initial values for heater


%Below are the estimated steady state matlab estimate for heater wall. Each
%row is a different power, 5000, 5500 etc. 
T_wall_steady_MATLAB = [117.6068  119.1256  128.4289  129.9546  135.3802  136.8902  141.8531  143.3381  140.0844  141.5549
  121.1530  122.8271  132.7237  134.4039  140.4429  142.1056  147.2641  148.8996  145.8033  147.4227
  124.7564  126.5855  136.9249  138.7591  145.6097  147.4247  152.5565  154.3419  151.5552  153.3228
  128.1799  130.1639  141.0712  143.0596  150.8358  152.8035  158.2319  160.1671  157.6771  159.5922
  131.5107  133.6496  145.2785  147.4209  155.7856  157.9047  163.5679  165.6524  163.4962  165.5583
  135.2100  137.5033  149.4679  151.7634  161.0574  163.3279  169.0015  171.2345  169.5301  171.7386
  138.3577  140.8058  153.8697  156.3192  166.1683  168.5890  174.4899  176.8706  175.4494  177.8032
  141.7752  144.3801  157.8221  160.4270  171.2472  173.8211  179.7061  182.2367  181.2539  183.7554
  145.2654  148.0272  161.9450  164.7048  176.1985  178.9255  185.3613  188.0418  187.2132  189.8613
  148.6294  151.5476  165.8128  168.7271  181.0841  183.9633  190.4369  193.2658  192.6255  195.4196
  152.1232  155.1980  169.8810  172.9499  186.2290  189.2596  195.5569  198.5344  198.6509  201.5914];

%Below are the estimated steady state matlab estimate for heater fluid 
T_fluid_steady_MATLAB = [81.5132   83.0230   84.5286   86.0309   87.5294   89.0246   90.5160   92.0038   93.4884   94.9694
   81.6689   83.3336   84.9933   86.6490   88.3001   89.9470   91.5895   93.2277   94.8619   96.4918
   81.8245   83.6440   85.4575   87.2663   89.0696   90.8679   92.6610   94.4489   96.2321   98.0101
   81.9800   83.9540   85.9212   87.8826   89.8376   91.7869   93.7299   95.6670   97.5985   99.5239
   82.1355   84.2640   86.3846   88.4986   90.6051   92.7049   94.7976   96.8833   98.9625  101.0348
   82.2909   84.5735   86.8473   89.1134   91.3709   93.6207   95.8624   98.0961  100.3224  102.5407
   82.4458   84.8824   87.3088   89.7265   92.1344   94.5336   96.9235   99.3045  101.6769  104.0403
   82.6039   85.1972   87.7791   90.3511   92.9121   95.4631   98.0038  100.5344  103.0553  105.5661
   82.7618   85.5117   88.2489   90.9749   93.6886   96.3911   99.0820  101.7617  104.4304  107.0880
   82.9197   85.8260   88.7183   91.5980   94.4640   97.3176  100.1582  102.9863  105.8023  108.6059
   83.0775   86.1401   89.1872   92.2203   95.2382   98.2424  101.2323  104.2084  107.1710  110.1199];

%Heater wall temperature
T_system.T_heater{1}(1,:) = 273 + [ 135.2100  137.5033  149.4679  151.7634  161.0574  163.3279  169.0015  171.2345  169.5301  171.7386];

%Hwater fluid temperature
T_system.T_heater{2}(1,:) = 273 + [82.2909   84.5735   86.8473   89.1134   91.3709   93.6207   95.8624   98.0961  100.3224  102.5407];



% Format: Each row is a different time step. Each column is a different
% module, Hot leg, Cold sink and Cold leg
T_system.T_modules = zeros(floor((t_end - t_start)./t_step),3);
T_system.dT_dt_T_modules_storer = zeros(floor((t_end - t_start)./t_step),3);

%Assign initial values for modules
% Format: Hot leg, cold sink, Cold Leg
T_system_modules_initial = [383 354 352];
T_system.T_modules(1,:) = T_system_modules_initial;

%Counter to index rows after each time step 
i = 1;



%% Non-temperature user inputs
mass_flow_fluid = 0.18; %[kg/s]
P_input = 5000; %[W]

%The following sets if the CTAH control is on or off and if on, what the
%setpoint temperature of the CTAH is. 
CTAH_control_set{1} = 'on'; CTAH_control_set{2} = 80 + 273; %[K]
CTAH_freq = 230.5548; %[Hz]. 

CTAH_freq_ss_reference = [151.5228
164.9967
180.9748
196.4390
212.1915
230.5548
252.5149
275.0226
301.2840
325.3848
351.1509
]; %Units: [Hz]. each row is a different power level, 5000, 5500 etc.

power_rejection_ss_reference = [4451.2114
4944.0600
5420.7977
5920.4352
6406.1366
6896.0413
7407.6640
7903.0679
8414.8782
8907.4905
9390.2586
];%Units: [W].each row is a different power level, 5000, 5500 etc.





%% Run time step

while t < t_end
    %Calc time deriavatives 
    dT_dt_heater_calc = (dT_dt_heater(T_system.T_heater{1}(i,:), T_system.T_heater{2}(i,:),T_system.T_modules(i,3), P_input,mass_flow_fluid))';
    dT_dt_modules_calc = (dT_dt_modules(T_system.T_modules(i,:)',T_system.T_heater{2}(i,end),mass_flow_fluid,CTAH_freq,CTAH_control_set))';
    
    %Store time deriavatives  
    T_system.dT_dt_T_heater_storer{1}(i+1,:) = dT_dt_heater_calc(1,:);
    T_system.dT_dt_T_heater_storer{2}(i+1,:) = dT_dt_heater_calc(2,:);
    T_system.dT_dt_T_modules_storer(i+1,:) = dT_dt_modules_calc;

    
    %T heater wall time step
    T_system.T_heater{1}(i+1,:) = T_system.T_heater{1}(i,:) + (dT_dt_heater_calc(1,:).*t_step);
    
    %T_heater_fluid time step
    T_system.T_heater{2}(i+1,:) = T_system.T_heater{2}(i,:) + (dT_dt_heater_calc(2,:).*t_step);
    
    %Hot leg, cold sink and cold leg time step
    T_system.T_modules(i+1,:) = T_system.T_modules(i,:) + (dT_dt_modules_calc.*t_step);
    
    %Update time and index counter
    t = t + t_step;
    i = i + 1;
end

%Module values as time becomes very large: 
final_modules = [T_system.T_modules(end,1) T_system.T_modules(end,2) T_system.T_modules(end,3)];




figure
plot(T_system.T_heater{2}(:,end))
title('Heater fluid outlet temperature')


figure
plot(T_system.T_modules(:,1))
title('Hot Leg')



figure
plot(T_system.T_modules(:,2))
title('Cold Sink')

figure
plot(T_system.T_modules(:,3))
title('Cold Leg')