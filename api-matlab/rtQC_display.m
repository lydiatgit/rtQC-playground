%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) rtQC Dev-Team
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 3
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,USA.
%
% Author: Stephan Heunis, <j.s.heunis@tue.nl>, 2018
%
% Function rtQC_display
%
% Description: rtQC GUI
%
% Parameters:
%
% Returns:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rtQC_display()

% Open SPM
% spm fmri
% Create main GUI figure
fig = figure('Visible','off',...
    'Name', 'rtQC',...
    'NumberTitle','off',...
    'units','normalized',...
    'outerposition', [0 0 1 1],...
    'MenuBar', 'none',...
    'ToolBar', 'none');
% Main data structure
gui_data = guidata(fig);
% Get rtQC defaults
defaults = rtQC_defaults();
fields = fieldnames(defaults);
for i=1:numel(fields)
    gui_data.(fields{i}) = defaults.(fields{i});
end
% Populate data if required
if gui_data.demo_mode
    data_set = defaults.sample_set{defaults.use_sample_set};
else
    data_set = defaults.empty_set;
end
dfields = fieldnames(data_set);
for i=1:numel(dfields)
    gui_data.(dfields{i}) = data_set.(dfields{i});
end

% Setup all UIcontrols and GUI components
rtQC_display_setup;

% Set callbacks
gui_data.tgroup.SelectionChangedFcn = @tabChangedCallback;
gui_data.pb_help.Callback = @linkToGithub;
gui_data.pb_docs.Callback = @linkToDocs;
gui_data.pb_mode.Callback = @changeMode;
gui_data.pb_start.Callback = @gotoTab1;
gui_data.edit_fd_threshold_defaults.Callback = @editFDthreshold;
gui_data.edit_spm_defaults.Callback = @editSPMdir;
gui_data.pb_spm_defaults.Callback = @setSPMdir;
gui_data.edit_outdir_defaults.Callback = @editOUTdir;
gui_data.pb_outdir_defaults.Callback = @setOUTdir;
gui_data.edit_structural.Callback = @editStructural;
gui_data.pb_structural.Callback = @setStructural;
gui_data.edit_functional.Callback = @editFunctional;
gui_data.pb_functional.Callback = @setFunctional;
gui_data.edit_fd_threshold.Callback = @editFDthreshold;
gui_data.pb_selectData1.Callback = @selectData1;
gui_data.pb_selectData2.Callback = @selectData2;
gui_data.pb_continue_to_online.Callback = @gotoTab2;
gui_data.edit_im1_dqchecks.Callback = @editIM1dqchecks;
gui_data.pb_im1_dqchecks.Callback = @setIM1dqchecks;
gui_data.edit_im2_dqchecks.Callback = @editIM2dqchecks;
gui_data.pb_im2_dqchecks.Callback = @setIM2dqchecks;
gui_data.pb_checkReg_dqchecks.Callback = @checkRegDQ;
gui_data.pb_MI_dqchecks.Callback = @calcAndDispMI;
gui_data.pb_xtc_qa.Callback = @openXTCqa;
gui_data.pb_xtc_nii.Callback = @openXTCnii;

gui_data.pb_initialize.Callback = @initialize;
gui_data.pb_startRT.Callback = @startRT;
gui_data.pb_stopRT.Callback = @stopRT;
gui_data.popup_setDim.Callback = @setDim;
gui_data.popup_setVendor.Callback = @setVendor;
gui_data.sld_slice.Callback = @changeSlice;
gui_data.popup_setImg.Callback = @setImg;
gui_data.edit_structural_pre.Callback = @editStructural;
gui_data.pb_structural_pre.Callback = @setStructural;
gui_data.edit_functional_pre.Callback = @editFunctional;
gui_data.pb_functional_pre.Callback = @setFunctional;
gui_data.pb_preproc.Callback = @runPreProc;
gui_data.pb_functional.Callback = @setFunctional;
gui_data.pb_run_qc_post.Callback = @runOfflineQC;
gui_data.pb_show_fdoutliers_post.Callback = @showFDoutliers;

gui_data.edit_roi1.Callback = @editROI1;
gui_data.pb_roi1.Callback = @setROI1;
gui_data.edit_roi2.Callback = @editROI2;
gui_data.pb_roi2.Callback = @setROI2;
gui_data.edit_roi1_pre.Callback = @editROI1;
gui_data.pb_roi1_pre.Callback = @setROI1;
gui_data.edit_roi2_pre.Callback = @editROI2;
gui_data.pb_roi2_pre.Callback = @setROI2;

gui_data.QCtgroup.SelectionChangedFcn = @QCtabChangedCallback;
gui_data.pb_open_qc_post.Callback = @generateReport;
gui_data.pb_get_physio_batch.Callback = @physioBatch;

% settings callback
gui_data.edit_physio_save_dir.Callback = @editphysio_save_dir ;
gui_data.edit_log_files_sampling_interval.Callback = @editlog_files_sampling_interval ;
gui_data.edit_log_files_relative_start_acquisition.Callback = @editlog_files_relative_start_acquisition ;
gui_data.edit_log_files_align_scan.Callback = @editlog_files_align_scan ;
gui_data.edit_sqpar_NslicesPerBeat.Callback = @editsqpar_NslicesPerBeat ;
gui_data.edit_sqpar_time_slice_to_slice.Callback = @editsqpar_time_slice_to_slice ;
gui_data.edit_sqpar_Nprep.Callback = @editsqpar_Nprep ;
gui_data.edit_sync_nominal.Callback = @editsync_nominal ;
gui_data.edit_auto_matched_min.Callback = @editauto_matched_min ;
gui_data.edit_auto_matched_file.Callback = @editauto_matched_file ;
gui_data.edit_posthoc_cpulse_select_off.Callback = @editposthoc_cpulse_select_off ;
gui_data.edit_model_output_multiple_regressors.Callback = @editmodel_output_multiple_regressors ;
gui_data.edit_model_output_physio.Callback = @editmodel_output_physio ;
gui_data.edit_model_orthogonalise.Callback = @editmodel_orthogonalise ;
gui_data.edit_model_censor_unreliable_recording_intervals.Callback = @editmodel_censor_unreliable_recording_intervals ;
gui_data.edit_order_c.Callback = @editorder_c; 
gui_data.edit_order_r.Callback = @editorder_r ;
gui_data.edit_order_cr.Callback = @editorder_cr ;
gui_data.edit_rvt_no.Callback = @editrvt_no ;
gui_data.edit_hrv_no.Callback = @edithrv_no ;
gui_data.edit_noise_rois_no.Callback = @editnoise_rois_no ;
gui_data.edit_movement_no.Callback = @editmovement_no ;
gui_data.edit_other_no.Callback = @editother_no ;
gui_data.edit_verbose_level.Callback = @editverbose_level ;
gui_data.edit_verbose_fig_output_file.Callback = @editverbose_fig_output_file ;
gui_data.edit_verbose_use_tabs.Callback = @editverbose_use_tabs ;

gui_data.export_settings.Callback = @export_settings;

set(findall(fig, '-property', 'Interruptible'), 'Interruptible', 'on')
% Make figure visible after normalizing units
set(findall(fig, '-property', 'Units'), 'Units', 'Normalized')
fig.Visible = 'on';
% Save GUI data to workspace
gui_data = guidata(fig);
% assignin('base', 'gui_data', gui_data)
end


function tabChangedCallback(hObject, eventdata)
% Get the Title of the previous tab
newTabName = eventdata.NewValue.Title;
oldTabName = eventdata.OldValue.Title;
% evalin('base', 'gui_data', gui_data)
fig = ancestor(hObject,'figure');
% guidata(fig,gui_data)

gui_data = guidata(fig);
switch newTabName
    case hObject.Children(1).Title
        %
    case hObject.Children(2).Title
        %
    case hObject.Children(3).Title
        %
    case hObject.Children(4).Title
        if strcmp(gui_data.RT_status, 'completed') ~= 1
            errordlg('Offline QC is only possible once online QC has been completed');
        else
            gui_data.txt_Nvolume_post.String = ['Acquired volumes:  ' num2str(gui_data.Nt)];
            valid_percentage = round(gui_data.Nvolume_valid/gui_data.Nt*100, 1);
            gui_data.txt_Nvolume_valid_post.String = ['Valid volumes:  ' num2str(gui_data.Nvolume_valid) '/' num2str(gui_data.Nt) ' (' num2str(valid_percentage) '%)'];
            gui_data.txt_fdsum_post.String = ['Total FD:  ' num2str(round(gui_data.FD_sum,2))];
            gui_data.txt_fdave_post.String = ['Mean FD:  ' num2str(round(gui_data.FD_dynamic_average,2))];
            gui_data.txt_tsnr_post.String = ['tSNR (brain):  ' num2str(round(gui_data.tSNR(gui_data.Nt),2))];
            gui_data.txt_tsnr_gm_post.String = ['tSNR (GM):  ' num2str(round(gui_data.tSNR_gm(gui_data.Nt),2))];
            gui_data.txt_tsnr_wm_post.String = ['tSNR (WM):  ' num2str(round(gui_data.tSNR_wm(gui_data.Nt),2))];
            gui_data.txt_tsnr_csf_post.String = ['tSNR (CSF):  ' num2str(round(gui_data.tSNR_csf(gui_data.Nt),2))];
        end
        %
    otherwise
        %
end
% assignin('base', 'gui_data', gui_data)
guidata(fig,gui_data)
end

function QCtabChangedCallback(hObject, eventdata)
end


function linkToGithub(hObject,eventdata)
url = 'https://github.com/rtQC-group/rtQC';
web(url, '-browser')
end

function linkToDocs(hObject,eventdata)
f = msgbox('Documentation coming soon!');
end

function changeMode(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
if gui_data.demo_mode == 1
    gui_data.demo_mode = 0;
    gui_data.mode_string = 'Standard Mode';
else
    gui_data.demo_mode = 1;
    gui_data.mode_string = 'Demo Mode';
end
gui_data.pb_mode.String = gui_data.mode_string;
guidata(fig,gui_data)
end

function gotoTab1(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
gui_data.tgroup.SelectedTab = gui_data.tab_pre;
guidata(fig,gui_data)
end

function gotoTab2(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
gui_data.tgroup.SelectedTab = gui_data.tab_online;
guidata(fig,gui_data)
end

%%%% start settings tab functions

function export_settings(hObject,eventdata)
    fig = ancestor(hObject,'figure');
    gui_data = guidata(fig);
    panels = {'general', 'physio', 'new'};
    labels = {};
    values = {};
    counter = 1;
    for i=1:length(panels)
        children = eval(['gui_data.panel_set_' panels{i} '.Children']);
        for j=1:length(children)
            if strcmp(children(j).Style, 'text')
                name = children(j).String;
                name = strrep(name, '.', '_');
                matching_edit = eval(['gui_data.edit_' name '.String']);
                labels{counter} = [panels{i} '_' name];
                values{counter} = matching_edit;
                counter = counter+1;
            end
        end
    end
    % save to json file
    enc = jsonencode(containers.Map(labels, values));
    fid = fopen([gui_data.qc_out_dir filesep 'settings.json'], 'wt');
    fprintf(fid, '%s', enc);
    fclose(fid);
    msgbox(['Saved settings in: ' gui_data.qc_out_dir], 'Success');
end

function editphysio_save_dir (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editlog_files_sampling_interval (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editlog_files_relative_start_acquisition (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editlog_files_align_scan (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editsqpar_NslicesPerBeat (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editsqpar_time_slice_to_slice (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editsqpar_Nprep (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editsync_nominal (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editauto_matched_min (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editauto_matched_file (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editposthoc_cpulse_select_off (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editmodel_output_multiple_regressors (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editmodel_output_physio (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editmodel_orthogonalise (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editmodel_censor_unreliable_recording_intervals (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editorder_c (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editorder_r (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editorder_cr (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editrvt_no (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function edithrv_no (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editnoise_rois_no (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editmovement_no (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editother_no (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editverbose_level (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end
function editverbose_fig_output_file(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
txt = get(hObject, 'String');
gui_data.editverbose_fig_output_file.String = txt;
% assignin('base', 'gui_data', gui_data)
guidata(fig,gui_data)
end
function editverbose_use_tabs (hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

%%%%% end setting tab functions


function editFDthreshold(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
txt = get(hObject, 'String');
gui_data.FD_threshold = str2double(txt);
if isnan(gui_data.FD_threshold)
    %     set(hObject, 'String', 0.25);
    gui_data.edit_fd_threshold.String = '0.25';
    gui_data.edit_fd_threshold_defaults.String = '0.25';
    gui_data.FD_threshold = 0.25;
    errordlg('Input must be a number','Error');
else
    gui_data.edit_fd_threshold.String = txt;
    gui_data.edit_fd_threshold_defaults.String = txt;
end

% assignin('base', 'gui_data', gui_data)
guidata(fig,gui_data)
end

function editSPMdir(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setSPMdir(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
% cd(gui_data.root_dir)
dirname = uigetdir(gui_data.root_dir, 'Select the SPM12 toolbox directory');
if dirname ~= 0
    gui_data.spm_dir = dirname;
    gui_data.edit_spm_defaults.String = dirname;
end
% assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end

function editOUTdir(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setOUTdir(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
% cd(gui_data.root_dir)
dirname = uigetdir(gui_data.root_dir, 'Select the OUTPUT directory');
if dirname ~= 0
    gui_data.qc_out_dir = dirname;
    gui_data.edit_outdir_defaults.String = dirname;
end
% assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end



function editStructural(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setStructural(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
cd(gui_data.root_dir)
[filename, pathname] = uigetfile('*.nii', 'Select the STRUCTURAL IMAGE file');
if filename ~= 0
    gui_data.structural_fn = [pathname filename];
    gui_data.edit_structural.String = gui_data.structural_fn;
    gui_data.edit_structural_pre.String = gui_data.structural_fn;
end
% assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end

function editFunctional(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setFunctional(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
cd(gui_data.root_dir)
[filename, pathname] = uigetfile('*.nii', 'Select the 4D (or 1st 3D) FUNCTIONAL IMAGE file');
if filename ~= 0
    gui_data.functional4D_fn = [pathname filename];
    gui_data.edit_functional.String = gui_data.functional4D_fn;
    gui_data.edit_functional_pre.String = gui_data.functional4D_fn;
end
% assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end

function selectData1(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
gui_data.pb_selectData1.String = ['Task ' char(hex2dec('2713'))];
gui_data.pb_selectData2.String = 'Rest';
gui_data.use_sample_set = 1;
data_set = gui_data.sample_set{gui_data.use_sample_set};
dfields = fieldnames(data_set);
for i=1:numel(dfields)
    gui_data.(dfields{i}) = data_set.(dfields{i});
end
gui_data.qc_out_dir = [gui_data.data_dir filesep 'rtQC_output'];
gui_data.edit_outdir_defaults.String = gui_data.qc_out_dir ;
gui_data.edit_structural.String = gui_data.structural_fn;
gui_data.edit_structural_pre.String = gui_data.structural_fn;
gui_data.edit_functional.String = gui_data.functional4D_fn;
gui_data.edit_functional_pre.String = gui_data.functional4D_fn;
gui_data.edit_roi1.String = gui_data.ROI1_fn;
gui_data.edit_roi1_pre.String = gui_data.ROI1_fn;
gui_data.edit_roi2.String = gui_data.ROI2_fn;
gui_data.edit_roi2_pre.String = gui_data.ROI2_fn;

gui_data.txt_preproc1_status.String = '-';
gui_data.txt_preproc2_status.String = '-';
gui_data.txt_preproc3_status.String = '-';
gui_data.preProc_status = 0;

guidata(fig, gui_data);
end


function selectData2(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
gui_data.pb_selectData1.String = 'Task';
gui_data.pb_selectData2.String = ['Rest ' char(hex2dec('2713'))];
gui_data.use_sample_set = 2;
data_set = gui_data.sample_set{gui_data.use_sample_set};
dfields = fieldnames(data_set);
for i=1:numel(dfields)
    gui_data.(dfields{i}) = data_set.(dfields{i});
end
gui_data.qc_out_dir = [gui_data.data_dir filesep 'rtQC_output'];
gui_data.edit_outdir_defaults.String = gui_data.qc_out_dir ;
gui_data.edit_structural.String = gui_data.structural_fn;
gui_data.edit_structural_pre.String = gui_data.structural_fn;
gui_data.edit_functional.String = gui_data.functional4D_fn;
gui_data.edit_functional_pre.String = gui_data.functional4D_fn;
gui_data.edit_roi1.String = gui_data.ROI1_fn;
gui_data.edit_roi1_pre.String = gui_data.ROI1_fn;
gui_data.edit_roi2.String = gui_data.ROI2_fn;
gui_data.edit_roi2_pre.String = gui_data.ROI2_fn;

gui_data.txt_preproc1_status.String = '-';
gui_data.txt_preproc2_status.String = '-';
gui_data.txt_preproc3_status.String = '-';
gui_data.preProc_status = 0;

guidata(fig, gui_data);
end


function editROI1(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setROI1(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
cd(gui_data.root_dir)
[filename, pathname] = uigetfile('*.nii', 'Select the 3D FUNCTIONAL IMAGE file');
if filename ~= 0
    gui_data.ROI1_fn = [pathname filename];
    gui_data.edit_roi1.String = gui_data.ROI1_fn;
    gui_data.edit_roi1_pre.String = gui_data.ROI1_fn;
end
% assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end

function editROI2(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setROI2(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
cd(gui_data.root_dir)
[filename, pathname] = uigetfile('*.nii', 'Select the 3D FUNCTIONAL IMAGE file');
if filename ~= 0
    gui_data.ROI2_fn = [pathname filename];
    gui_data.edit_roi2.String = gui_data.ROI2_fn;
    gui_data.edit_roi2_pre.String = gui_data.ROI2_fn;
end
% assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end


function editIM1dqchecks(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setIM1dqchecks(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
cd(gui_data.root_dir)
[filename, pathname] = uigetfile('*.nii', 'Select 3D FUNCTIONAL IMAGE #1');
if filename ~= 0
    gui_data.im1_dqchecks_fn = [pathname filename];
    gui_data.edit_im1_dqchecks.String = gui_data.im1_dqchecks_fn;
end
guidata(fig, gui_data);
end

function editIM2dqchecks(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setIM2dqchecks(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
cd(gui_data.root_dir)
[filename, pathname] = uigetfile('*.nii', 'Select 3D FUNCTIONAL IMAGE #2');
if filename ~= 0
    gui_data.im2_dqchecks_fn = [pathname filename];
    gui_data.edit_im2_dqchecks.String = gui_data.im2_dqchecks_fn;
end
guidata(fig, gui_data);
end


function checkRegDQ(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
if isempty(gui_data.im1_dqchecks_fn) || isempty(gui_data.im2_dqchecks_fn)
    errordlg('Please select two images (online and offline) to compare');
    return;
end
spm_check_registration(gui_data.im1_dqchecks_fn, gui_data.im2_dqchecks_fn)
end

function calcAndDispMI(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
if isempty(gui_data.im1_dqchecks_fn) || isempty(gui_data.im2_dqchecks_fn)
    errordlg('Please select two images (online and offline) to compare');
    return;
end


msgbox('Functionality to be added: plot 2D histogram and display mutual information measure');
% slice_nr = 20;
% im1 = spm_read_vols(spm_vol(gui_data.im1_dqchecks_fn));
% im2 = spm_read_vols(spm_vol(gui_data.im2_dqchecks_fn));
% slice_im1 = squeeze(im1(:,:, slice_nr));
% slice_im2 = squeeze(im2(:,:, slice_nr));
% [M, out] = MI_GG(slice_im1, slice_im2);

end


function openXTCqa(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
open(gui_data.xtc_qa_fn )
end

function openXTCnii(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
open(gui_data.xtc_nii_fn)
end







function runPreProc(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
gui_data.functional0_fn = [gui_data.functional4D_fn ',1'];
% Preprocess structural and f0 images
[d, f, e] = fileparts(gui_data.structural_fn);
disp(d);
disp(f);
if exist([d filesep 'rc1' f e], 'file')
    % 1) If preprocessing has already been done, assign variables
    gui_data.preProc_status = 1;
    gui_data.forward_transformation = [d filesep 'y_' f e];
    gui_data.inverse_transformation = [d filesep 'iy_' f e];
    gui_data.gm_fn = [d filesep 'c1' f e];
    gui_data.wm_fn = [d filesep 'c2' f e];
    gui_data.csf_fn = [d filesep 'c3' f e];
    gui_data.bone_fn = [d filesep 'c4' f e];
    gui_data.soft_fn = [d filesep 'c5' f e];
    gui_data.air_fn = [d filesep 'c6' f e];
    gui_data.rstructural_fn = [d filesep 'r' f e];
    gui_data.rgm_fn = [d filesep 'rc1' f e];
    gui_data.rwm_fn = [d filesep 'rc2' f e];
    gui_data.rcsf_fn = [d filesep 'rc3' f e];
    gui_data.rbone_fn = [d filesep 'rc4' f e];
    gui_data.rsoft_fn = [d filesep 'rc5' f e];
    gui_data.rair_fn = [d filesep 'rc6' f e];
    gui_data.preProc_step1_status = 1;
    gui_data.txt_preproc1_status.String = char(hex2dec('2713'));
    gui_data.preProc_step2_status = 1;
    gui_data.txt_preproc2_status.String = char(hex2dec('2713'));
    gui_data.preProc_step3_status = 1;
    gui_data.txt_preproc3_status.String = char(hex2dec('2713'));
else
    % 2) If not done, run scripts to get data in correct formats for
    % real-time processing
    gui_data.preProc_status = 0;
    guidata(fig,gui_data);
    output = preRtPreProc(fig, gui_data.functional0_fn, gui_data.structural_fn, gui_data.spm_dir);
    for fn = fieldnames(output)'
        gui_data.(fn{1}) = output.(fn{1});
    end
    gui_data.preProc_status = 1;
end
guidata(fig,gui_data);
end







function initialize(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
gui_data.txt_Nvolume.String = 'Acquired volumes:  0';
gui_data.txt_Nvolume_valid.String = 'Valid volumes:  0';
gui_data.txt_fdsum.String = 'Total FD:  0';
gui_data.txt_fdave.String = 'Mean FD:  0';
gui_data.txt_tsnr.String = 'tSNR (brain):  0';
gui_data.txt_tsnr_gm.String = 'tSNR (GM):  0';
gui_data.txt_tsnr_wm.String = 'tSNR (WM):  0';
gui_data.txt_tsnr_csf.String = 'tSNR (CSF):  0';
% Check preprocessing of structural and f0 images
if gui_data.preProc_status ~= 1
    errordlg('Please first complete the preprocessing in the PRE-NF QC tab','Preprocessing not done!');
    return;
end

img_spm = spm_vol(gui_data.functional4D_fn);
img_size = size(img_spm);
if img_size(1) > 1
    % if 4D image was entered
    gui_data.functional0_fn = [gui_data.functional4D_fn ',1'];
    gui_data.f4D_img = spm_read_vols(spm_vol(gui_data.functional4D_fn));
    [dir, fn, ext] = fileparts(gui_data.functional4D_fn);
    if ~exist([dir filesep fn '_00001' ext],'file')
        gui_data.f4D_img_spm = spm_file_split(gui_data.functional4D_fn);
    end
    gui_data.f3D_img = gui_data.f4D_img(:,:,:,1);
    [gui_data.Ni, gui_data.Nj, gui_data.Nk, gui_data.Nt] = size(gui_data.f4D_img);
else
    % if 3D image was entered
    gui_data.functional0_fn = gui_data.functional4D_fn;
    % for opennft sample data specifically
    if gui_data.use_sample_set == 1
        gui_data.functional4D_fn = [gui_data.data_dir filesep 'fanon-0007.nii'];
        if ~exist(gui_data.functional4D_fn, 'file')
            vols = cell(gui_data.Nt_default,1);
            for n = 1:gui_data.Nt_default
                vols{n, 1} = [gui_data.data_dir filesep 'fanon-0007-' sprintf('%05d',n) '-' sprintf('%06d',n) '-01.nii'];
            end
            rtQC_3Dto4Dnii(vols, 2, gui_data.functional4D_fn)
        end
        gui_data.f4D_img = spm_read_vols(spm_vol(gui_data.functional4D_fn));
    end
    gui_data.f3D_img = spm_read_vols(spm_vol(gui_data.functional0_fn));
    [gui_data.Ni, gui_data.Nj, gui_data.Nk] = size(gui_data.f3D_img);
    gui_data.Nt = gui_data.Nt_default;
end
gui_data.Ndims = [gui_data.Ni; gui_data.Nj; gui_data.Nk];
gui_data.slice_numbers = floor(gui_data.Ndims/2);
gui_data.fmax = max(max(max(gui_data.f3D_img)));
gui_data.tmax = 150;
gui_data.prev_dim = 3; % selected dimension for image volume in previous iteration, default = Z

% real-time realign and reslice parameters
gui_data.use_rt = 1;
gui_data.flagsSpmRealign = struct('quality',.9,'fwhm',5,'sep',4,...
    'interp',4,'wrap',[0 0 0],'rtm',0,'PW','','lkp',1:6);
gui_data.flagsSpmReslice = struct('quality',.9,'fwhm',5,'sep',4,...
    'interp',4,'wrap',[0 0 0],'mask',1,'mean',0,'which', 2);
gui_data.infoVolTempl = spm_vol(gui_data.functional0_fn);
gui_data.imgVolTempl  = spm_read_vols(gui_data.infoVolTempl);
gui_data.dimTemplMotCorr     = gui_data.infoVolTempl.dim;
gui_data.matTemplMotCorr     = gui_data.infoVolTempl.mat;
gui_data.dicomInfoVox   = sqrt(sum(gui_data.matTemplMotCorr(1:3,1:3).^2));
gui_data.A0=[];gui_data.x1=[];gui_data.x2=[];gui_data.x3=[];gui_data.wt=[];gui_data.deg=[];gui_data.b=[];
gui_data.R(1,1).mat = gui_data.matTemplMotCorr;
gui_data.R(1,1).dim = gui_data.dimTemplMotCorr;
gui_data.R(1,1).Vol = gui_data.imgVolTempl;
gui_data.nrSkipVol = 0;
gui_data.F_dyn_img = gui_data.f3D_img;
gui_data.tSNR_dyn_img = gui_data.f3D_img;
gui_data.FD_outliers = []; % Outlier volumes
gui_data.FD_sum = 0;
gui_data.outlier_counter = 0; % Outlier counter
gui_data.FD_dynamic_average = 0;
gui_data.t = 1:gui_data.Nt;
gui_data.MP1 = zeros(1,gui_data.Nt);
gui_data.MPall = cell(1,6);
for p = 1:6
    gui_data.MPall{p} =  gui_data.MP1;
end
gui_data.FD = nan(gui_data.Nt,1);
gui_data.DVARS = nan(1,gui_data.Nt);
gui_data.T = zeros(gui_data.Nt,8); % Timing vector: 1)realignment, 2)FD, 3)DVARS, 4)smoothing, 5)detrending, 6)PSC, 7)draw stuff, 8)total
% Create binary GM, WM and CSF masks
[gui_data.GM_img_bin, gui_data.WM_img_bin, gui_data.CSF_img_bin] = createBinarySegments(gui_data.rgm_fn, gui_data.rwm_fn, gui_data.rcsf_fn, 0.1);
% Initialize variables for real-time processing
gui_data.I_GM = find(gui_data.GM_img_bin);
gui_data.I_WM = find(gui_data.WM_img_bin);
gui_data.I_CSF = find(gui_data.CSF_img_bin);
gui_data.mask_reshaped = gui_data.GM_img_bin | gui_data.WM_img_bin | gui_data.CSF_img_bin;
gui_data.mask_3D = reshape(gui_data.mask_reshaped, gui_data.Ni, gui_data.Nj, gui_data.Nk);
gui_data.I_mask = find(gui_data.mask_reshaped);
gui_data.N_maskvox = numel(gui_data.I_mask);
gui_data.N_vox = gui_data.Ni*gui_data.Nj*gui_data.Nk;
gui_data.line1_pos = numel(gui_data.I_GM);
gui_data.line2_pos = numel(gui_data.I_GM) + numel(gui_data.I_WM);
% Initialize variables to be updated during each real-time iteration
gui_data.F_realigned = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_smoothed = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_dyn = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_dyn_img = zeros(gui_data.Ni, gui_data.Nj, gui_data.Nk);
gui_data.F_dyn_detrended = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_perc_signal_change = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_theplot = zeros(gui_data.N_vox, gui_data.Nt+1);
gui_data.F_cumulative_mean = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_cumulative_sum = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_stdev = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_tSNR = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_zscore = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_zscore_mean = nan(1, gui_data.Nt);
gui_data.tSNR_dyn_img = zeros(gui_data.Ni, gui_data.Nj, gui_data.Nk);
gui_data.tSNR = nan(1, gui_data.Nt);
gui_data.tSNR_gm = nan(1, gui_data.Nt);
gui_data.tSNR_wm = nan(1, gui_data.Nt);
gui_data.tSNR_csf = nan(1, gui_data.Nt);
gui_data.X_MP_detrending = (1:gui_data.Nt)';
gui_data.X_MP_detrending = gui_data.X_MP_detrending - mean(gui_data.X_MP_detrending); % demean non-constant regressors
gui_data.X_MP_detrending = [gui_data.X_MP_detrending ones(gui_data.Nt,1)]; % add constant regressor
gui_data.X_Func_detrending = gui_data.X_MP_detrending;
gui_data.MP = zeros(gui_data.Nt,6);
gui_data.MP_detrended = zeros(gui_data.Nt,6);
gui_data.MP_mm = zeros(gui_data.Nt,6);
gui_data.outlier_reg = zeros(1, gui_data.Nt);
% gui_data.outlier_reg_Ydata = zeros(2, gui_data.Nt);
% Initialize axes
gui_data.plot_FD = plot(gui_data.ax_FD, gui_data.t, gui_data.FD, 'c', 'LineWidth', 1.5);
gui_data.fd_line1 = line(gui_data.ax_FD, [1 gui_data.Nt],[gui_data.FD_threshold gui_data.FD_threshold],  'Color', 'r', 'LineWidth', 1);
gui_data.ax_FD.XLim = [0 (gui_data.Nt+1)]; gui_data.ax_FD.YLim = [0 2];
gui_data.ax_FD.XGrid = 'on'; gui_data.ax_FD.YGrid = 'on';
gui_data.ax_FD.Color = 'k';
gui_data.ax_FD.Title.String = gui_data.ax_FD_title;
gui_data.ax_FD.YLabel.String = 'mm';
removeAxesXTickLabels(gui_data.ax_FD)
gui_data.plot_tSNR = plot(gui_data.ax_tSNR, gui_data.t, gui_data.tSNR, 'c', 'LineWidth', 1.5);
gui_data.ax_tSNR.XLim = [0 (gui_data.Nt+1)]; gui_data.ax_tSNR.YLim = [0 100];
gui_data.ax_tSNR.XGrid = 'on'; gui_data.ax_tSNR.YGrid = 'on';
gui_data.ax_tSNR.Color = 'k';
gui_data.ax_tSNR.Title.String = gui_data.ax_tSNR_title;
gui_data.ax_tSNR.YLabel.String = 'a.u.';
removeAxesXTickLabels(gui_data.ax_tSNR)
gui_data.plot_globalZ = plot(gui_data.ax_globalZ, gui_data.t, gui_data.F_zscore_mean, 'c', 'LineWidth', 1.5);
gui_data.ax_globalZ.XLim = [0 (gui_data.Nt+1)]; gui_data.ax_globalZ.YLim = [0 10];
gui_data.ax_globalZ.XGrid = 'on'; gui_data.ax_tSNR.YGrid = 'on';
gui_data.ax_globalZ.Color = 'k';
gui_data.ax_globalZ.Title.String = gui_data.ax_globalZ_title;
gui_data.ax_globalZ.YLabel.String = 'a.u.';
removeAxesXTickLabels(gui_data.ax_globalZ)
hold(gui_data.ax_tSNR, 'on')
hold(gui_data.ax_globalZ, 'on')
if gui_data.use_sample_set == 1
    % hardcoding Nroi = 2, for the case of example Opennft sample data. To be
    % changed.
    
    gui_data.zscore_ROI = cell(1,2);
    gui_data.tSNR_ROI = cell(1,2);
    roi_colors = ['m'; 'g'];
    N_ROIs = numel(gui_data.tSNR_ROI);
    for roi = 1:N_ROIs
        gui_data.tSNR_ROI{roi} = nan(1, gui_data.Nt);
        gui_data.zscore_ROI{roi} = nan(1, gui_data.Nt);
        gui_data.plot_tSNR_ROI{roi} = plot(gui_data.ax_tSNR, gui_data.t, gui_data.tSNR_ROI{roi}, roi_colors(roi), 'LineWidth', 1.5);
        gui_data.plot_zscore_ROI{roi} = plot(gui_data.ax_globalZ, gui_data.t, gui_data.zscore_ROI{roi}, roi_colors(roi), 'LineWidth', 1.5);
    end
    gui_data.txt_tsnr_wm.String = 'tSNR (ROI1):  0';
    gui_data.txt_tsnr_csf.String = 'tSNR (ROI2):  0';
    gui_data.txt_tsnr_wm.ForegroundColor = 'm';
    gui_data.txt_tsnr_csf.ForegroundColor = 'g';
    
    gui_data.ax_tSNR.YLim = [0 150];
    gui_data.ax_globalZ.YLim = [0 20];
    
    % ROI masking
    gui_data.ROI_img = cell(1,N_ROIs);
    gui_data.ROI_fns{1} = gui_data.ROI1_fn;
    gui_data.ROI_fns{2} = gui_data.ROI2_fn;
    for r = 1:N_ROIs
        gui_data.ROI_img{r} = spm_read_vols(spm_vol(gui_data.ROI_fns{r}));
        gui_data.ROI_img{r}(isnan(gui_data.ROI_img{r})) = 0;
        gui_data.ROI_img{r} = (gui_data.ROI_img{r} >= 0.1);
        gui_data.I_ROI{r} = find(gui_data.ROI_img{r}(:));
    end
end
hold(gui_data.ax_tSNR, 'off')
hold(gui_data.ax_globalZ, 'off')
GM_img = gui_data.F_theplot(gui_data.I_GM, :);
WM_img = gui_data.F_theplot(gui_data.I_WM, :);
CSF_img = gui_data.F_theplot(gui_data.I_CSF, :);
all_img = [GM_img; WM_img; CSF_img];
gui_data.img_thePlot = imagesc(gui_data.ax_thePlot, all_img); 
colormap(gui_data.ax_thePlot, 'gray'); caxis(gui_data.ax_thePlot, [-5 5]);
hold(gui_data.ax_thePlot, 'on');
gui_data.plot_line1 = line(gui_data.ax_thePlot, [1 gui_data.Nt],[gui_data.line1_pos gui_data.line1_pos],  'Color', 'b', 'LineWidth', 2 );
gui_data.plot_line2 = line(gui_data.ax_thePlot, [1 gui_data.Nt],[gui_data.line2_pos gui_data.line2_pos],  'Color', 'g', 'LineWidth', 2 );
hold(gui_data.ax_thePlot, 'off');

gui_data.img_volumesX = imagesc(gui_data.ax_volumesX, squeeze(gui_data.f3D_img(gui_data.slice_numbers(1),:,:)));
gui_data.img_volumesY = imagesc(gui_data.ax_volumesY, squeeze(gui_data.f3D_img(:,gui_data.slice_numbers(2),:)));
gui_data.img_volumesZ = imagesc(gui_data.ax_volumesZ, squeeze(gui_data.f3D_img(:,:,gui_data.slice_numbers(3))));
set(gui_data.ax_volumesX, 'Clim', [0 gui_data.fmax])
set(gui_data.ax_volumesY, 'Clim', [0 gui_data.fmax])
set(gui_data.ax_volumesZ, 'Clim', [0 gui_data.fmax])
colormap(gui_data.ax_volumesX, 'bone');
colormap(gui_data.ax_volumesY, 'bone');
colormap(gui_data.ax_volumesZ, 'bone');
colorbar(gui_data.ax_volumesX);
colorbar(gui_data.ax_volumesY);
colorbar(gui_data.ax_volumesZ);
removeAxesTicks(gui_data.ax_volumesX);
removeAxesTicks(gui_data.ax_volumesY);
removeAxesTicks(gui_data.ax_volumesZ);
gui_data.RT_status = 'initialized';
[gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);
assignin('base', 'gui_data', gui_data)
guidata(fig,gui_data);
% msgbox('Initialized for real-time operation');
end



function startRT(hObject,eventdata)

fig = ancestor(hObject,'figure');
gui_data = guidata(fig);

if ~strcmp(gui_data.RT_status, 'stopped')
    gui_data.i = 1;
end
gui_data.RT_status = 'running';
[gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);

guidata(fig,gui_data);
% assignin('base', 'gui_data', gui_data)
[d, f, e] = fileparts(gui_data.functional4D_fn);


% Start/continue real-time simulation run
while gui_data.i < (gui_data.Nt+1)
    
    gui_data = guidata(fig);
    t0_start = clock;
    txt_dyn.String = ['#' num2str(gui_data.i)];
    % 0: Load dynamic functional image
    if gui_data.use_sample_set == 1
        fdyn_fn = [d filesep 'fanon-0007-' sprintf('%05d',gui_data.i) '-' sprintf('%06d',gui_data.i) '-01' e]; % filename of dynamic functional image
    elseif gui_data.use_sample_set == 2
        fdyn_fn = [d filesep f '_' sprintf('%05d',gui_data.i) e]; % filename of dynamic functional image
    else
        % Insert custom dynamic filename here, either for custom sample
        % data set or for new offline or real-time data
    end
    
    currentVol = spm_vol(fdyn_fn);
    gui_data.F_dyn_img = spm_read_vols(currentVol); % this is the unprocessed image to be used for DVARS and THEPLOT
    gui_data.F_dyn(:,gui_data.i) = gui_data.F_dyn_img(:);
    
    
    % 1:    rtFD - REAL-TIME FRAMEWISE DISPLACEMENT
    % Real-time calculation of estimated absolute displacement of
    % brain, per dynamic. This can help to identify outliers.
    % a) First realign each dynamic image data to functional0 to
    % get Head Movement/Motion Parameters (HMPs / MPs)
    t1_start = clock;
    if gui_data.use_rt == 1
        % Access current 'real-time' volume and assign to second index of R
        gui_data.R(2,1).mat = currentVol.mat;
        gui_data.R(2,1).dim = currentVol.dim;
        gui_data.R(2,1).Vol = gui_data.F_dyn_img;
        
        % realign (FROM OPENNFT: preprVol.m)
        [gui_data.R, gui_data.A0, gui_data.x1, gui_data.x2, gui_data.x3, gui_data.wt, gui_data.deg, gui_data.b, gui_data.nrIter] = spm_realign_rt(gui_data.R, gui_data.flagsSpmRealign, gui_data.i, gui_data.nrSkipVol + 1, gui_data.A0, gui_data.x1, gui_data.x2, gui_data.x3, gui_data.wt, gui_data.deg, gui_data.b);
        
        % MC params (FROM OPENNFT: preprVol.m). STEPHAN NOTE: I don't understand this part, but it runs fine
        tmpMCParam = spm_imatrix(gui_data.R(2,1).mat / gui_data.R(1,1).mat);
        if (gui_data.i == gui_data.nrSkipVol + 1)
            gui_data.P.offsetMCParam = tmpMCParam(1:6);
        end
        gui_data.P.motCorrParam(gui_data.i,:) = tmpMCParam(1:6)-gui_data.P.offsetMCParam; % STEPHAN NOTE: I changed indVolNorm to indVol due to error, not sure if this okay or wrong?
        gui_data.MP(gui_data.i,:) = gui_data.P.motCorrParam(gui_data.i,:);
        % Reslice (FROM OPENNFT: preprVol.m)
        gui_data.reslVol = spm_reslice_rt(gui_data.R, gui_data.flagsSpmReslice);
    else
        r_fdyn_fn = rtRealignReslice(gui_data.functional0_fn, fdyn_fn);
        mp = load([d filesep 'rp_' f '.txt']); % stuff todo
        gui_data.MP(gui_data.i,:) = mp(end,:);
    end
    gui_data.T(gui_data.i,1) = etime(clock,t1_start);
    
    % b) Then load MPs, calculate FD, and load figure data
    t2_start = clock;
    gui_data.MP_mm(gui_data.i,:) = gui_data.MP(gui_data.i,:);
    gui_data.MP_mm(gui_data.i,4:6) = gui_data.MP(gui_data.i,4:6)*gui_data.FD_radius; % 50mm = assumed radius of subject head; from Power et al paper (2014) [1].
    
    if gui_data.i == 1
        mp_diff = zeros(1, 6); % if first dynamic is realigned to functional0, this is technically not correct. TODO
    else
        mp_diff = diff(gui_data.MP_mm(gui_data.i-1:gui_data.i, :));
    end
    fd = sum(abs(mp_diff),2);
    gui_data.FD(gui_data.i) = fd;
    for k = 1:6
        gui_data.MPall{k}(gui_data.i) =  gui_data.MP(gui_data.i,k);
    end
    gui_data.T(gui_data.i,2) = etime(clock,t2_start);
    
    
    % 2:    rtDVARS - REAL-TIME ROOT MEAN VARIANCE OF IMAGE INTENSITY DIFFERENCE
    % Real-time calculation of the variance of difference images,
    % which is an indication of how much the image intensity
    % changes between frames and can help to identify outliers.
    % Description from Power et al paper (2014) [1].
    % Method from Chris Rorden's scripts [2].
    t3_start = clock;
    if gui_data.i == 1
        f_diff = (zeros(1, gui_data.N_vox))';
    else
        f_diff = diff((gui_data.F_dyn(:, gui_data.i-1:gui_data.i))');
        f_diff = f_diff';
    end
    dvars = var(f_diff); % Root Mean Variance across voxels
    gui_data.DVARS(:, gui_data.i) = dvars;
    gui_data.T(gui_data.i,3) = etime(clock,t3_start);
    
    
    % 3:    rtTHEPLOT
    % Real-time calculation of datapoints for customized Matlab version of THEPLOT (from Power, 2017 [3]).
    % This heatmap shows percentage signal change of unprocessed
    % BOLD signal alongside quality traces like FD, DVARS and
    % physiological data, and allows visual inspection of data
    % quality issues.
    % a) First smooth dynamic functional data (see paper) using
    % specified Gaussian kernel fwhm.
    t4_start = clock;
    if gui_data.use_rt == 1
        s_fdyn_img = zeros(gui_data.Ni, gui_data.Nj, gui_data.Nk);
        gKernel = [gui_data.fwhm gui_data.fwhm gui_data.fwhm] ./ gui_data.dicomInfoVox;
        spm_smooth(gui_data.reslVol, s_fdyn_img, gKernel);
    else
        s_fdyn_fn = rtSmooth(fdyn_fn, [gui_data.fwhm gui_data.fwhm gui_data.fwhm]);
        s_fdyn_img = spm_read_vols(spm_vol(s_fdyn_fn));
    end
    gui_data.F_smoothed(:,gui_data.i) = s_fdyn_img(:);
    gui_data.T(gui_data.i,4) = etime(clock,t4_start);
    % b) Then detrend masked data using cumulative GLM. Mask uses
    % combination of GM, WM and CSF masks as derived in
    % preRtPreProc step. Write last iteration's functional data to
    % static value matrix (but growing in size on each iteration).
    % Data detrending is necessary for THEPLOT because (reference)
    t5_start = clock;
    x_func_detrending = gui_data.X_Func_detrending(1:gui_data.i, :);
    beta_func = x_func_detrending\gui_data.F_smoothed(gui_data.I_mask,1:gui_data.i)'; % func = X*beta + e ==> beta = X\func ==> func_detrended = mp - X(i)*beta(i)
    F_detrended = gui_data.F_smoothed(gui_data.I_mask,1:gui_data.i)' - x_func_detrending(:, 1)*beta_func(1, :); % remove effects of all regressors except constant
    F_detrended = F_detrended';
    gui_data.F_dyn_detrended(gui_data.I_mask,gui_data.i) = F_detrended(:,gui_data.i);
    gui_data.T(gui_data.i,5) = etime(clock,t5_start);
    % c) Then calculate percentage signal change for THEPLOT display
    % purposes, using cumulative mean.
    t6_start = clock;
    if gui_data.i == 1
        gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i) = gui_data.F_dyn_detrended(gui_data.I_mask,gui_data.i);
    else
        gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i) = ((gui_data.i-1)*gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i-1) + gui_data.F_dyn_detrended(gui_data.I_mask,gui_data.i))/gui_data.i;
    end
    
    f_perc_signal_change = 100*(gui_data.F_dyn_detrended(gui_data.I_mask,gui_data.i)./gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i)) - 100;
    f_perc_signal_change(isnan(f_perc_signal_change))=0;
    gui_data.F_perc_signal_change(gui_data.I_mask, gui_data.i) = f_perc_signal_change;
    gui_data.F_theplot(gui_data.I_mask, gui_data.i) = gui_data.F_perc_signal_change(gui_data.I_mask, gui_data.i);
    gui_data.T(gui_data.i,6) = etime(clock,t6_start);
    
    
    % 4:    STATISTICS AND COUNTERS
    gui_data.F_stdev(gui_data.I_mask, gui_data.i) = std(gui_data.F_dyn(gui_data.I_mask, 1:gui_data.i), 0, 2);
    gui_data.F_tSNR(gui_data.I_mask, gui_data.i) = gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i)./gui_data.F_stdev(gui_data.I_mask, gui_data.i);
    gui_data.tSNR_dyn_img = reshape(gui_data.F_tSNR(:, gui_data.i), gui_data.Ni, gui_data.Nj, gui_data.Nk);
    
    gui_data.tSNR(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_mask, gui_data.i));
    gui_data.tSNR_gm(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_GM, gui_data.i));
    gui_data.tSNR_wm(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_WM, gui_data.i));
    gui_data.tSNR_csf(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_CSF, gui_data.i));
    
    if fd >= gui_data.FD_threshold
        gui_data.outlier_counter = gui_data.outlier_counter + 1;
        gui_data.FD_outliers = [gui_data.FD_outliers gui_data.i];
        %         gui_data.outlier_reg(gui_data.i) = 1;
        %         gui_data.outlier_reg_Ydata(1, gui_data.i) = gui_data.ax_FD.YLim(2);
    end
    gui_data.FD_sum = gui_data.FD_sum + fd;
    gui_data.FD_dynamic_average = gui_data.FD_sum/gui_data.i;
    
    gui_data.F_zscore(gui_data.I_mask, gui_data.i) = (gui_data.F_dyn(gui_data.I_mask, gui_data.i)-gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i))./gui_data.F_stdev(gui_data.I_mask, gui_data.i);
    gui_data.F_zscore(isnan(gui_data.F_zscore(gui_data.I_mask, gui_data.i)), gui_data.i) = 0;
    gui_data.F_zscore_mean(1, gui_data.i) = mean(gui_data.F_zscore(gui_data.I_mask, gui_data.i));
    
    if gui_data.use_sample_set == 1
        gui_data.zscore_ROI{1}(1, gui_data.i) = mean(gui_data.F_zscore(gui_data.I_ROI{1}, gui_data.i));
        gui_data.zscore_ROI{2}(1, gui_data.i) = mean(gui_data.F_zscore(gui_data.I_ROI{2}, gui_data.i));
        gui_data.tSNR_ROI{1}(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_ROI{1}, gui_data.i));
        gui_data.tSNR_ROI{2}(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_ROI{2}, gui_data.i));
    end
    
    gui_data.txt_Nvolume.String = ['Acquired volumes:  ' num2str(gui_data.i) '/' num2str(gui_data.Nt)];
    gui_data.Nvolume_valid = gui_data.i - gui_data.outlier_counter;
    valid_percentage = round(gui_data.Nvolume_valid/gui_data.i*100, 1);
    gui_data.txt_Nvolume_valid.String = ['Valid volumes:  ' num2str(gui_data.Nvolume_valid) '/' num2str(gui_data.i) ' (' num2str(valid_percentage) '%)'];
    gui_data.txt_fdsum.String = ['Total FD:  ' num2str(round(gui_data.FD_sum,2))];
    gui_data.txt_fdave.String = ['Mean FD:  ' num2str(round(gui_data.FD_dynamic_average,2))];
    gui_data.txt_tsnr.String = ['tSNR (brain):  ' num2str(round(gui_data.tSNR(gui_data.i),2))];
    gui_data.txt_tsnr_gm.String = ['tSNR (GM):  ' num2str(round(gui_data.tSNR_gm(gui_data.i),2))];
    if gui_data.use_sample_set == 1
        gui_data.txt_tsnr_wm.String = ['tSNR (ROI1):  ' num2str(round(gui_data.tSNR_ROI{1}(gui_data.i),2))];
        gui_data.txt_tsnr_csf.String = ['tSNR (ROI2):  ' num2str(round(gui_data.tSNR_ROI{2}(gui_data.i),2))];
    else
        gui_data.txt_tsnr_wm.String = ['tSNR (WM):  ' num2str(round(gui_data.tSNR_wm(gui_data.i),2))];
        gui_data.txt_tsnr_csf.String = ['tSNR (CSF):  ' num2str(round(gui_data.tSNR_csf(gui_data.i),2))];
    end
    
    t7_start = clock;
    
    gui_data_tmp = guidata(fig);
    dim = gui_data_tmp.popup_setDim.Value;
    
    if dim == 1
        gui_data.img_volumesX.Visible = 'on'; gui_data.ax_volumesX.Visible = 'on';
        gui_data.img_volumesY.Visible = 'off'; gui_data.ax_volumesY.Visible = 'off';
        gui_data.img_volumesZ.Visible = 'off'; gui_data.ax_volumesZ.Visible = 'off';
    elseif dim == 2
        gui_data.img_volumesX.Visible = 'off'; gui_data.ax_volumesX.Visible = 'off';
        gui_data.img_volumesY.Visible = 'on'; gui_data.ax_volumesY.Visible = 'on';
        gui_data.img_volumesZ.Visible = 'off'; gui_data.ax_volumesZ.Visible = 'off';
    else
        gui_data.img_volumesX.Visible = 'off'; gui_data.ax_volumesX.Visible = 'off';
        gui_data.img_volumesY.Visible = 'off'; gui_data.ax_volumesY.Visible = 'off';
        gui_data.img_volumesZ.Visible = 'on'; gui_data.ax_volumesZ.Visible = 'on';
    end
    
    if gui_data.prev_dim == dim
        gui_data.slice_numbers(dim) = gui_data_tmp.sld_slice.Value;
        gui_data.slice_numbers(dim) = min(gui_data.slice_numbers(dim), gui_data.Ndims(dim));
    else
        gui_data_tmp.sld_slice.Value = gui_data.slice_numbers(dim);
        
    end
    
    gui_data.sld_slice.SliderStep = [1/gui_data.Ndims(dim) 1/gui_data.Ndims(dim)];
    gui_data.txt_slice.String = ['Change slice: #' num2str(gui_data.slice_numbers(dim))];
%     gui_data.sld_slice.Value = gui_data.slice_numbers(dim);
    gui_data.sld_slice.Max = gui_data.Ndims(dim);
    gui_data.prev_dim = dim;
    guidata(fig,gui_data);
    
%     gui_data.sld_slice.Value = gui_data.slice_numbers(dim);
%     gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);
%     gui_data.sld_slice.SliderStep = [1/gui_data.Ndims(dim) 1/gui_data.Ndims(dim)];
%     gui_data.txt_slice.String = ['Change slice: #' num2str(gui_data.slice_numbers(dim))];
%     drawnow;
%     guidata(fig,gui_data);
    
    drawFD(fig);
    drawZscore(fig);
    drawtSNR(fig);
    drawTHEPLOT(fig);
    drawBrains(fig);

    gui_data.T(gui_data.i,7) = etime(clock,t7_start);
    gui_data.T(gui_data.i,8) = etime(clock,t0_start);
    
    pause(0.001);
    
    gui_data.i = gui_data.i+1;
    gui_data_tmp = guidata(fig);
    drawnow; % one way operation to allow gui itself to update (not to allow other parallel operations to finish processing)
    
    % update guidata - TODO
    if strcmp(gui_data_tmp.RT_status, 'stopped') || (gui_data.i == gui_data.Nt+1)
        gui_data.RT_status = 'stopped';
%         assignin('base', 'gui_data', gui_data)
        guidata(fig,gui_data);
        break;
    end
%     assignin('base', 'gui_data', gui_data)
    guidata(fig,gui_data);
   
end

gui_data.RT_status = 'completed';
[gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);

guidata(fig,gui_data);
assignin('base', 'gui_data', gui_data)



end


function stopRT(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);

gui_data.RT_status = 'stopped';
[gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);

% assignin('base', 'gui_data', gui_data)
guidata(fig,gui_data);
end


function drawFD(fig)
gui_data = guidata(fig);
set(gui_data.plot_FD, 'YData', gui_data.FD);
drawnow;
hold(gui_data.ax_FD,'on');
clear gui_data.line_outliers;
gui_data.line_outliers = line(gui_data.ax_FD, [gui_data.FD_outliers; gui_data.FD_outliers], [gui_data.ax_FD.YLim(2)*ones(1, numel(gui_data.FD_outliers)); zeros(1, numel(gui_data.FD_outliers))],  'Color', 'y', 'LineWidth', 1.5 );
hold(gui_data.ax_FD,'off');
drawnow;
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);
end

function drawtSNR(fig)
gui_data = guidata(fig);
set(gui_data.plot_tSNR, 'YData', gui_data.tSNR);
if gui_data.use_sample_set == 1
    set(gui_data.plot_tSNR_ROI{1}, 'YData', gui_data.tSNR_ROI{1});
    set(gui_data.plot_tSNR_ROI{2}, 'YData', gui_data.tSNR_ROI{2});
end
drawnow;
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);
end


function drawZscore(fig)
gui_data = guidata(fig);
set(gui_data.plot_globalZ, 'YData', gui_data.F_zscore_mean);
if gui_data.use_sample_set == 1
    set(gui_data.plot_zscore_ROI{1}, 'YData', gui_data.zscore_ROI{1});
    set(gui_data.plot_zscore_ROI{2}, 'YData', gui_data.zscore_ROI{2});
end
drawnow;
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);
end

function drawTHEPLOT(fig)
gui_data = guidata(fig);
GM_img = gui_data.F_theplot(gui_data.I_GM, :);
WM_img = gui_data.F_theplot(gui_data.I_WM, :);
CSF_img = gui_data.F_theplot(gui_data.I_CSF, :);
all_img = [GM_img; WM_img; CSF_img];
set(gui_data.img_thePlot, 'CData', all_img);
offline_qc.intensity_scale = [-6 6];
gui_data.ax_thePlot.Title.String = gui_data.ax_thePlot_title;
gui_data.ax_thePlot.YLabel.String = 'voxels';
gui_data.ax_thePlot.XLabel.String = 'Volume #';
drawnow;
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);
end

function setVendor(hObject,eventdata)

end

function setDim(hObject,eventdata)

end


function setImg(hObject,eventdata)
% fig = ancestor(hObject,'figure');
% gui_data = guidata(fig);
% gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);
% gui_data.slice_number = floor(gui_data.Ndims(gui_data.popup_setDim.Value)/2);
% gui_data.sld_slice.Value = gui_data.slice_number;
% gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);
% gui_data.sld_slice.SliderStep = [1/gui_data.Ndims(gui_data.popup_setDim.Value) 1/gui_data.Ndims(gui_data.popup_setDim.Value)];
% gui_data.txt_slice.String = ['Change slice: #' num2str(gui_data.slice_number)];
% guidata(fig, gui_data);
end

function changeSlice(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
dim = gui_data.popup_setDim.Value;
gui_data.slice_numbers(dim) = round(hObject.Value);
gui_data.slice_numbers(dim) = min(gui_data.slice_numbers(dim), gui_data.Ndims(dim));
gui_data.txt_slice.String = ['Change slice: #' num2str(gui_data.slice_numbers(dim))];
gui_data.sld_slice.Value = gui_data.slice_numbers(dim);
gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);
gui_data.sld_slice.SliderStep = [1/gui_data.Ndims(dim) 1/gui_data.Ndims(dim)];
% gui_data.txt_slice.String = ['Change slice: #' num2str(gui_data.slice_numbers(dim))];
drawnow;
% assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end


function checkVolumeSettings(fig)
% gui_data = guidata(fig);
% % dimension = gui_data.popup_setDim.Value;
% % 
% % gui_data.sld_slice.Max = gui_data.Ndims(dimension);
% % gui_data.slice_number = floor(gui_data.Ndims(gui_data.popup_setDim.Value)/2);
% gui_data.sld_slice.Value = gui_data.slice_number;
% gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);
% guidata(fig, gui_data);

end

function drawBrains(fig)
gui_data = guidata(fig);

if gui_data.popup_setImg.Value == 1
    set(gui_data.img_volumesX, 'CData', squeeze(gui_data.F_dyn_img(gui_data.slice_numbers(1),:,:)));
    set(gui_data.img_volumesY, 'CData', squeeze(gui_data.F_dyn_img(:,gui_data.slice_numbers(2),:)));
    set(gui_data.img_volumesZ, 'CData', squeeze(gui_data.F_dyn_img(:,:,gui_data.slice_numbers(3))));
    set(gui_data.ax_volumesX, 'Clim', [0 gui_data.fmax])
    set(gui_data.ax_volumesY, 'Clim', [0 gui_data.fmax])
    set(gui_data.ax_volumesZ, 'Clim', [0 gui_data.fmax])
    colormap(gui_data.ax_volumesX, 'bone');
    colormap(gui_data.ax_volumesY, 'bone');
    colormap(gui_data.ax_volumesZ, 'bone');
else
    set(gui_data.img_volumesX, 'CData', squeeze(gui_data.tSNR_dyn_img(gui_data.slice_numbers(1),:,:)));
    set(gui_data.img_volumesY, 'CData', squeeze(gui_data.tSNR_dyn_img(:,gui_data.slice_numbers(2),:)));
    set(gui_data.img_volumesZ, 'CData', squeeze(gui_data.tSNR_dyn_img(:,:,gui_data.slice_numbers(3))));
    set(gui_data.ax_volumesX, 'Clim', [0 gui_data.tmax])
    set(gui_data.ax_volumesY, 'Clim', [0 gui_data.tmax])
    set(gui_data.ax_volumesZ, 'Clim', [0 gui_data.tmax])
    colormap(gui_data.ax_volumesX, 'hot');
    colormap(gui_data.ax_volumesY, 'hot');
    colormap(gui_data.ax_volumesZ, 'hot');
end

drawnow;
% gui_data.ax_volumes.Title.String = '';
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);

end




function [pb_initialize, pb_startRT, pb_stopRT] = rtControlsDisplay(RT_status)

% RT_status = initialized, running, stopped, completed.
% [gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);
% if strcmp(RT_status, 'running')
%     pb_stopRT = 'on';
%     pb_startRT = 'off';
%     pb_initialize = 'off';
% end

switch RT_status
    case 'initialized'
        pb_initialize = 'on';
        pb_startRT = 'on';
        pb_stopRT = 'off';
    case 'running'
        pb_initialize = 'off';
        pb_startRT = 'off';
        pb_stopRT = 'on';
    case 'stopped'
        pb_initialize = 'on';
        pb_startRT = 'on';
        pb_stopRT = 'off';
    case 'completed'
        pb_initialize = 'on';
        pb_startRT = 'on';
        pb_stopRT = 'off';
    otherwise
        
end

end


% Offline tab functions

function runOfflineQC(hObject,eventdata)
fig = ancestor(hObject,'figure');

gui_data = guidata(fig);
offline_qc = struct;
if gui_data.preProc_status ~= 1
    errordlg('Please first complete the preprocessing in the PRE-NF QC tab','Preprocessing not done!');
    return;
end

if ~isfield(gui_data, 'qc_out_dir')
    gui_data.qc_out_dir = [gui_data.data_dir filesep 'rtQC_output'];
end
if ~exist(gui_data.qc_out_dir, 'dir')
    mkdir(gui_data.qc_out_dir)
end
cd(gui_data.qc_out_dir)

mmessage = 'Please wait while rtQC runs offline processing and quality assessment on all data. This may take a few minutes. When completed, the figures below will display QC information.';
mtitle = 'Running Offline QA';
msgbox(mmessage,mtitle);

% Gaussian kernel smoothing of unprocessed data
gui_data.fwhm = 6;
[d, f, e] = fileparts(gui_data.functional4D_fn);
gui_data.sfunctional4D_fn = [d filesep 's' f e];
if ~exist(gui_data.sfunctional4D_fn, 'file')
    gui_data.sfunctional4D_fn = rtQC_offline_smooth(gui_data.functional4D_fn, gui_data.Nt, gui_data.fwhm);
end
% Detrend 4D time series (smoothed and unsmoothed)
output = rtQC_detrend4D(gui_data.functional4D_fn);
offline_qc.detrend_output = output;
offline_qc.F4D_detrended = output.F4D_detrended;
offline_qc.F2D_detrended = output.F_2D_detrended;
% Statistical measures
offline_qc.F2D_mean = mean(offline_qc.F2D_detrended, 2);
offline_qc.F2D_stddev = std(offline_qc.F2D_detrended, 0, 2);
offline_qc.F2D_zstat = (offline_qc.F2D_detrended - offline_qc.F2D_mean)./offline_qc.F2D_stddev;
offline_qc.F2D_zstat(isnan(offline_qc.F2D_zstat))=0;
offline_qc.F2D_zstat_mean = mean(abs(offline_qc.F2D_zstat),1);
offline_qc.Zstat_mean = mean(offline_qc.F2D_zstat_mean);
offline_qc.F2D_var = var(offline_qc.F2D_detrended,0,2);
offline_qc.F2D_psc = 100*(offline_qc.F2D_detrended./repmat(offline_qc.F2D_mean, 1, gui_data.Nt)) - 100;
offline_qc.F2D_psc(isnan(offline_qc.F2D_psc))=0;
% Framewise displacement
gui_data.FD_radius = 50; % in mm
offline_qc.FD_measures = rtQC_calculateFD(gui_data.MP, gui_data.FD_radius, gui_data.FD_threshold);
% DVARS
assignin('base', 'offline_qc', offline_qc)
offline_qc.F2D_diff = [zeros(1, gui_data.Ni*gui_data.Nj*gui_data.Nk); diff(offline_qc.F2D_detrended')]';
offline_qc.DVARS = var(offline_qc.F2D_diff);
% GCOR
% Steps according to https://doi.org/10.1089/brain.2013.0156:
% (1)De-mean each voxel's time series and scale it by its Eucledian norm
% (2)Average scaled time series over the whole brain mask
% (3)GCOR is the length (L2 norm) of this averaged series
offline_qc.F2D_demeaned = offline_qc.F2D_detrended - offline_qc.F2D_mean;
offline_qc.F2D_norms = sqrt(sum(offline_qc.F2D_demeaned.^2,2));
offline_qc.F2D_scaled = offline_qc.F2D_demeaned./offline_qc.F2D_norms;
offline_qc.F2D_ave_timeseries = mean(offline_qc.F2D_scaled(gui_data.I_mask,:), 1);
offline_qc.GCOR = sum(offline_qc.F2D_ave_timeseries.^2,2);
% tSNR
offline_qc.tSNR_2D = offline_qc.F2D_mean./offline_qc.F2D_stddev;
offline_qc.tSNR_brain = mean(offline_qc.tSNR_2D(gui_data.I_mask));
offline_qc.tSNR_GM = mean(offline_qc.tSNR_2D(gui_data.I_GM));
offline_qc.tSNR_WM = mean(offline_qc.tSNR_2D(gui_data.I_WM));
offline_qc.tSNR_CSF = mean(offline_qc.tSNR_2D(gui_data.I_CSF));
% The Plot (with FD, DVARS, and mean Zscore per volume)
offline_qc.intensity_scale = [-6 6];
offline_qc.GM_img = offline_qc.F2D_psc(gui_data.I_GM, :);
offline_qc.WM_img = offline_qc.F2D_psc(gui_data.I_WM, :);
offline_qc.CSF_img = offline_qc.F2D_psc(gui_data.I_CSF, :);
offline_qc.all_img = [offline_qc.GM_img; offline_qc.WM_img; offline_qc.CSF_img];
line1_pos = numel(gui_data.I_GM);
line2_pos = numel(gui_data.I_GM) + numel(gui_data.I_WM);

tf = figure('visible', 'off');
fontsizeL = 14;
fontsizeM = 11;

ax1 = subplot(7,1,4:7);
imagesc(ax1, offline_qc.all_img); colormap(ax1, 'gray'); caxis(ax1, offline_qc.intensity_scale);
title(ax1, 'The Plot','fontsize',fontsizeL)
ylabel(ax1, 'Voxels','fontsize',fontsizeM)
xlabel(ax1, 'fMRI volumes','fontsize',fontsizeM)

hold(ax1, 'on');
line(ax1, [1 gui_data.Nt],[line1_pos line1_pos],  'Color', 'b', 'LineWidth', 2 )
line(ax1, [1 gui_data.Nt],[line2_pos line2_pos],  'Color', 'r', 'LineWidth', 2 )
hold(ax1, 'off');
imagesc(gui_data.ax_thePlot_offline, offline_qc.all_img); colormap(gui_data.ax_thePlot_offline, 'gray'); caxis(gui_data.ax_thePlot_offline, offline_qc.intensity_scale);
hold(gui_data.ax_thePlot_offline, 'on');
line(gui_data.ax_thePlot_offline, [1 gui_data.Nt],[line1_pos line1_pos],  'Color', 'b', 'LineWidth', 2 )
line(gui_data.ax_thePlot_offline, [1 gui_data.Nt],[line2_pos line2_pos],  'Color', 'r', 'LineWidth', 2 )
hold(gui_data.ax_thePlot_offline, 'off');
gui_data.ax_thePlot_offline.Title.String = gui_data.ax_thePlot_title;
gui_data.ax_thePlot_offline.YLabel.String = 'voxels';
gui_data.ax_thePlot_offline.XLabel.String = 'Volume #';

ax2 = subplot(7,1,1);
plot(ax2, offline_qc.FD_measures.FD, 'LineWidth', 2); grid;
set(ax2,'Xticklabel',[]);
title(ax2, 'FD','fontsize',fontsizeL)
ylabel(ax2, 'mm','fontsize',fontsizeM)
plot(gui_data.ax_FD_offline, offline_qc.FD_measures.FD, 'LineWidth', 2);
gui_data.ax_FD_offline.Title.String = gui_data.ax_FD_title;
gui_data.ax_FD_offline.YLabel.String = 'mm';
removeAxesXTickLabels(gui_data.ax_FD_offline);
grid(gui_data.ax_FD_offline);

ax3 = subplot(7,1,2);
plot(ax3, offline_qc.DVARS, 'LineWidth', 2); grid(ax3);
set(ax3,'Xticklabel',[]);
title(ax3, 'DVARS','fontsize',fontsizeL)
ylabel(ax3, 'a.u.','fontsize',fontsizeM)
plot(gui_data.ax_DVARS_offline, offline_qc.DVARS, 'LineWidth', 2);
gui_data.ax_DVARS_offline.Title.String = gui_data.ax_DVARS_title;
gui_data.ax_DVARS_offline.YLabel.String = 'a.u.';
removeAxesXTickLabels(gui_data.ax_DVARS_offline);
grid(gui_data.ax_DVARS_offline);

ax4 = subplot(7,1,3);
plot(ax4, offline_qc.F2D_zstat_mean, 'LineWidth', 2); grid(ax4);
set(ax4,'Xticklabel',[]);
title(ax4, 'Z-score','fontsize',fontsizeL)
ylabel(ax4, 'a.u.','fontsize',fontsizeM)
plot(gui_data.ax_globalZ_offline, offline_qc.F2D_zstat_mean, 'LineWidth', 2);
gui_data.ax_globalZ_offline.Title.String = gui_data.ax_globalZ_title;
gui_data.ax_globalZ_offline.YLabel.String = 'a.u.';
removeAxesXTickLabels(gui_data.ax_globalZ_offline);
grid(gui_data.ax_globalZ_offline);

print(tf, 'timeseries_summary', '-dpng')
close(tf)

% Prepare 3D and 4D images
offline_qc.mask_3D = reshape(gui_data.mask_reshaped, gui_data.Ni, gui_data.Nj, gui_data.Nk);
offline_qc.tSNR_3D = reshape(offline_qc.tSNR_2D, gui_data.Ni, gui_data.Nj, gui_data.Nk);
offline_qc.F3D_mean = reshape(offline_qc.F2D_mean, gui_data.Ni, gui_data.Nj, gui_data.Nk);
offline_qc.F3D_var = reshape(offline_qc.F2D_var, gui_data.Ni, gui_data.Nj, gui_data.Nk);
offline_qc.F3D_stddev = reshape(offline_qc.F2D_stddev, gui_data.Ni, gui_data.Nj, gui_data.Nk);
offline_qc.tSNR_2D_masked = zeros(gui_data.Ni*gui_data.Nj*gui_data.Nk, 1);
offline_qc.tSNR_2D_masked(gui_data.I_mask, :) = offline_qc.tSNR_2D(gui_data.I_mask, :);
offline_qc.tSNR_3D_masked = reshape(offline_qc.tSNR_2D_masked, gui_data.Ni, gui_data.Nj, gui_data.Nk);
% Create montages of 3D images
montage2 = rtQC_createMontage(offline_qc.F3D_mean, 5, 1, 'Mean EPI (whole image)', 'gray', 'off');
print(montage2.f, 'mean_epi', '-dpng')
im1 = imagesc(gui_data.ax_epimean_offline, montage2.image); colormap(gui_data.ax_epimean_offline, 'gray');
removeAxesTicks(gui_data.ax_epimean_offline);
colorbar(gui_data.ax_epimean_offline);

montage3 = rtQC_createMontage(offline_qc.F3D_stddev, 5, 1, 'Standard deviation (whole image)', 'parula', 'off');
print(montage3.f, 'stddev_epi', '-dpng')
im2 = imagesc(gui_data.ax_epistddev_offline, montage3.image); colormap(gui_data.ax_epistddev_offline, 'parula');
removeAxesTicks(gui_data.ax_epistddev_offline);
colorbar(gui_data.ax_epistddev_offline);

montage1 = rtQC_createMontage(offline_qc.tSNR_3D, 5, 1, 'tSNR (whole image)', 'hot', 'off');
print(montage1.f, 'tsnr_whole', '-dpng')
im3 = imagesc(gui_data.ax_tsnrwhole_offline, montage1.image); colormap(gui_data.ax_tsnrwhole_offline, 'hot');
removeAxesTicks(gui_data.ax_tsnrwhole_offline);
colorbar(gui_data.ax_tsnrwhole_offline);

montage4 = rtQC_createMontage(offline_qc.tSNR_3D_masked, 5, 1, 'tSNR (brain)', 'hot', 'off');
print(montage4.f, 'tsnr_brain', '-dpng')
im4 = imagesc(gui_data.ax_tsnrbrain_offline, montage4.image); colormap(gui_data.ax_tsnrbrain_offline, 'hot');
removeAxesTicks(gui_data.ax_tsnrbrain_offline);
colorbar(gui_data.ax_tsnrbrain_offline);

im5 = imagesc(gui_data.ax_registration_offline, montage2.image); colormap(gui_data.ax_registration_offline, 'gray');
removeAxesTicks(gui_data.ax_registration_offline);
colorbar(gui_data.ax_registration_offline);
hold(gui_data.ax_registration_offline, 'on');
montage_mask = rtQC_createMontage(offline_qc.mask_3D, 5, 1, 'Mask image', 'gray', 'off');
bin_mask_img = false(size(montage_mask.image));
bin_mask_img(montage_mask.image>0) = true;
bound_whole_bin = bwboundaries(bin_mask_img);
Nblobs_bin = numel(bound_whole_bin);
for b = 1:Nblobs_bin
    p5 = plot(gui_data.ax_registration_offline, bound_whole_bin{b,1}(:,2), bound_whole_bin{b,1}(:,1), 'r', 'LineWidth', 1);
end
hold(gui_data.ax_registration_offline, 'off');
figmask = rtQC_displayMaskContour(offline_qc.F3D_mean, offline_qc.mask_3D, 0, 3, 'off');
print(figmask, 'mask_contour', '-dpng')
% im5 = imagesc(gui_data.ax_registration_offline, figmask);

% close montage1.f montage2.f montage3.f montage4.f

gui_data.offline_qc = offline_qc;

assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);

end

function generateReport(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
offline_qc = gui_data.offline_qc;
% Create HTML log file
gui_data.subject_id = 'subj1';
dt = datetime('now');
[Y,MO,D,H,MI,S] = datevec(dt);
dt_str = [num2str(Y) num2str(MO) num2str(D) num2str(H) num2str(MI) num2str(round(S))];
t = datestr(dt);
log_name = [gui_data.subject_id '_' dt_str '.html'];
fid = fopen([gui_data.qc_out_dir filesep log_name],'a');
fprintf(fid, '<H2>Log</H2>');
fprintf(fid, ['\n<BR>Subject:  ' gui_data.subject_id]);
fprintf(fid, ['\n<BR>Date/time:  ' t]);
fprintf(fid, '<H2>Imaging info</H2>');
fprintf(fid, ['\nVolumes:  ' num2str(gui_data.Nt)]);
fprintf(fid, ['\n<BR>Voxels (x,y,z):  ' num2str(gui_data.Ni) ', ' num2str(gui_data.Nj) ', ' num2str(gui_data.Nk)]);
fprintf(fid, '<H2>Timeseries summary</H2>');
fprintf(fid, '\n<TABLE><TR><TD><img src="timeseries_summary.png" alt="no picture" width=700 height=600></TD></TR></TABLE>' );
fprintf(fid, '<H2>QC Metrics</H2>');
fprintf(fid, ['\nFD threshold (mm):  ' num2str(gui_data.FD_threshold)]);
fprintf(fid, ['\n<BR>FD outliers:  ' num2str(numel(offline_qc.FD_measures.FD_outliers_ind))]);
fprintf(fid, ['\n<BR>Total FD:  ' num2str(offline_qc.FD_measures.FD_sum)]);
fprintf(fid, ['\n<BR>Mean FD:  ' num2str(offline_qc.FD_measures.FD_mean)]);
fprintf(fid, ['\n<BR>Mean Zscore:  ' num2str(offline_qc.Zstat_mean)]);
fprintf(fid, ['\n<BR>GCOR:  ' num2str(offline_qc.GCOR)]);
fprintf(fid, ['\n<BR>tSNR (brain):  ' num2str(offline_qc.tSNR_brain)]);
fprintf(fid, ['\n<BR>tSNR (GM):  ' num2str(offline_qc.tSNR_GM)]);
fprintf(fid, ['\n<BR>tSNR (WM):  ' num2str(offline_qc.tSNR_WM)]);
fprintf(fid, ['\n<BR>tSNR (CSF):  ' num2str(offline_qc.tSNR_CSF)]);
fprintf(fid, '<H2>QC brain images</H2>');
fprintf(fid, '\n<TABLE><TR><TD><img src="mean_epi.png" alt="no picture" width=700 height=600></TD></TR></TABLE>' );
fprintf(fid, '\n<TABLE><TR><TD><img src="stddev_epi.png" alt="no picture" width=700 height=600></TD></TR></TABLE>' );
fprintf(fid, '\n<TABLE><TR><TD><img src="tsnr_whole.png" alt="no picture" width=700 height=600></TD></TR></TABLE>' );
fprintf(fid, '\n<TABLE><TR><TD><img src="tsnr_brain.png" alt="no picture" width=700 height=600></TD></TR></TABLE>' );
fprintf(fid, '\n<TABLE><TR><TD><img src="mask_contour.png" alt="no picture" width=700 height=700></TD></TR></TABLE>' );
% add physio plots
phys_dir = gui_data.edit_physio_save_dir.String;
if exist([gui_data.qc_out_dir filesep phys_dir])
    fprintf(fid, '<H2>Physio processing plots</H2>');
    figure_file_gen = split(gui_data.edit_verbose_fig_output_file.String, '.');
    figure_file = cell2mat(join([figure_file_gen(1) '_05.' figure_file_gen(2)], ''));
    img_to_plot =  [phys_dir '/' figure_file]; % possible option (this works if in settings tab just allow input of directory name
    % add other figures
    fprintf(fid, sprintf('\n<TABLE><TR><TD><img src="%s" alt="no picture" width=700 height=600></TD></TR></TABLE>', img_to_plot));
end
fclose(fid);
url = ['file:///' gui_data.qc_out_dir filesep log_name];
web(url, '-browser');

end

function physioBatch(hObject,eventdata)
    
    % get guidata
    fig = ancestor(hObject,'figure');
    gui_data = guidata(fig);
    
    vendor = gui_data.popup_setVendor.String(gui_data.popup_setVendor.Value);
    if strcmp(vendor, 'select vendor...')
        errordlg('First set vendor in drop down menu to the right of the button.');    
    end
   
    %% read nr slices and nr scans from nifti header:
    % hdr = spm_vol('C:\Users\nwiedemann\Downloads\rtQC_sample_data\rtQC_sample_data\sub-opennft\fanon-0007.nii')
    % nr_scans = length(hdr)
    % nr_slices = hdr(1).dim(3)
    %%
    % default path for cardiac and respiratory inputs:
    default_path = gui_data.data_dir;
    % default_path = 'C:\Users\nwiedemann\Downloads\tapas\tapas\misc\example\PhysIO';
    
    wrapper_physiobatch(char(vendor), gui_data.qc_out_dir, default_path, gui_data);
end

function showFDoutliers(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);

figure('position', [100 100 500 900], 'units','normalized');
gui_data.outlier_reg(gui_data.FD_outliers) = 1;
im = imagesc(gui_data.outlier_reg');
removeAxesXTickLabels(gca);
title(['FD outliers (white) based on threshold of ' num2str(gui_data.FD_threshold) ' mm per volume'])
ylabel('Time')
colormap gray; colorbar;

if ~isfield(gui_data, 'qc_out_dir')
    gui_data.qc_out_dir = [gui_data.data_dir filesep 'rtQC_output'];
end
if ~exist(gui_data.qc_out_dir, 'dir')
    mkdir(gui_data.qc_out_dir)
end
dlmwrite([gui_data.qc_out_dir filesep 'FD_outliers_regressor.txt'], gui_data.outlier_reg')

end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% assignin('base', 'src',src)
% assignin('base', 'eventdata',eventdata)

% % Create figure
% figure_handle = figure('Toolbar','none');
% % create structure of handles
% myhandles = guihandles(figure_handle);
% % Add some additional data as a new field called numberOfErrors
% myhandles.numberOfErrors = 0;
% % Save the structure
% guidata(figure_handle,myhandles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function removeAxesTicks(ax)
set(ax,'xtick',[])
set(ax,'xticklabel',[])
set(ax,'ytick',[])
set(ax,'yticklabel',[])
set(ax,'ztick',[])
set(ax,'zticklabel',[])
end

function removeAxesXTickLabels(ax)
set(ax,'xticklabel',[])
end






