function [velocity, beta] = positionEstimatorTraining(trial)

%% Get trials to the same length

vector_size = zeros(100,1);
smallest_vector = zeros(98,8);

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

trainingData = struct([]);
velocity = struct([]);

dt = 10;

for trl = 1:100 % neural unit
    for ang = 1:8 % reaching angles
        for neu = 1:98 % trials
            for time = 1:dt:smallest_vector(neu,ang)-3*dt
                
                % find the firing rates of one neural unit for one trial
                number_of_spikes = length(find(trial(trl,ang).spikes(neu,time:time+dt)==1));
                rate = cat(2, rate, number_of_spikes/dt);
                
                % find the velocity of the hand movement (needs calculating
                % just once) 
                if neu==1
                    x_low = trial(trl,ang).handPos(1,time);
                    x_high = trial(trl,ang).handPos(1,time+dt);

                    y_low = trial(trl,ang).handPos(2,time);
                    y_high = trial(trl,ang).handPos(2,time+dt);

                    vel_x = (x_high - x_low) / (dt*0.001);
                    vel_y = (y_high - y_low) / (dt*0.001);
                    vel_xarray = cat(2, vel_xarray, vel_x);
                    vel_yarray = cat(2, vel_yarray, vel_y);
                end
   
            end
            
            % store firing rate for each trial
            firingRates = cat(1, firingRates, rate);
            rate = [];
            
        end
        
        trainingData(trl,ang).firingRates = firingRates;
       	velocity(trl,ang).xaxis = vel_xarray;
        velocity(trl,ang).yaxis = vel_yarray;
        
        vel_xarray = [];
        vel_yarray = [];
        firingRates = [];
        
    end
end

%% Regression model
% Take in data to calculate weights
beta = struct([]);
ang = 1;
for trl = 1:50
        
    y = [velocity(trl,ang).xaxis; velocity(trl,ang).yaxis];
    x = [trainingData(trl,ang).firingRates];
        for neu = 1:98
            x_single = [1 x(neu,:)];          % look at ind. firing rate per trial and neuron
            b_1 = lsqminnorm(x_single,y(1,:));    % find weights
            b_2 = lsqminnorm(x_single,y(2,:));
            
            %predX=x_single*b_1;    % check beta values are working
            %predY=x_single*b_2;
            
            %velX(neu,:)=predX;  % store the predictive velocity for all neurons 
            %velY(neu,:)=predY; 
           
            beta(trl,neu).X = b_1;
            beta(trl,neu).Y = b_2;
            beta_1 = [];
            beta_2 = [];
        end
        
%     output(trl).beta=beta;      % save all beta weightings for each trial and angle
%     output(trl).velx=velx_pred;
%     output(trl).vely=vely_pred;
%     output(trl).rsq= 1 - sum((y - test).^2)/sum((y - mean(y)).^2);

end 

%average of beta across 50 trials 

% % input the remaining trials and find out velocity
% for t = 51:100
%     y = [velocity(t,ang).xaxis; velocity(t,ang).yaxis];
%     x = [trainingData(t,ang).firingRates];
%         for neu = 1:98
%             x_single = [1 x(neu,:)];
%             predX(neu,:) = x_single*b_1;  % each neuron weighted by b1
%             predY(neu,:) = x_single*b_2;  % each neuron weighted by b2 for Yvel.
%             % probs need to make b_1 and b_2 an average rather than just one
%             % realisation
%         end
%      velX(t-50,:) = predX;
%      velY(t-50,:) = predY;
%     
%      % next step is to just take in 300 ms and predict along the way
%    
% end

end