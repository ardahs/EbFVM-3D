function [BSGridCFD_2D, BSGridCFD_3D] = lubricantFilmThickness(BSGridCFD_2D, BSGridCFD_3D, BSModels)
% *************************************************************************************************************************************************************
% Update the lubricant film thickness due to misalignment of journal bearing
% *************************************************************************************************************************************************************

%% Auxiliar variables
    alfab      = BSModels.modelBearing.calculationInputs.alfab;
    dp_Hlim    = BSModels.modelBearing.dimensionless.dp_Hlim;
    coords2D   = BSGridCFD_2D.nodes.coords;
    numNodes2D = size(coords2D, 1);

%% Calculate local geometry of the lubricant film
    BSGridCFD_2D.nodes.hHydro =  (1 + ...
                                 (-BSModels.numericalOptions.solverStatic.Yr + BSModels.numericalOptions.solverStatic.Ar * coords2D(:,2)) .* cos(coords2D(:,1) + alfab) + ...
                                 ( BSModels.numericalOptions.solverStatic.Xr + BSModels.numericalOptions.solverStatic.Br * coords2D(:,2)) .* sin(coords2D(:,1) + alfab));
    BSGridCFD_2D.nodes.H1     = -( BSGridCFD_2D.nodes.deltaG1 + BSGridCFD_2D.nodes.deltaR1);
    BSGridCFD_2D.nodes.H2     =    BSGridCFD_2D.nodes.hHydro - (BSGridCFD_2D.nodes.deltaG2 + BSGridCFD_2D.nodes.deltaR2);
    BSGridCFD_2D.nodes.H2H1   =  ( BSGridCFD_2D.nodes.H2 - BSGridCFD_2D.nodes.H1 );

%% Check film thickness limit 
    BSGridCFD_2D.nodes.H2H1(BSGridCFD_2D.nodes.H2H1 < dp_Hlim) = dp_Hlim;

%% Extrude film thickness slong the z-axis
    zLevelsMatrix  = linspace(0, 1, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid)';
    zDimensionless = round((zLevelsMatrix * BSGridCFD_2D.nodes.H2H1(:)') ./ BSGridCFD_2D.nodes.H2H1(:)', 6); % Round to 6 decimals

%% Preallocate 3D coordinates for the extruded nodes
    BSGridCFD_3D.nodes.coords = zeros(numNodes2D * BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 3);

%% Fill the Nodes3D array by extruding along z using varying h values
    for k = 1:BSGridCFD_3D.ExtrusionNodes.ZNodesFluid
        BSGridCFD_3D.nodes.coords((k-1)*numNodes2D+1:k*numNodes2D, :) = [coords2D, zDimensionless(k, :)'];
    end

end % *** END FUNCTION % **************************************************************************************************************************************