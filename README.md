# NI
Scripts and instructions for using National Instruments DAQ

File descriptions:

How_to_use_NI.pdf: Instructions for use of 'daqNIwithMatlab.m' script

daqNIwithMatlab.m: MATLAB script for recording data using the NI USB-6221 unit. Record upto 8 channels at upto 250KHz rate (rate is divided between channels, so 1 channel is possible at 250Khz but 2 at 125Khz etc.)

Transmit_NI.m: MATLAB script for transmiting signals. will transmit on a loop untill 'Stop_transmit.m' script is run.

Transmit_OCV.m: same as above but trnsmits 15 pulses at each frequency between 30 and 80 KHz (at 1Khz intervals).

Transmit_NI.m: MATLAB script for terminating transmittion session.

spectrum_analyzer.slx: simulink module that turnes the NI USB-6221 to a spectrum analyzer. requires SIMULINK.


