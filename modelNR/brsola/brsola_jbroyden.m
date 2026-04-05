function [problem] = brsola_jbroyden(problem)
% Function  : Compute iteration step using Broyden's formulation
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	problem ........... updated data structure with the problem definition
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 1, 2003
% This code comes with no guarantee or warranty of any kind.
% *************************************************************************************************************************************************************

%% Auxiliar variables
    itc         = problem.auxiliar.iteration;
    fc          = problem.auxiliar.fc;
    step        = problem.auxiliar.step;
    step_norm   = problem.auxiliar.step_norm;
    lambda_hist = problem.auxiliar.lambda_hist;
    nbroy       = problem.auxiliar.nbroy;

%% Internal control parameters
    maxdimBroyden = problem.options.maxdimBroyden;
    
%% Compute iteration step
    itc = itc+1;
    if (nbroy == 0 || nbroy > maxdimBroyden)
        % Set the initial step to -F and compute the step norm
            step(:,1)    = -fc;
            step_norm(1) = step(:,1)'*step(:,1);
            nbroy        = 1;
    else
        z=-fc;
        if (nbroy > 1)
            for kbr = 1:nbroy-1
                 ztmp = step(:,kbr+1)/lambda_hist(kbr+1);
                 ztmp = ztmp+(1 - 1/lambda_hist(kbr))*step(:,kbr);
                 ztmp = ztmp*lambda_hist(kbr);
                 z    = z+ztmp*((step(:,kbr)'*z)/step_norm(kbr));
            end
        end
        % Store the new search direction and its norm
            a2                 = -lambda_hist(nbroy)/step_norm(nbroy);
            a1                 = 1 - lambda_hist(nbroy);
            zz                 = step(:,nbroy)'*z;
            a3                 = a1*zz/step_norm(nbroy);
            a4                 = 1+a2*zz;
            step(:,nbroy+1)    = (z-a3*step(:,nbroy))/a4;
            step_norm(nbroy+1) = step(:,nbroy+1)'*step(:,nbroy+1);
            nbroy              = nbroy+1;
    end
    
%% Update variables
    problem.auxiliar.step        = step;
    problem.auxiliar.step_norm   = step_norm;
    problem.auxiliar.lambda_hist = lambda_hist;
    problem.auxiliar.nbroy       = nbroy;
    problem.auxiliar.iteration   = itc;
    
end % *** END FUNCTION % **************************************************************************************************************************************
    