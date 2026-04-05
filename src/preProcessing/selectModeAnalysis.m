function [InfoSim] = selectModeAnalysis(InfoSim)
% *************************************************************************************************************************************************************
% Initialise main lubrication solvers (Isothermal / Thermal)
% *************************************************************************************************************************************************************

%% Auxiliary variables
    BSModels     = InfoSim.BSModels;
    BSGridCFD_2D = InfoSim.BSGridCFD.BSGridCFD_2D;
    BSGridCFD_3D = InfoSim.BSGridCFD.BSGridCFD_3D;
    
%% Main solver
    switch InfoSim.solverType
        case 'Isothermal'
            epsilon  = 1e-30;
            numIter  = 0;
            maxError = BSModels.numericalOptions.solverCoupling.toleranceError + 10;
            while (maxError > BSModels.numericalOptions.solverCoupling.toleranceError) ...
                    && (numIter < BSModels.numericalOptions.solverCoupling.maximumIterations)
                % Auxiliary variables
                    numIter      = numIter + 1;
                    pHydroOLD    = BSGridCFD_2D.nodes.pHydro(:);
                    muOLD        = BSGridCFD_3D.nodes.mu(:);
                    rhoOLD       = BSGridCFD_3D.nodes.rho(:);
                % Update integral coefficients
                    [BSGridCFD_2D, BSGridCFD_3D] = GREcoeffs_Curvilinear(BSModels, BSGridCFD_2D, BSGridCFD_3D);
                % Hydrodynamic solver
                    [BSModels, BSGridCFD_2D, BSGridCFD_3D] = staticJBR(BSModels, BSGridCFD_2D, BSGridCFD_3D);
                % Update density
                    BSGridCFD_3D = updateRheology(BSModels, BSGridCFD_2D, BSGridCFD_3D, 'density');
                % Update viscosity
                    BSGridCFD_3D = updateRheology(BSModels, BSGridCFD_2D, BSGridCFD_3D, 'viscosity');
                % Update solutions
                    pHydro = BSGridCFD_2D.nodes.pHydro(:);
                    mu     = BSGridCFD_3D.nodes.mu(:);
                    rho    = BSGridCFD_3D.nodes.rho(:);
                % Compute error
                    Error_pHydro = ((norm(pHydro-pHydroOLD))*((norm(pHydro))/((norm(pHydro)+epsilon)^2)));
                    Error_mu     = ((norm(mu-muOLD))*((norm(mu))/((norm(mu)+epsilon)^2)));
                    Error_rho    = ((norm(rho-rhoOLD))*((norm(rho))/((norm(rho)+epsilon)^2)));
                    maxError     = Error_pHydro + Error_mu + Error_rho;
                % Update initial displacement
                    BSModels.numericalOptions.solverStatic.Xr0 = BSModels.numericalOptions.solverStatic.Xr;
                    BSModels.numericalOptions.solverStatic.Yr0 = BSModels.numericalOptions.solverStatic.Yr;
                    BSModels.numericalOptions.solverStatic.Ar0 = BSModels.numericalOptions.solverStatic.Ar;
                    BSModels.numericalOptions.solverStatic.Br0 = BSModels.numericalOptions.solverStatic.Br;
                % Display results
                    fprintf('Iteration \t\t Norm of Error \n');
                    fprintf('   %-d\t\t          %-4.3e \n', numIter, maxError);
                    fprintf('\n');
            end

        case 'Thermal'
            epsilon  = 1e-30;
            numIter  = 0;
            maxError = BSModels.numericalOptions.solverCoupling.toleranceError + 10;
            while (maxError > BSModels.numericalOptions.solverCoupling.toleranceError) ...
                    && (numIter < BSModels.numericalOptions.solverCoupling.maximumIterations)
                % Auxiliary variables
                    numIter      = numIter + 1;
                    pHydroOLD    = BSGridCFD_2D.nodes.pHydro(:);
                    tempHydroOLD = BSGridCFD_3D.nodes.T_fluid(:);
                    muOLD        = BSGridCFD_3D.nodes.mu(:);
                    rhoOLD       = BSGridCFD_3D.nodes.rho(:);
                % Update integral coefficients
                    [BSGridCFD_2D, BSGridCFD_3D] = GREcoeffs_Curvilinear(BSModels, BSGridCFD_2D, BSGridCFD_3D);
                % Hydrodynamic solver
                    [BSModels, BSGridCFD_2D, BSGridCFD_3D] = staticJBR(BSModels, BSGridCFD_2D, BSGridCFD_3D);
                % Start display
                    fprintf('--------------------------------------------------------------------- \n');
                    fprintf('   Thermal Solver \n' );
                    fprintf('--------------------------------------------------------------------- \n');
                % Update density
                    BSGridCFD_3D = updateRheology(BSModels, BSGridCFD_2D, BSGridCFD_3D, 'density');
                % Update viscosity
                    BSGridCFD_3D = updateRheology(BSModels, BSGridCFD_2D, BSGridCFD_3D, 'viscosity');
                % Thermal solver
                    [BSGridCFD_2D, BSGridCFD_3D] = Energy_EbFVM(BSModels, BSGridCFD_2D, BSGridCFD_3D);
                % Update solutions
                    pHydro    = BSGridCFD_2D.nodes.pHydro(:);
                    tempHydro = BSGridCFD_3D.nodes.T_fluid(:);
                    mu        = BSGridCFD_3D.nodes.mu(:);
                    rho       = BSGridCFD_3D.nodes.rho(:);
                % Compute error
                    Error_pHydro    = ((norm(pHydro-pHydroOLD))*((norm(pHydro))/((norm(pHydro)+epsilon)^2)));
                    Error_tempHydro = ((norm(tempHydro-tempHydroOLD))*((norm(tempHydro))/((norm(tempHydro)+epsilon)^2)));
                    Error_mu        = ((norm(mu-muOLD))*((norm(mu))/((norm(mu)+epsilon)^2)));
                    Error_rho       = ((norm(rho-rhoOLD))*((norm(rho))/((norm(rho)+epsilon)^2)));
                    maxError        = Error_pHydro + Error_tempHydro + Error_mu + Error_rho;
                % Update initial displacement
                    BSModels.numericalOptions.solverStatic.Xr0 = BSModels.numericalOptions.solverStatic.Xr;
                    BSModels.numericalOptions.solverStatic.Yr0 = BSModels.numericalOptions.solverStatic.Yr;
                    BSModels.numericalOptions.solverStatic.Ar0 = BSModels.numericalOptions.solverStatic.Ar;
                    BSModels.numericalOptions.solverStatic.Br0 = BSModels.numericalOptions.solverStatic.Br;
                % Display results
                    fprintf('Iteration \t\t Max temp \t\t Norm of THL \n');
                    fprintf('   %-d\t\t\t %-6.3f\t\t  %-4.3e \n', numIter, max(tempHydro), maxError);
                    fprintf('\n');
            end

        otherwise
            error('Unkown analysis type')
    end

%% Update solutions
    InfoSim.BSModels               = BSModels;
    InfoSim.BSGridCFD.BSGridCFD_2D = BSGridCFD_2D;
    InfoSim.BSGridCFD.BSGridCFD_3D = BSGridCFD_3D;

end % *** END FUNCTION % **************************************************************************************************************************************    