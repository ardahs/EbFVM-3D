function [BSGridCFD_2D] = Organise_JFO_EbFVM_cfdCoeffs(BSModels, BSGridCFD_2D)
% *************************************************************************************************************************************************************
% Calculate and assembly coefficients matrices for the solution of the
% generalised Reynolds equation with JFO cavitation model using the
% Element-based Finite Volume
% *************************************************************************************************************************************************************

%% Auxiliary variables
    df_p    = BSModels.modelBearing.dimensionless.df_p_GRE;

%% Initialise coefficient matrices
    Ap     = 0*BSGridCFD_2D.calcMatrices.cfdCoeffs.Ap;
    Atheta = 0*BSGridCFD_2D.calcMatrices.cfdCoeffs.Atheta;
    B      = 0*BSGridCFD_2D.calcMatrices.cfdCoeffs.B;

%% Extract transport and source terms at the element nodes
    % Diffusive (Poiseuille) terms at the element nodes
        sD  = BSGridCFD_2D.nodes.sD(:,:,:);
    % Convective (Couette) terms at the element nodes
        sC  = BSGridCFD_2D.nodes.sC(:,:,:);
    % Translated squeeze terms at the element nodes
        sTS = BSGridCFD_2D.nodes.sTS(:,:,:);
    % Normal squeeze terms at the element nodes
        sNS = BSGridCFD_2D.nodes.sNS(:,:,:);
    % Temporal terms at the element nodes
        sT  = BSGridCFD_2D.nodes.sT(:,:,:);
    % Film fraction at the element nodes
        thetaHydroPrev = BSGridCFD_2D.nodes.thetaHydroPrev(:,:,:);
    
%% Extract transport and source properties at elements
    % Element nodes connectivity
        nodesConnec = BSGridCFD_2D.elements.nodesConnec;
    % Diffusive (Poiseuille) properties
        BD = BSGridCFD_2D.elements.BD;
    % Convective (Couette) properties
        BC = BSGridCFD_2D.elements.BC;
    % Source properties
        BS = BSGridCFD_2D.elements.BS;
    % Pointers to CFD matrices
        pointers2CFDMatrix = BSGridCFD_2D.elements.pointers2CFDMatrix;
        
%% Calculate coefficient matrices (loop over 2D grid elements)
    [Ap, Atheta, B] = JFO_EbFVM_cfdCoeffs_Calc(Ap, Atheta, B, nodesConnec, BD, BC, BS, pointers2CFDMatrix, sD, sC, sTS, sNS, sT, thetaHydroPrev);
    
%% Impose boundary conditions
    Ap_BC     = Ap;
    Atheta_BC = Atheta;
    B_BC      = B;
    
    % Fixed pressure boundary condition
        for iPartBC = 1 : BSGridCFD_2D.BCs.fixedPressure.numParts
            for iNodeBC = 1 : BSGridCFD_2D.BCs.fixedPressure.parts(iPartBC,1).numNodesBC
                nodeID  = BSGridCFD_2D.BCs.fixedPressure.parts(iPartBC,1).nodesID(iNodeBC,1);
                bcValue = BSGridCFD_2D.BCs.fixedPressure.parts(iPartBC,1).bcValues(:,:,iNodeBC);

                Ap_BC(nonzeros(bcValue(3,:)))       = 0;
                Ap_BC(nodeID)                       = 1;
                BSGridCFD_2D.nodes.pHydro(nodeID,1) = (bcValue(2,1)/df_p);

                Atheta_BC(nonzeros(bcValue(3,:)))       = 0;
                Atheta_BC(nodeID)                       = 1;
                BSGridCFD_2D.nodes.thetaHydro(nodeID,1) = 1;

                B_BC(nodeID) = (bcValue(2,1)/df_p) - 1;
            end
        end

    % Periodic flow boundary condition
        for iPartBC = 1 : BSGridCFD_2D.BCs.periodicFlow.numParts
            for iNodeBC = 1 : BSGridCFD_2D.BCs.periodicFlow.parts(iPartBC,1).numNodesBC
                nodeID  = BSGridCFD_2D.BCs.periodicFlow.parts(iPartBC,1).nodesID(iNodeBC,1);
                bcValue = BSGridCFD_2D.BCs.periodicFlow.parts(iPartBC,1).bcValues(:,:,iNodeBC);

                Ap_BC(nonzeros(bcValue(5,:)))     = Ap(nonzeros(bcValue(5,:)))     + Ap(nonzeros(bcValue(4,:)));
                Atheta_BC(nonzeros(bcValue(5,:))) = Atheta(nonzeros(bcValue(5,:))) + Atheta(nonzeros(bcValue(4,:)));
                B_BC(nodeID)                      = B(nodeID) + B(bcValue(4,1));
            end
        end

%% Update sparse matrices
    BSGridCFD_2D.calcMatrices.cfdCoeffs.Ap        = Ap;
    BSGridCFD_2D.calcMatrices.cfdCoeffs.Ap_BC     = Ap_BC;
    BSGridCFD_2D.calcMatrices.cfdCoeffs.Atheta    = Atheta;
    BSGridCFD_2D.calcMatrices.cfdCoeffs.Atheta_BC = Atheta_BC;
    BSGridCFD_2D.calcMatrices.cfdCoeffs.B         = B;
    BSGridCFD_2D.calcMatrices.cfdCoeffs.B_BC      = B_BC;

end % *** END FUNCTION % **************************************************************************************************************************************
