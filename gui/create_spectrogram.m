function s = create_spectrogram(y, Fs)
window = 512;
fbins_per_fft = 2;
overlap_ratio = 0.5;

% Define number of rows of cells
% For a 20 second audio file, want 120 rows of 10 second audio (10*Fs),
% but there are still some bytes remiaining. To account for that, we
% add on the remainder to the end of this matrix.
s = [repmat(10*Fs, floor(length(y)/(10*Fs)), 1); mod(length(y), 10*Fs)];

% Convert audio matrix to cells
audio_cells = mat2cell(y, s, 1);

% Iterate through 10 second chunks of the audio cells
for n = 1:length(audio_cells)
    audio = audio_cells{n};

    % Verify that the audio sample is large enough
    if length(audio(:, 1)) > 500
        % Create spectrogram of audio sample
        fbins = fbins_per_fft * window;
        dn = round((1 - overlap_ratio) * window);
        [s, f, t] = spectrogram(audio(:, 1), window, window - dn, fbins, Fs);
        
        % Use only 4000Hz to 12000Hz
        idx = find(f >= 100 & f < 3750);
        s = s(idx, :);
        f = f(idx);
        
        % Get the absolute value of the spectrogram
        v = abs(s(:));

        % Flip the spectrogram
        s = flipud(s);
        
        % Scale to use decibels
        scale = 20 * log10(abs(s) / median(v) + 0.1);
        s = (scale + 20) / 80;
    end
end
