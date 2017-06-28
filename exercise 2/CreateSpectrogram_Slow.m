%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is significantly slower and more complicated  %
% than the other. This function reads the audio many times,   %
% specifying the number of samples to take from the file each %
% time. This results in a much longer function.               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

audiofiles = dir('../audios/*.wav');

% Run Time: 690 seconds
% Iterate through audio files
for i = 1:numel(audiofiles)
    fprintf('%2.2f%% complete\n', (i/numel(audiofiles))*100);

    % Get audio file information
    info = audioinfo(strcat('../audios/', audiofiles(i).name));
    
    ten_sec = 10*info.SampleRate;
    
    % Iterate through 10 second chunks of the audio file
    remaining = info.Duration;
    for n = 1:ceil(info.Duration / 10)
        % Check if at least 10 seconds are remaining in the file
        if remaining >= 10
            % If so, read next 10 seconds
            samples = [(n-1)*ten_sec+1, n*ten_sec];
            [y, Fs] = audioread(strcat('../audios/', audiofiles(i).name), samples);
            
            % Decease time remaining by 10
            remaining = remaining - 10;
        else
            % If not, read the remainder of the file
            samples = [(n-1)*ten_sec+1, (n-1)*ten_sec+ceil(remaining*info.SampleRate)];
            [y, Fs] = audioread(strcat('../audios/', audiofiles(i).name), samples);
        end
        
        % Verify that the audio sample is large enough
        if length(y(:, 1)) > 500
            % Create spectrogram of audio sample
            fbins = fbins_per_fft * window;
            dn = round((1 - overlap_ratio) * window);
            [s, f, t] = spectrogram(y(:, 1), window, window - dn, fbins, fs);
            
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
