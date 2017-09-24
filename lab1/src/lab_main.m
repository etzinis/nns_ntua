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

avergae_precision = zeros(6);
avergae_recall = zeros(6);
accuracies = [];
f1_scores = [];
recalls = [];
precisions = [];
for i = 1:1
    % Create net and setup parameters
    network = newff(pr_train, train_d_targets, [20, 15], {'tansig', 'tansig', 'purelin'});

    %network.divideFcn = 'divideblock';
    network.divideParam.trainRatio=0.8;
    network.divideParam.valRatio=0.2;
    network.divideParam.testRatio=0;
    network.trainFcn = 'traingdx';

    % Train Neural Network
    net = train(network,pr_train,train_d_targets);

    % Simulate Neural Network
    TestDataOutput = sim(net,pr_test);

    % Evaluate
    [accuracy,precision,recall] = eval_Accuracy_Precision_Recall(TestDataOutput,TestDataTargets);
    accuracies(i) = accuracy;
    f1_scores(i) = mean(2*(precision.*recall)./(precision+recall));
    recalls(i) = mean(recall);
    precisions(i) = mean(precision);
end

average_acc = mean(accuracies);
average_f_score = mean(f1_scores);
average_recall = mean(recalls);
average_precision = mean(precisions);
average_accuracy = mean(accuracies)
  

%% Confusion matrix

 [~, actual_is]  = max(TestDataTargets);
 
 [~, classified_is] = max(TestDataOutput);
 
 confusion = zeros(5);
 j = 1;
 for i = 1:length(classified_is)
    x = actual_is(i);
    y = classified_is(i);
    confusion(x,y) = confusion(x,y) + 1;
    if x ~= y
        wrong(1:5,j) = TestDataOutput(:,i);
        wrong(6,j) = actual_is(i);    
        j = j + 1;
        display(TestDataOutput(:,i));
    end
 end
 
confusion


