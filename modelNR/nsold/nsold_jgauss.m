function [problem] = nsold_jgauss(problem)
% Function  : Evaluate and factor the Jacobian with Gaussian Elimination
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

%% Auxiliar parameters
    itc      = problem.auxiliar.iteration;
    xc       = problem.auxiliar.xc;
    fc       = problem.auxiliar.fc;
    fnrm     = problem.auxiliar.fnrm;
    fnrmo    = problem.auxiliar.fnrmo;
    jac      = problem.auxiliar.jac;
    itsham   = problem.auxiliar.itsham;
    jac_age  = problem.auxiliar.jac_age;
    armflag  = problem.auxiliar.armflag;
    funcEval = problem.auxiliar.funcEval;

%% Internal control parameters
    isham = problem.options.Isham;
    rsham = problem.options.Rsham;
    jdiff = problem.options.Jdiff;
    
%% Evaluate/Update Jacobian
    itc = itc + 1;
    rat = fnrm/fnrmo;
    if(itc == 1 && isempty(jac) || rat > rsham || itsham == 0 || armflag == 1)
        itsham  = isham;
        jac_age = -1;
        if (jdiff == 1)
            if (problem.options.nl ~= 0) && (problem.options.nu ~= 0)
                [jac, funcEval] = nsold_bandjac(problem, xc, fc, funcEval); 
            else
                [jac, funcEval] = nsold_diffjac(problem, xc, fc, funcEval);
            end
        else
            [fv, jac] = feval(problem.fun,xc);
            funcEval = funcEval + 1;
        end
    end
    
%% Compute the Newton direction 
    [l, u]    = lu(jac);
    tmp       = -l\fc;
    direction = u\tmp;

%% Update variables
    problem.auxiliar.direction = direction;
    problem.auxiliar.jac_age   = jac_age+1;
    problem.auxiliar.itsham    = itsham-1;
    problem.auxiliar.jac       = jac;
    problem.auxiliar.funcEval  = funcEval;
    problem.auxiliar.iteration = itc;

end % *** END FUNCTION % **************************************************************************************************************************************
