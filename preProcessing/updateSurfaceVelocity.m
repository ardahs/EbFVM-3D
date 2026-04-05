function [BSModels] = updateSurfaceVelocity(BSModels)
% *************************************************************************************************************************************************************
% Convert rotational speeds to linear velocities.
% *************************************************************************************************************************************************************

%% Convert velocity parameters to m/s
    BSModels.modelSpeeds.Uj = BSModels.modelSpeeds.Uj * BSModels.modelBearing.parametersBearing.bearingRadius * (2 * pi) / 60;
    BSModels.modelSpeeds.Ub = BSModels.modelSpeeds.Ub * BSModels.modelBearing.parametersBearing.bearingRadius * (2 * pi) / 60;
    BSModels.modelSpeeds.Vj = BSModels.modelSpeeds.Vj * BSModels.modelBearing.parametersBearing.bearingRadius * (2 * pi) / 60;
    BSModels.modelSpeeds.Vb = BSModels.modelSpeeds.Vb * BSModels.modelBearing.parametersBearing.bearingRadius * (2 * pi) / 60;

%% Entrainment speeds
    BSModels.modelSpeeds.Uent = (BSModels.modelSpeeds.Uj + BSModels.modelSpeeds.Ub) / 2; 
    BSModels.modelSpeeds.Vent = (BSModels.modelSpeeds.Vj + BSModels.modelSpeeds.Vb) / 2; 

%% Sliding speeds
    BSModels.modelSpeeds.Us = BSModels.modelSpeeds.Uj - BSModels.modelSpeeds.Ub; 
    BSModels.modelSpeeds.Vs = BSModels.modelSpeeds.Vj - BSModels.modelSpeeds.Vb; 

end % *** END FUNCTION % **************************************************************************************************************************************    