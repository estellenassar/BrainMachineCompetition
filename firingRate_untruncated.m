clear
close all

load('monkeydata_training.mat')

dt = 10;
rate = [];
% t=1:floor(length(trial(1,1).spikes(1,:))/dt)

for neu=1:98 % neural unit
    for ang=1:8 % reaching angles
        for trl=1:100 % trials
           
            for time=1:10:length(trial(trl,ang).spikes(1,:))-10
                % find the firing rates of one neural unit for one trial
                number_of_spikes = length(find(trial(trl,ang).spikes(1,time:time+dt)==1));
                rate = [rate , number_of_spikes/dt];
            end
            % store firing rate for each trial -  this needs to be a struct
            % as vectors will be diff length
            trials(trl).firingRate=rate;
            rate = [];
        end
        firingRateData(neu,ang).trials = trials;
    end
end       
        
%plot(firingRateData(1,1).trials(1).firingRate)