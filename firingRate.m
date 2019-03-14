function [firingRateData] = firingRate(trial, dt)

%% Get trials to the same length
for neu=1:98
    for ang=1:8
        for t=1:100
            for trl=1:100
                vector_size(trl) = length(trial(trl,ang).spikes(neu,:));
            end
            smallest_vector(neu,ang) = min(vector_size);
        end
    end
end


%% Find firing rates

rate = [];
firingRates = [];

for neu=1:98 % neural unit
    for ang=1:8 % reaching angles
        for trl=1:100 % trials
            
            for time=1:dt:smallest_vector(neu,ang)-dt
                % find the firing rates of one neural unit for one trial
                number_of_spikes = length(find(trial(trl,ang).spikes(neu,time:time+dt)==1));
                rate = [rate , number_of_spikes/dt];
            end
            % store firing rate for each trial - this needs to be a struct
            % as vectors will be diff length
            firingRates=[firingRates ; rate];
            rate = [];
        end
        firingRateData(neu,ang).firingRates = firingRates;
        firingRates = [];
    end
end


%% Find average and standard deviation

for neu=1:98
    for ang=1:8
        average = mean(firingRateData(neu,ang).firingRates);
        standard_dev = std(firingRateData(neu,ang).firingRates);
        
        firingRateData(neu,ang).averageFiringRate = average;
        firingRateData(neu,ang).standardDeviation = standard_dev;
    end
end


end
