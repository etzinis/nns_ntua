clc; clear all; close all;

%% Neural Network Lab 1

load dataSet; 

pr_train = TrainData;
train_d_targets = TrainDataTargets;
pr_test = TestData;
%% Step 3 - Create, Train and Evaluate Neural Network

avergae_precision = zeros(6);
avergae_recall = zeros(6);
for k = 1:6
    for j = 1:1
        accuracies = [];
        f1_scores = [];
        recalls = [];
        precisions = [];
        for i = 1:5
            % Create net and setup parameters
            network = newff(pr_train, train_d_targets, [5*k]);
            
            
            network.divideParam.trainRatio=0.8;
            network.divideParam.valRatio=0.2;
            network.divideParam.testRatio=0;
            
            
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
        average_recall(j,k) = mean(recalls);
        average_precision(j,k) = mean(precisions);
        average_accuracy(j,k) = mean(accuracies)
        var_acc = var(accuracies);
        var_f_score = var(f1_scores);
        var_recall = var(recalls);
        var_precision = var(precisions);

    end
end 
%end