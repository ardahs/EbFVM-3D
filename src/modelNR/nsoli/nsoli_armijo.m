function [problem] = nsoli_armijo(problem)
% *************************************************************************************************************************************************************
% Function  : Compute the step length with the three point parabolic model (see item 1.6)
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
    xc        = problem.auxiliar.xc;
    fc        = problem.auxiliar.fc;
    direction = problem.auxiliar.direction;
    exitflag  = problem.auxiliar.exitflag;
    funcEval  = problem.auxiliar.funcEval;

%% Internal control parameters
    alpha  = problem.options.alpha;
    sigma1 = problem.options.sigma1;
    maxarm = problem.options.maxarm;
    
%% Initialize variables
    lambda    = 1;
    lamm      = 1;
    lamc      = lambda;
    iarm      = 0;
    direction = feval(problem.funConstr, direction, xc);
    step      = lambda*direction;
    xt        = xc + step;
    ft        = feval(problem.fun,xt);
    funcEval  = funcEval + 1;
    nft       = norm(ft);
    nf0       = norm(fc);
    ff0       = nf0*nf0;
    ffc       = nft*nft;
    ffm       = nft*nft;
    
%% Compute line search
    while (nft >= (1 - alpha*lambda) * nf0)
        % Apply the three point parabolic model.
            if (iarm == 0)
                lambda = sigma1*lambda;
            else
                lambda = nsoli_parab3p(problem, lamc, lamm, ff0, ffc, ffm);
            end
        % Update xc; keep the books on lambda
            step = lambda*direction;
            xt   = xc + step;
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
                fprintf('   Armijo failure, too many reductions  \n');
                xt       = xc;
                ft       = fc;
                exitflag = 3;
                break;
            end
    end

%% Update variables    
    problem.auxiliar.fnrmo    = problem.auxiliar.fnrm;
    problem.auxiliar.fnrm     = norm(ft);
    problem.auxiliar.step     = step;
    problem.auxiliar.xc       = xt;
    problem.auxiliar.fc       = ft;
    problem.auxiliar.exitflag = exitflag;
    problem.auxiliar.funcEval = funcEval;
    
end % *** END FUNCTION % **************************************************************************************************************************************
