function [problem] = nsoli_dkrylov(problem)
% Function  : Krylov linear equation solver for use in nsoli (see item 3.1)
%             Note that for Newton-GMRES we incorporate any preconditioning
%             into the function routine.
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

%% Auxiliar parameters
    itc      = problem.auxiliar.iteration;
    xc       = problem.auxiliar.xc;
    fc       = problem.auxiliar.fc;
    exitflag = problem.auxiliar.exitflag;
    funcEval = problem.auxiliar.funcEval;

%% Internal control parameters
    lmeth   = problem.options.lmeth;
    lmaxit  = problem.options.MaxIterInn;
    etamax  = abs(problem.options.etamax);
    restart_limit = problem.options.restart_limit;
    if (lmeth == 1)
        restart_limit = 0;
    end
    
%% Linear iterative methods
    itc = itc + 1;
    if (lmeth == 1 || lmeth == 2)  % GMRES or GMRES(m) 
        % Compute the direction using a GMRES routine especially designed for this purpose
            [direction, errstep, total_iters, funcEval] = nsoli_dgmres(problem, xc, fc, [], funcEval);
            kinn = 0;
        % Restart at most restart_limit times
        while (total_iters == lmaxit && errstep(total_iters) > etamax*norm(fc) && kinn < restart_limit)
            kinn = kinn+1;
            [direction, errstep, total_iters, funcEval] = nsoli_dgmres(problem, xc, fc, direction, funcEval);
        end
    elseif (lmeth == 3)            % Bi-CGSTAB
        [direction, errstep, total_iters, exitflag, funcEval] = nsoli_dcgstab(problem, xc, fc, [], exitflag, funcEval);
    elseif (lmeth == 4)            % TFQMR
        [direction, errstep, total_iters, exitflag, funcEval] = nsoli_dtfqmr(problem, xc, fc, [], exitflag, funcEval);
    else
        error(' Unknown Krylov linear equation solver')
    end
    
%% Update variables
    problem.auxiliar.direction = direction;
    problem.auxiliar.errstep   = errstep;
    problem.auxiliar.exitflag  = exitflag;
    problem.auxiliar.funcEval  = funcEval;
    problem.auxiliar.iteration = itc;
    
end % *** END FUNCTION % **************************************************************************************************************************************
