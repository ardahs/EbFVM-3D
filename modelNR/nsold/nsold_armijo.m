function [problem] = nsold_armijo(problem)
% Function  : Compute the step length with the three point parabolic model
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
%
% *** OUTPUTS *************************************************************************************************************************************************
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 1, 2003
% This code comes with no guarantee or warranty of any kind.
% *************************************************************************************************************************************************************

%% Auxilar variables
    xc        = problem.auxiliar.xc;
    fc        = problem.auxiliar.fc;
    direction = problem.auxiliar.direction;
    jac_age   = problem.auxiliar.jac_age;
    exitflag  = problem.auxiliar.exitflag;
    funcEval  = problem.auxiliar.funcEval;

%% Internal control parameters
    alpha  = problem.options.alpha;
    sigma1 = problem.options.sigma1;
    maxarm = problem.options.maxarm;

%% Initilize variables
    lambda    = 1;
    lamm      = 1;
    lamc      = lambda;
    iarm      = 0;
    armflag   = 0;
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
                lambda = nsold_parab3p(problem, lamc, lamm, ff0, ffc, ffm);
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
                %xt = xc;
                %ft = fc;
                if (jac_age > 0)
                  fprintf('   Armijo failure; recompute Jacobian \n');
                  armflag = 1;
                else
                  fprintf('   Complete Armijo failure \n');
                  exitflag = 3;
                end
                break;
            end
    end
    
%% Update variables    
    problem.auxiliar.fnrmo    = problem.auxiliar.fnrm;
    problem.auxiliar.fnrm     = norm(ft);
    problem.auxiliar.step     = step;
    problem.auxiliar.xc       = xt;
    problem.auxiliar.fc       = ft;
    problem.auxiliar.armflag  = armflag;
    problem.auxiliar.exitflag = exitflag;
    problem.auxiliar.funcEval = funcEval;
    
end % *** END FUNCTION % **************************************************************************************************************************************
