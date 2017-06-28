textfiles = dir('../../textfiles/*.txt');

% Iterate through text files in the ../../textfiles directory
for i = 1:numel(textfiles)
    % Read the text file
    textfile = load(strcat('../../textfiles/', textfiles(i).name));

    % Remove the first three lines of text file
    textfile_modified = textfile;
    textfile_modified(1:3, :) = [];

    % Write new text file to ../new_textfiles/filename_modified.txt
    split = strsplit(textfiles(i).name, '.');
    path = sprintf('../new_textfiles/%s_modified.txt', split{1});
    csvwrite(path, textfile_modified);
end
