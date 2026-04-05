function [gridCFDNodes_3D] = EnergyFluid(gridCFDNodes_2D, gridCFDNodes_3D, BSModels, Nz, BSGridCFD_3D)
% *************************************************************************************************************************************************************
% Calculate diffusive and convective transport matrices of the thermal energy equation
% *************************************************************************************************************************************************************

%% Initialise pre-computation
    numNodes            = size(gridCFDNodes_3D.coords, 1);
    H2H1_grad           = zeros(numNodes, 3);
    gridCFDNodes_3D.sD  = zeros(3, 3, numNodes);
    gridCFDNodes_3D.sC  = zeros(numNodes, 3);
    gridCFDNodes_3D.sTS = zeros(numNodes, 1);
    gridCFDNodes_3D.sNS = zeros(numNodes, 1);
    gridCFDNodes_3D.sT  = zeros(numNodes, 1);

%% Auxiliary variables
    H2H1           = repmat(gridCFDNodes_2D.H2H1, Nz, 1);
    V              = gridCFDNodes_3D.contravariantVelocity;
    Gamma          = gridCFDNodes_3D.curvilinearShearRate;
    k              = gridCFDNodes_3D.k./BSModels.modelRheology.k_0;
    rho            = gridCFDNodes_3D.rho./BSModels.modelRheology.rho_0;
    cp             = gridCFDNodes_3D.cp./BSModels.modelRheology.cp_0;
    mu             = gridCFDNodes_3D.mu./BSModels.modelRheology.mu_0;
    H2H1_grad(:,1) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GX*H2H1));
    H2H1_grad(:,2) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GY*H2H1));

%% Bearing parameters
    pB       = BSModels.modelBearing.parametersBearing;
    speeds   = BSModels.modelSpeeds;
    rheology = BSModels.modelRheology;
    thermal  = BSModels.modelThermal;
    rLXZ     = pB.bearingRadius/(pB.bearingWidth / 2);
    epsilon  = pB.radialClearance/pB.bearingRadius;
    Br       = rheology.mu_0*(speeds.Uent^2)/rheology.k_0/thermal.T_supply;
    Pe       = rheology.rho_0*rheology.cp_0*speeds.Uent*pB.bearingRadius*(epsilon^2)/rheology.k_0;

%% Construct diffusive matrix
    gridCFDNodes_3D.sD(1, 1, :) = k.*(epsilon.^2).*H2H1;
    gridCFDNodes_3D.sD(2, 2, :) = k.*(epsilon.^2).*H2H1.*(rLXZ.^2);
    gridCFDNodes_3D.sD(3, 3, :) = (k./H2H1) .* (1 + (epsilon.^2).*(gridCFDNodes_3D.coords(:, 3).^2) .* ((H2H1_grad(:,1).^2) + ((rLXZ .* H2H1_grad(:,2)).^2)));
    
%% Construct convective matrix
    % Transport Couette terms
        sC_diag    = Pe.*rho.*cp;
        sC_offdiag = zeros(size(sC_diag));
    % Construct the convective transport matrix
        gridCFDNodes_3D.sC = [V(:, 1).*sC_diag     +  V(:, 2).*sC_offdiag  +  V(:, 3).*sC_offdiag, ...
                              V(:, 1).*sC_offdiag  +  V(:, 2).*sC_diag     +  V(:, 3).*sC_offdiag, ...
                              V(:, 1).*sC_offdiag  +  V(:, 2).*sC_offdiag  +  V(:, 3).*sC_diag];

%% Calculate translated squeeze term
    gridCFDNodes_3D.sTS = zeros(numNodes, 1);

%% Calculate normal squeeze term
    gridCFDNodes_3D.sNS = zeros(numNodes, 1);

%% Calculate source term
    gridCFDNodes_3D.sT = -(Br.*mu./(H2H1.^3)).*((Gamma(:, 1)).^2 + (Gamma(:, 2)./rLXZ).^2);   

end % *** END FUNCTION % **************************************************************************************************************************************