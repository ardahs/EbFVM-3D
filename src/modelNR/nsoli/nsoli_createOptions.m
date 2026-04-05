function [options] = nsoli_createOptions()
% Function  : Create structure collecting standard options for nsoli algorithm
%
% *** INPUTS **************************************************************************************************************************************************
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	options ........... data structure with standard options for nsoli algorithm
%
% *************************************************************************************************************************************************************

%% General options
    options.Algorithm = 'newton-krylov';
    options.MaxIter   = 40;
    options.gamma     = 0.9;

%% Tolerance options    
    options.TolFunAbs = 1e-3;
    options.TolFunRel = 0;

%% Jacobian calculation options
    options.FinDiffRelStep = 1e-3;
    options.TypicalX       = 1e-2;
    options.etamax         = 0.9;
    options.MaxIterInn     = 40;
    options.lmeth          = 1;
    options.restart_limit  = 20;

%% Line search options    
    options.alpha  = 1e-4;
    options.sigma0 = 0.1;
    options.sigma1 = 0.5;
    options.maxarm = 20;
    
end % *** END FUNCTION % **************************************************************************************************************************************
