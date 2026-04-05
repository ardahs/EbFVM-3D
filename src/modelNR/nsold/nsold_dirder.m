function [z, funcEval] = nsold_dirder(problem, xc, w, fc, funcEval)
% Function  : Compute a finite difference directional derivative
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
%
% *** OUTPUTS *************************************************************************************************************************************************
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 27, 2001
% This code comes with no guarantee or warranty of any kind.
% *************************************************************************************************************************************************************

%% Internal control parameters
    epsnew   = problem.options.FinDiffRelStep;
    TypicalX = problem.options.TypicalX;
    n        = problem.auxiliar.n;
    
%% Scale the step
    if (norm(w) == 0)
        z = zeros(n,1);
        return
    end
    
%% Now scale the difference increment.
    xs = (xc'*w)/norm(w);
    if (xs ~= 0.d0)
        epsnew=epsnew*max(abs(xs),TypicalX)*sign(xs);
    end
    epsnew=epsnew/norm(w);
    
%% del and f1 could share the same space if storage is more important than clarity
    del      = xc+epsnew*w;
    f1       = feval(problem.fun,del);
    funcEval = funcEval + 1;
    z        = (f1 - fc)/epsnew;

end % *** END FUNCTION % **************************************************************************************************************************************
