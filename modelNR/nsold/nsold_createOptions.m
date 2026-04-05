function [options] = nsold_createOptions()
% Function  : Create structure collecting standard options for nsold algorithm
%
% *** INPUTS **************************************************************************************************************************************************
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	options ........... data structure with standard options for nsold algorithm
%
% *************************************************************************************************************************************************************

%% General options
    options.Algorithm = 'newton-direct';
    options.MaxIter   = 40;
    
%% Tolerance options    
    options.TolFunAbs = 1e-3;
    options.TolFunRel = 0;

%% Jacobian calculation options
    options.jacobian       = [];
    options.FinDiffRelStep = 1e-3;
    options.TypicalX       = 1e-2;
    options.Isham          = 1;
    options.Rsham          = 0;
    options.Jdiff          = 1;
    options.nl             = 0;
    options.nu             = 0;
    
%% Line search options    
    options.alpha  = 1e-4;
    options.sigma0 = 0.1;
    options.sigma1 = 0.5;
    options.maxarm = 20;
    
end % *** END FUNCTION % **************************************************************************************************************************************
