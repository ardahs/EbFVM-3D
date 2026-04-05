function [BSGridCFD_2D, BSGridCFD_3D] = Energy_EbFVM(BSModels, BSGridCFD_2D, BSGridCFD_3D)
% *************************************************************************************************************************************************************
% Solve the thermal problem of a general rigid misaligned journal bearing
% *************************************************************************************************************************************************************

%% Auxiliary variables
    Nz   = BSGridCFD_3D.ExtrusionNodes.ZNodesFluid;
    df_T = BSModels.modelThermal.T_supply;

%% Update local fluid flow
    BSGridCFD_3D = computeLubricantFlow(BSGridCFD_2D, BSGridCFD_3D, BSModels);

%% Update thermal transport properties
    BSGridCFD_3D.nodes = EnergyFluid(BSGridCFD_2D.nodes, BSGridCFD_3D.nodes, BSModels, Nz, BSGridCFD_3D);

%% Update thermal coefficient matrices
    [BSGridCFD_3D] = Organise_fluidEnergy_EbFVM_cfdCoeffs(BSGridCFD_3D, BSModels);

%% Solve system of equations
    [At_sparce] = MRS2Sparce(BSGridCFD_3D.calcMatrices.cfdCoeffs.At_BC, BSGridCFD_3D.calcMatrices.cfdCoeffs.JA, BSGridCFD_3D.nodes.numNodes);
    T = At_sparce\BSGridCFD_3D.calcMatrices.cfdCoeffs.B_BC';

%% Update fluid thermal solution
    BSGridCFD_3D.nodes.T_fluid = T.*df_T;

end % *** END FUNCTION % **************************************************************************************************************************************
  

function [Ap_sparce] = MRS2Sparce(Ap, JAp, nnodes)
% *************************************************************************************************************************************************************
% Converts a Modified Row Storage (MRS) matrix to a MATLAB sparse matrix.
% Diagonal entries are stored in Ap(1,i); off-diagonal entries are stored
% in Ap(1,j) with column indices given by JAp(1,j), for j in the range
% [JAp(1,i), JAp(1,i+1)-1].
% *************************************************************************************************************************************************************

%% Initialise storage arrays
    nnzero = (size(Ap,2)-1);
    r      = zeros(nnzero,1);
    c      = zeros(nnzero,1);
    s      = zeros(nnzero,1);

%% Initialise solver
    cont = 0;
    for i = 1 : nnodes
        % Diagonal coefficients
            cont      = cont+1;
            r(cont,1) = i;
            c(cont,1) = i;
            s(cont,1) = Ap(1,i);
        % Non-diagonal coefficients
            for j = JAp(1,i):(JAp(1,(i+1))-1)
                cont      = cont+1;
                r(cont,1) = i;
                c(cont,1) = JAp(1,j);
                s(cont,1) = Ap(1,j);
            end
    end

%% Assemble sparse matrix
    Ap_sparce = sparse(r,c,s,nnodes,nnodes);

end % *** END FUNCTION % **************************************************************************************************************************************