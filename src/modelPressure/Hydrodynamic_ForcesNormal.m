function [modelBearing] = Hydrodynamic_ForcesNormal(modelBearing, BSGridCFD_2D)
% *************************************************************************************************************************************************************
% Calculate hydrodynamic normal forces
% *************************************************************************************************************************************************************

%% Calculation inputs
	alfab = modelBearing.calculationInputs.alfab;

%% Dimensionless factors
    df_WX = modelBearing.dimensionless.df_WX;
    df_WY = modelBearing.dimensionless.df_WY;
    df_WZ = modelBearing.dimensionless.df_WZ;

%% Nodes coordinates
    coord = BSGridCFD_2D.nodes.coords;
    
%% Hydrodynamic forces in the journal (Normalise pressure due to LUBST function)
    pHydro_j = BSGridCFD_2D.nodes.pHydro;
    
    fWX_j =  (1/4)*(pHydro_j.*sin(coord(:,1)));
    fWY_j = (-1/4)*(pHydro_j.*cos(coord(:,1)));

    WX_j = BSGridCFD_2D.calcMatrices.vectorIntegr.V*fWX_j;
    WY_j = BSGridCFD_2D.calcMatrices.vectorIntegr.V*fWY_j;
    WZ_j = 0;
    
    modelBearing.results.hydrodynamic.WX_j(1,1) = (WX_j*cos(alfab) - WY_j*sin(alfab));
    modelBearing.results.hydrodynamic.WX_j(1,2) = (df_WX)*modelBearing.results.hydrodynamic.WX_j(1,1);
    
    modelBearing.results.hydrodynamic.WY_j(1,1) = (WY_j*cos(alfab) + WX_j*sin(alfab));
    modelBearing.results.hydrodynamic.WY_j(1,2) = (df_WY)*modelBearing.results.hydrodynamic.WY_j(1,1);

    modelBearing.results.hydrodynamic.WZ_j(1,1) = WZ_j;
    modelBearing.results.hydrodynamic.WZ_j(1,2) = (df_WZ)*modelBearing.results.hydrodynamic.WZ_j(1,1);
    
    modelBearing.results.hydrodynamic.W_j = norm([modelBearing.results.hydrodynamic.WX_j(1,2) modelBearing.results.hydrodynamic.WY_j(1,2) modelBearing.results.hydrodynamic.WZ_j(1,2)]);
    
%% Hydrodynamic forces in the bearing
    WX_b = -WX_j;
    WY_b = -WY_j;
    WZ_b = 0;

    modelBearing.results.hydrodynamic.WX_b(1,1) = (WX_b*cos(alfab) - WY_b*sin(alfab));
    modelBearing.results.hydrodynamic.WX_b(1,2) = (df_WX)*modelBearing.results.hydrodynamic.WX_b(1,1);
    
    modelBearing.results.hydrodynamic.WY_b(1,1) = (WY_b*cos(alfab) + WX_b*sin(alfab));
    modelBearing.results.hydrodynamic.WY_b(1,2) = (df_WY)*modelBearing.results.hydrodynamic.WY_b(1,1);

    modelBearing.results.hydrodynamic.WZ_b(1,1) = WZ_b;
    modelBearing.results.hydrodynamic.WZ_b(1,2) = (df_WZ)*modelBearing.results.hydrodynamic.WZ_b(1,1);
    
    modelBearing.results.hydrodynamic.W_b = norm([modelBearing.results.hydrodynamic.WX_b(1,2) modelBearing.results.hydrodynamic.WY_b(1,2) modelBearing.results.hydrodynamic.WZ_b(1,2)]);

end % *** END FUNCTION % **************************************************************************************************************************************