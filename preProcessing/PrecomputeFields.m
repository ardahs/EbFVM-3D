function InfoSim = PrecomputeFields(InfoSim)
% *************************************************************************************************************************************************************
% Precompute simulation fieds
% *************************************************************************************************************************************************************

%% Auxilary variables
    BSModels     = InfoSim.BSModels;
    BSGridCFD_2D = InfoSim.BSGridCFD.BSGridCFD_2D;
    BSGridCFD_3D = InfoSim.BSGridCFD.BSGridCFD_3D;

%% Set static calculation inputs
    BSModels = updateSurfaceVelocity(BSModels);

%% Set initial film thickness
    [BSGridCFD_2D, BSGridCFD_3D] = initialFilmThickness(BSGridCFD_2D, BSGridCFD_3D, BSModels);

%% Update dimensionless parameters    
    BSModels = Dimensionless_parameters(BSModels);

%% Preallocate THL fields
    BSGridCFD_3D = initialiseFields(BSGridCFD_2D, BSGridCFD_3D, InfoSim.BSModels);

%% Update solutions
    InfoSim.BSModels               = BSModels;
    InfoSim.BSGridCFD.BSGridCFD_2D = BSGridCFD_2D;
    InfoSim.BSGridCFD.BSGridCFD_3D = BSGridCFD_3D;

end % *** END FUNCTION % **************************************************************************************************************************************    