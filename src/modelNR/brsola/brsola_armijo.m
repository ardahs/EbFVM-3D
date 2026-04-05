function [problem] = brsola_armijo(problem)
% Function  : Compute the step length with the three point parabolic model
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

%% Auxilar variables
    xc          = problem.auxiliar.xc;
    fc          = problem.auxiliar.fc;
    step        = problem.auxiliar.step;
    step_norm   = problem.auxiliar.step_norm;
    lambda_hist = problem.auxiliar.lambda_hist;
    nbroy       = problem.auxiliar.nbroy;
    exitflag    = problem.auxiliar.exitflag;
    funcEval    = problem.auxiliar.funcEval;

%% Internal control parameters
    alpha  = problem.options.alpha;
    sigma1 = problem.options.sigma1;
    maxarm = problem.options.maxarm;

%% Auxiliar and initilize variables
    lambda   = 1;
    lamm     = 1;
    lamc     = lambda;
    iarm     = 0;
    step     = feval(problem.funConstr, step(:,nbroy), xc);
    xt       = xc + lambda*step(:,nbroy);
    ft       = feval(problem.fun,xt);
    funcEval = funcEval + 1;
    nft      = norm(ft);
    nf0      = norm(fc);
    ff0      = nf0*nf0;
    ffc      = nft*nft;
    ffm      = nft*nft;

%% Compute line search
    while (nft >= (1 - alpha*lambda) * nf0)
        % Apply the three point parabolic model.
            if (iarm == 0)
                lambda = sigma1*lambda;
            else
                lambda = nsold_parab3p(problem, lamc, lamm, ff0, ffc, ffm);
            end
        % Update xc; keep the books on lambda
            xt = xc + lambda*step(:,nbroy);
            lamm = lamc;
            lamc = lambda;
        % Keep the books on the function norms.
            ft       = feval(problem.fun,xt);
            funcEval = funcEval + 1;
            nft      = norm(ft);
            ffm      = ffc;
            ffc      = nft*nft;
            iarm     = iarm+1;
            if (iarm > maxarm)
                fprintf('   Line search failure  \n');
                xt = xc;
                ft = fc;
                exitflag = 3;
                break;
            end
    end
    
%% Modify the step and step norm if needed to reflect the line search
    lambda_hist(nbroy) = lambda;
    if (lambda ~= 1)
         step(:,nbroy)    = lambda*step(:,nbroy);
         step_norm(nbroy) = lambda*lambda*step_norm(nbroy);
    end
    
%% Update variables    
    problem.auxiliar.fnrm       = norm(ft);
    problem.auxiliar.xc          = xt;
    problem.auxiliar.fc          = ft;
    problem.auxiliar.step        = step;
    problem.auxiliar.step_norm   = step_norm;
    problem.auxiliar.lambda_hist = lambda_hist;
    problem.auxiliar.exitflag    = exitflag;
    problem.auxiliar.funcEval    = funcEval;
    
end % *** END FUNCTION % **************************************************************************************************************************************
