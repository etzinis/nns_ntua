function [ eval1, eval2 ] = test_neurons_configs( dataset , name)
   %% Neurons Experimenting
    maximum = max(dataset, [], 2);
    minimum = min(dataset, [], 2);

    epochs = 25;
    epochs_multiplier = 4;
    
    global IW distances;

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
        saveas(gcf, ['images\' name '_output_' int2str(neurons(1)) '_' int2str(neurons(2))  '_neurons_hexagonal_dist.png']);
        eval1(i) = somEvaluate(dataset)
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
            somTrain(dataset, epochs_multiplier, 1)
            figure; 
            plot2DSomData(IW, distances, dataset);
            saveas(gcf, ['images\' name '_output_5_5_neurons_' topology_configs{i} '_' distance_configs{j} '.png']);
            eval2(i,j) = somEvaluate(dataset)
        end
    end
 
end

