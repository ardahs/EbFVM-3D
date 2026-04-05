function [BSModels, BSGridCFD_2D, BSGridCFD_3D] = staticJBR(BSModels, BSGridCFD_2D, BSGridCFD_3D)
% *************************************************************************************************************************************************************
% Run the static simulation of a general rigid misaligned journal bearing
% *************************************************************************************************************************************************************

%% Instantaneous equilibrium equations of the rigid body solver (implicit method)
    function [F] = solverInstantaneousRigidBodyEquilibrium(q_t)
        % Set instantaneous degrees of freedom 
            BSModels.numericalOptions.solverStatic.Xr = q_t(1);    % q_t(1) = Xr
            BSModels.numericalOptions.solverStatic.Yr = q_t(2);    % q_t(2) = Yr
            BSModels.numericalOptions.solverStatic.Ar = q_t(3);    % q_t(3) = Ar
            BSModels.numericalOptions.solverStatic.Br = q_t(4);    % q_t(4) = Br
        % Update kinematic of the lubricant film (geometry of the lubricant film)
            [BSGridCFD_2D, BSGridCFD_3D] = lubricantFilmThickness(BSGridCFD_2D, BSGridCFD_3D, BSModels);
        % Instantaneous hydrodynamic solver
            [BSGridCFD_2D, BSGridCFD_3D] = GRE_EbFVM(BSModels, BSGridCFD_2D, BSGridCFD_3D);
        % Calculation of the instantaneous hydrodynamic loads
            BSModels.modelBearing = Hydrodynamic_ForcesNormal(BSModels.modelBearing, BSGridCFD_2D);
            BSModels.modelBearing = Hydrodynamic_MomentsNormal(BSModels.modelBearing, BSGridCFD_2D);                
            P_t_HYDRO = [BSModels.modelBearing.results.hydrodynamic.WX_j(1,2); ...
                         BSModels.modelBearing.results.hydrodynamic.WY_j(1,2); ...
                         BSModels.modelBearing.results.hydrodynamic.MX_j(1,2); ...
                         BSModels.modelBearing.results.hydrodynamic.MY_j(1,2)];
        % Calculate equilibrium equation
            F = (P_t_HYDRO + Fext);
    end

%% Rigid body solver
    function [q, qp, qpp] = solverRigidBody(q00)
        % Start display
            fprintf('--------------------------------------------------------------------- \n');
            fprintf('   Rigid Body Solver \n' );
            fprintf('---------------------------------------------------------------------   ');
        % Auxiliary variables
            solverControl_RB_maxX0     = 3;
            solverControl_RB_maxStepFD = 6;
            alpha_X0                   = 0.9;
            alpha_StepFD               = 10;
        % Rigid body equilibrium solution
            for numX0 = 1:solverControl_RB_maxX0
                q_s0 = (alpha_X0^(numX0-1))*q00;
                for numStepFD = 1:solverControl_RB_maxStepFD
                    problem_RB.x0                     = q_s0;
                    problem_RB.options.FinDiffRelStep = (alpha_StepFD^(-numStepFD+1))*options_RB.FinDiffRelStep;
                    problem_RB.options.TolFunAbs      = norm(Fext)*options_RB.TolFunAbs;
                    problem_RB = nsolver(problem_RB);
                    q_s0 = problem_RB.output.x;
                    if (problem_RB.output.exitflag == 1)
                        q   = problem_RB.output.x;
                        qp  = [];
                        qpp = [];
                        return
                    end
                end
            end
    end

%% Define rigid body equilibrium problem
    % Options of the static solver
        options_RB                = nsolver_createOptions('newton-direct');
        options_RB.FinDiffRelStep = BSModels.numericalOptions.solverStatic.FinDiffRelStep;
        options_RB.MaxIter        = BSModels.numericalOptions.solverStatic.MaxIter;
        options_RB.TolFunAbs      = BSModels.numericalOptions.solverStatic.TolFun;
        options_RB.TypicalX       = BSModels.numericalOptions.solverStatic.TypicalX;
        options_RB.maxarm         = 10;
    % Create static problem
        problem_RB.options        = options_RB;
        problem_RB.x0             = [BSModels.numericalOptions.solverStatic.Xr0; BSModels.numericalOptions.solverStatic.Yr0; BSModels.numericalOptions.solverStatic.Ar0; BSModels.numericalOptions.solverStatic.Br0];
        problem_RB.fun            = (@(q_t) solverInstantaneousRigidBodyEquilibrium(q_t));
        problem_RB.funJAC         = (@(q_t) solverInstantaneousRigidBodyEquilibrium(q_t));
        problem_RB.funConstr      = (@(direction, q_t) direction);

%% STATIC SOLUTION
    Fext = [BSModels.modelLoads.forceX_j;  ...
            BSModels.modelLoads.forceY_j;  ...
            BSModels.modelLoads.momentX_j; ...
            BSModels.modelLoads.momentY_j];
    [~, ~, ~] = solverRigidBody(problem_RB.x0);

end % *************************************************************************************************************************************************************
