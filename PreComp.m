clear all

load('monkeydata_training.mat')


%% Question 1
for t=1:100
    for a=1:8
        trial(t,a).spikes(trial(t,a).spikes==0) = NaN;
    end
end

figure(1)
hold on
for i=1:98
    AP = i*trial(1,1).spikes(i,:);
    plot(AP, '*')
end
hold off
xlabel('Time (ms)')
ylabel('Neuron unit')
title('Population raster plot for trial 1')


%% Question 2
trials_angle1 = trial(:,1); % trials for one reaching angle

figure(2)
hold on
for i=1:100
    neuron_trials(i).spikes = trials_angle1(i).spikes(1,:);
    AP = i*neuron_trials(i).spikes;
    plot(AP, '*')
end
hold off
xlabel('Time (ms)')
ylabel('Trial number')
title('Raster plot of one cell over many trials')


%% Question 3 - for one neural unit

delta_t = 10;
k = 100; % number of trials

% need to get them all to the same length:
smallest_vector = length(neuron_trials(1).spikes);
for i=2:100
    next_vector = length(neuron_trials(i).spikes);
    if next_vector < smallest_vector
        smallest_vector = next_vector;
    end
end

for i=1:100
    % resize all spikes vectors
    neuron_trials(i).spikes = neuron_trials(i).spikes(1:smallest_vector);
end

% compute number of occurences of spikes summed over all trials:
n_total = 0;
for j=1:delta_t:smallest_vector-delta_t
    % add up over all trials first, then move on to next time step
    for i=1:100
        n_i = length(find(neuron_trials(i).spikes(j:j+delta_t)==1));
        n_total = n_total + n_i;
    end
    n(j:j+delta_t) = n_total;
    n_total = 0;
end

spike_density = (1/delta_t)*(n/k);

figure(3)
plot(spike_density)
xlabel('Time (ms)')
ylabel('Spike density')
title('Peri-stimulus time histogram for one neural unit over 100 trials at one reaching angle')


%% Question 4

figure(4)
hold on
for i=1:100
    neuron_trials(i).handPos = trials_angle1(i).handPos;
    hand_pos = neuron_trials(i).handPos;
    plot3(hand_pos(1,:),hand_pos(2,:), hand_pos(3,:))
end
hold off
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
title('Hand position for different trials')


%% Question 5 - tuning curve for ONE neuron
% I think the 'movement direction' is the reaching angles, but not sure
% how would you plot firing rate over hand position anyway

reaching_angles = [30/180*pi, 70/180*pi, 110/180*pi, 150/180*pi, 190/180*pi,...
    230/180*pi, 310/180*pi, 350/180*pi];

for n=1:8
    for i=1:100
        % add spikes over all trials
        n_i = length(find(trial(i,n).spikes(1,:)==1));
        n_total = n_total + n_i;
    end
    total_spikes(n) = n_total;
    n_total = 0;
end

% to get average rate per second:
firing_rate = total_spikes/100/(smallest_vector/1000);

figure(5)
plot(reaching_angles,firing_rate)
xlabel('Reaching angles (rad)')
ylabel('Average firing rate (s^-^1)')
title('Tuning curve for one neuronal unit')

