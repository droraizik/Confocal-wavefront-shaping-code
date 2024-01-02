clc;
clear;
close all;
addpath('functions');
addpath('Scripts');
laser_off;
try
    %% Settings
    settings_script;
    save_name =                                 'deep_neuron_400um';
    %% Initialize
    Initialize_system;
    %% Original images
    capture_original;
    %% Optimization
    Optimization_script;
    %% Evaluation
    evaluate_optimization_BSI;
    evaluate_optimization_PG;
    %% find tilt shift parameter
    tilt_shift_find_alpha;
    tilt_shift_scan_PG;
    %% Big FOV
    capture_big_area_PG;
    capture_big_area_BSI;
    confocal_scan; 
    %% finish
    save_data;
catch e
    error_script;
end


