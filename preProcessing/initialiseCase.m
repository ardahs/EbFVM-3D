function InfoSim = initialiseCase(geometry, analysisType, toleranceError)
% *************************************************************************************************************************************************************
% Load a saved simulation case and initialise the requested analysis settings
% *************************************************************************************************************************************************************

%% Select MAT-file from geometry
    switch lower(strtrim(geometry))
        case 'herringbone'
            fileName = 'Herringbone.mat';
            geometryName = 'Herringbone Journal Bearing';

        case 'dimple'
            fileName = 'Dimple.mat';
            geometryName = 'Dimple Journal Bearing';

        case 'sawtooth'
            fileName = 'SawTooth.mat';
            geometryName = 'Sawtooth Journal Bearing';

        otherwise
            error('Unknown geometry. Choose: ''Herringbone'', ''Dimple'', or ''SawTooth''.');
    end

%% Display loading message
    fprintf('\n');
    fprintf('***************************************************  L O A D   S I M U L A T I O N  *************************************************\n');
    fprintf('* Geometry Type       : %s\n', geometryName);
    fprintf('* Analysis Type       : %s\n', analysisType);
    fprintf('* Source File         : %s\n', fileName);
    fprintf('* Status              : Loading simulation data...\n');
    fprintf('************************************************************************************************************************************\n');
    fprintf('\n');

%% Load InfoSim structure
    S = load(fileName, 'InfoSim');

    if ~isfield(S, 'InfoSim')
        error('The file %s does not contain the variable ''InfoSim''.', fileName);
    end

    InfoSim = S.InfoSim;

%% Plot selected mesh
    D2       = InfoSim.BSGridCFD.BSGridCFD_2D;
    coords2D = D2.nodes.coords;
    faces2D  = D2.elements.nodesConnec;

    M    = InfoSim.BSModels.modelBearing;
    R_mm = M.parametersBearing.bearingRadius * 1e3;
    W_mm = 0.5 * M.parametersBearing.bearingWidth * 1e3;
    XY   = [coords2D(:,1) * R_mm, coords2D(:,2) * W_mm];

    figure('Color','w', 'Units', 'normalized', 'Position', [0.1 0.3 0.3 0.3]);
    patch('Vertices', [XY, zeros(size(XY,1),1)], ...
          'Faces', faces2D, ...
          'FaceColor', 'none', ...
          'EdgeColor', 'k', ...
          'LineWidth', 0.5);

    view(0,90)
    axis equal tight
    box on

    title(sprintf('%s Mesh', geometryName), 'Interpreter', 'none', 'FontSize', 14)
    xlabel('$x$ (mm)', 'Interpreter', 'latex', 'FontSize', 14)
    ylabel('$y$ (mm)', 'Interpreter', 'latex', 'FontSize', 14)

    set(gca, 'TickDir', 'in', 'FontSize', 12)

    drawnow

%% Set analysis type
    switch lower(strtrim(analysisType))
        case 'thermal'
            InfoSim.solverType = 'Thermal';

        case 'isothermal'
            InfoSim.solverType = 'Isothermal';

        otherwise
            error('Unknown analysis type. Choose either ''Thermal'' or ''Isothermal''.');
    end

%% Set coupling tolerance
    InfoSim.BSModels.numericalOptions.solverCoupling.toleranceError = toleranceError;

%% Display successful loading message
    fprintf('\n');
    fprintf('************************************************  L O A D I N G   C O M P L E T E D  ************************************************\n');
    fprintf('* Geometry Type       : %s\n', geometryName);
    fprintf('* Analysis Type       : %s\n', InfoSim.solverType);
    fprintf('* Source File         : %s\n', fileName);
    fprintf('* Tolerance Error     : %.3e\n', InfoSim.BSModels.numericalOptions.solverCoupling.toleranceError);
    fprintf('* Status              : Simulation data loaded successfully.\n');
    fprintf('************************************************************************************************************************************\n');
    fprintf('\n');

end % *** END FUNCTION % **************************************************************************************************************************************