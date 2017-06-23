n = 1024*16;
options.n = n;
[x,fs] = audioread('bird.wav', n);

clf;
plot(1:n,x);
axis('tight');
set_graphic_sizes([], 20);
title('Signal');
