function final = whiten_spectrogram(s)
lt = length(s);
image_double = 10.^((im2double(s)*80-20)/20);

% First Pass
% Find noise frames
enrg_t = mean(abs(s).^2); % compute enrg as a fcn of time
htmp = floor(lt*0.05); % 5% of frames
[val,eidx] = sort(enrg_t,'ascend');
iv = eidx(1:htmp); % time-index to bottom 10% frames (in terms of enrg)

% compute a smooth noise spectrum estimate
psd_noise = mean(abs(s(:,iv).').^2)+1e-10; % compute noise PSD

MM = 0; % tweaking parameter (large MM - smoother noise PSD)
m2 = 2*MM+1;
z = conv(psd_noise,ones(m2,1))/m2; % smooth PSD
psd_noise_new = (z(1+MM:end-MM));
psd_noise(m2:end-m2) = psd_noise_new(m2:end-m2);
psd_noise = psd_noise';

psd_noise_mat=psd_noise*ones(1,lt); % power spectral density of the noise

% denoising
Wf = 1./sqrt(psd_noise_mat);
absspect1 = image_double.*Wf;

enrg_t = mean(absspect1.^2); % compute enrg as a fcn of time
htmp = floor(lt*0.20);
[val,eidx] = sort(enrg_t,'ascend');
iv = eidx(1:htmp); % time-index to bottom 20% frames (in terms of enrg)

% compute a smooth noise spectrum estimate
psd_noise = mean(abs(s(:,iv).').^2)+1e-10; % compute noise PSD

MM = 0; % tweaking parameter (large MM - smoother noise PSD)
m2 = 2*MM+1;
z = conv(psd_noise,ones(m2,1))/(m2); % smooth PSD
psd_noise_new = (z(1+MM:end-MM));
psd_noise(m2:end-m2) = psd_noise_new(m2:end-m2);
psd_noise = psd_noise';

psd_noise_mat=psd_noise*ones(1,lt);

% estimating average signal power (not used with the noise divide option)
Q = 500;
[val7,idx7] = sort(absspect1(:),'descend');
emask = zeros(size(absspect1));
emask(idx7(1:Q)) = 1; % signal mask (1 for signal above threshold and 0 otherwise)
avg_max_sp = sum(sum(image_double.^2.*emask))/Q; % average signal power over the mask
avg_sp = avg_max_sp/100; % arbitrary conversion between max to average

Wf = 1./sqrt(psd_noise_mat);
absspect1 = image_double.*Wf;
absspect = absspect1;

% threshold;
rr = length(absspect(:));
qq = sort(absspect(:),'descend');
hh = qq(1);

final = absspect/hh;
