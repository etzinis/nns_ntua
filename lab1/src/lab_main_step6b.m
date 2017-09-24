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
[pr_train, settings] = processpca(clean_train, 0.00045);
pr_test = processpca('apply', clean_test, settings);


%% Step 3 - Create, Train and Evaluate Neural Network

avergae_precision = zeros(6);
avergae_recall = zeros(6);
%for k = 1:6
    for j = 1:2
        accuracies = [];
        f1_scores = [];
        recalls = [];
        precisions = [];
        for i = 1:5
            % Create net and setup parameters
            if j == 1
                network = newff(pr_train, train_d_targets, [20, 15], {'tansig', 'tansig', 'tansig'}, 'traingdx',  'learngd');
            else
                network = newff(pr_train, train_d_targets, [20, 15], {'tansig', 'tansig', 'tansig'}, 'traingdx',  'learngdm');
            end
            network.divideFcn = 'divideblock';
            network.divideParam.trainRatio=0.8;
            network.divideParam.valRatio=0.2;
            network.divideParam.testRatio=0;
            network.trainParam.epochs = 1000;
            network.trainParam.showWindow = false;
            
            % Train Neural Network
            net = traingdx(network,pr_train,train_d_targets);
            
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
        average_recall(j) = mean(recalls);
        average_precision(j) = mean(precisions);
        average_accuracy(j) = mean(accuracies)
        var_acc = var(accuracies);
        var_f_score = var(f1_scores);
        var_recall = var(recalls);
        var_precision = var(precisions);

    end
    
%end