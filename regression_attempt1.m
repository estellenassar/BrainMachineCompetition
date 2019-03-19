for ang=1:8
    for trl=1:100

    y=[velocity(trl,ang).xaxis, velocity(trl,ang).yaxis];
    x=[trainingData(trl,ang).firingRates];
        for neu=1:98
            x_single=x(neu,:);          % look at ind. firing rate per trial and neuron
            beta=lsqminnorm(x_single,y); % find weights

            test=x_single*beta; % find out predictive velocity
            store(neu,:)=test;  % store the predictive velocity for all neurons 
            save(neu,trl).beta=beta;
        end
    avg=mean(store);
    velx_pred=avg(1:length(y)/2);  % first half of vector is for X velocity
    vely_pred=avg(length(y)/2+1:length(y));  % second half of vector is Y vel. 
    
    output(trl,ang).beta=beta;      % save all beta weightings for each trial and angle
    output(trl,ang).velx=velx_pred;
    output(trl,ang).vely=vely_pred;
    output(trl,ang).velocity=avg;
    output(trl,ang).variance=std(store,[],1);
    output(trl,ang).rsq=1 - sum((y - test).^2)/sum((y - mean(y)).^2);
    store=[];
    end 
   
end