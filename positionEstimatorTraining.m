function [parameter_struct] = positionEstimatorTraining(training_data)
    % number of neurons = size(training_data(1,1).spikes, 1)
    % returned structure has one field for each neuron
    
    % number of trials = size(training_data , 1)
    % number of angles = size(training_data , 2)
    
    number_of_neurons = size(training_data(1,1).spikes, 1);
    number_of_trials = size(training_data , 1);
    number_of_angles = size(training_data , 2);
    
    parameter_struct = struct([]);
    
    temporary = zeros(number_of_neurons, number_of_trials, number_of_angles);
    
    % average firing rate for each trial, rows -> neurons, columns ->
    % trials, 3D -> reaching angle
    for j = 1:number_of_angles
        for k = 1:number_of_neurons
            for i = 1:number_of_trials            
                temporary(k,i,j) = nnz(training_data(i,j).spikes(k,:)) ...
                    /length(training_data(i,j).spikes(k,:));            
            end
            parameter_struct(k).firing_rate(j) = mean(temporary(k,:,j),2);
            [parameter_struct(k).max_rate,parameter_struct(k).angle_index] = ...
                max(parameter_struct(k).firing_rate);
        end
    end
    
    