function [max_rate,preferred_direction, reaching_angles] = pref_dir(trial)

reaching_angles = [30/180*pi, 70/180*pi, 110/180*pi, 150/180*pi, 190/180*pi,...
    230/180*pi, 310/180*pi, 350/180*pi];

firing_rate = zeros(1,100);
mean_firing_rate = zeros(98,8);

for neu=1:98 % neural unit
    for ang=1:8 % reaching angles
        for trl=1:100 % trials
            % find the firing rate of one neural unit for one trial
            number_of_spikes = length(find(trial(trl,ang).spikes(neu,:)==1));
            firing_rate(trl) = number_of_spikes/length(trial(trl,ang).spikes(neu,:));
        end
    % find the mean firing rate of one neural unit over all 100 trials
    meanFiringRate(neu,ang) = mean(firing_rate);
    end  
end

[max_rate, preferred_direction] = max(meanFiringRate,[],2);


%figure
%plot(reaching_angles,meanFiringRate(50,:))
%xlabel('Reaching angles (rad)')
%ylabel('Average firing rate (ms^-^1)')
%title('Tuning curve for all neuron units')
%xlim([30/180*pi, 350/180*pi])
%xticks(reaching_angles)
%xticklabels({'30/180\pi', '70/180\pi', '110/180\pi', '150/180\pi', '190/180\pi',...
%    '230/180\pi', '310/180\pi', '350/180\pi'})

end