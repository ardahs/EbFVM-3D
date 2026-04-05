function [BSGridCFD_2D, BSGridCFD_3D] = GREcoeffs_Cartesian(BSModels, BSGridCFD_2D, BSGridCFD_3D)
% *************************************************************************************************************************************************************
% Calaculate GRE coefficients (Generalised Reynolds Equation) in cartesian coordinates
% *************************************************************************************************************************************************************

%% Auxiliary variables
    coords_2D    = BSGridCFD_2D.nodes.coords;
    coords_3D    = BSGridCFD_3D.nodes.coords;
    num_nodes_2D = size(coords_2D, 1);
    num_nodes_3D = size(coords_3D, 1);
    neighbor_map = BSGridCFD_3D.nodes.neighbor_map;
    z            = coords_3D(:, 3) ...
                  .* repmat(BSGridCFD_2D.nodes.H2H1, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1) ...
                  .* BSModels.modelBearing.parametersBearing.radialClearance;
    mu           = BSGridCFD_3D.nodes.mu;
    rho          = BSGridCFD_3D.nodes.rho;
    mu_inv       = 1 ./ mu(:);
    z_mu         = z(:) ./ mu(:);

%% Preallocate arrays
    J1 = zeros(num_nodes_2D, 1);
    I1 = zeros(num_nodes_2D, 1);
    R1 = zeros(num_nodes_2D, 1);
    R2 = zeros(num_nodes_2D, 1);
    R3 = zeros(num_nodes_2D, 1);
    J  = zeros(num_nodes_3D, 1);
    I  = zeros(num_nodes_3D, 1);
    
%% J1 and I1
    for node_2D = 1:num_nodes_2D  % Parallelize this loop if possible
        % Get x, y coordinates of the current 2D node
            x_2D = coords_2D(node_2D, 1);
            y_2D = coords_2D(node_2D, 2);
        
        % Create the key and find corresponding vertical neighbors in the 3D grid
            key = sprintf('%.10f_%.10f', round(x_2D, 10), round(y_2D, 10));
            if isKey(neighbor_map, key)
                vertical_neighbors = neighbor_map(key);
            else
                continue;
            end
        
        % Ensure there are at least two vertical neighbors (to calculate dz)
            if length(vertical_neighbors) >= 2
                % Sort vertical neighbors based on z-coordinate
                    [~, sorted_idx] = sort(z(vertical_neighbors));
                    idx             = vertical_neighbors(sorted_idx);
                
                % Compute dz
                    dz = z(idx(2)) - z(idx(1));
                
                % Compute cumulative sums for mu and z/mu for neighbors between the first and last
                    mu_Crop_sum   = sum(mu_inv(idx(2:end-1)));
                    z_mu_Crop_sum = sum(z_mu(idx(2:end-1)));                            
                
                % Calculate J1 and I1
                    J1(node_2D) = 0.5 * dz * (mu_inv(idx(1)) + mu_inv(idx(end)) + 2 * mu_Crop_sum);
                    I1(node_2D) = 0.5 * dz * (z_mu(idx(1))   + z_mu(idx(end))   + 2 * z_mu_Crop_sum);
            end
    end

%% J and I
   for node_3D = 1:num_nodes_3D  % Parallelize this loop
       % Get x, y coordinates of the current 3D node
           x_3D = coords_3D(node_3D, 1);
           y_3D = coords_3D(node_3D, 2);

       % Create the key and find corresponding vertical neighbors in the 3D grid
           key = sprintf('%.10f_%.10f', round(x_3D, 10), round(y_3D, 10));
           if isKey(neighbor_map, key)
               vertical_neighbors = neighbor_map(key);
           else
               continue;
           end

       % Sort the vertical neighbors by their z-coordinate
           [~, sorted_idx] = sort(z(vertical_neighbors));
           idx = vertical_neighbors(sorted_idx);

       % Ensure there are at least two vertical neighbors to compute dz
           if length(idx) >= 2
               % Initialize accumulators for cumulative sums
                   mu_sum = 0;
                   z_mu_sum = 0;
        
               % Loop over the vertical neighbors, starting from the second one
                   for k = 2:length(idx)
                       % Compute dz between the current and previous vertical neighbor
                           dz = z(idx(k)) - z(idx(k-1));
        
                       % Get mu for the current and previous neighbors
                           mu_inv_current  = 1 / mu(idx(k));
                           mu_inv_previous = 1 / mu(idx(k-1));
        
                       % Get z_mu for the current and previous neighbors
                           z_mu_current  = z(idx(k)) / mu(idx(k));
                           z_mu_previous = z(idx(k-1)) / mu(idx(k-1));
        
                       % For k = 2, calculate the first J and I
                           if k == 2
                               J(idx(k)) = 0.5 * dz * (mu_inv_previous + mu_inv_current);
                               I(idx(k)) = 0.5 * dz * (z_mu_previous   + z_mu_current);
                           else
            
                               % Accumulate the sums for mu and z/mu
                                   mu_sum   = mu_sum   + mu_inv_previous;
                                   z_mu_sum = z_mu_sum + z_mu_previous;
            
                               % Compute J and I for k > 2 with cumulative sum
                                   J(idx(k)) = 0.5 * dz * (mu_inv(idx(1)) + mu_inv_current + 2 * mu_sum);
                                   I(idx(k)) = 0.5 * dz * (z_mu(idx(1))   + z_mu_current   + 2 * z_mu_sum);
                           end
                   end
           end
   end

%% R1, R2 and R3
   % Calculate modified rho-weighted J and I values
       rho_J = rho(:) .* J;
       rho_I = rho(:) .* I;

   % R1, R2 and R3 computation (Optimized)
       for node_2D = 1:num_nodes_2D  % Parallelize this loop
           % Get x, y coordinates of the current 2D node
               x_2D = coords_2D(node_2D, 1);
               y_2D = coords_2D(node_2D, 2);

           % Create the key and find corresponding vertical neighbors in the 3D grid
               key = sprintf('%.10f_%.10f', round(x_2D, 10), round(y_2D, 10));
               if isKey(neighbor_map, key)
                   vertical_neighbors = neighbor_map(key);
               else
                   continue;
               end

           % Sort the vertical neighbors by their z-coordinate
               [~, sorted_idx] = sort(z(vertical_neighbors));
               idx             = vertical_neighbors(sorted_idx);

           % Ensure there are at least two vertical neighbors to compute dz
               if length(idx) >= 2
                   % Compute dz as the difference between the first two z-coordinates
                       dz = z(idx(2)) - z(idx(1));

                   % Calculate R1, R2, and R3
                       R1(node_2D) = 0.5 * dz * (rho_J(idx(1)) + rho_J(idx(end)) + 2 * sum(rho_J(idx(2:end-1))));
                       R2(node_2D) = 0.5 * dz * (rho_I(idx(1)) + rho_I(idx(end)) + 2 * sum(rho_I(idx(2:end-1))));
                       R3(node_2D) = 0.5 * dz * (rho(idx(1)) + rho(idx(end)) + 2 * sum(rho(idx(2:end-1))));
               end
       end

%% Update coefficients
   BSGridCFD_3D.nodes.cartesian.I  = I;
   BSGridCFD_3D.nodes.cartesian.J  = J;
   BSGridCFD_2D.nodes.cartesian.J1 = J1;
   BSGridCFD_2D.nodes.cartesian.I1 = I1;
   BSGridCFD_2D.nodes.cartesian.R1 = R1;
   BSGridCFD_2D.nodes.cartesian.R2 = R2;
   BSGridCFD_2D.nodes.cartesian.R3 = R3;

end % *** END FUNCTION % **************************************************************************************************************************************           
