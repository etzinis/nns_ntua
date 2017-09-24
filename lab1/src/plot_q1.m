clc; clear all; close all;

%% Question 1 plot

load('with_pre_and_without_pre.mat')

data = [With ; Without]';
figure();
bar(5:5:30, data);
title('Accuracy with and without data preproccessing');
xlabel('Neurons');
ylabel('Classification Accuracy');
legend('With Preproccess', 'Without Preproccess');

%% Question 2 plot

load('average_accuracy_4_5.mat')

data = reshape(average_accuracy, [36,4]);

figure();
neurons = cell(6,6);
for i=1:6
    for j=1:6
        neurons(i,j) = {[num2str(5*i), '-',num2str(5*j)]};
    end
end



trainfncs = {'trainlm', 'traingdx', 'traingd', 'traingda'};
for i = 1:4
    subplot(4,1,i);
    bar(data(:,i));
    set(gca, 'XTick', 1:36, 'XTickLabel', reshape(neurons,[36,1]));
    title(['Classification Accuracy for ', trainfncs{i}]);
    xlabel('Neurons (1st Hidden - 2nd Hidden)');
    ylabel('Classification Accuracy');

end

%% Question 3

gdx = [0.8393    0.4000    0.9103    0.1327];
lm = [0.9028    0.6243    0.8785    0.1215];
data = [gdx ; lm]';
figure
bar(data);
set(gca, 'XTick', 1:4, 'XTickLabel', {'tansig', 'logsig', 'purelin', 'hardlim'});
title('Accuracy for traingdx and trainlm regarding different output functions');
xlabel('Output function');
ylabel('Classification Accuracy');
legend('traingdx', 'trainlm');


%% Question 5

data = [0.6495    0.9112    0.9159    0.9019    0.8925    0.8925 0.8785; 0.5607    0.8925    0.9112    0.9252    0.9019    0.9019    0.8972];
figure
plot([100, 150, 200, 500 ,1000, 2000, 5000], data');
title('Accuracy for traingdx with and without early stopping');
xlabel('Epochs');
ylabel('Classification Accuracy');
legend('Without Early Stopping', 'With Early Stop');


%% Question 7
data = [0.8879    0.8897    0.8822    0.8991    0.8897    0.8879    0.8953    0.8822;
        0.8019    0.9140    0.9009    0.9047    0.9009    0.9140    0.9065    0.9065;
        0.8243    0.6467    0.5458    0.5589    0.3963    0.6243    0.7794    0.9140;
        0.8206    0.8785    0.9103    0.9028    0.9159    0.9234    0.9028    0.9121];

figure
plot(0.05:0.05:0.40, data');
title('Accuracy for traingdx and traingd for various learning rates');
xlabel('Learning Rate');
ylabel('Classification Accuracy');
legend('traingdx - Without Early Stopping', 'traingd - Without Early Stop', 'traingdx - With Early Stopping', 'traingd - With Early Stop');

%% Confusion Matrix

% Accuracy 93.46%
data = [40    1     0     1     0;
        0    27     3     0     0;
        0     2    28     0     0;
        0     0     0    26     0;
        0     0     1     0    30];
    
% \[
% \begin{tabular}{|c| c | c |c |c |c |} 
% \hline
% \multicolumn{6}{|c|}{\(Confusion Matrix\)} \\
% \hline
% ~ & \(Cl\) 1 & \(Cl\) 2 & \(Cl\) 3 & \(Cl\) 4 & \(Cl\) 5\\ 
% \hline
% \(Class\) 1 & 40 & 1 & 0 & 1 & 0\\ 
% \(Class\) 2 & 0 & 27 & 3 & 0 & 0\\ 
% \(Class\) 3 & 0 & 2 & 28 & 0 & 0\\ 
% \(Class\) 4 & 0 & 0 & 0 & 26 & 0\\ 
% \(Class\) 5 & 0 & 0 & 1 & 0 & 30 \\
% \hline
% \end{tabular}
% \]
  

%% Backpropagation algorithm
load('saverino.mat')
figure
plot(test_accuracy);
title('Accuracy on test data');
xlabel('Iterations');
ylabel('Classification Accuracy');

figure
plot(perf);
title('Error on train data');
xlabel('Iterations');
ylabel('Error on train data');

figure
plot(non_zeroed);
title('Number of zeroed out weights');
xlabel('Iterations');
ylabel('Number of weights');

load('less_neuros_10.mat')
figure
plot(test_accuracy);
title('Accuracy on test data on a network with 10 neurons');
xlabel('Iterations');
ylabel('Classification Accuracy');

