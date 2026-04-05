function [At, B] = Energy_EbFVM_cfdCoeffs_Calc(At, B, nodesConnec, BD, BC, BS, pointers2CFDMatrix, sD, sC, sNS, sT)
% *************************************************************************************************************************************************************
% Calculate 3D element coefficients of thermal energy equation with
% discretised using Element-based Finite Volume
% *************************************************************************************************************************************************************

%% Auxiliary variables
    [numElements, numNodesPerElement] = size(nodesConnec);
    ndim = 3;
    
%% Initialise thermal fields
    sizeAD  = ndim * ndim * numNodesPerElement;
    sizeAC  = ndim * numNodesPerElement;
    diagIdx = 1:(numNodesPerElement+1):(numNodesPerElement^2);
    
%% Re-start coefficient matrices and vector
    At = 0*At;
    B  = 0*B;
    
%% Update element properties
    for ielem = 1 : numElements
        
        % Triangular prism element
        if (numNodesPerElement == 6)
            % Diffusive terms
                AD = reshape((BD(:,:,ielem))*(reshape(permute(sD(:,:,nodesConnec(ielem,:)),[3 2 1]), sizeAD, 1)), numNodesPerElement, numNodesPerElement)';
            % Convective terms
                qC = (BC(:,:,ielem))*(reshape(sC(nodesConnec(ielem,:),:), sizeAC, 1));
                AC = NUIS_tria(qC);
            % Source terms
                % sNS: source term components linearly proportional to the transport variable, including parts related to the temporal discretisation
                % sT:  source term components independent of the transport variable, including parts related to the temporal discretisation
                    AC(diagIdx) = AC(diagIdx) + (BS(:,:,ielem) .* (sNS(nodesConnec(ielem,:))))';
                    AS          = BS(:,:,ielem) .* sT(nodesConnec(ielem,:));
                    
        % Hexahdron element
        elseif (numNodesPerElement == 8)
            % Diffusive terms
                AD = reshape((BD(:,:,ielem))*(reshape(permute(sD(:,:,nodesConnec(ielem,:)),[3 2 1]), sizeAD, 1)), numNodesPerElement, numNodesPerElement)';
            % Convective terms
                qC = (BC(:,:,ielem))*(reshape(sC(nodesConnec(ielem,:),:), sizeAC, 1));
                AC = NUIS_hexa(qC);
            % Source terms
                % sNS: source term components linearly proportional to the transport variable, including parts related to the temporal discretisation
                % sT:  source term components independent of the transport variable, including parts related to the temporal discretisation
                    AC(diagIdx) = AC(diagIdx) + (BS(:,:,ielem) .* (sNS(nodesConnec(ielem,:))))';
                    AS          = BS(:,:,ielem) .* sT(nodesConnec(ielem,:));
        end

        % Organise terms in the sparse coefficient matrices
            % Attention to the signs (AD + AC or AD - AC; +AS or -AS);
            % they depend on how the diffusion, convection and source terms are arranged to construct the linear system
            At(pointers2CFDMatrix(:,:,ielem)) = At(pointers2CFDMatrix(:,:,ielem)) + AD + AC;
            B(nodesConnec(ielem,:))           = B(nodesConnec(ielem,:)) + AS';

    end
    
end % *** END FUNCTION % **************************************************************************************************************************************
