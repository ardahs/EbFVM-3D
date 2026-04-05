function [] = PostProcessing(InfoSim)
% *************************************************************************************************************************************************************
% Post-process and visualise solution fields
%
% This routine extracts the main 2D and mid-plane 3D solution variables,
% rescales them to physical units, and plots them over the computational domain
%
% Fields displayed:
%   1. Film thickness
%   2. Hydrodynamic pressure
%   3. Mid-plane fluid temperature
%   4. Lubricant fraction
% *************************************************************************************************************************************************************

%% Red-white-blue colormap
    cmap = [
        0.0235    0.1804    0.3804
        0.1333    0.3961    0.6784
        0.2588    0.5843    0.7569
        0.5765    0.7725    0.8627
        0.8353    0.8863    0.9412
        0.9608    0.9765    0.9529
        0.9961    0.8588    0.7882
        0.9686    0.6471    0.5020
        0.8431    0.3725    0.3059
        0.7098    0.0902    0.1843
        0.4078    0.0039    0.1137
    ];

%% Extract simulation structures
    D2 = InfoSim.BSGridCFD.BSGridCFD_2D;
    D3 = InfoSim.BSGridCFD.BSGridCFD_3D;
    M  = InfoSim.BSModels.modelBearing;

%% Extract 2D nodal fields

    coords2D  = D2.nodes.coords;
    faces2D   = D2.elements.nodesConnec;

    filmThk   = D2.nodes.H2H1   .* (M.parametersBearing.radialClearance ./ 1e-6);
    pHydro    = D2.nodes.pHydro .* (M.dimensionless.df_p ./ 1e6);
    theta     = D2.nodes.thetaHydro;

%% Scale coordinates to physical dimensions
    R_mm = M.parametersBearing.bearingRadius * 1e3;
    W_mm = 0.5 * M.parametersBearing.bearingWidth * 1e3;
    XY   = [coords2D(:,1) * R_mm, coords2D(:,2) * W_mm];

%% Extract mid-plane temperature field from the 3D mesh
    z               = D3.nodes.coords(:,3);
    midZ            = 0.5;
    absDifferences  = abs(z - midZ);
    minDifference   = min(absDifferences);
    midPlaneIndices = find(absDifferences == minDifference);

    if length(midPlaneIndices) > length(coords2D(:,1))
        upperIndices = midPlaneIndices(z(midPlaneIndices) > midZ);

        if ~isempty(upperIndices)
            midPlaneIndices = upperIndices;
        else
            midPlaneIndices = midPlaneIndices(1:length(coords2D(:,1)));
        end
    end

    if isempty(midPlaneIndices)
        error('No nodes found near the mid-plane.');
    end

    Tfield = D3.nodes.T_fluid(midPlaneIndices);

%% Define fields to be plotted
    data = {
        filmThk,  'Film thickness ($\mu$m)',           '$h$ ($\mu$m)';
        pHydro,   'Hydrodynamic pressure (MPa)',       '$p$ (MPa)';
        Tfield,   'Mid-plane temperature ($^\circ$C)', '$T$ ($^\circ$C)';
        theta,    'Lubricant fraction ($-$)',          '$\theta$ (–)';
    };

%% Create figure and tiled layout
    figure('Color','w', 'Units', 'normalized', 'Position', [0.1 0.3 0.5 0.5]);
    tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

%% Plot all fields
    for k = 1:4
        nexttile

        patch('Vertices', [XY, data{k,1}], ...
              'Faces', faces2D, ...
              'EdgeColor', 'k', ...
              'FaceColor', 'interp', ...
              'FaceVertexCData', data{k,1});

        view(0,90)
        colormap(cmap)
        axis tight

        cb = colorbar;
        set(cb, 'TickLabelInterpreter','latex');

        title(data{k,2}, 'Interpreter','latex', 'FontSize',15)
        xlabel('$x$ (mm)', 'Interpreter','latex', 'FontSize',15)
        ylabel('$y$ (mm)', 'Interpreter','latex', 'FontSize',15)

        set(gca, 'View', [0 90], 'Colormap', cmap, ...
            'Box', 'on', 'Color', 'none', 'LineWidth', 0.5, 'TickDir', 'in', 'FontSize', 13, ...
            'XGrid', 'off', 'XLimitMethod', 'tight', ...
            'YGrid', 'off', 'YLimitMethod', 'tight', ...
            'ZGrid', 'off', 'ZLimitMethod', 'tickaligned');
    end

end % *** END FUNCTION % **************************************************************************************************************************************