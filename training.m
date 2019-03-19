 load monkeydata_training.mat
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
vel_xarray = [];
vel_yarray = [];

dt = 10;

for trl=1:100 % neural unit
    for ang=1:8 % reaching angles
        for neu=1:98% trials
            for time=250:dt:smallest_vector(neu,ang)-3*dt
                % find the firing rates of one neural unit for one trial
                number_of_spikes = length(find(trial(trl,ang).spikes(neu,time:time+dt)==1));
                rate = [rate , number_of_spikes/dt];
                
                % find the velocity of the hand movement (needs calculating
                % just once) 
                if neu==1
                    x_low = trial(trl,ang).handPos(1,time);
                    x_high = trial(trl,ang).handPos(1,time+dt);

                    y_low = trial(trl,ang).handPos(2,time);
                    y_high = trial(trl,ang).handPos(2,time+dt);

                    vel_x = (x_high - x_low) / (dt*0.001);
                    vel_y = (y_high - y_low) / (dt*0.001);
                    vel_xarray = [vel_xarray, vel_x];
                    vel_yarray = [vel_yarray, vel_y];
                end
   
            end
            % store firing rate for each trial - this needs to be a struct
            % as vectors will be diff length
            firingRates=[firingRates ; rate];
            rate = [];
            
            %vel_xmatrix = [vel_xmatrix ; vel_xarray];
            %vel_ymatrix = [vel_ymatrix ; vel_yarray];
        end
        trainingData(trl,ang).firingRates = firingRates;
       	velocity(trl,ang).xaxis=vel_xarray;
        velocity(trl,ang).yaxis=vel_yarray;
        
        vel_xarray = [];
        vel_yarray = [];
        firingRates = [];
    end
end

% for trl=1:50
%     for ang=1:8
%         x=[ones(98,1), trainingData(trl,ang).firingRates];
%         y=[velocity(trl,ang).xaxis, velocity(trl,ang).yaxis];
%         %beta=pinv(x)*y;
%         %weights(trl,ang).beta=pinv(x)*y;
%         
%         beta(trl,ang).beta=lsqminnorm(x,y);
%     end
% end

