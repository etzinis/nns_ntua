close all; clear all; clc; 

%% GroupData

global IW distances

run GroupData.m
dataset = GroupPatterns(1:2,:);

maximum = max(dataset, [], 2);
minimum = min(dataset, [], 2);

epochs = 25;
epochs_multiplier = 4;

neuron_configs = [ 5  1
                   10 1
                   20 1
                   5  5
                   10 5
                   10 10 ];
for i = 1:size(neuron_configs,1)
    neurons = neuron_configs(i,:);
    somCreate([minimum(1:2) maximum(1:2)], neurons, 'hexagonaltopology', 'dist');
    somTrainParameters(0.9, epochs, 0.1);
    %somShow(IW, neurons);
    somTrain(dataset, epochs_multiplier, 1)
    %somShow(IW, neurons);
    figure; 
    plot2DSomData(IW, distances, dataset);
    saveas(gcf, ['images\13_output_' int2str(neurons(1)) '_' int2str(neurons(2))  '_neurons.png']);
    eval1_13(i) = somEvaluate(dataset)
end

%% Distance and grid exerimenting

topology_configs = {'gridtop'
                    'hextop'
                    'randtop'
                    'hexagonaltopology'};

distance_configs = {'boxdist'
                    'dist'
                    'linkdist'
                    'mandist'
                    'ring_distance'};
neurons = [5 5];

for i = 1:length(topology_configs)
    for j = 1:length(distance_configs)
        somCreate([minimum(1:2) maximum(1:2)], neurons, topology_configs{i}, distance_configs{j});
        somTrainParameters(0.9, epochs, 0.1);
        %somShow(IW, neurons);
        somTrain(dataset, epochs_multiplier, 1)
        %somShow(IW, neurons);
        figure; 
        plot2DSomData(IW, distances, dataset);
        %saveas(gcf, ['images\13_output_' int2str(neurons(1)) '_' int2str(neurons(2))  '_neurons.png']);
        eval2_13(i,j) = somEvaluate(dataset)
    end
end


%% Boundaries
close all;

decision_boundaries = [-0.35, -0.25];
%decision_boundaries = [-0.4, -0.2];

true_groups(1) = length(find(GroupPatterns(3,:) == 0));
true_groups(2) = length(find(GroupPatterns(3,:) == 1))

% Train
neuron_configs = [10 1
                  20 1
                  5  5
                  10 5
                  5  10
                  10 10];
for i= 1:6
    neurons = neuron_configs(i,:);
    somCreate([minimum(1:2) maximum(1:2)], neurons, 'hexagonaltopology', 'dist');
    somTrainParameters(0.9, epochs, 0.1);
    somTrain(dataset, epochs_multiplier, 1)
    figure;
    somShow(IW, neurons);
    saveas(gcf, ['images\13_umatrix_' int2str(neurons(1)) '_' int2str(neurons(2))  '_neurons.png']);
    figure; 
    plot2DSomData(IW, distances, dataset);
    saveas(gcf, ['images\13_output_' int2str(neurons(1)) '_' int2str(neurons(2))  '_neurons.png']);
    evalboundaries = somEvaluate(dataset)

    estimated_groups(1) = length(find(IW(:,1) >= decision_boundaries(2)));
    estimated_groups(2) = length(find(IW(:,1) <= decision_boundaries(1)))

    estimated_analogy(i) = estimated_groups(1)/estimated_groups(2)
end

%%

topology_configs = {'gridtop'
                    'hexagonaltopology'};

distance_configs = {'boxdist'
                    'dist'
                    'mandist'};
neuron_configs = [5  5
           10 10
           20 1];

for i = 1:length(topology_configs)
    for j = 1:length(distance_configs)
        for k = 1:size(neuron_configs,1)
            neurons = neuron_configs(k,:);
            somCreate([minimum(1:2) maximum(1:2)], neurons, topology_configs{i}, distance_configs{j});
            somTrainParameters(0.9, epochs, 0.1);
            somTrain(dataset, epochs_multiplier, 1)
            figure; somShow(IW, neurons);
            saveas(gcf, ['images\13_umatrix_' int2str(neurons(1)) '_' int2str(neurons(2))  '_' topology_configs{i} '_' distance_configs{j} '_neurons.png']);
            figure; 
            plot2DSomData(IW, distances, dataset);
            saveas(gcf, ['images\13_output_' int2str(neurons(1)) '_' int2str(neurons(2))  '_' topology_configs{i} '_' distance_configs{j} '_neurons.png']);
            
            eval_boundaries_13(i,j,k) = somEvaluate(dataset)
            estimated_groups(1) = length(find(IW(:,1) >= decision_boundaries(2)));
            estimated_groups(2) = length(find(IW(:,1) <= decision_boundaries(1)))
            estimated_analogy2(i,j,k) = estimated_groups(1)/estimated_groups(2)
        end
    end
end


true_analogy = true_groups(1)/true_groups(2)
