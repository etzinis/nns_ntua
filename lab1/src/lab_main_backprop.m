clc; clear all; close all;

%% Neural Network Lab 1

%% Step 1 - Get an equal amount of all classes from the train_data

load dataSet; 
each_train = sum(TrainDataTargets, 2);

min_train_data = min(each_train);
[~, labels] = max(TrainDataTargets, [], 1); 

% Keep a random sample of the train data from each class
for i = 1:5
    reshaped_train_to_use(i,:) = randsample(find(labels == i), min_train_data);
end

train_to_use = reshape(reshaped_train_to_use,1, []);
%% Step 2 - Preprocess (Removeconstantrows - ProcessPca

train_d = TrainData(:,train_to_use);
train_d_targets = TrainDataTargets(:,train_to_use);

% Remove constant rows
[clean_train, settings] = removeconstantrows(train_d);
clean_test = removeconstantrows('apply', TestData, settings);

% Apply PCA to the train data
pca_ratio = 0.00045;
[pr_train, settings] = processpca(clean_train, pca_ratio);
pr_test = processpca('apply', clean_test, settings);


%% Step 3 - Create, Train and Evaluate Neural Network

% Create net and setup parameters
network = newff(pr_train, train_d_targets, [30], {'tansig', 'tansig', 'tansig'});

%network.divideFcn = 'divideblock';
network.divideParam.trainRatio=0.8;
network.divideParam.valRatio=0.2;
network.divideParam.testRatio=0;

network.trainFcn = 'traingd';
network.trainParam.epochs = 1;
network.trainParam.showWindow=1;
network.trainParam.lr = 1;
% Train Neural Network
% 
lambda = 0.01;
d = 0.05;

max_iters = 1000;
i = 1;
flag = false;
t_old = getwb(network);
while flag == false && i < max_iters
    t = getwb(network);
    
    network = train(network, pr_train, train_d_targets);
    t_new = getwb(network);
    
    t_final = t_new - t*lambda;
    
    indexes = find(abs(t_final) < d);
    t_final(indexes) = 0;
    non_zeroed(i) = length(t_final) - length(indexes);
    network = setwb(network, t_final);
    %flag = true;
    outputs = network(pr_train);
    errors = outputs - train_d_targets;
    perf(i) = perform(network,outputs,train_d_targets);

    TestDataOutput = sim(network,pr_test);
    [test_accuracy(i),precision,recall] = eval_Accuracy_Precision_Recall(TestDataOutput,TestDataTargets);
    
    i = i + 1;
end
net = network;

%net = train(network,pr_train,train_d_targets);
% Simulate Neural Network
TestDataOutput = sim(net,pr_test);

% Evaluate
[accuracy,precision,recall] = eval_Accuracy_Precision_Recall(TestDataOutput,TestDataTargets);
accuracies = accuracy
f1_scores = mean(2*(precision.*recall)./(precision+recall));
recalls = mean(recall)
precisions = mean(precision)
