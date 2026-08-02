# OFDM Wireless Communication System

An implementation of an Orthogonal Frequency Division Multiplexing (OFDM) communication system using **MATLAB** and **Simulink**. This project demonstrates the complete transmission and reception of OFDM signals using QPSK modulation and evaluates system performance under AWGN and Rayleigh fading channels.

---

## Project Objectives

- Design and simulate an OFDM communication system.
- Implement QPSK modulation and demodulation.
- Analyze Bit Error Rate (BER) performance under different channel conditions.
- Compare OFDM performance over AWGN and Rayleigh fading channels.
- Visualize transmitted and received constellation diagrams.

---

## Features

- Random Bit Generation
- QPSK Modulation & Demodulation
- Serial-to-Parallel Conversion
- OFDM Modulation (IFFT)
- Cyclic Prefix Addition & Removal
- AWGN Channel Simulation
- Rayleigh Fading Channel Simulation
- OFDM Demodulation (FFT)
- BER Calculation
- BER vs SNR Analysis
- MATLAB & Simulink Implementation

---

## Repository Structure

```
OFDM-Wireless-Communication-System
│
├── MATLAB_Code/
│
├── Simulink_Models/
│
├── Results/
│
├── Documentation/
│
├── README.md
│
└── LICENSE
```

---

## Software Used

- MATLAB R2025b
- Simulink
- Communications Toolbox

---

## Modulation Technique

- QPSK

---

## OFDM Parameters

| Parameter | Value |
|-----------|-------|
| FFT Length | 64 |
| Cyclic Prefix | 16 |
| Guard Bands | [6 5] |
| Modulation | QPSK |

---

## Results

### AWGN Channel

- BER decreases as Signal-to-Noise Ratio (SNR) increases.
- Constellation becomes increasingly clear at higher SNR values.

### Rayleigh Fading Channel

- Model implemented using the SISO Fading Channel block.
- BER analysis is under validation and repository will be updated with final performance plots.

---

## Future Improvements

- Channel Estimation
- One-Tap Equalization
- Pilot Assisted OFDM
- Higher Order Modulation (16-QAM / 64-QAM)
- MIMO-OFDM
- 5G NR Waveform Integration

---

## Author

**Nandinee Tandon**

B.Tech Electronics & Communication Engineering

National Institute of Technology Hamirpur

---

## License

This project is licensed under the MIT License.
