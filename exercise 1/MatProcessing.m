matfiles = dir('../../matfiles/*.mat');

% Iterate through mat files in the ../../matfiles directory
for i = 1:numel(matfiles)
    % Read the mat file
    matfile = load(strcat('../../matfiles/', matfiles(i).name));

    % Remove the first three lines of mat file
    matfile_modified = matfile;
    matfile_modified.a(1:3, :) = [];

    % Write new mat file to ../new_matfiles/filename_modified.mat
    split = strsplit(matfiles(i).name, '.');
    path = sprintf('../new_matfiles/%s_modified.mat', split{1});
    save(path, 'matfile_modified');
end
