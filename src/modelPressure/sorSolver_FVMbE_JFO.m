 function [pHydro, thetaHydro] = sorSolver_FVMbE_JFO(pHydro, thetaHydro, JA, Ap_BC, Atheta_BC, B_BC, pcav, w_pHydro, w_thetaHydro, maxIter, tol)
% *************************************************************************************************************************************************************
% Solve linear system of equation using Successive Over Relaxation (SOR)
% *************************************************************************************************************************************************************

%% Initialisation
    epsilon       = 1e-30;
    convFlag      = false;
    numIter       = 0;
    numNodes      = size(pHydro,2);
    pHydroOLD     = pHydro;
    thetaHydroOLD = thetaHydro;
    
%% Start iterations
    for numIter = 1 : maxIter
        for oe = 1 : 2
            for p = oe : 2 : numNodes
                % Calculate pressure
                    Bp_res = B_BC(1,p);
                    for iP = JA(1,p) : (JA(1,(p+1))-1)
                        Bp_res = Bp_res - (Ap_BC(1,iP)*pHydro(1,JA(1,iP))) + (Atheta_BC(1,iP)*thetaHydro(1,JA(1,iP)));
                    end
                    pHydroAux       = ((Bp_res + Atheta_BC(1,p))/Ap_BC(1,p));
                    pHydro(1,p)     = ((w_pHydro*pHydroAux) + (1-w_pHydro)*pHydro(1,p));
                    thetaHydro(1,p) = 1;
                % Check cavitation
                    if ((pHydroAux*Ap_BC(1,p)) > (Ap_BC(1,p)*pcav)) && (pHydro(1,p) < pcav)
                        thetaHydro(1,p) = ((w_thetaHydro/Atheta_BC(1,p))*((Ap_BC(1,p)*pcav)-Bp_res) + (1-w_thetaHydro)*thetaHydro(1,p));
                        pHydro(1,p)     = pcav;
                    end
            end
        end
        % Compute error (relative error 2, less accurate and faster)
            Error_pHydro      = ((norm(pHydro-pHydroOLD))        *((norm(pHydro))    /((norm(pHydro)+epsilon)    ^2)));
            Error_dthetaHydro = ((norm(thetaHydro-thetaHydroOLD))*((norm(thetaHydro))/((norm(thetaHydro)+epsilon)^2)));
            maxError          = Error_pHydro + Error_dthetaHydro;
        % Check error
            if (maxError <= tol)
                convFlag = true;
                return
            else
                pHydroOLD     = pHydro;
                thetaHydroOLD = thetaHydro;
            end
    end
    
end % *** END FUNCTION % **************************************************************************************************************************************