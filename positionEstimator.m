function [x, y] = positionEstimator(test_data, model)

% modelParameters is currently the model

x = predict(model.x, test_data, K); % what is k?
y = predict(model.y, test_data, K);

end