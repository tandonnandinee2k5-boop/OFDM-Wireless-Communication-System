# OFDM Wireless Communication System using MATLAB/Simulink

## Overview

This project demonstrates the simulation and performance analysis of an Orthogonal Frequency Division Multiplexing (OFDM) based wireless communication system using MATLAB and Simulink.

The system implements QPSK modulation, OFDM modulation/demodulation, AWGN and Rayleigh fading channels, and evaluates performance using Bit Error Rate (BER) analysis and constellation diagrams.

---

## Features

- QPSK Modulation and Demodulation
- OFDM Modulation and Demodulation
- AWGN Channel Simulation
- Rayleigh (SISO Fading) Channel Simulation
- BER Calculation
- BER vs SNR Analysis
- Constellation Diagram Visualization

---

## Software Used

- MATLAB R2025b
- Simulink
- Communications Toolbox
- DSP System Toolbox

---

## System Flow

```
Random Bit Generator
        ↓
QPSK Modulator
        ↓
OFDM Modulator
        ↓
AWGN / Rayleigh Channel
        ↓
OFDM Demodulator
        ↓
QPSK Demodulator
        ↓
BER Calculation
```

---

## Results

- Successfully simulated an end-to-end OFDM communication system.
- BER decreases with increasing SNR under the AWGN channel.
- Rayleigh fading significantly degrades system performance.
- Performance evaluated using BER analysis and constellation diagrams.

---

## Future Scope

- Channel Estimation
- One-Tap Equalization
- Pilot-Based OFDM
- 16-QAM / 64-QAM
- MIMO-OFDM
- 5G NR Physical Layer Extensions

---

## Repository Contents

- MATLAB source code (`.m` files)
- Simulink models (`.slx`)
- BER vs SNR graph
- Project report (to be added)

---

## Author

**Nandinee Tandon**

B.Tech, Electronics and Communication Engineering

National Institute of Technology Hamirpur
