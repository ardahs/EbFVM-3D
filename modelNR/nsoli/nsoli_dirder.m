function [z, funcEval] = nsoli_dirder(problem, xc, w, fc, funcEval)
% Function  : Compute a finite difference directional derivative ( approximate f'(xc)w )
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%   xc ................ current point solution
%   w ................. direction
%   fc ................ current function solution
% 	funcEval .......... function evaluation count
%
% *** OUTPUTS *************************************************************************************************************************************************
% 	funcEval .......... updated function evaluation count
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 1, 2003
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
        epsnew = epsnew*max(abs(xs),TypicalX)*sign(xs);
    end
    epsnew = epsnew/norm(w);
    
%% del and f1 could share the same space if storage is more important than clarity.
    del      = xc+epsnew*w;
    f1       = feval(problem.fun,del);
    funcEval = funcEval + 1;
    z        = (f1 - fc)/epsnew;
    
end % *** END FUNCTION % **************************************************************************************************************************************
