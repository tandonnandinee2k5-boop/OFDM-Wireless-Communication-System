function ber = theoretical_ber(snrDb, channel)
% THEORETICAL_BER
% Theoretical QPSK bit error rate versus Es/N0 (dB) per subcarrier.
%   'awgn'     : BER = 0.5*erfc(sqrt(Eb/N0))
%   'rayleigh' : BER = 0.5*(1 - sqrt(g/(1+g))), g = Eb/N0
%                (flat Rayleigh fading, perfect equalisation)
% For QPSK, Es = 2*Eb, so Eb/N0 = Es/N0 / 2.

snr  = 10 .^ (snrDb/10);
ebn0 = snr / 2;

switch lower(channel)
    case 'awgn'
        ber = 0.5 * erfc(sqrt(ebn0));
    case 'rayleigh'
        ber = 0.5 * (1 - sqrt(ebn0 ./ (1 + ebn0)));
    otherwise
        error('Unknown channel: %s', channel);
end

end
