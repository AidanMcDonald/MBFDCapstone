clearvars -except trainingDataOutputs trainingDataInputs
%% Load Training data
data = readtable('2018-02-07_Power_Step_Change_Test_RAW.csv');

outputColumns = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 56 58 59 60 61 62 63 64 65 66]; % Column indeces for output data
inputColumns = [57 20]; % Column indeces for input data

%% Set up outputs/variables to predict
if ~exist('trainingDataOutputs')
    trainingDataOutputs = cell(1,size(outputColumns,2));
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = outputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataOutputs(1,i) = {temp'};
        if mod(i,10000)==0
            disp(['Processing output row ', int2str(i)])
        end
    end
end

%% Set up inputs/variables we want to use to predict outputs
if ~exist('trainingDataInputs')
    trainingDataInputs = cell(1,size(inputColumns,2));
    for i = 1:size(data,1) % For each row/time we have data for
        temp = [];
        for j = inputColumns % For each column/variable we want to use
            temp = [temp table2array(data(i,j))];
        end
        trainingDataInputs(1,i) = {temp'};
        if mod(i,10000)==0
            disp(['Processing input row ', int2str(i)])
        end
    end
end