%% Input
expTimes = 1 ./ load('TestImages/Test1-ExpTime.txt');
imgFiles = {'TestImages/Test1-1.jpg', 'TestImages/Test1-2.jpg', 'TestImages/Test1-3.jpg', 'TestImages/Test1-4.jpg', 'TestImages/Test1-5.jpg'};
%% Function call
radmap = makeRadmap(imgFiles,expTimes,20);
%% Write to file
hdrwrite(radmap,'TestImages/Test1.hdr');