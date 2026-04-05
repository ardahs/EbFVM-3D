function [problem] = brsola_createAuxiliar(problem)
% Function  : Create structure collecting auxiliar variables for the nsold algorithm
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	problem ........... updated data structure with the problem definition
%
% *************************************************************************************************************************************************************

%% Auxiliar variable
    maxdimBroyden = problem.options.maxdimBroyden;

%% General variables
    auxiliar.iteration = 0;
    auxiliar.nbroy     = 0;
    auxiliar.funcEval  = 0;
    auxiliar.exitflag  = 1;

%% Initial iterate and compute the stop tolerance
    auxiliar.n        = length(problem.x0);
    auxiliar.xc       = problem.x0;
    auxiliar.fc       = feval(problem.fun,problem.x0);
    auxiliar.funcEval = auxiliar.funcEval + 1;    
    auxiliar.fnrm     = norm(auxiliar.fc);
    auxiliar.fnrmo    = 1;
    auxiliar.stop_tol = (problem.options.TolFunAbs + problem.options.TolFunRel*auxiliar.fnrm);
    
%% Direction and step
    auxiliar.step        = zeros(auxiliar.n,maxdimBroyden);
    auxiliar.step_norm   = zeros(maxdimBroyden,1);
    auxiliar.lambda_hist = ones(maxdimBroyden,1);

%% Update structure problem
    problem.auxiliar = auxiliar;
    
end % *** END FUNCTION % **************************************************************************************************************************************
