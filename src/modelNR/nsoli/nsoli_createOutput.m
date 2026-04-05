function [problem] = nsoli_createOutput(problem)
% Function  : Create structure collecting outputs for nsoli algorithm
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	problem ........... updated data structure with the problem definition
%
% *************************************************************************************************************************************************************


%% Define further problem variables
    n     = problem.auxiliar.n;
    maxit = problem.options.MaxIter;
    
%% Create output structure
	output.x          = [];
    output.fval       = [];
    output.iterations = [];
    output.funcEval   = [];
    output.exitflag   = [];
    output.iterHist   = zeros(maxit+1,4);
    output.xHist      = zeros(maxit+1,n+1);
    output.message{1} = '   *** Successful Convergence *** \n';
    output.message{2} = '   *** Convergence Criterion NOT Satisfied After Maximum Iterations *** \n';
    output.message{3} = '   *** Convergence Failure in the Line Search *** \n';
    output.message{4} = '   *** Convergence Failure in the Krylov Linear Solver *** \n';
    
%% Update structure problem
    problem.output = output;
    
end % *** END FUNCTION % **************************************************************************************************************************************
