Fs = 2.5e6/3;			% set the sample rate, with 6 channels, 40kHz is the maximum
freq_range = 30:80; % frequency in Khz
PW = 5; % pulse width in milliseconds
PRI = 1; % repetition interval in milliseconds
rep_number = 15; % number of pulses transmitted in each frequency in each frequency
amp=0.44; % amplitude in Volts
    
%Setup Session, Add Channels and Configure Parameters
% d = daq.getDevices;
for freq=freq_range
    freq
    ses2 = daq.createSession('ni');%Create the data acquisition session with directsound!
    ses2.Rate = Fs;			%Define Sampling rate
    ses2.IsContinuous = true;
    ses2.addAnalogOutputChannel('Dev1','ao0','Voltage'); %Add output channel

    t = 0:1/Fs:(PW/1000)-1/Fs;%t of an output signal
    Ref = [amp*sin(2*pi*t*freq*1000),zeros([1,floor(PRI*Fs-PW*Fs/1000)])];
    % Ref = repmat(Ref,[1 rep_number]);
    queueOutputData(ses2,Ref');
    lho = addlistener(ses2,'DataRequired', @(src,event) src.queueOutputData(Ref'));



    %starting transmitting
    startBackground(ses2);
    pause(PRI*(rep_number-0.5))
    stop(ses2);
    pause(1)
    ses2.release()
    ses2.IsContinuous = false;
    delete(lho);
    delete(ses2);
    clear ses2 lho 
end



