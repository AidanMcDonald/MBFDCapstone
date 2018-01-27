function output = PowerConversion(input)
% This function calculates the temperatures and pressures in a combined.
% Inputs can be single values for steady state operation or a vector in
% time for transient operation.
% Authors: Aidan McDonald

% Check if given an input time vector
if isfield(input,'t')
    t = input.t;
else
    t = [0];
end

% Initialize state object to empty structure array
state = struct();

for i = 1:length(t) % Loop through time vector
    fields = fieldnames(state); % Get all fields present in state
    if ~(i==1) % If we arent at the first point
        for j = 1:numel(fields)
            state.(fields{j})(i) = state.(fields{j})(i-1); % Shift all state variables forward (to get inputs. Variables that change will be overwritten later)
        end
    end
    
    %% Update Brayton cycle states at time i
    % Assemble input for Brayton function
    % For each possible input, check if we have it, and if so, check that
    % it has the correct length. If it doesn't, spit out a warning and use
    % the default.
    braytonInput = struct();
    if isfield(input,'B_beta')
        if length(input.B_beta)==length(t)
            braytonInput.beta = input.B_beta(i);
        elseif length(input.B_beta)==1
            braytonInput.beta = input.B_beta;
        else
            warning('Invalid input: Input for beta has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_P_1'))
        if length(input.B_P_1)==length(t)
            braytonInput.P_1 = input.B_P_1(i);
        elseif length(input.B_P_1)==1
            braytonInput.P_1 = input.B_P_1;
        else
            warning('Invalid input: Input for B_P_1 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_T_1'))
        if length(input.B_T_1)==length(t)
            braytonInput.T_1 = input.B_T_1(i);
        elseif length(input.B_T_1)==1
            braytonInput.T_1 = input.B_T_1;
        else
            warning('Invalid input: Input for B_T_1 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_T_3'))
        if length(input.B_T_3)==length(t)
            braytonInput.T_3 = input.B_T_3(i);
        elseif length(input.B_T_3)==1
            braytonInput.T_3 = input.B_T_3;
        else
            warning('Invalid input: Input for B_T_3 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_T_5'))
        if length(input.B_T_5)==length(t)
            braytonInput.T_5 = input.B_T_5(i);
        elseif length(input.B_T_5)==1
            braytonInput.T_5 = input.B_T_5;
        else
            warning('Invalid input: Input for B_T_5 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_eta_C'))
        if length(input.B_eta_C)==length(t)
            braytonInput.eta_C = input.B_eta_C(i);
        elseif length(input.B_eta_C)==1
            braytonInput.eta_C = input.B_eta_C;
        else
            warning('Invalid input: Input for B_eta_C has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_eta_T1'))
        if length(input.B_eta_T1)==length(t)
            braytonInput.eta_T1 = input.B_eta_T1(i);
        elseif length(input.B_eta_T1)==1
            braytonInput.eta_T1 = input.B_eta_T1;
        else
            warning('Invalid input: Input for B_eta_T1 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_eta_T2'))
        if length(input.B_eta_T2)==length(t)
            braytonInput.eta_T2 = input.B_eta_T2(i);
        elseif length(input.B_eta_T2)==1
            braytonInput.eta_T2 = input.B_eta_T2;
        else
            warning('Invalid input: Input for B_eta_T2 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_Wdot_T2'))
        if length(input.B_Wdot_T2)==length(t)
            braytonInput.Wdot_T2 = input.B_Wdot_T2(i);
        elseif length(input.B_Wdot_T2)==1
            braytonInput.Wdot_T2 = input.B_Wdot_T2;
        else
            warning('Invalid input: Input for B_Wdot_T2 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_deltaP_1'))
        if length(input.B_deltaP_1)==length(t)
            braytonInput.deltaP_1 = input.B_deltaP_1(i);
        elseif length(input.B_deltaP_1)==1
            braytonInput.deltaP_1 = input.B_deltaP_1;
        else
            warning('Invalid input: Input for B_deltaP_1 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_deltaP_2'))
        if length(input.B_deltaP_2)==length(t)
            braytonInput.deltaP_2 = input.B_deltaP_2(i);
        elseif length(input.B_deltaP_2)==1
            braytonInput.deltaP_2 = input.B_deltaP_2;
        else
            warning('Invalid input: Input for B_deltaP_2 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_mdot'))
        if length(input.B_mdot)==length(t)
            braytonInput.mdot = input.B_mdot(i);
        elseif length(input.B_mdot)==1
            braytonInput.mdot = input.B_mdot;
        else
            warning('Invalid input: Input for B_mdot has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'B_c_p'))
        if length(input.B_c_p)==length(t)
            braytonInput.c_p = input.B_c_p(i);
        elseif length(input.B_c_p)==1
            braytonInput.c_p = input.B_c_p;
        else
            warning('Invalid input: Input for B_c_p has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    % Run Brayton function
    braytonOutput = Brayton(braytonInput);
    
    % Update state variables at t(i) with output from Brayton function
    % Overwrite old values
    state.B_P_1(i) = braytonOutput.P_1;
    state.B_T_1(i) = braytonOutput.T_1;
    state.B_P_2(i) = braytonOutput.P_2;
    state.B_T_2(i) = braytonOutput.T_2;
    state.B_P_3(i) = braytonOutput.P_3;
    state.B_T_3(i) = braytonOutput.T_3;
    state.B_P_4(i) = braytonOutput.P_4;
    state.B_T_4(i) = braytonOutput.T_4;
    state.B_P_5(i) = braytonOutput.P_5;
    state.B_T_5(i) = braytonOutput.T_5;
    state.B_P_6(i) = braytonOutput.P_6;
    state.B_T_6(i) = braytonOutput.T_6;
    
    %% Update Rankine cycle states at time i
    % Assemble input for Rankine function
    % For each possible input, check if we have it, and if so, check that
    % it has the correct length. If it doesn't, spit out a warning and use
    % the default.
    rankineInput = struct();
    
    if(isfield(input,'R_P_5'))
        if length(input.R_P_5)==length(t)
            braytonInput.P_5 = input.R_P_5(i);
        elseif length(input.R_P_5)==1
            braytonInput.P_5 = input.R_P_5;
        else
            warning('Invalid input: Input for R_P_5 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'R_P_1'))
        if length(input.R_P_1)==length(t)
            rankineInput.P_1 = input.R_P_1(i);
        elseif length(input.R_P_1)==1
            rankineInput.P_1 = input.R_P_1;
        else
            warning('Invalid input: Input for R_P_1 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'R_T_4'))
        if length(input.R_T_4)==length(t)
            rankineInput.T_4 = input.R_T_4(i);
        elseif length(input.R_T_4)==1
            rankineInput.T_4 = input.R_T_4;
        else
            warning('Invalid input: Input for R_T_4 has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'R_eta_T'))
        if length(input.R_eta_T)==length(t)
            rankineInput.eta_T = input.R_eta_T(i);
        elseif length(input.R_eta_T)==1
            rankineInput.eta_T = input.R_eta_T;
        else
            warning('Invalid input: Input for R_eta_T has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    if(isfield(input,'R_eta_P'))
        if length(input.R_eta_P)==length(t)
            rankineInput.eta_P = input.R_eta_P(i);
        elseif length(input.R_eta_P)==1
            rankineInput.eta_P = input.R_eta_P;
        else
            warning('Invalid input: Input for R_eta_P has different length than t. Must be a scalar or a vector with length = length(t). It has been set to default value.')
        end
    end
    
    rankineInput.T_airIn = braytonOutput.T_6;
    
    if(isfield(input,'R_deltaT_pp'))
        rankineInput.deltaT_pp = input.R_deltaT_pp; % [K]
    else
        rankineInput.deltaT_pp = 25; % [K]
    end
    
    % Run Rankine function
    rankineOutput = Rankine(rankineInput);
    
    % Update state(i) with output from Rankine function
    % Overwrite old values
    state.R_P_1(i) = rankineOutput.P_1;
    state.R_T_1(i) = rankineOutput.T_1;
    state.R_h_1(i) = rankineOutput.h_1;
    state.R_P_4(i) = rankineOutput.P_4;
    state.R_T_4(i) = rankineOutput.T_4;
    state.R_h_4(i) = rankineOutput.h_4;
    state.R_P_5(i) = rankineOutput.P_5;
    state.R_T_5(i) = rankineOutput.T_5;
    state.R_h_5(i) = rankineOutput.h_5;
    state.R_P_6(i) = rankineOutput.P_6;
    state.R_T_6(i) = rankineOutput.T_6;
    state.R_h_6(i) = rankineOutput.h_6;
    
end
% Put time vector into output
state.t = t;
output = state;
end