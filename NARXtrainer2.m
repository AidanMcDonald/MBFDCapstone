clearvars -except trainingDataOutputs trainingDataInputs
%% Input which colums we want to predict using which other columns

outputColumns = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 56 58 59 60 61 62 63 64 65]; % Column indeces for output data
inputColumns = [57 20]; % Column indeces for input data

%% Set up outputs/variables to predict
if ~exist('trainingDataOutputs')
    trainingDataOutputs = cell(5,size(outputColumns,2));
    % Time series 1
    data = readtable('NewData1.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = outputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataOutputs(1,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 1: Processing output row ', int2str(i)])
        end
    end
    
    % Time series 2
    data = readtable('NewData2.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = outputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataOutputs(2,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 2: Processing output row ', int2str(i)])
        end
    end
    
    % Time series 3
    data = readtable('NewData3.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = outputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataOutputs(3,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 3: Processing output row ', int2str(i)])
        end
    end
    
    % Time series 4
    data = readtable('NewData4.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = outputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataOutputs(4,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 4: Processing output row ', int2str(i)])
        end
    end
    
    % Time series 5
    data = readtable('NewData5.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = outputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataOutputs(5,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 5: Processing output row ', int2str(i)])
        end
    end
end
%% Set up inputs/variables we want to use to predict outputs
if ~exist('trainingDataInputs')
    trainingDataInputs = cell(5,size(inputColumns,2));
    % Time series 1
    data = readtable('NewData1.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = inputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataInputs(1,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 1: Processing input row ', int2str(i)])
        end
    end
    
    % Time series 2
    data = readtable('NewData2.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = inputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataInputs(2,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 2: Processing input row ', int2str(i)])
        end
    end
    
    % Time series 3
    data = readtable('NewData3.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = inputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataInputs(3,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 3: Processing input row ', int2str(i)])
        end
    end
    
    % Time series 4
    data = readtable('NewData4.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = inputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataInputs(4,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 4: Processing input row ', int2str(i)])
        end
    end
    
    % Time series 5
    data = readtable('NewData5.csv');
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = inputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataInputs(5,i) = {temp'};
        if mod(i,1000)==0
            disp(['Time series 5: Processing input row ', int2str(i)])
        end
    end
end

%% Create and train the network
% Create a Nonlinear Autoregressive Network with External Input
inputDelays = 1:4;
feedbackDelays = 1:4;
hiddenLayerSize = 4;
net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize);

for i = 1:5
    inputSeries = trainingDataInputs(i,:);
    targetSeries = trainingDataOutputs(i,:);
    inputSeries = inputSeries(~cellfun('isempty',inputSeries));
    targetSeries = targetSeries(~cellfun('isempty',targetSeries));
    
    % Prepare the Data for Training and Simulation
    % The function PREPARETS prepares time series data
    % for a particular network, shifting time by the minimum
    % amount to fill input states and layer states.
    % Using PREPARETS allows you to keep your original
    % time series data unchanged, while easily customizing it
    % for networks with differing numbers of delays, with
    % open loop or closed loop feedback modes.
    [inputs,inputStates,layerStates,targets] = ...
        preparets(net,inputSeries,{},targetSeries);
    
    % Set up Division of Data for Training, Validation, Testing
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;
    
    % Train the Network
    [net,tr] = train(net,inputs,targets,inputStates,layerStates,'CheckpointFile','MyCheckpoint','CheckpointDelay',600);
    
    % Test the Network
    outputs = net(inputs,inputStates,layerStates);
    errors = gsubtract(targets,outputs);
    performance = perform(net,targets,outputs);
    
    % View the Network
    view(net)
    
    if(i~=5)
        disp(['Finished training with time series ',num2str(i),': Press any button to continue'])
        pause;
    end
end

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotregression(targets,outputs)
% figure, plotresponse(targets,outputs)
% figure, ploterrcorr(errors)
% figure, plotinerrcorr(inputs,errors)