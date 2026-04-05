function [Ap, Atheta, B] = JFO_EbFVM_cfdCoeffs_Calc(Ap, Atheta, B, nodesConnec, BD, BC, BS, pointers2CFDMatrix, sD, sC, sTS, sNS, sT, thetaHydroPrev)
% *************************************************************************************************************************************************************
% Calculate 2D element coefficients of generalised Reynolds equation with
% JFO cavitation model discretised using Element-based Finite Volume
% *************************************************************************************************************************************************************

%% Auxiliary variables
    [numElements, numNodesPerElement] = size(nodesConnec);
    
%% Re-start coefficient matrices and vector
    Ap     = 0*Ap;
    Atheta = 0*Atheta;
    B      = 0*B;
    
%% Update element properties
    for ielem = 1 : numElements
        
        % Triangular element
        if (numNodesPerElement == 3)
            % Diffusive terms
                AD = reshape((BD(:,:,ielem))*(reshape(permute(sD(:,:,nodesConnec(ielem,:)),[3 2 1]),12,1)),3,3)';
            % Convective terms
                qC = (BC(:,:,ielem))*(reshape(sC(nodesConnec(ielem,:),:),6,1));
                AC = FWUS1_tria1(qC);
            % Source terms
                AC([1 5 9]) =  AC([1 5 9]) + (BS(:,:,ielem).*(sTS(nodesConnec(ielem,:))+sNS(nodesConnec(ielem,:))+sT(nodesConnec(ielem,:))))';
                AS          = -BS(:,:,ielem).*sT(nodesConnec(ielem,:)).*thetaHydroPrev(nodesConnec(ielem,:),1);
                
        % Quadrangular element
        elseif (numNodesPerElement == 4)
            % Diffusive terms
                AD = reshape((BD(:,:,ielem))*(reshape(permute(sD(:,:,nodesConnec(ielem,:)),[3 2 1]),16,1)),4,4)';
            % Convective terms
                qC = (BC(:,:,ielem))*(reshape(sC(nodesConnec(ielem,:),:),8,1));
                AC = FWUS1_quad1(qC);
            % Source terms
                AC([1 6 11 16]) =  AC([1 6 11 16]) + (BS(:,:,ielem).*(sTS(nodesConnec(ielem,:))+sNS(nodesConnec(ielem,:))+sT(nodesConnec(ielem,:))))';
                AS              = -BS(:,:,ielem).*sT(nodesConnec(ielem,:)).*thetaHydroPrev(nodesConnec(ielem,:),1);
        end
        
        % Organise terms in the sparse coefficient matrices
            Ap(pointers2CFDMatrix(:,:,ielem))     = Ap(pointers2CFDMatrix(:,:,ielem))     + AD;
            Atheta(pointers2CFDMatrix(:,:,ielem)) = Atheta(pointers2CFDMatrix(:,:,ielem)) + AC;
            B(nodesConnec(ielem,:))               = B(nodesConnec(ielem,:))               + AS';

    end
    
end % *** END FUNCTION % **************************************************************************************************************************************