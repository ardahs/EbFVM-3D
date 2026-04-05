function [problem] = nsold_createAuxiliar(problem)
% Function  : Create structure collecting auxiliar variables for the nsold algorithm
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	problem ........... updated data structure with the problem definition
%
% *************************************************************************************************************************************************************

%% General variables
    auxiliar.iteration = 0;
    auxiliar.funcEval  = 0;
    auxiliar.exitflag  = 1;
    auxiliar.jac_age   = 0;
    auxiliar.armflag   = 0;

%% Initial iterate and compute the stop tolerance
    auxiliar.n        = length(problem.x0);
    auxiliar.xc       = problem.x0;
    auxiliar.fc       = feval(problem.fun,problem.x0);
    auxiliar.funcEval = auxiliar.funcEval + 1;    
    auxiliar.fnrm     = norm(auxiliar.fc);
    auxiliar.fnrmo    = 1;
    auxiliar.jac      = problem.options.jacobian;
    auxiliar.itsham   = problem.options.Isham;
    auxiliar.stop_tol = (problem.options.TolFunAbs + problem.options.TolFunRel*auxiliar.fnrm);
    
%% Direction and step
    auxiliar.direction = [];
    auxiliar.step      = [];

%% Update structure problem
    problem.auxiliar = auxiliar;
    
end % *** END FUNCTION % **************************************************************************************************************************************
