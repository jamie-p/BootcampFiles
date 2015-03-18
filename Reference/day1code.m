%% Interactive prototyping.

load S02_MedData




%% Basic data exploration.

x = MedData.Age;

y = MedData.BPDiff; % Pulse pressure

figure

scatter(x, y, 'kx')

xlabel('Age (years)')

ylabel('Pulse pressure (mmHg)')

title('Pulse pressure vs. age')




%% Task: aim to fit a model to this data set.

% Preprocess to deal with missing values.

missingVals = isnan(x) | isnan(y);

xClean = x(~missingVals);

yClean = y(~missingVals);

% Formulate the model and write it in MATLAB code.

% We can write this as 

% pulsePressure = [1, Age, Age^2] * [C0; C1; C2]

b = yClean;

A = [ones(size(xClean)), xClean, xClean.^2];

% Alternative to ONES: xClean.^0 

modelCoeffs = A\b; % Solve the system.

% Get the fitted curve:

pulseModel = A * modelCoeffs;

% Plot:

hold on

plot(xClean, pulseModel, 'r*')

legend('Raw Data', 'Fitted Model')




%% Move to two dimensions.

height = MedData.Height; % x1

waist = MedData.Waist;   % x2

weight = MedData.Weight; % y

% Problem: can we estimate weight (y) using height and waist (x1 and x2)?

% We'll use a quadratic model.




%% Exercise before the break.

% Step 1: Plot the raw data (SCATTER3).

figure

scatter3(height, waist, weight, 'kx')




% Step 2: Clean the data (ISNAN).

badRows = any(isnan([height, waist, weight]), 2);

x1Clean = height(~badRows);

x2Clean = waist(~badRows);

yClean = weight(~badRows);




% Step 3: Formulate and solve the model.

b = yClean;

A = [ones(size(x1Clean)), x1Clean, x1Clean.^2, x2Clean, x2Clean.^2, x1Clean.*x2Clean];

modelCoeffs = A\b;




% Step 4: Visualisation.

modelFun = @(c, x1, x2) c(1) + c(2)*x1 + c(3)*x1.^2 + c(4)*x2 + c(5)*x2.^2 + c(6)*x1.*x2;




% Substep 1: make vector data for x1 and x2.

x1Vec = linspace(min(x1Clean), max(x1Clean), 150);

x2Vec = linspace(min(x2Clean), max(x2Clean), 150);

% Substep 2: turn this into a grid.

[X1, X2] = meshgrid(x1Vec, x2Vec);

% Substep 3: evaluate the model on the grid.

modelOnGrid = modelFun(modelCoeffs, X1, X2);




hold on

surf(X1, X2, modelOnGrid, 'EdgeAlpha', 0)

% EdgeAlpha - transparency of the edges in the grid.
