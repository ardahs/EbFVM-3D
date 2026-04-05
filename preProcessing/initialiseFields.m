function BSGridCFD_3D = initialiseFields(BSGridCFD_2D, BSGridCFD_3D, BSModels)
% *************************************************************************************************************************************************************
% Initialise parameter fields
% *************************************************************************************************************************************************************

%% Auxiliary variables
    numNodes_2D = size(BSGridCFD_2D.nodes.coords,1);
    numNodes_3D = numNodes_2D * BSGridCFD_3D.ExtrusionNodes.ZNodesFluid;

%% Initialise three-dimensional fields
    % Lubricant rheology
        BSGridCFD_3D.nodes.mu  = ones(numNodes_3D,1,1) .* BSModels.modelRheology.mu_0;  
        BSGridCFD_3D.nodes.rho = ones(numNodes_3D,1,1) .* BSModels.modelRheology.rho_0;
        BSGridCFD_3D.nodes.k   = ones(numNodes_3D,1,1) .* BSModels.modelRheology.k_0;
        BSGridCFD_3D.nodes.cp  = ones(numNodes_3D,1,1) .* BSModels.modelRheology.cp_0;
    % Thermal properties
        BSGridCFD_3D.nodes.T_fluid = ones(numNodes_3D,1,1) .* BSModels.modelThermal.T_supply;

end % *** END FUNCTION % **************************************************************************************************************************************    