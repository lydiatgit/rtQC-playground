function matlabbatch = wrapper_physiobatch(data_vendor, out_dir, default_path, gui_data)
    spm_jobman('initcfg');
    global defaults
    defaults.stats.maxmem   = 2^30;
    matlabbatch = {};
    
    matlabbatch{1}.spm.tools.physio.log_files.vendor = data_vendor;

% FOR TESTING:
% EXAMPLES IN C:\Users\nwiedemann\Downloads\tapas\tapas\misc\example\PhysIO   
%     matlabbatch{1}.spm.tools.physio.log_files.cardiac = {'C:\Users\nwiedemann\Downloads\tapas\tapas\misc\example\PhysIO\BIDS\CPULSE3T\sub-s998_task-random_run-99_physio.tsv'}; 
%     matlabbatch{1}.spm.tools.physio.log_files.respiration = {''}; 
%     matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''};
    % different vendor options require different file input
    if strcmp(data_vendor, 'BIDS')
        [tsv_filename, file_path] = uigetfile('*.tsv*','Specify tsv/tsv.gz file with ECG data',default_path);
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {fullfile(file_path, tsv_filename)}; 
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {''}; 
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''};
    elseif strcmp(data_vendor, 'Philips')
        [scanphyslog, file_path] = uigetfile('*.log','Specify SCANPHYSLOG.log file', default_path);
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {fullfile(file_path, scanphyslog)}; 
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {fullfile(file_path, scanphyslog)}; 
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {fullfile(file_path, scanphyslog)}; % or empty?
    elseif strcmp(data_vendor, 'Biopac_Txt')
        [scanphyslog, file_path] = uigetfile('*.txt','Specify biopac data export txt file', default_path);
        % scanphyslog = input('Specify file path to the biopac data export txt file', 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {fullfile(file_path, scanphyslog)}; 
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {fullfile(file_path, scanphyslog)}; 
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {fullfile(file_path, scanphyslog)};
     elseif strcmp(data_vendor, 'GE')
        [cardiac, file_path1] = uigetfile('*.*','Specify cardiac file (starting with ECGData_)', default_path);
        % cardiac = input('Specify file path to the cardiac file (in template starting with ECGData_)', 's');
        [respiration, file_path2] = uigetfile('*.*','Specify respiration file (starting with RespData_)', default_path);
        % respiration = input('Specify file path to the respiration file (in template starting with RespData_)', 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {fullfile(file_path1, cardiac)};
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {fullfile(file_path2, respiration)};
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''};
     elseif strcmp(data_vendor, 'Siemens_HCP')
        [physiolog, file_path] = uigetfile('*.*','Specify physio data file (sth like tfMRI_MOTOR_LR_Physio_log.txt)', default_path);
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {fullfile(file_path, physiolog)};
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {fullfile(file_path, physiolog)};
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''};
     elseif strcmp(data_vendor, 'Siemens')
        [physiolog, file_path] = uigetfile('*.ecg','Specify physio data file (siemens_PAV.ecg)', default_path);
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {fullfile(file_path, physiolog)};
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {''};
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''}; 
     elseif strcmp(data_vendor, 'Siemens_Tics')
        [cardiac, file_path1] = uigetfile('*.log','Specify cardiac file (..._PULS.log)', default_path);
        [respiration, file_path2] = uigetfile('*.log','Specify respiration file (..._RESP.log)', default_path);
        [timing, file_path3] = uigetfile('*.log','Specify scan timing file (..._Info.log)', default_path);
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {fullfile(file_path1, cardiac)};
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {fullfile(file_path2, respiration)};
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {fullfile(file_path3, timing)};
    else
        ME = MException('error:wronginput', 'Wrong vendor specified. Please specify one of BIDS, Philips, Biopac_Txt, GE, Siemens, Siemens_HCP, Siemens_Tics');
        throw(ME);
    end
    
    % read scan parameters
    input_params = inputdlg({'Number of scans:','Number of slices:','Number of dummies:', 'TR:', 'Onset slice:', 'ECG/PPU:'}, 'Parameters for physio', 1, {'30', '40', '0', '2', '1', 'ECG'});
    
    % scan parameters --> input
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nslices = str2double(input_params{2});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.TR = str2double(input_params{4});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Ndummies = str2double(input_params{3});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nscans = str2double(input_params{1});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.onset_slice = str2double(input_params{5});
    % input modality
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.modality = input_params{6};
    
    % parameters from settings tab
    matlabbatch{1}.spm.tools.physio.save_dir = {[out_dir filesep gui_data.edit_physio_save_dir.String]};
    matlabbatch{1}.spm.tools.physio.log_files.sampling_interval = eval(gui_data.edit_log_files_sampling_interval.String);
    matlabbatch{1}.spm.tools.physio.log_files.relative_start_acquisition = str2double(gui_data.edit_log_files_relative_start_acquisition.String);
    matlabbatch{1}.spm.tools.physio.log_files.align_scan = gui_data.edit_log_files_align_scan.String;
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.NslicesPerBeat = eval(gui_data.edit_sqpar_NslicesPerBeat.String);
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.time_slice_to_slice = eval(gui_data.edit_sqpar_time_slice_to_slice.String);
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nprep = eval(gui_data.edit_sqpar_Nprep.String);
    matlabbatch{1}.spm.tools.physio.scan_timing.sync.nominal = struct(eval(gui_data.edit_sync_nominal.String));
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.min = str2double(gui_data.edit_auto_matched_min.String);
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.file = gui_data.edit_auto_matched_file.String;
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.posthoc_cpulse_select.off = struct(eval(gui_data.edit_posthoc_cpulse_select_off.String));
    matlabbatch{1}.spm.tools.physio.model.output_multiple_regressors = gui_data.edit_model_output_multiple_regressors.String;
    matlabbatch{1}.spm.tools.physio.model.output_physio = gui_data.edit_model_output_physio.String;
    matlabbatch{1}.spm.tools.physio.model.orthogonalise = gui_data.edit_model_orthogonalise.String;
    matlabbatch{1}.spm.tools.physio.model.censor_unreliable_recording_intervals = strcmpi(gui_data.edit_model_censor_unreliable_recording_intervals.String, 'true');
    matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.c = str2double(gui_data.edit_order_c.String);
    matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.r = str2double(gui_data.edit_order_r.String);
    matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.cr = str2double(gui_data.edit_order_cr.String);
    matlabbatch{1}.spm.tools.physio.model.rvt.no = struct(eval(gui_data.edit_rvt_no.String));
    matlabbatch{1}.spm.tools.physio.model.hrv.no = struct(eval(gui_data.edit_hrv_no.String));
    matlabbatch{1}.spm.tools.physio.model.noise_rois.no = struct(eval(gui_data.edit_noise_rois_no.String));
    matlabbatch{1}.spm.tools.physio.model.movement.no = struct(eval(gui_data.edit_movement_no.String));
    matlabbatch{1}.spm.tools.physio.model.other.no = struct(eval(gui_data.edit_other_no.String));
    matlabbatch{1}.spm.tools.physio.verbose.level = str2double(gui_data.edit_verbose_level.String);
    matlabbatch{1}.spm.tools.physio.verbose.fig_output_file = gui_data.edit_verbose_fig_output_file.String;
    matlabbatch{1}.spm.tools.physio.verbose.use_tabs = strcmpi(gui_data.edit_verbose_use_tabs.String, 'true');
    
    % check if physio is installed:
    pathCell = regexp(path, pathsep, 'split');
    onPath = any(contains(pathCell, 'PhysIO'));
    if onPath
        spm_jobman('run',matlabbatch);
    else
        % save batch if physio is not installed
        save([out_dir filesep 'physio_batch'], 'matlabbatch');
        % current out_dir: C:\Users\nwiedemann\Downloads\rtQC_sample_data\rtQC_sample_data\sub-hcp\rtQC_output
        % msgbox(['Saved matlabbatch in: ' out_dir], 'Success');
        errordlg('Batch was saved to rtQC_output directory. \n \n Plots could not be created because the Physio toolbox is not installed or not added to path. Follow installation instructions on https://github.com/translationalneuromodeling/tapas.');
    end
end

% matlabbatch{1}.spm.tools.physio.save_dir = {[out_dir filesep 'physio_out']};
%     
%    scan parameters - defaults
%     matlabbatch{1}.spm.tools.physio.log_files.sampling_interval = [];
%     matlabbatch{1}.spm.tools.physio.log_files.relative_start_acquisition = 0;
%     matlabbatch{1}.spm.tools.physio.log_files.align_scan = 'last'; % sometimes first, sometimes last
%     matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.NslicesPerBeat = []; 
%     matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.time_slice_to_slice = []; % eval(gui_data.edit_sqpar_time_slice_to_slice.String);
% 
%     template
%     matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nprep = [];
%     matlabbatch{1}.spm.tools.physio.scan_timing.sync.nominal = struct([]);
%     matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.min = 0.4;
%     matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.file = 'initial_cpulse_kRpeakfile.mat';
%     matlabbatch{1}.spm.tools.physio.preproc.cardiac.posthoc_cpulse_select.off = struct([]);
%     matlabbatch{1}.spm.tools.physio.model.output_multiple_regressors = 'retroicor_regressors.txt';
%     matlabbatch{1}.spm.tools.physio.model.output_physio = 'physio.mat';
%     matlabbatch{1}.spm.tools.physio.model.orthogonalise = 'none';
%     matlabbatch{1}.spm.tools.physio.model.censor_unreliable_recording_intervals = false;
%     matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.c = 3;
%     matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.r = 4; % str2double(gui_data.edit_order_r.String);
%     matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.cr = 1;
%     matlabbatch{1}.spm.tools.physio.model.rvt.no = struct([]);
%     matlabbatch{1}.spm.tools.physio.model.hrv.no = struct([]);
%     matlabbatch{1}.spm.tools.physio.model.noise_rois.no = struct([]);
%     matlabbatch{1}.spm.tools.physio.model.movement.no = struct([]);
%     matlabbatch{1}.spm.tools.physio.model.other.no = struct([]);
%     matlabbatch{1}.spm.tools.physio.verbose.level = 2;
%     matlabbatch{1}.spm.tools.physio.verbose.fig_output_file = ''; % gui_data.edit_verbose_fig_output_file.String;
%     matlabbatch{1}.spm.tools.physio.verbose.use_tabs = false;
%     