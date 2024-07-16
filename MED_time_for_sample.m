function time = MED_time_for_sample(sample_number, MED_directory, varargin)

    %
    %   MED_time_for_sample() requires 2 to 3 inputs
    %
    %   Prototype:
    %   time = MED_time_for_sample(sample_number, MED_directory, [password]);
    %
    %   MED_time_for_sample() returns a time for a specified sample number
    %
    %   Arguments in square brackets are optional => '[]' will substitute default values
    %
    %   Input Arguments:
    %   sample_number:  integer specifying sample_number in Matlab index schema: (1:n) rather than 0:(n-1)
    %   ('start' & 'end' are also accepted)
    %   MED_directory:  string specifying channel or session
    %   password:  if empty/absent, proceeds as if unencrypted (but, may error out)
    %         
    %   Copyright Dark Horse Neuro, 2024


    time = [];
    if nargin < 2 || nargin > 3 || nargout ~=  1
        help MED_time_for_sample;
        return;
    end

    MED_directory = get_full_paths(MED_directory);

    %   Enter DEFAULT_PASSWORD here for convenience, if doing does not violate your privacy requirements
    DEFAULT_PASSWORD = [];
    if nargin == 3
        password = varargin{1};
    else
        password = DEFAULT_PASSWORD;
    end
    if isstring(password)
        password = char(password);
    end
  

    try
        time = MED_time_for_sample_exec(sample_number, MED_directory, password);
        if (isempty(sample_number))
            errordlg('MED_sample_for_time() error', 'Read MED');
            return;
        end
    catch ME
        OS = computer;
        if (strcmp(OS, 'PCWIN64') == 1)
            DIR_DELIM = '\';
        else
            DIR_DELIM = '/';
        end
        switch ME.identifier
            case 'MATLAB:UndefinedFunction'
                [READ_MED_PATH, ~, ~] = fileparts(which('read_MED'));
                RESOURCES = [READ_MED_PATH DIR_DELIM 'Resources'];
                addpath(RESOURCES, READ_MED_PATH, '-begin');
                savepath;
                msg = ['Added ', RESOURCES, ' to your search path.' newline];
                beep
                fprintf(2, '%s', msg);  % 2 == stderr, so red in command window
                sample_number = MED_time_for_sample_exec(sample_number, MED_directory, password);
            otherwise
                rethrow(ME);
        end
    end
    
end
