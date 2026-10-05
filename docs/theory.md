# Theory notes

## OFDM chain implemented

```
bits -> QPSK -> serial-to-parallel (48 data) -> insert 16 pilots (64 total)
     -> IFFT -> add cyclic prefix (16)
     -> channel (AWGN or Rayleigh + AWGN)
     -> remove cyclic prefix -> FFT -> [channel estimation from pilots]
     -> one-tap equalizer -> drop pilots -> parallel-to-serial
     -> QPSK demodulation -> bits -> BER
```

## Why OFDM works with a cyclic prefix

A multipath channel with L taps smears each sample over the next L-1 samples.
If the cyclic prefix is at least L-1 samples long, the smear from the previous
symbol only lands inside the prefix, which the receiver throws away. The rest
of the symbol then behaves as a circular convolution, and after the FFT:

```
Y(k) = H(k) X(k) + N(k)        for every subcarrier k
```

so each subcarrier sees one complex gain H(k), and a single complex division
per subcarrier undoes it (one-tap equalizer).

Here L = 4 taps and the prefix is 16 samples, so the condition holds.

## Mapping and scaling

- QPSK, Gray mapping, unit average symbol energy: Es = 1.
- MATLAB's `ifft` includes a 1/N factor, so a time-domain sample has power
  Es/N. The noise per time-domain sample is set to (Es/N)/SNR.
- After the FFT (which multiplies noise power by N), every subcarrier has
  noise variance 1/SNR. So the simulation's "SNR" is **Es/N0 per subcarrier**.
- For QPSK, Es = 2 Eb, so Eb/N0 = (Es/N0)/2.
- The cyclic prefix is not penalised in this definition (its energy is not
  counted as overhead).

## Pilot-based channel estimation

Every OFDM symbol carries 16 known pilots, one every 4th subcarrier (indices
0, 4, 8, ..., 60). The receiver works in two steps.

1. **Least squares at the pilots:** Hp(m) = Y(pilot m) / X(pilot m).
   Each estimate contains the true H plus noise of variance 1/SNR.
2. **Interpolate to the data subcarriers:**
   - *Linear:* straight lines between neighbouring pilots (the grid is treated
     as periodic, because H(k) repeats every N subcarriers). Simple, but the
     channel response curves between pilots, so a small error remains that does
     not shrink with SNR. This causes a BER floor at high SNR.
   - *DFT:* the channel has only a few taps in time. An IFFT of the 16 pilot
     estimates gives its time-domain version (aliased mod 16). The first 8 taps
     are kept and the rest are set to zero, which removes most of the noise,
     and an FFT gives H(k) on all 64 subcarriers. If the true channel has at
     most 8 taps, the result is exact without noise and far less noisy than LS
     alone. Noise power is reduced by about 8/16 compared with raw LS.

Pilot spacing must satisfy the sampling condition in frequency: spacing at most
N / (channel length) = 64 / 4 = 16 subcarriers. Spacing 4 is well inside it.

Pilots take part of the symbol, so throughput is 48/64 = 75 % of an all-data
symbol. This overhead does not appear in BER versus Es/N0.

## Theoretical BER of QPSK

AWGN:

```
BER = Q( sqrt(2 Eb/N0) ) = 0.5 * erfc( sqrt(Eb/N0) )
```

Flat Rayleigh fading with perfect channel knowledge (applies to each OFDM
subcarrier, because |H(k)|^2 is exponentially distributed with mean 1):

```
BER = 0.5 * ( 1 - sqrt( g / (1 + g) ) ),   g = Eb/N0
```

At high SNR this tends to 1 / (4 g): fading turns the exponential BER decay
of AWGN into a slow, inverse-linear decay.

## Rayleigh channel model

- 4 taps, exponentially decaying power delay profile exp(-n/1.5),
  normalised to unit total power (about 52 %, 27 %, 14 %, 7 %).
- Taps are independent complex Gaussian (Rayleigh magnitude).
- Block fading: one channel realisation per OFDM symbol, constant over it.
- No equalizer: every subcarrier is rotated by a random phase, so QPSK
  decisions are essentially random and BER is about 0.5 at every SNR.
- One-tap zero-forcing equalizer with perfect channel knowledge: BER follows
  the theoretical Rayleigh curve.
- One-tap equalizer with pilot-based estimates: BER lies above the perfect
  knowledge curve because of estimation error (LS + DFT is close, LS + linear
  is worse at high SNR).

## Not modelled (possible extensions)

Channel tracking over time, MMSE estimation, channel coding, Doppler / time-varying
channels within a symbol, synchronisation errors, guard bands and DC null,
higher-order modulation (16-QAM / 64-QAM), MIMO.
