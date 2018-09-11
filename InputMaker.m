function InputMaker
% InputMaker makes the input data and parameters needed for Windsurf model
% and saves them as a mat file.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%-------------------------------------------------------------------------- 

%-------------- wind parameters
data.wind.CDM.z0 = 0.01;
data.wind.CDM.z = 10;
data.wind.CDM.vonKarman = 0.41;
data.wind.XB.rhoa = 1.25;
data.wind.XB.Cd = 0.002;
data.wind.XB.windUse = 0;
data.wind.speed = [5;5;5;5;5;5];
data.wind.dir = [90;90;90;90;90;90];
data.wind.threshold = 4;

%-------------- wave parameters




