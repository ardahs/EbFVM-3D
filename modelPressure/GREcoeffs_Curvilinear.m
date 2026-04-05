function [BSGridCFD_2D, BSGridCFD_3D] = GREcoeffs_Curvilinear(BSModels, BSGridCFD_2D, BSGridCFD_3D)
% *************************************************************************************************************************************************************
% Calaculate GRE coefficients (Generalised Reynolds Equation) in curvilinear coordinates
% *************************************************************************************************************************************************************

%% Auxiliary variables
    coords_2D    = BSGridCFD_2D.nodes.coords;
    coords_3D    = BSGridCFD_3D.nodes.coords;
    neighbor_map = BSGridCFD_3D.nodes.neighbor_map;
    z            = coords_3D(:, 3);
    mu           = BSGridCFD_3D.nodes.mu  ./ BSModels.modelRheology.mu_0;
    rho          = BSGridCFD_3D.nodes.rho ./ BSModels.modelRheology.rho_0;
    mu_inv       = 1 ./ mu(:);
    z_mu         = z(:) ./ mu(:);

%% Pre-allocate variables
    num_nodes_2D = size(coords_2D, 1);
    num_nodes_3D = size(coords_3D, 1);
    J1_bar       = zeros(num_nodes_2D, 1);
    I1_bar       = zeros(num_nodes_2D, 1);
    R1_bar       = zeros(num_nodes_2D, 1);
    R2_bar       = zeros(num_nodes_2D, 1);
    R3_bar       = zeros(num_nodes_2D, 1);
    J_bar        = zeros(num_nodes_3D, 1);
    I_bar        = zeros(num_nodes_3D, 1);
    
%% J1_bar and I1_bar
    for node_2D = 1:num_nodes_2D

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
            idx = vertical_neighbors(sorted_idx);
            
            % Compute dz
            dz = z(idx(2)) - z(idx(1));
            
            % Compute cumulative sums for mu and z/mu for neighbors between the first and last
            mu_Crop_sum   = sum(mu_inv(idx(2:end-1)));
            z_mu_Crop_sum = sum(z_mu(idx(2:end-1)));                            
            
            % Calculate J1_bar and I1_bar
            J1_bar(node_2D) = 0.5 * dz * (mu_inv(idx(1)) + mu_inv(idx(end)) + 2 * mu_Crop_sum);
            I1_bar(node_2D) = 0.5 * dz * (z_mu(idx(1))   + z_mu(idx(end))   + 2 * z_mu_Crop_sum);
        end
    end

%% J_bar and I_bar
   for node_3D = 1:num_nodes_3D

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

           % Loop over the vertical neighbors, starting from the second node
           for k = 2:length(idx)

               % Compute dz between the current and previous vertical neighbor
               dz = z(idx(k)) - z(idx(k-1));

               % Get mu for the current and previous neighbors
               mu_inv_current  = 1 / mu(idx(k));
               mu_inv_previous = 1 / mu(idx(k-1));

               % Get z_mu for the current and previous neighbors
               z_mu_current  = z(idx(k)) / mu(idx(k));
               z_mu_previous = z(idx(k-1)) / mu(idx(k-1));

               % For k = 2, calculate the first J_bar and I_bar
               if k == 2
                   J_bar(idx(k)) = 0.5 * dz * (mu_inv_previous + mu_inv_current);
                   I_bar(idx(k)) = 0.5 * dz * (z_mu_previous   + z_mu_current);
               else

                   % Accumulate the sums for mu and z/mu
                   mu_sum   = mu_sum   + mu_inv_previous;
                   z_mu_sum = z_mu_sum + z_mu_previous;

                   % Compute J_bar and I_bar for k > 2 with cumulative sum
                   J_bar(idx(k)) = 0.5 * dz * (mu_inv(idx(1)) + mu_inv_current + 2 * mu_sum);
                   I_bar(idx(k)) = 0.5 * dz * (z_mu(idx(1))   + z_mu_current   + 2 * z_mu_sum);
               end
           end
       end
   end

%% R1_bar, R2_bar and R3_bar
   % Calculate modified rho-weighted J_bar and I_bar values
   rho_J_bar = rho(:) .* J_bar;
   rho_I_bar = rho(:) .* I_bar;

   % R1_bar, R2_bar and R3_bar computation (Optimized)
   for node_2D = 1:num_nodes_2D

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
       idx = vertical_neighbors(sorted_idx);

       % Ensure there are at least two vertical neighbors to compute dz
       if length(idx) >= 2

           % Compute dz as the difference between the first two z-coordinates
           dz = z(idx(2)) - z(idx(1));

           % Calculate R1_bar, R2_bar, and R3_bar
           R1_bar(node_2D) = 0.5 * dz * (rho_J_bar(idx(1)) + rho_J_bar(idx(end)) + 2 * sum(rho_J_bar(idx(2:end-1))));
           R2_bar(node_2D) = 0.5 * dz * (rho_I_bar(idx(1)) + rho_I_bar(idx(end)) + 2 * sum(rho_I_bar(idx(2:end-1))));
           R3_bar(node_2D) = 0.5 * dz * (rho(idx(1)) + rho(idx(end)) + 2 * sum(rho(idx(2:end-1))));
       end
   end

%% Update solutions
   BSGridCFD_3D.nodes.curvilinear.I_bar  = I_bar;
   BSGridCFD_3D.nodes.curvilinear.J_bar  = J_bar;
   BSGridCFD_2D.nodes.curvilinear.J1_bar = J1_bar;
   BSGridCFD_2D.nodes.curvilinear.I1_bar = I1_bar;
   BSGridCFD_2D.nodes.curvilinear.R1_bar = R1_bar;
   BSGridCFD_2D.nodes.curvilinear.R2_bar = R2_bar;
   BSGridCFD_2D.nodes.curvilinear.R3_bar = R3_bar;

end % *** END FUNCTION % **************************************************************************************************************************************           
