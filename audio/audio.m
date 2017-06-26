[song, fs] = audioread('bird.wav');
song = song(1:fs*20);
spectrogram(song, 256, [], [], fs, 'yaxis');
