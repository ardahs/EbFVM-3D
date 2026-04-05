function [options] = nsolver_createOptions(solverType)
% Function  : Create structure collecting standard options for nsolver algorithms
%
% *** INPUTS **************************************************************************************************************************************************
% 	solverType ........... type of the solver
%       'newton-direct'
%       'newton-krylov'
%       'newton-broyden'
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	options ........... data structure with options for nsolver algorithms
%
% *************************************************************************************************************************************************************

%% Create problem definition for nsolver algorithms
    switch solverType
            case 'newton-direct'           % Newton's method with direct factorization of Jacobians
                options = nsold_createOptions();
            case 'newton-krylov'           % Inexact Newton-Krylov methods without matrix storage
                options = nsoli_createOptions();
            case 'newton-broyden'          % Broyden's method (NOT WORKING)
                options = brsola_createOptions();
        otherwise
            error('Unknown Newton''s solver');
    end

end % *** END FUNCTION % **************************************************************************************************************************************
