% Tuning Curve ! 


close all;
load monkeydata_training.mat

axis=[1:59];

% plot of 1 neuron's firing rate for 100 different trials 
figure;    
subplot(2,1,1);
plot(axis,ans(1,1).firingRates, 'LineWidth', 0.5); 
title('Firing rate of 1 neuron unit'); 
% add mean and std as second plot
subplot(2,1,2); plot(axis, ans(1,1).averageFiringRate,'k','LineWidth', 2),
hold on;
plot(axis,ans(1,1).standardDeviation);
title('Average over 100 trials for 1 neuron and stand dev');
close all;

% average over timeee 
for neuron=1:98
    for angle=1:8
        for trial=1:100
            timeavg(neuron,trial) = mean(ans(neuron,angle).firingRates(trial,:));
        end
        angle_firingrate(neuron, angle) = mean(timeavg(neuron,:));
    end
   [value, prefDirection(neuron)] =(max(angle_firingrate(neuron,:)));
   %prefDirection gives value of 1-8 representing the pref. angle
    
end

angle_axis=[1:8];
figure;
plot(angle_axis, angle_firingrate);
title('Tuning curve for 1 neuron');
xlabel('different angles');ylabel('Firing rate, averaged across time and trials');








