function [InfoSim] = main()
% *************************************************************************************************************************************************************
%   MAIN:  Run a 3D EbFVM simulation case
%
%   This function loads a predefined geometry, initialises the selected
%   analysis type, precomputes auxiliary fields, solves the problem, and
%   post-processes the results.
%
%   Settings are defined locally in this script through:
%       geometry, analysisType, and toleranceError
%
%   Output:
%       InfoSim - simulation structure containing model data and results
%
%   Suhaib Ardah
% *************************************************************************************************************************************************************

clc;

%% Define simulation
    geometry       = 'Dimple';          % {'Dimple' ; 'Herringbone' ; 'SawTooth'}
    analysisType   = 'Isothermal';      % {'Isothermal' ; 'Thermal'}
    toleranceError = 1E0;

%% Add folders to the path
    addpath(genpath('../EbFVM-3D'))

%% Load simulation case
    InfoSim = initialiseCase(geometry, analysisType, toleranceError);

%% Start simulation
    ticSimulation = tic;
    fprintf(' \n');
    fprintf('***************************************************  R U N   S I M U L A T I O N  **************************************************\n');
    fprintf('* Geometry Type       : %s\n', geometry);
    fprintf('* Analysis Type       : %s\n', analysisType);
    fprintf('************************************************************************************************************************************\n');
    fprintf(' \n');

%% Precompute paramters
    InfoSim = PrecomputeFields(InfoSim);

%% Initialise analysis
    InfoSim = selectModeAnalysis(InfoSim);

%% Plot results
    PostProcessing(InfoSim);

%% End simulation
    tElapsed = toc(ticSimulation);
    fprintf('     END SIMULATION  -  Time elapsed: %s s \n', num2str(tElapsed));
    fprintf('******************************************************************************* \n');
    diary off

end % *** END FUNCTION % **************************************************************************************************************************************       
