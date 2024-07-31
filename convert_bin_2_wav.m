inputfile = 'NIRec_30_07_13_28_1.bin';
fs = 40e3;
channel_num=6;          %real number of channels


outputfile = [inputfile(1:end-3) 'wav'];
fid = fopen(inputfile);
sig=fread(fid,[channel_num + 1,5e6],'double');
fclose(fid);
audiowrite(outputfile,sig(2:(channel_num + 1),:)',fs);


