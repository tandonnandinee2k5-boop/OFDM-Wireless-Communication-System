%% OFDM Wireless Communication System
% Pilot-based QPSK-OFDM transmitter / receiver simulated over AWGN and
% Rayleigh fading channels. Channel estimation uses comb pilots with LS
% estimation followed by linear or DFT-based interpolation. BER versus SNR is
% compared with theory and with the perfect-channel-knowledge receiver.
%
% Run this file (press Run). Figures and ber_results.csv are saved in result/.
% Works in base MATLAB, no toolboxes needed.

clc; clear; close all;

projectRoot = fileparts(mfilename('fullpath'));
if exist(fullfile(projectRoot, 'transmitter'), 'dir') ~= 7   % started with run(...)
    projectRoot = pwd;
end
addpath(genpath(projectRoot));
resultDir = fullfile(projectRoot, 'result');
if exist(resultDir, 'dir') ~= 7, mkdir(resultDir); end

disp('===========================================');
disp('   OFDM Wireless Communication System');
disp('===========================================');

%% 1. PARAMETERS ---------------------------------------------------------
p.fftSize        = 64;                 % subcarriers (FFT length)
p.cpLength       = 16;                 % cyclic prefix length (samples)
p.pilotSpacing   = 4;                  % one pilot every 4 subcarriers
p.numTaps        = 8;                  % DFT estimator: assumed max channel length
p.pdp            = exp(-(0:3)/1.5);    % 4-tap exponential power delay profile
p.numOfdmSymbols = 1024;               % OFDM symbols per frame
p.minErrors      = 100;                % stop an SNR point after this many errors
p.maxFrames      = 50;                 % ... or after this many frames

demoSnr   = 20;                        % SNR (dB) for the single-run demo
snrRange  = 0:2:30;                    % SNR sweep (dB), Es/N0 per subcarrier
saveFiles = true;                      % save figures and results into result/

try, rng(1); catch, randn('state', 1); rand('state', 1); end %#ok<RAND>

cfg = pilot_config(p.fftSize, p.pilotSpacing);
fprintf('Subcarriers: %d  (pilots: %d, data: %d, pilot overhead: %.1f %%)\n', ...
        p.fftSize, cfg.numPilots, cfg.numData, 100*cfg.numPilots/p.fftSize);

%% 2. SINGLE RUN: TRANSMITTER ---------------------------------------------
numBits = 2 * cfg.numData * p.numOfdmSymbols;
bits    = generate_bits(numBits);
symbols = qpsk_modulator(bits);
display_first_symbols(symbols);

figConstTx = plot_constellation(symbols(1:4000), 'Transmitted QPSK Constellation', 120, 1.5);

par      = serial_to_parallel(symbols, cfg.numData);   % data per OFDM symbol
X        = insert_pilots(par, cfg);                    % add known pilots
ofdmSig  = ofdm_modulator(X);
txSignal = add_cyclic_prefix(ofdmSig, p.cpLength);
verify_cyclic_prefix(txSignal, ofdmSig, p.cpLength);

figWave = plot_waveform(real(txSignal(1,:)), 'OFDM Symbol with Cyclic Prefix (real part)');

%% 3. SINGLE RUN: AWGN CHANNEL --------------------------------------------
rxAwgn = awgn_channel(txSignal, demoSnr);
Y      = ofdm_demodulator(remove_cyclic_prefix(rxAwgn, p.cpLength));
dataRx = extract_data(Y, cfg);
figConstAwgn = plot_constellation(dataRx(1:4000), ...
    sprintf('Received Constellation, AWGN, SNR = %d dB', demoSnr));
berAwgn = calculate_ber(bits, qpsk_demodulator(parallel_to_serial(dataRx)));
disp('AWGN channel:');  display_ber(berAwgn);

%% 4. SINGLE RUN: RAYLEIGH FADING CHANNEL ---------------------------------
[rxRay, H] = rayleigh_channel(txSignal, demoSnr, p.fftSize, p.pdp);
Y          = ofdm_demodulator(remove_cyclic_prefix(rxRay, p.cpLength));

% 4a. no equalizer
dataRx = extract_data(Y, cfg);
figConstRay = plot_constellation(dataRx(1:4000), ...
    sprintf('Rayleigh Fading, NO Equalizer, SNR = %d dB', demoSnr));
berNoEq = calculate_ber(bits, qpsk_demodulator(parallel_to_serial(dataRx)));
disp('Rayleigh channel, no equalizer:');  display_ber(berNoEq);

% 4b. equalizer with perfect channel knowledge
dataEq = extract_data(one_tap_equalizer(Y, H), cfg);
ber1   = calculate_ber(bits, qpsk_demodulator(parallel_to_serial(dataEq)));
disp('Rayleigh channel, equalizer with PERFECT channel knowledge:');  display_ber(ber1);

% 4c. pilot-based channel estimation
Hlin = estimate_channel(Y, cfg, 'ls_linear');
Hdft = estimate_channel(Y, cfg, 'ls_dft', p.numTaps);

nmse = @(Hh) mean(abs(Hh(:) - H(:)).^2) / mean(abs(H(:)).^2);
fprintf('Channel estimation error (NMSE) at %d dB:  LS+linear = %.4f   LS+DFT = %.4f\n', ...
        demoSnr, nmse(Hlin), nmse(Hdft));

dataEq = extract_data(one_tap_equalizer(Y, Hlin), cfg);
ber2   = calculate_ber(bits, qpsk_demodulator(parallel_to_serial(dataEq)));
disp('Rayleigh channel, pilot estimate LS + linear interpolation:');  display_ber(ber2);

dataEq = extract_data(one_tap_equalizer(Y, Hdft), cfg);
figConstEq = plot_constellation(dataEq(1:4000), ...
    sprintf('Rayleigh Fading, Pilot-Based Equalizer (LS+DFT), SNR = %d dB', demoSnr), 8, 2);
ber3   = calculate_ber(bits, qpsk_demodulator(parallel_to_serial(dataEq)));
disp('Rayleigh channel, pilot estimate LS + DFT interpolation:');  display_ber(ber3);

figChan = plot_channel_estimate(H, Hlin, Hdft, cfg, 1, ...
    sprintf('Channel Estimation, First OFDM Symbol, SNR = %d dB', demoSnr));

%% 5. BER vs SNR -----------------------------------------------------------
disp('Running BER simulation (this can take a minute)...');
berAwgnSim = simulate_ber('awgn',               snrRange, p);
berPerfect = simulate_ber('rayleigh_perfect',   snrRange, p);
berDft     = simulate_ber('rayleigh_ls_dft',    snrRange, p);
berLin     = simulate_ber('rayleigh_ls_linear', snrRange, p);
berNoEqSim = simulate_ber('rayleigh_noeq',      snrRange, p);
berThAwgn  = theoretical_ber(snrRange, 'awgn');
berThRay   = theoretical_ber(snrRange, 'rayleigh');

figBer = figure;
semilogy(snrRange, berAwgnSim, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 6); hold on;
semilogy(snrRange, berThAwgn,  'b--', 'LineWidth', 1.0);
semilogy(snrRange, berPerfect, 'rs-', 'LineWidth', 1.5, 'MarkerSize', 6);
semilogy(snrRange, berThRay,   'r--', 'LineWidth', 1.0);
semilogy(snrRange, berDft,     'gd-', 'LineWidth', 1.5, 'MarkerSize', 6);
semilogy(snrRange, berLin,     'm^-', 'LineWidth', 1.5, 'MarkerSize', 6);
semilogy(snrRange, berNoEqSim, 'k-',  'LineWidth', 1.0);
grid on; ylim([1e-6 1]); xlim([min(snrRange) max(snrRange)]);
xlabel('SNR, Es/N0 per subcarrier (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR of Pilot-Based QPSK-OFDM');
legend('AWGN (simulated)', 'AWGN (theory)', ...
       'Rayleigh, perfect channel knowledge', 'Rayleigh (theory)', ...
       'Rayleigh, pilots LS + DFT', 'Rayleigh, pilots LS + linear', ...
       'Rayleigh, no equalizer', 'Location', 'southwest');

fprintf('\n%7s %10s %10s %10s %10s %10s %10s\n', 'SNR(dB)', 'AWGN', 'Perfect', ...
        'LS+DFT', 'LS+linear', 'No-eq', 'Rayl-theory');
for k = 1:numel(snrRange)
    fprintf('%7d %10.2e %10.2e %10.2e %10.2e %10.2e %10.2e\n', snrRange(k), ...
        berAwgnSim(k), berPerfect(k), berDft(k), berLin(k), berNoEqSim(k), berThRay(k));
end
disp('(NaN = no bit errors observed, BER too low to measure)');

%% 6. SAVE RESULTS ---------------------------------------------------------
if saveFiles
    save_figure(figConstTx,   fullfile(resultDir, 'constellation_tx.png'));
    save_figure(figWave,      fullfile(resultDir, 'ofdm_symbol_with_cp.png'));
    save_figure(figConstAwgn, fullfile(resultDir, 'constellation_awgn.png'));
    save_figure(figConstRay,  fullfile(resultDir, 'constellation_rayleigh_no_eq.png'));
    save_figure(figConstEq,   fullfile(resultDir, 'constellation_rayleigh_pilot_eq.png'));
    save_figure(figChan,      fullfile(resultDir, 'channel_estimation.png'));
    save_figure(figBer,       fullfile(resultDir, 'ber_vs_snr.png'));

    fid = fopen(fullfile(resultDir, 'ber_results.csv'), 'w');
    fprintf(fid, 'snr_db,awgn_sim,rayleigh_perfect_csi,rayleigh_ls_dft,rayleigh_ls_linear,rayleigh_no_eq,awgn_theory,rayleigh_theory\n');
    for k = 1:numel(snrRange)
        fprintf(fid, '%d,%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,%.3e\n', snrRange(k), ...
            berAwgnSim(k), berPerfect(k), berDft(k), berLin(k), berNoEqSim(k), ...
            berThAwgn(k), berThRay(k));
    end
    fclose(fid);
    disp(['Results saved in: ' resultDir]);
end
