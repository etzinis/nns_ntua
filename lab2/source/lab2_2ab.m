%% Lab 2
close all; clear all; clc;

%% EightData.m
run EightData.m

%% Group Data
run QuestionData.m

%% Experimenting
[eval1_question, eval2_question] = test_neurons_configs(QuestionPatterns, 'Question')
[eval1_8, eval2_8] = test_neurons_configs(EightPatterns, '8')

%% TSP

run Cities.m
maximum = max(CityCoordinates, [], 2);
minimum = min(CityCoordinates, [], 2);

global IW distances;
neuron_configs = [ 5   1
                   10  1
                   20  1
                   50  1
                   100 1
                   200 1 ];
epochs = 20;
epochs_multiplier = 2;
epochs = 40;
epochs_multiplier = 4;
epochs = 100;
epochs_multiplier = 5;
for i = 1:size(neuron_configs,1)
    neurons = neuron_configs(i,:);
    somCreate([0 1; 0 1;], neurons, 'hexagonaltopology', 'ring_distances');
    somTrainParameters(0.9, epochs, 0.1);
    somTrain(CityCoordinates, epochs_multiplier, 1)
    figure; 
    plot2DSomData(IW, distances, CityCoordinates);
    saveas(gcf, ['images\even_more_cities_output_' int2str(neurons(1)) '_' int2str(neurons(2))  '_neurons.png']);
    eval_cities(i) = somEvaluate(CityCoordinates)
end


