function [modelBearing] = Hydrodynamic_MomentsNormal(modelBearing, BSGridCFD_2D)
% *************************************************************************************************************************************************************
% Calculate hydrodynamic normal moments
% *************************************************************************************************************************************************************

%% Calculation inputs
	alfab = modelBearing.calculationInputs.alfab;

%% Dimensionless factors
    df_MX = modelBearing.dimensionless.df_MX;
    df_MY = modelBearing.dimensionless.df_MY;
    df_MZ = modelBearing.dimensionless.df_MZ;

%% Nodes coordinates
    coord = BSGridCFD_2D.nodes.coords;
    
%% Hydrodynamic forces in the journal (Normalise pressure due to LUBST function)
    pHydro_j = BSGridCFD_2D.nodes.pHydro;

    fMX_j = (1/4)*((coord(:,2)).*pHydro_j.*cos(coord(:,1)));
    fMY_j = (1/4)*((coord(:,2)).*pHydro_j.*sin(coord(:,1)));

    MX_j = BSGridCFD_2D.calcMatrices.vectorIntegr.V*fMX_j;
    MY_j = BSGridCFD_2D.calcMatrices.vectorIntegr.V*fMY_j;
    MZ_j = 0;
    
    modelBearing.results.hydrodynamic.MX_j(1,1) = (MX_j*cos(alfab) - MY_j*sin(alfab));
    modelBearing.results.hydrodynamic.MX_j(1,2) = (df_MX)*modelBearing.results.hydrodynamic.MX_j(1,1);

    modelBearing.results.hydrodynamic.MY_j(1,1) = (MY_j*cos(alfab) + MX_j*sin(alfab));
    modelBearing.results.hydrodynamic.MY_j(1,2) = (df_MY)*modelBearing.results.hydrodynamic.MY_j(1,1);

    modelBearing.results.hydrodynamic.MZ_j(1,1) = MZ_j;
    modelBearing.results.hydrodynamic.MZ_j(1,2) = (df_MZ)*modelBearing.results.hydrodynamic.MZ_j(1,1);
    
    modelBearing.results.hydrodynamic.M_j = norm([modelBearing.results.hydrodynamic.MX_j(1,2) modelBearing.results.hydrodynamic.MY_j(1,2) modelBearing.results.hydrodynamic.MZ_j(1,2)]);
    
%% Hydrodynamic moments in the bearing
    MX_b = -MX_j;
    MY_b = -MY_j;
    MZ_b = 0;
    
    modelBearing.results.hydrodynamic.MX_b(1,1) = (MX_b*cos(alfab) - MY_b*sin(alfab));
    modelBearing.results.hydrodynamic.MX_b(1,2) = (df_MX)*modelBearing.results.hydrodynamic.MX_b(1,1);

    modelBearing.results.hydrodynamic.MY_b(1,1) = (MY_b*cos(alfab) + MX_b*sin(alfab));
    modelBearing.results.hydrodynamic.MY_b(1,2) = (df_MY)*modelBearing.results.hydrodynamic.MY_b(1,1);

    modelBearing.results.hydrodynamic.MZ_b(1,1) = MZ_b;
    modelBearing.results.hydrodynamic.MZ_b(1,2) = (df_MZ)*modelBearing.results.hydrodynamic.MZ_b(1,1);
    
    modelBearing.results.hydrodynamic.M_b = norm([modelBearing.results.hydrodynamic.MX_b(1,2) modelBearing.results.hydrodynamic.MY_b(1,2) modelBearing.results.hydrodynamic.MZ_b(1,2)]);

end % *** END FUNCTION % **************************************************************************************************************************************