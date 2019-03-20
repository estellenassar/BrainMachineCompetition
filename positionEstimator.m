function [x, y] = positionEstimator(test_data, beta)

% modelParameters is currently the weights beta, could be something else

% classifies using the four nearest neighbors
x = fitcknn(test_data, beta.X, 'NumNeighbors',4);
y = fitcknn(test_data, beta.Y, 'NumNeighbors',4);

% need to break down test_data into different trials or different neurons?
% need to go over how the test function works

end