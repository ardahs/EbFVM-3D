function [AC] = NUIS_hexa(qC)
% *************************************************************************************************************************************************************
% Calculate convective matrix considering the Nodal Upwind Scheme (NUIS)
% used into the EbFVM discretisation for linear hexahedral elements
% 
% Integration point to SCV connectivity
%   ip_mapping(ip,:) = [donor_SCV, receiver_SCV] for positive flux at ip
%
%   ip_mapping(ip,:) = [donor_SCV, receiver_SCV] for positive flux at ip
%
%   SCV1: Inflow from pI4      ; Outflow through pI1  and pI9
%   SCV2: Inflow from pI1      ; Outflow through pI2  and pI10
%   SCV3: Inflow from pI2      ; Outflow through pI3  and pI11
%   SCV4: Inflow from pI3      ; Outflow through pI4  and pI12
%   SCV5: Inflow from pI8, pI9 ; Outflow through pI5
%   SCV6: Inflow from pI5, pI10; Outflow through pI6
%   SCV7: Inflow from pI6, pI11; Outflow through pI7
%   SCV8: Inflow from pI7, pI12; Outflow through pI8
% *************************************************************************************************************************************************************

%% Validate input
    if ~isnumeric(qC) || numel(qC) ~= 12
        error('Invalid input: qC must be a numeric 12x1 vector.');
    end

%% Updated inflow-outflow integration point mappings for SCVs
    ip_mapping = [
        1, 2;   % pI1:  outflow from SCV1 to SCV2
        2, 3;   % pI2:  outflow from SCV2 to SCV3
        3, 4;   % pI3:  outflow from SCV3 to SCV4
        4, 1;   % pI4:  outflow from SCV4 to SCV1
        5, 6;   % pI5:  outflow from SCV5 to SCV6
        6, 7;   % pI6:  outflow from SCV6 to SCV7
        7, 8;   % pI7:  outflow from SCV7 to SCV8
        8, 5;   % pI8:  outflow from SCV8 to SCV5
        1, 5;   % pI9:  outflow from SCV1 to SCV5
        2, 6;   % pI10: outflow from SCV2 to SCV6
        3, 7;   % pI11: outflow from SCV3 to SCV7
        4, 8;   % pI12: outflow from SCV4 to SCV8
    ];

%% Calculate convective matrix
    AC = zeros(8, 8);
    for ip = 1:12
        flux = qC(ip);
        if flux == 0; continue; end
        % Determine donor and receiver based on flux sign
        if flux > 0
            donor    = ip_mapping(ip, 1);
            receiver = ip_mapping(ip, 2);
        else
            donor    = ip_mapping(ip, 2);
            receiver = ip_mapping(ip, 1);
            flux     = abs(flux);
        end
        % Update the convective coefficient matrix
        AC(donor,    donor) = AC(donor,    donor) - flux;
        AC(receiver, donor) = AC(receiver, donor) + flux;
    end
    
end % *** END FUNCTION % **************************************************************************************************************************************