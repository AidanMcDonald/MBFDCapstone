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

for i = 1:size(ssCutoffs,2) % For each steady state condition
    ssData{i} = zeros(1,size(data,2));
    for j = ssCutoffs(1,i):ssCutoffs(2,i) % For each row of steady state data
        if j==1
            ssData{i} = [data(j,:)]; % Add that row
        else
            ssData{i} = [ssData{i};data(j,:)];
        end
    end
end

%% Analyze steady state data
averages = cell(1,size(ssCutoffs,2)); % place to store averages and variances

for i = 1:size(ssCutoffs,2) % For each steady state condition
    tempAverages = zeros(2,size(ssData{i},2));
    tempssData = ssData{i};
    for j = 1:size(ssData{i},2) % For each sensor/variable
        tempAverages(1,j) = mean(tempssData(:,j));
        tempAverages(2,j) = var(tempssData(:,j));
    end
    averages{i} = tempAverages;
end