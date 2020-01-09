function matlabbatch = wrapper_physiobatch(data_vendor, out_dir, default_path)
    spm_jobman('initcfg');
    global defaults
    defaults.stats.maxmem   = 2^30;
    matlabbatch = {};
    
    matlabbatch{1}.spm.tools.physio.save_dir = {[out_dir filesep 'physio_dir']};
    matlabbatch{1}.spm.tools.physio.log_files.vendor = data_vendor;
    
    % EXAMPLES IN C:\Users\nwiedemann\Downloads\tapas\tapas\misc\example\PhysIO
    
    % different vendor options require different file input
    if strcmp(data_vendor, 'BIDS')
        [tsv_filename, ~] = spm_select(1,'.*.tsv.*','Specify tsv/tsv.gz file with ECG data',{}, default_path);
        % tsv_filename = input(['For BIDS, you only need to specify the tsv/tsv.gz file containing 3 columns without header.' ...
         % 'There must be a json with the same file name in the same folder containing metainformation'], 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {tsv_filename}; 
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {''}; 
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''};
    elseif strcmp(data_vendor, 'Philips')
        [scanphyslog, ~] = spm_select(1,'.*.log','Specify SCANPHYSLOG.log file',{}, default_path);
        % scanphyslog = input('Specify file path to SCANPHYSLOG.log file', 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {scanphyslog}; 
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {scanphyslog}; 
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {scanphyslog}; % or empty?
    elseif strcmp(data_vendor, 'Biopac_Txt')
        [scanphyslog, ~] = spm_select(1,'.*.txt','Specify biopac data export txt file',{}, default_path);
        % scanphyslog = input('Specify file path to the biopac data export txt file', 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {scanphyslog}; 
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {scanphyslog}; 
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {scanphyslog};
     elseif strcmp(data_vendor, 'GE')
        [cardiac, ~] = spm_select(1,'any','Specify cardiac file (starting with ECGData_)',{}, default_path);
        % cardiac = input('Specify file path to the cardiac file (in template starting with ECGData_)', 's');
        [respiration, ~] = spm_select(1,'any','Specify respiration file (starting with RespData_)',{}, default_path);
        % respiration = input('Specify file path to the respiration file (in template starting with RespData_)', 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {cardiac};
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {respiration};
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''};
     elseif strcmp(data_vendor, 'Siemens_HCP')
        [physiolog, ~] = spm_select(1,'any','Specify physio data file (sth like tfMRI_MOTOR_LR_Physio_log.txt)',{}, default_path);
        % physiolog = input('Specify file path to the tfMRI_MOTOR_LR_Physio_log.txt file', 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {physiolog};
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {physiolog};
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''};
     elseif strcmp(data_vendor, 'Siemens')
        [physiolog, ~] = spm_select(1,'.*.ecg','Specify physio data file (siemens_PAV.ecg)',{}, default_path);
        % physiolog = input('Specify file path to the siemens_PAV.ecg file', 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {physiolog};
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {''};
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {''}; 
     elseif strcmp(data_vendor, 'Siemens_Tics')
        [cardiac, ~] = spm_select(1,'.*.log','Specify cardiac file (..._PULS.log)',{}, default_path);
        % cardiac = input('Specify file path to the cardiac file (in template ending with _PULS.log)', 's');
        [respiration, ~] = spm_select(1,'.*.log','Specify respiration file (..._RESP.log)',{}, default_path);
        % respiration = input('Specify file path to the respiration file (in template ending with _RESP.log)', 's');
        [timing, ~] = spm_select(1,'.*.log','Specify scan timing file (..._Info.log)',{}, default_path);
        % timing = input('Specify file path to the scan timing file (in template ending with _Info.log)', 's');
        matlabbatch{1}.spm.tools.physio.log_files.cardiac = {cardiac};
        matlabbatch{1}.spm.tools.physio.log_files.respiration = {respiration};
        matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {timing};
    else
        ME = MException('error:wronginput', 'Wrong vendor specified. Please specify one of BIDS, Philips, Biopac_Txt, GE, Siemens, Siemens_HCP, Siemens_Tics');
        throw(ME);
    end
    
    % read scan parameters
    input_params = inputdlg({'Number of scans:','Number of slices:','Number of dummies:', 'TR:', 'Onset slice:'}, 'Parameters for physio');
    
    % scan parameters
    matlabbatch{1}.spm.tools.physio.log_files.sampling_interval = [];
    matlabbatch{1}.spm.tools.physio.log_files.relative_start_acquisition = 0;
    matlabbatch{1}.spm.tools.physio.log_files.align_scan = 'last'; % sometimes first, sometimes last
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nslices = str2double(input_params{2});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.NslicesPerBeat = [];
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.TR = str2double(input_params{4});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Ndummies = str2double(input_params{3});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nscans = str2double(input_params{1});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.onset_slice = str2double(input_params{5});
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.time_slice_to_slice = [];

    % template
    matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nprep = [];
    matlabbatch{1}.spm.tools.physio.scan_timing.sync.nominal = struct([]);
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.modality = 'ECG';
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.min = 0.4;
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.file = 'initial_cpulse_kRpeakfile.mat';
    matlabbatch{1}.spm.tools.physio.preproc.cardiac.posthoc_cpulse_select.off = struct([]);
    matlabbatch{1}.spm.tools.physio.model.output_multiple_regressors = 'retroicor_regressors.txt';
    matlabbatch{1}.spm.tools.physio.model.output_physio = 'physio.mat';
    matlabbatch{1}.spm.tools.physio.model.orthogonalise = 'none';
    matlabbatch{1}.spm.tools.physio.model.censor_unreliable_recording_intervals = false;
    matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.c = 3;
    matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.r = 4;
    matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.cr = 1;
    matlabbatch{1}.spm.tools.physio.model.rvt.no = struct([]);
    matlabbatch{1}.spm.tools.physio.model.hrv.no = struct([]);
    matlabbatch{1}.spm.tools.physio.model.noise_rois.no = struct([]);
    matlabbatch{1}.spm.tools.physio.model.movement.no = struct([]);
    matlabbatch{1}.spm.tools.physio.model.other.no = struct([]);
    matlabbatch{1}.spm.tools.physio.verbose.level = 2;
    matlabbatch{1}.spm.tools.physio.verbose.fig_output_file = '';
    matlabbatch{1}.spm.tools.physio.verbose.use_tabs = false;
    
    % save batch
     save([out_dir filesep 'physio_batch'], 'matlabbatch');
     disp("Saved matlabbatch in:");
     disp(out_dir);
        
    % spm_jobman('run',matlabbatch);
end