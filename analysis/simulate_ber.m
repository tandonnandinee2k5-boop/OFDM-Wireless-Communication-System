function ber = simulate_ber(channelType, snrList, p)
% SIMULATE_BER
% Monte-Carlo BER of the complete pilot-based OFDM chain.
%
%   channelType : 'awgn'
%                 'rayleigh_perfect'    fading, equalised with the true channel
%                 'rayleigh_ls_dft'     fading, pilot estimate (LS + DFT)
%                 'rayleigh_ls_linear'  fading, pilot estimate (LS + linear)
%                 'rayleigh_noeq'       fading, no equaliser
%   snrList     : Es/N0 values in dB (per subcarrier)
%   p           : struct with fftSize, cpLength, pilotSpacing, numOfdmSymbols,
%                 numTaps, minErrors, maxFrames and pdp
%
% Every frame has the same structure for all channel types (data + pilots).
% Each SNR point is simulated frame by frame until minErrors bit errors are
% counted or maxFrames frames have been used. Points with zero errors are
% returned as NaN (BER too low to measure) and are not plotted.

cfg          = pilot_config(p.fftSize, p.pilotSpacing);
bitsPerFrame = 2 * cfg.numData * p.numOfdmSymbols;
ber          = nan(size(snrList));

for k = 1:numel(snrList)
    errors = 0;  total = 0;  frames = 0;

    while errors < p.minErrors && frames < p.maxFrames
        % ---- transmitter ----
        bits = generate_bits(bitsPerFrame);
        par  = serial_to_parallel(qpsk_modulator(bits), cfg.numData);
        tx   = add_cyclic_prefix(ofdm_modulator(insert_pilots(par, cfg)), p.cpLength);

        % ---- channel ----
        if strcmp(channelType, 'awgn')
            rx = awgn_channel(tx, snrList(k));
            H  = ones(p.numOfdmSymbols, p.fftSize);
        else
            [rx, H] = rayleigh_channel(tx, snrList(k), p.fftSize, p.pdp);
        end

        % ---- receiver ----
        Y = ofdm_demodulator(remove_cyclic_prefix(rx, p.cpLength));
        switch channelType
            case {'awgn', 'rayleigh_noeq'}
                Hest = ones(size(Y));
            case 'rayleigh_perfect'
                Hest = H;
            case 'rayleigh_ls_dft'
                Hest = estimate_channel(Y, cfg, 'ls_dft', p.numTaps);
            case 'rayleigh_ls_linear'
                Hest = estimate_channel(Y, cfg, 'ls_linear');
            otherwise
                error('Unknown channel type: %s', channelType);
        end
        eq     = one_tap_equalizer(Y, Hest);
        rxBits = qpsk_demodulator(parallel_to_serial(extract_data(eq, cfg)));

        errors = errors + sum(bits ~= rxBits);
        total  = total + numel(bits);
        frames = frames + 1;
    end

    if errors > 0
        ber(k) = errors / total;
    end
end

end
