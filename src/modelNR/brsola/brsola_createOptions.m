function [options] = brsola_createOptions()
% Function  : Create structure collecting standard options for brsola algorithm
%
% *** INPUTS **************************************************************************************************************************************************
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	options ........... data structure with standard options for brsola algorithm
%
% *************************************************************************************************************************************************************

%% General options
    options.Algorithm = 'newton-broyden';
    options.MaxIter   = 40;

%% Tolerance options    
    options.TolFunAbs = 1e-3;
    options.TolFunRel = 0;

%% Jacobian calculation options
    options.maxdimBroyden  = 40;
    
%% Line search options    
    options.alpha  = 1e-4;
    options.sigma0 = 0.1;
    options.sigma1 = 0.5;
    options.maxarm = 20;
    
end % *** END FUNCTION % **************************************************************************************************************************************
