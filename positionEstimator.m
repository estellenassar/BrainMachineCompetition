function [x, y] = positionEstimator(test_data, model_parameters)



current_firing_rate = zeros(1,98);
start_time = size(test_data.spikes, 2) - 20;
end_time = size(test_data.spikes, 2);

for i = 1:98
    current_firing_rate(1,i) = nnz(test_data.spikes(i,start_time:end_time));    
end

% Population vector

%representing direction as a 8D vector and getting weighting for each
%direction
direction_vector = zeros(1,8);
for i = 1:98
    direction_vector(1, model_parameters(i).angle_index) ... % updating pref angle index
    = (current_firing_rate(1,i)/model_parameters(i).max_rate) + direction_vector(1,model_parameters(i).angle_index);
end

% pick maximum value of direction vector
[~, index] = max(direction_vector);

% reaching angles
angles = [30, 70, 110, 150, 190, 230, 310, 350];
angles = angles*pi/180;

% assuming a constant step of 0.0647.
if (size(test_data.decodedHandPos, 1) > 0)
    x = cos(angles(index))*5 + test_data.decodedHandPos(1,end);
    y = sin(angles(index))*5 + test_data.decodedHandPos(2, end);
else 
    x = cos(angles(index))*6;
    y = sin(angles(index))*6;
end

end