clear;clc;

% name of the record file. name by the time it is created.
CurrentTime = clock;
prefix = ['NIRec_', num2str(round(CurrentTime(3)),'%.2d'), '_', ...
    num2str(round(CurrentTime(2)),'%.2d'), '_',...
    num2str(round(CurrentTime(4)),'%.2d'), '_',  ...
    num2str(round(CurrentTime(5)),'%.2d')];

fs = 250000;			% set the sample rate, with 6 channels, 40kHz is the maximum

global param;
param.fs = fs;
param.dispCH = 1;
param.prefix = prefix;
param.index = 1;
param.filename = [prefix, '_1.bin'];
param.fid = fopen(param.filename,'w');
param.maxLen = 500000000;	% define the maximum length of each saved files. you can change this
param.dispLen = fs;
param.dispSig = zeros(1,fs);
param.dispPos = 1;
param.dispFactor = param.dispLen/param.fs;
param.specStep = 512;
param.specYLen = 1024;
% param.specXLen = floor(param.dispLen/param.specYLen);
param.specXLen = floor((param.dispLen-param.specYLen+param.specStep)/param.specStep);
param.specData = zeros(param.specYLen,param.specXLen);
param.specCalPos = 1;
param.specXPos = 1;

%Setup Session, Add Channels and Configure Parameters
d = daq.getDevices;
list_id={d(:).ID};

ses = daq.createSession('ni');	%Create the data acquisition session with directsound!
ses.Rate = fs;			%Define Sampling rate
ses.IsContinuous = true;

% add 6 channels to the session. It can be customized
ses.addAnalogInputChannel('Dev1','ai0','Voltage');
% ses.addAnalogInputChannel('Dev1','ai1','Voltage');
% ses.addAnalogInputChannel('Dev1','ai2','Voltage');
% ses.addAnalogInputChannel('Dev1','ai3','Voltage');
% ses.addAnalogInputChannel('Dev1','ai4','Voltage');
% ses.addAnalogInputChannel('Dev1','ai5','Voltage');

lh = addlistener(ses,'DataAvailable',@(src, event)logData(src,event,prefix));

disp('Start receiving');

% start the recording
startBackground(ses);

str = 'recording';
% waiting for input. If the input is from 1-6, show the signal of corresponding channel.
% recording is stopped only when you input 'stop'
while (~strcmp(str,'stop'))
	str = input('input number to change observation or input ''stop'' to stop recording\n','s');
	num = str2double(str);
	if ((num >= 1) && (num <= 4))
		param.dispCH = round(num);
		param.dispSig = zeros(1,fs);
		param.dispPos = 1;
		param.specData = zeros(param.specYLen,param.specXLen);
		param.specCalPos = 1;
		param.specXPos = 1;
	end
end

stop(ses);
ses.release();
ses.IsContinuous = false;
delete(lh);

disp('Stop receiving');
fclose(param.fid);          % close the last file opened

function logData(src, evt, prefix)
% Add the time stamp and the data values to data. To write data sequentially,
% transpose the matrix.
%   Copyright 2011 The MathWorks, Inc.
    global param;

    lenRx = length(evt.TimeStamps);
    data = [evt.TimeStamps, evt.Data]' ;
    fwrite(param.fid,data,'double');

    s = dir(param.filename);
    lenFile = s.bytes;
    if (lenFile >= param.maxLen)
	    fclose(param.fid);		% close current file
	    param.index = param.index+1;% increase number of index
	    param.filename = [prefix, '_',num2str(param.index),'.bin'];	% new file name
	    param.fid = fopen(param.filename,'w');
	    %disp(['change record file to ',param.filename]);
    end

    param.dispSig(mod(param.dispPos+(0:lenRx-1)-1,param.dispLen)+1) = data(param.dispCH+1,:);
    param.dispPos = mod(param.dispPos+lenRx-1,param.dispLen)+1;
    figure(100);subplot(211);
    plot(1/param.fs:1/param.fs:param.dispLen/param.fs,[param.dispSig(param.dispPos:end),param.dispSig(1:param.dispPos-1)]);grid on;box on;
    xlabel('Time(s)');ylabel('Amplitude(V)');title('time domain');

    Len = mod(param.dispPos-param.specCalPos-1,param.dispLen)+1;
    Num = floor((Len-param.specYLen+param.specStep)/param.specStep);
    while (Num > 0)
	    idx = mod(param.specCalPos+(1:param.specYLen)-1,param.dispLen)+1;
	    param.specData(:,param.specXPos) = transpose(abs(fft(param.dispSig(idx))));
%         disp(num2str([Num,idx([1,end]),param.specCalPos,param.specXPos]));
	    param.specXPos = mod(param.specXPos,param.specXLen)+1;
	    param.specCalPos = mod(param.specCalPos+param.specStep-1,param.dispLen)+1;
	    Num = Num-1;
    end
    figure(100);subplot(212);
    imagesc((1:param.specXLen)/param.specXLen*param.dispFactor,(1:param.specYLen/2)/param.specYLen*param.fs,param.specData(1:param.specYLen/2,[param.specXPos:end,1:param.specXPos-1]));
    xlabel('Time(s)');ylabel('Frequency(V)');title('spectrogram');
end

