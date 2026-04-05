function [BSGridCFD_3D] = updateRheology(BSModels, BSGridCFD_2D, BSGridCFD_3D, property)
% *************************************************************************************************************************************************************
% Update pressure- and temperature- dependent fluid rheology
% *************************************************************************************************************************************************************

%% Define lubricatnt property
    switch property

        % Viscosity
        case 'viscosity'
            % Houpert
                mu_0                  = BSModels.modelRheology.mu_0;
                T_inlet               = BSModels.modelThermal.T_supply;
                T                     = BSGridCFD_3D.nodes.T_fluid;
                p                     = repmat(BSGridCFD_2D.nodes.pHydro, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1).*(BSModels.modelBearing.dimensionless.df_p);
                Z                     = 0.689;
                beta                  = 0.0476;
                S0                    = beta .* ((T_inlet + 273 - 138) ./ (log(mu_0) + 9.67));
                A                     = (log(mu_0) + 9.67);
                B                     = (1 + (5.1E-9).*p).^Z;
                C                     = ((T + 273 - 138)./(T_inlet + 273 - 138)).^(-S0);
                BSGridCFD_3D.nodes.mu = mu_0 .* exp(A .* (-1 + B .* C));
            % Cavitation
                BSGridCFD_3D.nodes.mu  = BSGridCFD_3D.nodes.mu .* repmat(BSGridCFD_2D.nodes.thetaHydro, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1);

        % Density
        case 'density'   
            % Dowson and Higginson
                rho_0                  = BSModels.modelRheology.rho_0;
                T_inlet                = BSModels.modelThermal.T_supply;
                T                      = BSGridCFD_3D.nodes.T_fluid;
                p                      = repmat(BSGridCFD_2D.nodes.pHydro, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1).*(BSModels.modelBearing.dimensionless.df_p);
                epsilon                = 6.5E-4;
                BSGridCFD_3D.nodes.rho = rho_0.*(1 + (0.6*(p./1E9)./(1 + (1.7.*p./1E9))))...
                                        .*(1 - (epsilon.*((T + 273) - (T_inlet + 273))));
            
        otherwise
            error('Unkown lubricant property')
    end

end % *************************************************************************************************************************************************************
