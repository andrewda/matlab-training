run('../config.m');
spectrograms = dir('../../Assignment2/Andrew/spectrograms/*.bmp');
    
for i = 1:numel(spectrograms)
	filename_in = strcat(spectrograms(i).folder, '/', spectrograms(i).name);
	filename_out = strcat('./whitening/', spectrograms(i).name);
	[s1] = imread(filename_in);
	lt = length(s1);
	image_double = 10.^((im2double(s1)*80-20)/20);
	
    if(smoothing_method == 3)
        [h,w] = size(image_double);
        imsort = sort(image_double','ascend')'; % sort each row
        w2 = ceil(w/10); % consider the bottom 10% as noise
        npsd = mean(imsort(:,1:w2),2);
        imnew = image_double./(npsd*ones(1,w));

        if display
            figure(1)
            plot(npsd) % uncomment to visualize the noise psd
            figure(2)
            imagesc(imnew) % visualize the whitened spec
            pause
        end

        factor = factor_val; % try and play with the factor - I set it to 40
        imwrite(imnew/factor,filename_out,'bmp');
        disp(filename_out)
	
    else
		% First Pass
		% Find noise frames
		enrg_t = mean(abs(s1).^2); % compute enrg as a fcn of time
		htmp = floor(lt*percent_frames); % 5% of frames
		[val,eidx] = sort(enrg_t,'ascend');
		iv = eidx(1:htmp); % time-index to bottom 10% frames (in terms of enrg)
		
		% compute a smooth noise spectrum estimate
		psd_noise = mean(abs(s1(:,iv).').^2)+1e-10; % compute noise PSD
		
		fl = smoothing_method;
		% moving average smoothing
		if fl == 1
			MM = moving_parameter; % tweaking parameter (large MM - smoother noise PSD)
			m2 = 2*MM+1;
			z = conv(psd_noise,ones(m2,1))/m2; % smooth PSD
			psd_noise_new = (z(1+MM:end-MM));
			psd_noise(m2:end-m2) = psd_noise_new(m2:end-m2);
			psd_noise = psd_noise';

		% polynomial fit to noise spectrum
		elseif fl == 2;
			fn = f/max(f);
			P = [ones(lf,1),fn,fn.^2,fn.^3,fn.^4,fn.^5,fn.^6]; % seventh order polynomial
			M = P'*P;
			iM = inv(M);
			v = P'*log(psd_noise)';
			c1 = [0;1;0;0;0;0;0]; % left end condition
			c2 = [0;1;2;3;4;5;6]; % right end condition
			C = [c1,c2];
			a = iM*v; % LS
			psd_noise = exp(P*a);
		else
			disp('invalid smoothing choice')
		end
		
		psd_noise_mat=psd_noise*ones(1,lt); % power spectral density of the noise
		
		% denoising
		Wf = 1./sqrt(psd_noise_mat);
		absspect1 = image_double.*Wf;
		
		enrg_t = mean(absspect1.^2); % compute enrg as a fcn of time
		htmp = floor(lt*0.20);
		[val,eidx] = sort(enrg_t,'ascend');
		iv = eidx(1:htmp); % time-index to bottom 20% frames (in terms of enrg)

		% compute a smooth noise spectrum estimate
		psd_noise = mean(abs(s1(:,iv).').^2)+1e-10; % compute noise PSD
		if display
			figure(99)
			plot(psd_noise,'.-')
		end

		% moving average smoothing
		if fl == 1
			MM = 0; % tweaking parameter (large MM - smoother noise PSD)
			m2 = 2*MM+1;
			z = conv(psd_noise,ones(m2,1))/(m2); % smooth PSD
			psd_noise_new = (z(1+MM:end-MM));
			psd_noise(m2:end-m2) = psd_noise_new(m2:end-m2);
			psd_noise = psd_noise';
				if display
					figure(99)
					hold on
					plot(psd_noise,'r')
					hold off
				end
				
		% polynomial fit to noise spectrum		
		elseif fl == 2;
			fn = f/max(f);
			P = [ones(lf,1),fn,fn.^2,fn.^3,fn.^4,fn.^5,fn.^6]; % seventh order polynomial
			M = P'*P;
			iM = inv(M);
			v = P'*log(psd_noise)';
			c1 = [0;1;0;0;0;0;0]; % left end condition
			c2 = [0;1;2;3;4;5;6]; % right end condition
			C = [c1,c2];
			a = iM*v;
			psd_noise = exp(P*a);
				if display
					figure(99)
					hold on
					plot(psd_noise,'r')
					hold off
				end
				
		else
			disp('invalid smoothing choice')
		end
		
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
		
		if display
			figure(3)
			title('Normalized Spectrogram - Pass 2')
			imagesc(absspect/hh)
			pause
		end
		
		if save_fl
			imwrite(absspect/hh,filename_out,'bmp')
			disp(filename_out);
        end
    end
end
