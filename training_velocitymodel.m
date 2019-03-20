 load monkeydata_training.mat
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
ang=1;
for trl=1:50        %  get beta values from initial 50 trials (training data )
        
    y=[velocity(trl,ang).xaxis(:,1:30);velocity(trl,ang).yaxis(1:30)];
    x=[trainingData(trl,ang).firingRates(:,1:30)];
        for neu=1:98
            x_single=[1 x(neu,:)];          % look at ind. firing rate per trial and neuron
            b_1=lsqminnorm(x_single,y(1,:));    % find weights
            b_2=lsqminnorm(x_single,y(2,:));
            
            %predX=x_single*b_1;    % check beta values are working
            %predY=x_single*b_2;
            
            %velX(neu,:)=predX;  % store the predictive velocity for all neurons 
            %velY(neu,:)=predY; 
           
            beta(trl,neu).X=b_1;
            beta(trl,neu).Y=b_2;
 
        end
        
%     output(trl).beta=beta;      % save all beta weightings for each trial and angle
%     output(trl).velx=velX;
%     output(trl).vely=velY;
%     output(trl).rsq= 1 - sum((y - test).^2)/sum((y - mean(y)).^2);

end 

%average of beta across 50 trials 
%% Prediction with previous beta
% input the remaining trials and find out velocity
ang=1;
for t=51:100
    y=[velocity(t,ang).xaxis(1:30);velocity(t,ang).yaxis(1:30)];
    x=[trainingData(t,ang).firingRates(:,1:30)];
        for neu=1:98
            x_single=[1 x(neu,:)];
            
            b_1=beta(t-50,neu).X;
            b_2=beta(t-50,neu).Y;
            
            predX(neu,:)=x_single*b_1;  % each neuron weighted by b1
            predY(neu,:)=x_single*b_2;  % each neuron weighted by b2 for Yvel.
            % probs need to make b_1 and b_2 an average rather than just one
            % realisation
 
        end
     predX_avg=mean(predX,1);
     predY_avg=mean(predY,1);
     velX(t-50,:)=predX_avg;
     velY(t-50,:)=predY_avg;
     velX_avg=mean(velX,1);
     velY_avg=mean(velY,1);
     
     subplot(2,1,1);plot([1:30],velX_avg);
     subplot(2,1,2);plot([1:30],y(1,:));
        
     % next step is to just take in 300 ms and predict along the way  
end


% given the next 20 ms, predict the velocity ahead
for neu=1:98
    x_ahead=[1 trainingData(1,ang).firingRates(neu,30:32)];
    
    b_1=beta(t-50,neu).X([1:4],[1:3]);
    b_2=beta(t-50,neu).Y([1:4],[1:3]);
    pred2x(neu,:)=x_ahead*b_1;  % each neuron weighted by b1
    pred2y(neu,:)=x_ahead*b_2;  % each neuron weighted by b2 for Yvel.
     
end
