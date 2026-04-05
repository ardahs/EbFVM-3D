function [BSGridCFD_3D] = updateCurvilinearFlow(BSGridCFD_2D, BSGridCFD_3D, BSModels)
% *************************************************************************************************************************************************************
% Update local kinematic of the lubricant film in curvilinear grid
% *************************************************************************************************************************************************************

%% Auxiliary variables
    coords  = BSGridCFD_3D.nodes.coords;
    pB      = BSModels.modelBearing.parametersBearing;
    speeds  = BSModels.modelSpeeds;
    H2H1    = repmat(BSGridCFD_2D.nodes.H2H1, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1);
    SRRx    = speeds.Us / speeds.Uent;
    SRRy    = speeds.Vs / (speeds.Vent + eps);
    epsilon = pB.radialClearance / pB.bearingRadius;
    rLXZ    = pB.bearingRadius / (pB.bearingWidth / 2);
    pHydro  = (repmat(BSGridCFD_2D.nodes.pHydro, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1) ...
              .* BSModels.modelBearing.dimensionless.df_p) ./ BSModels.modelBearing.dimensionless.df_p_GRE;

%% Calculate gradients
    % Pressure gradients
        pHydro_grad(:,1) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GX*pHydro));
        pHydro_grad(:,2) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GY*pHydro));
    % Thickness gradients
        H2H1_grad(:,1) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GX*H2H1));
        H2H1_grad(:,2) = (BSGridCFD_3D.calcMatrices.grad.MM\(BSGridCFD_3D.calcMatrices.grad.GY*H2H1));
        
%% Calculate integral terms
    [BSGridCFD_2D, BSGridCFD_3D] = GREcoeffs_Curvilinear(BSModels, BSGridCFD_2D, BSGridCFD_3D);
    J_bar  = BSGridCFD_3D.nodes.curvilinear.J_bar;
    I_bar  = BSGridCFD_3D.nodes.curvilinear.I_bar;
    I1_bar = repmat(BSGridCFD_2D.nodes.curvilinear.I1_bar, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1);
    J1_bar = repmat(BSGridCFD_2D.nodes.curvilinear.J1_bar, BSGridCFD_3D.ExtrusionNodes.ZNodesFluid, 1);
    ISbar  = J_bar ./ J1_bar;
    IPbar  = ((H2H1.*H2H1.*I_bar)) - (((H2H1.*H2H1.*I1_bar)).*J_bar./J1_bar);

%% Curvilinear velocity
    % X-direction
        BSGridCFD_3D.nodes.curvilinearVelocity(:, 1) = (speeds.Uj/speeds.Uent) + (pHydro_grad(:,1).*IPbar) + (SRRx.*ISbar);
    % Y-direction
        BSGridCFD_3D.nodes.curvilinearVelocity(:, 2) = (speeds.Vj/(speeds.Vent + eps)) + (pHydro_grad(:,2).*IPbar) + (SRRy.*ISbar);
    % Z-direction
        BSGridCFD_3D.nodes.curvilinearVelocity(:, 3) = BSGridCFD_3D.nodes.cartesianVelocity(:, 3)./epsilon./speeds.Uent;

%% Contravariant flow
    % X-direction
        BSGridCFD_3D.nodes.contravariantVelocity(:, 1) = BSGridCFD_3D.nodes.curvilinearVelocity(:, 1).*H2H1;
    % Y-direction
        BSGridCFD_3D.nodes.contravariantVelocity(:, 2) = BSGridCFD_3D.nodes.curvilinearVelocity(:, 2).*H2H1.*rLXZ;
    % Z-direction
        BSGridCFD_3D.nodes.contravariantVelocity(:, 3) = BSGridCFD_3D.nodes.curvilinearVelocity(:, 3) ...
                                                       - ((H2H1_grad(:,1).*BSGridCFD_3D.nodes.curvilinearVelocity(:, 1)) ...
                                                       + (rLXZ.*H2H1_grad(:,2).*BSGridCFD_3D.nodes.curvilinearVelocity(:, 2))).*coords(:, 3);

%% Curvilinear shear rate
    scaling = epsilon.*pB.bearingRadius.*H2H1.*H2H1./speeds.Uent;
    % X-direction
        BSGridCFD_3D.nodes.curvilinearShearRate(:, 1) = BSGridCFD_3D.nodes.cartesianShearRate(:, 1) .* scaling;
    % Y-direction
        BSGridCFD_3D.nodes.curvilinearShearRate(:, 2) = BSGridCFD_3D.nodes.cartesianShearRate(:, 2) .* scaling .* rLXZ;

end % *** END FUNCTION % **************************************************************************************************************************************