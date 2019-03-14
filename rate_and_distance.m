clear

load('monkeydata_training.mat')
% only need preferred direction indices
[~,pref_dir, ~] = pref_dir(trial);

%% Get trials to the same length
for neu=1:98
    for trl=1:100
        vector_size(trl) = length(trial(trl,pref_dir(neu)).spikes(neu,:));
    end
    smallest_vector(neu) = min(vector_size);   
end


%% Find firing rates
dt = 10;
rate = [];
dist = [];
firingRates = [];
distances = [];

for neu=1:98 % neural unit
    for trl=1:100 % trials
        for time=1:dt:smallest_vector(neu)-dt
            % find the firing rates of one neural unit for one trial
            number_of_spikes = length(find(trial(trl,pref_dir(neu)).spikes(neu,time:time+dt)==1));
            rate = [rate , number_of_spikes/dt];
            
            % find distance hand travelled from time to time+dt
             xy = sqrt((trial(trl,pref_dir(neu)).handPos(1,time+dt)-trial(trl,pref_dir(neu)).handPos(1,time))^2 ...
                + (trial(trl,pref_dir(neu)).handPos(2,time+dt)-trial(trl,pref_dir(neu)).handPos(2,time))^2);
            dist=[dist , xy];
        end
        % store firing rate for each trial
        firingRates=[firingRates ; rate];
        rate = [];
        
        % store distances for each trial
        distances=[distances ; dist];
        dist = [];
    end
    % input firing rate into struct
    firingRateData(neu).firingRates = firingRates;
    firingRates = [];
    
    % input average of firing rate into struct
    average_rate = mean(firingRateData(neu).firingRates);
    firingRateData(neu).averageFiringRate = average_rate;
    
    % input distances into struct
    firingRateData(neu).distances = distances;
    distances = [];
    
    % input average of distances into struct
    average_dist = mean(firingRateData(neu).distances);
    firingRateData(neu).averageDistances = average_dist;
    
end
