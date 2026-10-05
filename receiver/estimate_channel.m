function H = estimate_channel(Y, cfg, method, numTaps)
% ESTIMATE_CHANNEL
% Pilot-based channel estimation for every OFDM symbol.
%
%   Y       : received frequency-domain symbols (numSymbols x fftSize)
%   cfg     : pilot layout from pilot_config
%   method  : 'ls_linear' or 'ls_dft'
%   numTaps : (ls_dft only) assumed maximum channel length in samples
%   H       : estimated channel, numSymbols x fftSize
%
% Step 1 (both methods), least squares at the pilots:
%       Hp(m) = Y(pilot m) / X(pilot m)
% Step 2, get H on all subcarriers:
%   ls_linear : linear interpolation between neighbouring pilots
%   ls_dft    : the channel has few taps in time, so
%                 a) go to the time domain with an IFFT of the pilot estimates
%                 b) keep only the first numTaps taps (zero the rest: this
%                    removes most of the noise)
%                 c) go back to all subcarriers with an FFT
%               Needs the pilot grid to start at subcarrier 1 (it does).

N      = cfg.fftSize;
P      = cfg.numPilots;
numSym = size(Y, 1);

Hp = Y(:, cfg.pilotIdx) ./ repmat(cfg.pilotSymbols, numSym, 1);

switch method
    case 'ls_linear'
        kp   = [cfg.pilotIdx - 1, N];       % periodic extension: H(N) = H(0)
        Hext = [Hp, Hp(:, 1)];
        kq   = 0:N-1;
        Hre  = interp1(kp, real(Hext).', kq, 'linear').';
        Him  = interp1(kp, imag(Hext).', kq, 'linear').';
        H    = Hre + 1j*Him;

    case 'ls_dft'
        if nargin < 4 || isempty(numTaps), numTaps = floor(P/2); end
        numTaps = min(numTaps, P);
        a = ifft(Hp, [], 2);                % P-point time-domain estimate
        a(:, numTaps+1:end) = 0;            % keep first numTaps taps only
        H = fft([a, zeros(numSym, N - P)], [], 2);

    otherwise
        error('Unknown estimation method: %s', method);
end

end
