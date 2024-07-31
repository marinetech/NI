# NI
Scripts and instructions for using National Instruments DAQ

File descriptions:

How_to_use_NI.pdf: Instructions for use of 'daqNIwithMatlab.m' script

daqNIwithMatlab.m: MATLAB script for recording and displaying data using the NI USB-6221 unit. Record upto 8 channels at upto 250KHz rate (rate is divided between channels, so 1 channel is possible at 250Khz but 2 at 125Khz etc.). The data is diplayed as waveform and spectrogram data - which can cause the script to lack responsiveness therefore there is a differtent version with no display.

daqNIwithMatlab_nodisplay.m: same as above but forgoes the display which improves responsiveness

convert_bin_2_wav.m: MATLAB script for converting the binary files to '.wav' files. note: you need to change the number of cahnnels and sampling rate in order for this to work correctly.

Transmit_NI.m: MATLAB script for transmiting signals. will transmit on a loop untill 'Stop_transmit.m' script is run.

Transmit_OCV.m: same as above but trnsmits 15 pulses at each frequency between 30 and 80 KHz (at 1Khz intervals).

Transmit_NI.m: MATLAB script for terminating transmittion session.

spectrum_analyzer.slx: simulink module that turnes the NI USB-6221 to a spectrum analyzer. requires SIMULINK.


