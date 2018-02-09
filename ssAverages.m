% Get averages and variances of all sensors in steady-state conditions

%% Load Data from CSV
filename = 'trainingData.csv';
dataTable = readtable(filename);
data = table2array(dataTable);

%% Extract only steay-state data
% ssCutoffs: each column is a set of row numbers (from filename) indicating
% the fist row of steady state and thelast row of steady state. Different columns
% are for each steady state situation.
ssCutoffs = [1 3 5 7 9; 2 4 6 8 10];
ssData = cell(1,size(ssCutoffs,2));
numSamples = zeros(1,size(ssCutoffs,2));

for i = 1:size(ssCutoffs,2) % For each steady state condition
    ssData{i} = zeros(1,size(data,2));
    for j = ssCutoffs(1,i):ssCutoffs(2,i) % For each row of steady state data
        % Add that row
        if j==1
            ssData{i} = [data(j,:)]; 
        else
            ssData{i} = [ssData{i};data(j,:)];
        end
    end
    numSamples(i) = ssCutoffs(2,i) - ssCutoffs(1,i) + 1; % Number of samples in each steady state condition
end


%% Analyze steady state data
stats = cell(1,size(ssCutoffs,2)); % place to store averages and variances

for i = 1:size(ssCutoffs,2) % For each steady state condition
    tempStats = zeros(2,size(ssData{i},2));
    tempssData = ssData{i};
    for j = 1:size(ssData{i},2) % For each sensor/variable
        tempStats(1,j) = mean(tempssData(:,j));
        tempStats(2,j) = var(tempssData(:,j));
    end
    stats{i} = tempStats;
end