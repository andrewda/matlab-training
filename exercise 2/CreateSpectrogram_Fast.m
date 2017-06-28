%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is significantly faster than the other. Instead %
% of reading the file many times, it only reads each audio file %
% once, then splits the audio as a matrix.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

audiofiles = dir('../audios/*.wav');

window = 512;
fbins_per_fft = 2;
overlap_ratio = 0.5;

% Run Time: 500 seconds
% Iterate through audio files
for i = 1:numel(audiofiles)
    fprintf('%2.2f%% complete\n', (i/numel(audiofiles))*100);
    
    % Read audio file and determine its length in seconds
    [y, fs] = audioread(strcat('../audios/', audiofiles(i).name));

    % Define number of rows of cells
    % For a 20 second audio file, want 120 rows of 10 second audio (10*Fs),
    % but there are still some bytes remiaining. To account for that, we
    % add on the remainder to the end of this matrix.
    s = [repmat(10*fs, floor(length(y)/(10*fs)), 1); mod(length(y), 10*fs)];

    % Convert audio matrix to cells
    audio_cells = mat2cell(y, s, 2);
    
    % Iterate through 10 second chunks of the audio cells
    for n = 1:length(audio_cells)
        audio = audio_cells{n};
        
        % Verify that the audio sample is large enough
        if length(audio(:, 1)) > 500
            % Create spectrogram of audio sample
            fbins = fbins_per_fft * window;
            dn = round((1 - overlap_ratio) * window);
            [s, f, t] = spectrogram(audio(:, 1), window, window - dn, fbins, fs);
            
            % Use only 4000Hz to 12000Hz
%             idx = find(f >= 4000 & f < 12000);
%             s = s(idx, :);
%             f = f(idx);

            % Get the absolute value of the spectrogram
            v = abs(s(:));

            % Flip the spectrogram
            s = flipud(s);

            % Scale to use decibels
            scale = 20 * log10(abs(s) / median(v) + 0.1);
            s = (scale + 20) / 80;
        
            % Write image as bitmap
            split = strsplit(audiofiles(i).name, '.');
            path = sprintf('./spectrograms/%s_chunk_%03d.bmp', split{1}, n);
            imwrite(s, path, 'bmp');
        end
    end
end
