close all; clear all; clc;

%% Document clustering and visualization
% 
% load NIPS500.mat
% 
% %tfidf = tfidf1(Patterns);
% save tfidf.mat
% load tfidf.mat
% 
% neurons = [7 7];
% maximum = max(tfidf, [], 1);
% minimum = min(tfidf, [], 1);
% 
% global IW;
% 
% somCreate([minimum' maximum'], neurons, 'hexagonaltopology', 'dist');
% somTrainParameters(0.9, 10, 0.1);
% somShow(IW, neurons);
% somTrain(tfidf', 2, 1)
% somShow(IW, neurons);
% save('NIPS_IW_7_7_Epochs_10.mat', 'IW');

%% Load Neural Net
load NIPS500.mat
load tfidf.mat

neurons = [10 10];
maximum = max(tfidf, [], 1);
minimum = min(tfidf, [], 1);

global IW;

somCreate([minimum' maximum'], neurons, 'hexagonaltopology', 'dist');
load('NIPS_IW_10_10_Epochs_10.mat')
figure; somShow(IW, [10 10]);

%% Number of Documents for each Neuron
neuron_documents_count = zeros(size(IW,1),1);
for i = 1:size(tfidf,1)
   index = find(somOutput(tfidf(i,:)'));
   neuron_documents_count(index) = neuron_documents_count(index) + 1;
end

figure;
width = 0.7;
bar3(reshape(neuron_documents_count, 10,10),width)
title('Number of documents belonging to each Neuron');
xlabel('Neurons');
ylabel('Neurons');
zlabel('Number of documents');
saveas(gcf, ['images\nips_documents_belonging_to_each_neuron.png']);
%% Find title


global N;
title_indexes = zeros(N,1);
for i = 1:N
   %display(i);
   temp = negdist(tfidf, IW(i,:)');
   title_indexes(i) = find(compet(temp));
end

% Only for visualization purposes
temp = tabulate(title_indexes);
[~, ind] = sort(temp(:,2), 'descend');

figure; 
plot(temp(:,2))
title('Histogram of closest titles');
xlabel('Title Index');
ylabel('Frequency');
saveas(gcf, ['images\nips_histogram_of_closest_titles.png']);

% The 3 titles closer to more neurons
titles(ind(1:3))

figure;
bar3(reshape(title_indexes,10,10))
title('Index of titles closest to each neuron');
xlabel('Neurons')
ylabel('Neurons')
zlabel('Title Index')
saveas(gcf, ['images\nips_index_of_titles_closest_to_each_neuron.png']);
%% Find close terms

term_indexes = zeros(N,3);
for i = 1:N
   %display(i);
   [~, temp] = sort(IW(i,:), 'descend');
   term_indexes(i,:) = temp(1:3);
end

% Only for visualization purposes
common = reshape(term_indexes, 1, []);
temp = tabulate(common);
[~, ind] = sort(temp(:,2), 'descend');
terms(ind(1:3))
figure; plot(temp(:,2))
figure;
bar3(term_indexes)
title('Index of the 3 most important terms to each neuron');
ylabel('Neurons')
xlabel('Importance')
zlabel('Average Term Index')
legend('1st most important', '2nd most important', '3rd most important');
%saveas(gcf, ['images\nips_index_of_most_important_terms_to_each_neuron.png']);
%% Find network and function

net_i = -1;
fun_i = -1;
for i = 1:length(terms)
    if strcmp(terms{i}, 'network')
        net_i = i;
    end    
    if strcmp(terms{i},'function')
        fun_i = i;
    end
end

wanted_neurons = [];
j = 1;
max_net = 0.3 * max(IW(:,net_i));
max_fun = 0.3 * max(IW(:,fun_i));
for i = 1:N
   maximum = 0.01*max(IW(i,:));
   if IW(i,net_i) > max_net & IW(i,fun_i) > max_fun
      wanted_neurons(j) = i;
      j = j + 1;
   end
    
end
length(wanted_neurons)
%% Average weight

indexes_average_weights = zeros(length(terms));
max_term_weights = max(IW);
vals = zeros(length(wanted_neurons),length(terms));
for i = 1:length(wanted_neurons)
   %display(i);
   neuron_i = wanted_neurons(i);
   
   vals(i,:) = IW(neuron_i,:) ./ max_term_weights;
end

figure;
selected_average = mean(vals);
plot(selected_average)
title('Average importance of all terms for the neurons of iv');
xlabel('Terms');
ylabel('Average importance');
saveas(gcf, ['images\nips_average_importance_of_all_terms_for_the_iv_neurons.png']);