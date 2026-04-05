function [BSGridCFD_3D] = updateCartesianFlow(BSGridCFD_2D, BSGridCFD_3D, BSModels)
% *************************************************************************************************************************************************************
% Update local kinematic of the lubricant film in cartesian grid
% *************************************************************************************************************************************************************

%% Auxiliary variables
    pB     = BSModels.modelBearing.parametersBearing;
    H2H1   = repmat(BSGridCFD_2D.nodes.H2H1, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1);
    pHydro = repmat(BSGridCFD_2D.nodes.pHydro, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1);
    Uj     = BSModels.modelSpeeds.Uj;
    Vj     = BSModels.modelSpeeds.Vj;
    Us     = BSModels.modelSpeeds.Us; 
    Vs     = BSModels.modelSpeeds.Vs;

%% Convert from dimensionless to dimensional
    coords = BSGridCFD_3D.nodes.coords .* ...
            [pB.bearingRadius * ones(size(BSGridCFD_3D.nodes.coords, 1), 1), ...
            0.5 * pB.bearingWidth * ones(size(BSGridCFD_3D.nodes.coords, 1), 1), ...
            H2H1 .* pB.radialClearance];

%% Calculate gradient of hydrodynamic pressure
    pHydro_grad(:,1) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GX*pHydro)).*(BSModels.modelBearing.dimensionless.df_p/pB.bearingRadius);
    pHydro_grad(:,2) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GY*pHydro)).*(BSModels.modelBearing.dimensionless.df_p/(pB.bearingWidth/2));

%% Calculate integral terms
    [BSGridCFD_2D, BSGridCFD_3D] = GREcoeffs_Cartesian(BSModels, BSGridCFD_2D, BSGridCFD_3D);
    J  = BSGridCFD_3D.nodes.cartesian.J;
    I  = BSGridCFD_3D.nodes.cartesian.I;
    I1 = repmat(BSGridCFD_2D.nodes.cartesian.I1, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1);
    J1 = repmat(BSGridCFD_2D.nodes.cartesian.J1, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1);

%% Calculate local lubricant flow in the Cartesian system
    % Along the x direction
        BSGridCFD_3D.nodes.cartesianVelocity(:, 1) = Uj + (pHydro_grad(:,1) .* (I - (J .* I1 ./ J1))) + (Us .* J ./ J1);
    % Along the y direction
        BSGridCFD_3D.nodes.cartesianVelocity(:, 2) = Vj + (pHydro_grad(:,2) .* (I - (J .* I1 ./ J1))) + (Vs .* J ./ J1);
    % Along the z direction
        BSGridCFD_3D.nodes.cartesianVelocity(:, 3) = cartesianZVelocity(BSModels, BSGridCFD_2D, BSGridCFD_3D);

%% Calculate local shear rate in the Cartesian system
    % Along the x direction
        BSGridCFD_3D.nodes.cartesianShearRate(:, 1) = (pHydro_grad(:,1).*(coords(:, 3) - (I1./J1)) + (Us./J1))./BSGridCFD_3D.nodes.mu;
    % Along the y direction
        BSGridCFD_3D.nodes.cartesianShearRate(:, 2) = (pHydro_grad(:,2).*(coords(:, 3) - (I1./J1)) + (Vs./J1))./BSGridCFD_3D.nodes.mu;

end % *** END FUNCTION % **************************************************************************************************************************************


function [w] = cartesianZVelocity(BSModels, BSGridCFD_2D, BSGridCFD_3D)
% *************************************************************************************************************************************************************
% Update local kinematic of the lubricant film in cartesian grid based on continuity equation (z-axis)
% *************************************************************************************************************************************************************

%% Auxiliary variables
    coords_3D    = BSGridCFD_3D.nodes.coords;
    rhoU         = BSGridCFD_3D.nodes.rho .* BSGridCFD_3D.nodes.cartesianVelocity(:, 1);
    rhoV         = BSGridCFD_3D.nodes.rho .* BSGridCFD_3D.nodes.cartesianVelocity(:, 2);
    num_nodes_3D = size(coords_3D, 1);
    neighbor_map = BSGridCFD_3D.nodes.neighbor_map;
    z            = coords_3D(:, 3) ...
                  .* repmat(BSGridCFD_2D.nodes.H2H1, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1) ...
                  .* BSModels.modelBearing.parametersBearing.radialClearance;

%% Preallocate arrays
    rhoU_grad = zeros(num_nodes_3D, 3);
    rhoV_grad = zeros(num_nodes_3D, 3);
    w         = zeros(num_nodes_3D, 1);

%% Calculate intermediate variables
    % Compute gradients
        rhoU_grad(:,1) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GX*rhoU))./(BSModels.modelBearing.parametersBearing.bearingRadius);
        rhoV_grad(:,2) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GY*rhoV))./((BSModels.modelBearing.parametersBearing.bearingWidth/2));
    % Calculate dwdz
        dwdz = - rhoU_grad(:,1) - rhoV_grad(:,2);

%% Calculate vertical lubricant velocity (w)
    for node_3D = 1:num_nodes_3D
        % Get x, y coordinates of the current 3D node
            x_3D = coords_3D(node_3D, 1);
            y_3D = coords_3D(node_3D, 2);

        % Create the key and find corresponding vertical neighbors in the 3D grid
            key = sprintf('%.10f_%.10f', round(x_3D, 10), round(y_3D, 10));
            if ~isKey(neighbor_map, key)
                continue;
            end
            vertical_neighbors = neighbor_map(key);

        % Sort the vertical neighbors by their z-coordinate
            [~, sorted_idx] = sort(z(vertical_neighbors));
            idx             = vertical_neighbors(sorted_idx);

        % Ensure there are at least two vertical neighbors to compute dz
            if length(idx) >= 2
                % Initialize accumulators for cumulative sums
                    dwdz_sum = 0;
    
                % Loop over the vertical neighbors
                    for k = 2:length(idx)
                        dz = z(idx(k)) - z(idx(k-1));
                        dwdz_current  = dwdz(idx(k));
                        dwdz_previous = dwdz(idx(k-1));
        
                        % Calculate the velocity using cumulative sums
                            if k == 2
                                w(idx(k)) = 0.5 * dz * (dwdz_previous + dwdz_current);
                            else
                                dwdz_sum = dwdz_sum + dwdz_previous;
                                w(idx(k)) = 0.5 * dz * (dwdz(idx(1)) + dwdz_current + 2 * dwdz_sum);
                            end
                    end
            end
    end

%% Extract velocity and exclude density
    w = w ./ BSGridCFD_3D.nodes.rho;

end % *** END FUNCTION % **************************************************************************************************************************************