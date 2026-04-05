function [BSGridCFD_3D] = computeLubricantFlow(BSGridCFD_2D, BSGridCFD_3D, BSModels)
% *************************************************************************************************************************************************************
% Evaluate the fluid flow in the cartesian and curvilinear grid systems
% *************************************************************************************************************************************************************

%% Update local kinematic of the lubricant film in cartesian grid
    BSGridCFD_3D = updateCartesianFlow(BSGridCFD_2D, BSGridCFD_3D, BSModels);

%% Update local kinematic of the lubricant film in curvilinear grid
    BSGridCFD_3D = updateCurvilinearFlow(BSGridCFD_2D, BSGridCFD_3D, BSModels);

end % *** END FUNCTION % **************************************************************************************************************************************
