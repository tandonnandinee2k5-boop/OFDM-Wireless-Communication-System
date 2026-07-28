%% 5G OFDM Communication System

clc;
clear;
close all;

addpath(genpath(pwd));

disp('===========================================');
disp('     5G OFDM Communication System');
disp('===========================================');

%% Generate Random Bits

numBits = 131072;

bits = generate_bits(numBits);

plot_bits(bits);

%% QPSK Modulation

symbols = qpsk_modulator(bits);

display_first_symbols(symbols);

plot_constellation(symbols,'Transmitted QPSK Constellation');

%% Serial to Parallel

N = 64;

parallelSymbols = serial_to_parallel(symbols,N);

disp('Parallel Symbol Matrix Size:')
disp(size(parallelSymbols))

%% OFDM Modulation

ofdmSignal = ofdm_modulator(parallelSymbols);

disp('OFDM Signal Size:')
disp(size(ofdmSignal))

plot_waveform(real(ofdmSignal(1,:)),...
'Real Part of First OFDM Symbol');

%% Add Cyclic Prefix

cpLength = 16;

txSignal = add_cyclic_prefix(ofdmSignal,cpLength);

verify_cyclic_prefix(txSignal,ofdmSignal,cpLength);

plot_waveform(real(txSignal(1,:)),...
'OFDM Symbol with Cyclic Prefix');

%% AWGN Channel

snr = 20;

rxSignal = awgn_channel(txSignal,snr);

plot_waveform(real(rxSignal(1,:)),...
'Received Signal after AWGN');

%% Remove Cyclic Prefix

rxOFDM = remove_cyclic_prefix(rxSignal,cpLength);

verify_signal_sizes(ofdmSignal,rxOFDM);

plot_waveform(real(rxOFDM(1,:)),...
'Received OFDM Symbol');

%% OFDM Demodulation

receivedSymbols = ofdm_demodulator(rxOFDM);

plot_constellation(receivedSymbols(:),...
'Received QPSK Constellation');

%% Parallel to Serial

serialSymbols = parallel_to_serial(receivedSymbols);

display_first_symbols(serialSymbols);

%% QPSK Demodulation

receivedBits = qpsk_demodulator(serialSymbols);

display_first_bits(receivedBits);

%% BER Calculation

ber = calculate_ber(bits,receivedBits);

display_ber(ber);

%% BER vs SNR

snrValues = 0:2:20;

berValues = zeros(size(snrValues));

for k = 1:length(snrValues)

    rxSignal = awgn_channel(txSignal,snrValues(k));

    rxOFDM = remove_cyclic_prefix(rxSignal,cpLength);

    receivedSymbols = ofdm_demodulator(rxOFDM);

    serialSymbols = parallel_to_serial(receivedSymbols);

    receivedBits = qpsk_demodulator(serialSymbols);

    berValues(k)=calculate_ber(bits,receivedBits);

end

figure;

semilogy(snrValues, berValues, '-o', ...
    'LineWidth', 2, ...
    'MarkerSize', 8);

grid on;
grid minor;

xlabel('Signal-to-Noise Ratio (SNR) [dB]', 'FontSize', 12);
ylabel('Bit Error Rate (BER)', 'FontSize', 12);

title('BER vs SNR Performance of QPSK-OFDM over AWGN Channel', ...
    'FontSize', 14);
grid on;

xlabel('SNR (dB)');
ylabel('Bit Error Rate');

title('BER vs SNR for OFDM System');

disp('SNR      BER')
disp([snrValues' berValues'])