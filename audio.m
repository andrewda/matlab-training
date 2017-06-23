n = 1792400;
options.n = n;
[x,fs] = audioread('bird.wav');

clf;
plot(1:n,x);
axis('tight');
title('Signal');
