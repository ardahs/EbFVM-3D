function [AC] = NUIS_tria(qC)
% *************************************************************************************************************************************************************
% Calculate convective matrix considering the Nodal Upwind Scheme (NUIS)
% used into the EbFVM discretisation for linear triangular prism elements
% 
% Integration point to SCV connectivity
%   ip_mapping(ip,:) = [donor_SCV, receiver_SCV] for positive flux at ip
%
%   SCV1: Inflow from pI3     ; Outflow through pI1 and pI7
%   SCV2: Inflow from pI1     ; Outflow through pI2 and pI8
%   SCV3: Inflow from pI2     ; Outflow through pI3 and pI9
%   SCV4: Inflow from pI6, pI7; Outflow through pI4
%   SCV5: Inflow from pI4, pI8; Outflow through pI5
%   SCV6: Inflow from pI5, pI9; Outflow through pI6
% *************************************************************************************************************************************************************

%% Validate input
    if ~isnumeric(qC) || numel(qC) ~= 9
        error('Invalid input: qC must be a numeric 9x1 vector.');
    end

%% Updated inflow-outflow integration point mappings for SCVs
    ip_mapping = [
        1, 2;   % pI1: outflow from SCV1 to SCV2
        2, 3;   % pI2: outflow from SCV2 to SCV3
        3, 1;   % pI3: outflow from SCV3 to SCV1
        4, 5;   % pI4: outflow from SCV4 to SCV5
        5, 6;   % pI5: outflow from SCV5 to SCV6
        6, 4;   % pI6: outflow from SCV6 to SCV4
        1, 4;   % pI7: outflow from SCV1 to SCV4
        2, 5;   % pI8: outflow from SCV2 to SCV5
        3, 6;   % pI9: outflow from SCV3 to SCV6
    ];

%% Calculate convective matrix
    AC = zeros(6, 6);
    for ip = 1:9
        flux = qC(ip);
        if flux == 0; continue; end
        % Determine donor and receiver based on flux sign
        if flux > 0
            donor    = ip_mapping(ip, 1);
            receiver = ip_mapping(ip, 2);
        else
            donor    = ip_mapping(ip, 2);
            receiver = ip_mapping(ip, 1);
            flux     = -flux;
        end
         % Update the convective coefficient matrix
        AC(donor,    donor) = AC(donor,    donor) - flux;
        AC(receiver, donor) = AC(receiver, donor) + flux;
    end
    
end % *** END FUNCTION % **************************************************************************************************************************************