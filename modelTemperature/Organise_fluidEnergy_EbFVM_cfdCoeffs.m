function [BSGridCFD_3D] = Organise_fluidEnergy_EbFVM_cfdCoeffs(BSGridCFD_3D, BSModels)
% *************************************************************************************************************************************************************
% Calculate and assembly coefficients matrices for the solution of the
% three-dimensional energy equation using the Element-based Finite Volume
% *************************************************************************************************************************************************************

%% Auxilary variables
    df_T = BSModels.modelThermal.T_supply;

%% Initialise coefficient matrices
    At = 0*BSGridCFD_3D.calcMatrices.cfdCoeffs.At;
    B  = 0*BSGridCFD_3D.calcMatrices.cfdCoeffs.B;

%% Extract transport and source terms at the element nodes
    % Diffusive (conduction) terms at the element nodes
        sD  = BSGridCFD_3D.nodes.sD(:,:,:);
    % Convective (convection) terms at the element nodes
        sC  = BSGridCFD_3D.nodes.sC(:,:,:);
    % Normal squeeze terms at the element nodes
        sNS = BSGridCFD_3D.nodes.sNS(:,:,:);
    % Temporal terms at the element nodes
        sT  = BSGridCFD_3D.nodes.sT(:,:,:);
    
%% Extract transport and source properties at elements
    % Element nodes connectivity
        nodesConnec = BSGridCFD_3D.volumes.nodesConnec;
    % Diffusive properties
        BD = BSGridCFD_3D.elements.BD;
    % Convective properties
        BC = BSGridCFD_3D.elements.BC;
    % Source properties
        BS = BSGridCFD_3D.elements.BS;
    % Pointers to CFD matrices
        pointers2CFDMatrix = BSGridCFD_3D.volumes.pointers2CFDMatrix;
        
%% Calculate coefficient matrices (loop over 3D grid elements)
    [At, B] = Energy_EbFVM_cfdCoeffs_Calc(At, B, nodesConnec, BD, BC, BS, pointers2CFDMatrix, sD, sC, sNS, sT);
    
%% Impose boundary conditions
    At_BC = At;
    B_BC  = B;
    
    % Fixed thermal boundary condition
        for iPartBC = 1 : BSGridCFD_3D.BCs.fixedTemperature.numParts
            for iNodeBC = 1 : BSGridCFD_3D.BCs.fixedTemperature.parts(iPartBC,1).numNodesBC
                nodeID  = BSGridCFD_3D.BCs.fixedTemperature.parts(iPartBC,1).nodesID(iNodeBC,1);
                bcValue = BSGridCFD_3D.BCs.fixedTemperature.parts(iPartBC,1).bcValues(:,:,iNodeBC);

                At_BC(nonzeros(bcValue(3,:)))        = 0;
                At_BC(nodeID)                        = 1;
                BSGridCFD_3D.nodes.T_fluid(nodeID,1) = (bcValue(2,1)/df_T);

                B_BC(nodeID) = (bcValue(2,1)/df_T);
            end
        end

    % Periodic flow boundary condition
        for iPartBC = 1 : BSGridCFD_3D.BCs.periodicFlow.numParts
            for iNodeBC = 1 : BSGridCFD_3D.BCs.periodicFlow.parts(iPartBC,1).numNodesBC
                nodeID  = BSGridCFD_3D.BCs.periodicFlow.parts(iPartBC,1).nodesID(iNodeBC,1);
                bcValue = BSGridCFD_3D.BCs.periodicFlow.parts(iPartBC,1).bcValues(:,:,iNodeBC);

                At_BC(nonzeros(bcValue(5,:))) = At(nonzeros(bcValue(5,:))) + At(nonzeros(bcValue(4,:)));
                B_BC(nodeID) = B(nodeID) + B(bcValue(4,1));
            end
        end

%% Update sparse matrices
    BSGridCFD_3D.calcMatrices.cfdCoeffs.At    = At;
    BSGridCFD_3D.calcMatrices.cfdCoeffs.At_BC = At_BC;
    BSGridCFD_3D.calcMatrices.cfdCoeffs.B     = B;
    BSGridCFD_3D.calcMatrices.cfdCoeffs.B_BC  = B_BC;

end % *** END FUNCTION % **************************************************************************************************************************************
