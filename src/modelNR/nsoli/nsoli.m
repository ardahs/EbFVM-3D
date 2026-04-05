function [problem] = nsoli(problem)
% Function  : Newton-Krylov solver, nonlinear global solver (see item 3)
%             Inexact-Newton-Armijo iteration
%             Eisenstat-Walker forcing term
%             Parabolic line search via three point interpolation
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	problem ........... updated data structure with the problem definition
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 27, 2001
% This code comes with no guarantee or warranty of any kind.
% *************************************************************************************************************************************************************

%% Update output
    problem.output.iterHist(problem.auxiliar.iteration+1,:) = [problem.auxiliar.iteration, problem.auxiliar.funcEval, problem.auxiliar.fnrm, 0];
    problem.output.xHist(problem.auxiliar.iteration+1,:)    = [problem.auxiliar.iteration, problem.auxiliar.xc'];

%% Start display
    fprintf('\n Iteration \t\t Func-Eval \t\t Norm of f(x) \t\t Norm of step \n');
    fprintf('   %-d\t\t\t   %-d\t\t\t   %-4.3e\t\t   %-4.3e \n', problem.auxiliar.iteration, problem.auxiliar.funcEval, problem.auxiliar.fnrm, []);
    
%% Main iteration loop
    while (problem.auxiliar.fnrm > problem.auxiliar.stop_tol && problem.auxiliar.iteration < problem.options.MaxIter && problem.auxiliar.exitflag == 1)
        % Compute iteration step
            problem = nsoli_dkrylov(problem);
        % Compute line search
            problem = nsoli_armijo(problem);
        % Adjust eta as per Eisenstat-Walker.
            problem = nsoli_eisewal(problem);
        % Update output
            problem.output.iterHist(problem.auxiliar.iteration+1,:) = [problem.auxiliar.iteration, problem.auxiliar.funcEval, problem.auxiliar.fnrm, norm(problem.auxiliar.step)];
            problem.output.xHist(problem.auxiliar.iteration+1,:)    = [problem.auxiliar.iteration, problem.auxiliar.xc'];
        % Update display
            fprintf('   %-d\t\t\t   %-d\t\t\t   %-4.3e\t\t   %-4.3e \n', problem.auxiliar.iteration, problem.auxiliar.funcEval, problem.auxiliar.fnrm, norm(problem.auxiliar.step));
    end
    if (problem.auxiliar.iteration == problem.options.MaxIter && problem.auxiliar.fnrm > problem.auxiliar.stop_tol)
        problem.auxiliar.exitflag = 2;
    end

%% Organize output
    problem.output.x          = problem.auxiliar.xc;
    problem.output.fval       = problem.auxiliar.fc;
    problem.output.iterations = problem.auxiliar.iteration;
    problem.output.funcEval   = problem.auxiliar.funcEval;
    problem.output.exitflag   = problem.auxiliar.exitflag;
    problem.output.iterHist   = problem.output.iterHist(1:problem.auxiliar.iteration+1,:);
    problem.output.xHist      = problem.output.xHist(1:problem.auxiliar.iteration+1,:);

%% Display final solution
    fprintf(problem.output.message{problem.output.exitflag});
    fprintf('\t\t x \t\t\t f(x) \n');
    fprintf('\t\t  %-+4.3f\t  %-+4.3e \n', [problem.output.x, problem.output.fval]');
    fprintf('\n');

end % *** END FUNCTION % **************************************************************************************************************************************
    