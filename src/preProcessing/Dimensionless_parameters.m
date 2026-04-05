function [BSModels] = Dimensionless_parameters(BSModels)
% *************************************************************************************************************************************************************
% Initialise dimensionless parameters
% *************************************************************************************************************************************************************

%% Update dimensionless information    
    % Auxilary variables
        Rb    = BSModels.modelBearing.parametersBearing.bearingRadius;
        L     = BSModels.modelBearing.parametersBearing.bearingWidth;
        c     = BSModels.modelBearing.parametersBearing.radialClearance;
        mi0   = BSModels.modelRheology.mu_0;
        rho0  = BSModels.modelRheology.rho_0;
        Uent  = BSModels.modelSpeeds.Uent;
        df_qX = BSModels.modelBearing.dimensionless.df_qX;
        df_qZ = BSModels.modelBearing.dimensionless.df_qZ;
        wj    = BSModels.modelBearing.calculationInputs.wj;
        wb    = BSModels.modelBearing.calculationInputs.wb;
        Zjp   = BSModels.modelBearing.calculationInputs.Zjp;
        Zbp   = BSModels.modelBearing.calculationInputs.Zbp;
        R     = (Rb-(c/2));
        OMEGA = abs((wj+wb)/(2*pi));
        if (OMEGA == 0)
            OMEGA = 1;
        end
    % Dimensionless characteristics
        BSModels.modelBearing.dimensionless.dc_OMEGA = OMEGA;
    % Dimensionless parameters
        BSModels.modelBearing.dimensionless.dp_wj    = (wj/(2*pi));
        BSModels.modelBearing.dimensionless.dp_wb    = (wb/(2*pi));
        BSModels.modelBearing.dimensionless.dp_Zjp   = (Zjp/(L/2));
        BSModels.modelBearing.dimensionless.dp_Zbp   = (Zbp/(L/2));
    % Dimensionless factors
        BSModels.modelBearing.dimensionless.df_p     = ((mi0*OMEGA)*((R/c)^2));
        BSModels.modelBearing.dimensionless.df_gamaX = ((OMEGA)*(R/c));
        BSModels.modelBearing.dimensionless.df_gamaZ = ((OMEGA)*(R/c));
        BSModels.modelBearing.dimensionless.df_talX  = ((mi0*OMEGA)*(R/c));
        BSModels.modelBearing.dimensionless.df_talZ  = ((mi0*OMEGA)*(R/c));
        BSModels.modelBearing.dimensionless.df_qX    = ((rho0*OMEGA)*(R)*(c));
        BSModels.modelBearing.dimensionless.df_qZ    = ((rho0*OMEGA)*(R)*(c));
        BSModels.modelBearing.dimensionless.df_QX    = ((df_qX*(R)));        
        BSModels.modelBearing.dimensionless.df_QZ    = ((df_qZ*(L/2)));
        BSModels.modelBearing.dimensionless.df_WX    = ((mi0*OMEGA)*(2*R*L)*((R/c)^2));
        BSModels.modelBearing.dimensionless.df_WY    = ((mi0*OMEGA)*(2*R*L)*((R/c)^2));
        BSModels.modelBearing.dimensionless.df_WZ    = ((mi0*OMEGA)*(2*R*L)*((R/c)^2));
        BSModels.modelBearing.dimensionless.df_MX    = ((mi0*OMEGA)*(2*R*L)*((R/c)^2)*(L/2));
        BSModels.modelBearing.dimensionless.df_MY    = ((mi0*OMEGA)*(2*R*L)*((R/c)^2)*(L/2));
        BSModels.modelBearing.dimensionless.df_MZ    = ((mi0*OMEGA)*(2*R*L)*((R/c)^2)*(R));
        BSModels.modelBearing.dimensionless.df_FX    = ((mi0*OMEGA)*(2*R*L)*(R/c));
        BSModels.modelBearing.dimensionless.df_FY    = ((mi0*OMEGA)*(2*R*L)*(R/c));
        BSModels.modelBearing.dimensionless.df_FZ    = ((mi0*OMEGA)*(2*R*L)*(R/c));
        BSModels.modelBearing.dimensionless.df_TX    = ((mi0*OMEGA)*(2*R*L)*(R/c)*(L/2));
        BSModels.modelBearing.dimensionless.df_TY    = ((mi0*OMEGA)*(2*R*L)*(R/c)*(L/2));
        BSModels.modelBearing.dimensionless.df_TZ    = ((mi0*OMEGA)*(2*R*L)*(R/c)*(R));
        BSModels.modelBearing.dimensionless.df_P     = ((mi0*OMEGA)*(2*R*L)*(R/c)*(R)*OMEGA);
        BSModels.modelBearing.dimensionless.df_p_GRE = ((mi0*Uent*Rb))/(c^2);
        
end % *** END FUNCTION % **************************************************************************************************************************************
