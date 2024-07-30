Fs = 2.5e6/3;			% set the sample rate, with 6 channels, 40kHz is the maximum
f0 = 30e3;
f1 = 41e3;
Ttot = 1;  %Total duration time [s]
Tdo = 0.005;%duration output
amp = 0.02;
rep_number = 100;
    
%Setup Session, Add Channels and Configure Parameters
% d = daq.getDevices;
% for ii=1:rep_number
    ses2 = daq.createSession('ni');%Create the data acquisition session with directsound!
    ses2.Rate = Fs;			%Define Sampling rate
    ses2.IsContinuous = true;
    ses2.addAnalogOutputChannel('Dev1','ao0','Voltage'); %Add output channel

    tsin = 0:1/Fs:Tdo-1/Fs;%t of an output signal
    Ref = amp*chirp(tsin,f0,Tdo,f1);
    Ref = [Ref,zeros([1,round((Ttot-Tdo)*Fs)])];
    % Ref = repmat(Ref,[1 20]);
    queueOutputData(ses2,Ref');
    lho = addlistener(ses2,'DataRequired', @(src,event) src.queueOutputData(Ref'));



    %starting transmitting
    startBackground(ses2);
    % pause(Ttot)
    % stop(ses2);
    % % pause(1)
    % ses2.release()
    % ses2.IsContinuous = false;
    % delete(lho);
    % delete(ses2);
    % clear ses2 lho 
% end



