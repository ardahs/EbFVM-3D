function [gridCFDNodes] = GRE_lubricantTransport(BSModels, gridCFDNodes)
% *************************************************************************************************************************************************************
% Construct the diffusive and convective transport matrices
% *************************************************************************************************************************************************************

%% Auxiliary variables
    V1       = zeros(size(gridCFDNodes.coords, 1), 2);
    V2       = zeros(size(gridCFDNodes.coords, 1), 2);
    U_JR_bar = BSModels.modelSpeeds.Uj / BSModels.modelSpeeds.Uent;
    V_JR_bar = BSModels.modelSpeeds.Vj / BSModels.modelSpeeds.Uent;
    U_BR_bar = BSModels.modelSpeeds.Ub / BSModels.modelSpeeds.Uent;
    V_BR_bar = BSModels.modelSpeeds.Vb / BSModels.modelSpeeds.Uent;
    V1(:,1)  = U_BR_bar;
    V1(:,2)  = V_BR_bar;
    V2(:,1)  = U_JR_bar;
    V2(:,2)  = V_JR_bar;
    Ue       = (V2(:,1) + V1(:,1)) ./ 2;
    Ve       = (V2(:,2) + V1(:,2)) ./ 2;
    
%% Bearing parameters
    rLXZ  = BSModels.modelBearing.parametersBearing.bearingRadius / (BSModels.modelBearing.parametersBearing.bearingWidth / 2);

%% Construct diffusive matrix (transport Poiseuille term)
    epsilon                = (gridCFDNodes.curvilinear.I1_bar .* gridCFDNodes.curvilinear.R1_bar ./ gridCFDNodes.curvilinear.J1_bar) - gridCFDNodes.curvilinear.R2_bar;
    gridCFDNodes.sD(1,1,:) =             ((gridCFDNodes.H2H1.^3) .* epsilon);
    gridCFDNodes.sD(2,2,:) = (rLXZ^2) .* ((gridCFDNodes.H2H1.^3) .* epsilon);
    
%% Construct convective matrix (transport Couette term)
    rho_e_STAR = 2 .* gridCFDNodes.curvilinear.R1_bar ./ gridCFDNodes.curvilinear.J1_bar;
    rho_1_STAR = gridCFDNodes.curvilinear.R3_bar - rho_e_STAR;
    
    sC11  = (gridCFDNodes.H2H1) .* ((rho_e_STAR) + (rho_1_STAR .* V2(:,1) ./ Ue));
    sC12  = 0;
    sC22  = (rLXZ) .* (gridCFDNodes.H2H1) .* ((rho_e_STAR) + (rho_1_STAR .* V2(:,2) ./ Ve));    
    sC21  = 0;
    V     = ((V2 + V1) / 2);

    sCr11 = 0;
    sCr12 = 0;
    sCr22 = 0;
    sCr21 = 0;
    Vr    = ((V2 - V1) / 2);

    sC22(isnan(sC22)) = 0;

    gridCFDNodes.sC = ([(V(:,1).*sC11 + V(:,2).*sC21)     , (V(:,1).*sC12 + V(:,2).*sC22)] + ....
                       [(Vr(:,1).*sCr11 + Vr(:,2).*sCr21) , (Vr(:,1).*sCr12 + Vr(:,2).*sCr22)]);

%% Calculate translated squeeze term
    gridCFDNodes.sTS = zeros(size(gridCFDNodes.coords, 1), 1);

%% Calculate normal squeeze term
    gridCFDNodes.sNS = zeros(size(gridCFDNodes.coords, 1), 1);

%% Calculate temporal term
    gridCFDNodes.sT = zeros(size(gridCFDNodes.coords, 1), 1);
    
end % *** END FUNCTION % **************************************************************************************************************************************    
