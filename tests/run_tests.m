%% Tests for the OFDM project - every line should print PASS.
clc; clear;
projectRoot = fileparts(fileparts(mfilename('fullpath')));
if exist(fullfile(projectRoot, 'transmitter'), 'dir') ~= 7   % started with run(...)
    projectRoot = pwd;
end
addpath(genpath(projectRoot));
try, rng(1); catch, randn('state', 1); rand('state', 1); end %#ok<RAND>

n = 0;
p.fftSize = 64;  p.cpLength = 16;  p.pilotSpacing = 4;  p.numOfdmSymbols = 1024;
p.numTaps = 8;   p.pdp = exp(-(0:3)/1.5);  p.minErrors = 200;  p.maxFrames = 50;
cfg = pilot_config(p.fftSize, p.pilotSpacing);

% --- modulation -----------------------------------------------------------
bits = generate_bits(1000);
n = check(isequal(qpsk_demodulator(qpsk_modulator(bits)), bits), ...
          'QPSK modulate/demodulate round trip', n);

s = qpsk_modulator(generate_bits(20000));
n = check(abs(mean(abs(s).^2) - 1) < 1e-12, 'QPSK symbol energy Es = 1', n);

% --- pilot layout ---------------------------------------------------------
n = check(cfg.numPilots == 16 && cfg.numData == 48 && ...
          isempty(intersect(cfg.pilotIdx, cfg.dataIdx)), ...
          'Pilot layout: 16 pilots, 48 data, no overlap', n);

% --- noiseless chain with pilots -----------------------------------------
numSym = 100;
bits = generate_bits(2 * cfg.numData * numSym);
par  = serial_to_parallel(qpsk_modulator(bits), cfg.numData);
tx   = add_cyclic_prefix(ofdm_modulator(insert_pilots(par, cfg)), p.cpLength);
Y    = ofdm_demodulator(remove_cyclic_prefix(tx, p.cpLength));
n = check(isequal(qpsk_demodulator(parallel_to_serial(extract_data(Y, cfg))), bits), ...
          'Noiseless pilot-based chain: zero errors', n);
n = check(isequal(tx(:,1:16), tx(:,end-15:end)), 'Cyclic prefix = end of symbol', n);

% --- theory ---------------------------------------------------------------
n = check(abs(theoretical_ber(10,'awgn') - 7.827e-4) < 1e-6, ...
          'Theory: QPSK AWGN at 10 dB = 7.83e-4', n);
% Es/N0 = 10 dB -> Eb/N0 = 5 -> 0.5*(1 - sqrt(5/6)) = 4.356e-2
n = check(abs(theoretical_ber(10,'rayleigh') - 4.356e-2) < 1e-4, ...
          'Theory: QPSK Rayleigh at 10 dB = 4.36e-2', n);

% --- channel estimators on a noiseless 4-tap channel ----------------------
numSym = 200;
pdp = p.pdp / sum(p.pdp);
h   = (randn(numSym,4) + 1j*randn(numSym,4)) / sqrt(2) .* repmat(sqrt(pdp), numSym, 1);
H   = fft([h, zeros(numSym, 60)], [], 2);
X   = insert_pilots(ones(numSym, cfg.numData) * (1+1j)/sqrt(2), cfg);
Yn  = H .* X;
nmse = @(Hh) mean(abs(Hh(:) - H(:)).^2) / mean(abs(H(:)).^2);
nmseDft = nmse(estimate_channel(Yn, cfg, 'ls_dft', p.numTaps));
nmseLin = nmse(estimate_channel(Yn, cfg, 'ls_linear'));
n = check(nmseDft < 1e-20, 'LS+DFT estimator is exact without noise', n);
n = check(nmseLin < 1e-2 && nmseLin > nmseDft, ...
          'LS+linear has a small interpolation error', n);

% --- simulated BER versus theory -----------------------------------------
snr = [4 8];
sim = simulate_ber('awgn', snr, p);
th  = theoretical_ber(snr, 'awgn');
n = check(all(abs(sim./th - 1) < 0.25), 'AWGN simulation matches theory (4, 8 dB)', n);

snr = [10 20];
perfect = simulate_ber('rayleigh_perfect', snr, p);
th      = theoretical_ber(snr, 'rayleigh');
n = check(all(abs(perfect./th - 1) < 0.25), ...
          'Rayleigh, perfect CSI matches theory (10, 20 dB)', n);

dft = simulate_ber('rayleigh_ls_dft', 20, p);
n = check(dft > perfect(2) && dft < 2.2 * perfect(2), ...
          'Pilot LS+DFT is close to perfect CSI (within 2.2x at 20 dB)', n);

noEq = simulate_ber('rayleigh_noeq', 20, p);
n = check(noEq > 0.4, 'No equalizer: BER stays near 0.5', n);

fprintf('\n%d tests passed.\n', n);

function n = check(cond, name, n)
    if cond, fprintf('PASS: %s\n', name); n = n + 1;
    else,    fprintf('FAIL: %s\n', name); end
end
