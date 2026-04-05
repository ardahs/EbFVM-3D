function [AC] = FWUS1_quad1(qC)
% *************************************************************************************************************************************************************
% Calculate convective matrix considering the 1st-order Flow Weighted Upwind Scheme (FWUS)
% used into the EbFVM discretisation for bilinear quadrangular elements
% *************************************************************************************************************************************************************

%% Auxiliary variables
    epsilon = 1e-30;
    
%% Compute coefficient defining flow directions
    alphaC = (qC > 0);

%% Compute local flow ratio
    As      = [ 0               (1-alphaC(1))   0               alphaC(1)     ;
                alphaC(2)       0               (1-alphaC(2))   0             ; 
                0               alphaC(3)       0               (1-alphaC(3)) ; 
                (1-alphaC(4))   0               alphaC(4)       0            ];
       
    wp      = (As*qC)./(qC+epsilon);
    lambdaC = max(min(wp,1),0);
    
%% Compute interpolation matrices
    Bs = [ 1                             (-(1-alphaC(1))*lambdaC(1))   0                             (-alphaC(1)*lambdaC(1))     ; 
           (-alphaC(2)*lambdaC(2))       1                             (-(1-alphaC(2))*lambdaC(2))   0                           ;
           0                             (-alphaC(3)*lambdaC(3))       1                             (-(1-alphaC(3))*lambdaC(3)) ;
           (-(1-alphaC(4))*lambdaC(4))   0                             (-alphaC(4)*lambdaC(4))       1                          ];

    Cs = [ (alphaC(1)*(1-lambdaC(1)))       ((1-alphaC(1))*(1-lambdaC(1)))   0                                0                              ; 
           0                                (alphaC(2)*(1-lambdaC(2)))       ((1-alphaC(2))*(1-lambdaC(2)))   0                              ;
           0                                0                                (alphaC(3)*(1-lambdaC(3)))       ((1-alphaC(3))*(1-lambdaC(3))) ;
           ((1-alphaC(4))*(1-lambdaC(4)))   0                                0                                (alphaC(4)*(1-lambdaC(4)))    ];

    Ds = [  1    0    0   -1  ; 
           -1    1    0    0  ;
            0   -1    1    0  ;
            0    0   -1    1 ];

   IM = (Bs\Cs);
   
%% Calculate convective matrix
    AC = (Ds)*(diag(qC))*(IM);
        
end % *** END FUNCTION % **************************************************************************************************************************************
