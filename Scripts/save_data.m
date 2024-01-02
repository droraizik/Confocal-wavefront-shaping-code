%% save 
num_saves = length(save_params);
text = ['''' save_params{1} ''','];
for i = 1:num_saves-1
    if(exist(save_params{i+1},'var'))
        text = [text '''' save_params{i+1} ''','];
    end
end
text = text(1:end-1);

save_time = datestr(datevec(now),'yyyy_mm_dd_HH_MM_SS');
save_command = ['save(''' save_folder '\' save_time '_' save_name ''',' text ',''-v7.3'')'];
eval(save_command);
