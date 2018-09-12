function InputMaker
% InputMaker makes the input data and parameters needed for Windsurf model
% and saves them as a mat file.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------

% data.general.XB.NetCDF = 1;
% data.general.XB.outputType = 0;
data.general.XB.hydro_spinup = 600;
% data.general.flag.XB = 1;
% data.general.flag.CDM = 2;
% data.general.flag.Aeolis = 1;

%-------------- load data
load example1_data

%-------------- timestep variables
data.timestep.Windsurf = 3600;
data.timestep.CDM = 60;
data.timestep.Aeolis = 60;

%-------------- grid parameters
data.grid.CDM.fixboundary_numcells = 10;

data.grid.X = X;
data.grid.Z0 = Z;

%-------------- wind parameters
data.wind.XB.rhoa = 1.25;
data.wind.XB.Cd = 0.002;
data.wind.XB.windUse = 0;

data.wind.CDM.z0 = 0.01;
data.wind.CDM.z = 10;
data.wind.CDM.vonKarman = 0.41;

data.wind.speed = windspeed;
data.wind.dir = winddir;
data.wind.threshold = 4;

%-------------- wave parameters
data.wave.XB.dtheta = 360;
data.wave.XB.thetamin = -180;
data.wave.XB.thetamax = 180;
data.wave.XB.random =0;
data.wave.XB.fw = 0;
data.wave.XB.shoal = 1;
data.wave.XB.eps = 0.05;
data.wave.XB.use_stationary_hs = 0;
data.wave.XB.nonhydrostatic = 0;
data.wave.XB.break = 3;
data.wave.XB.gamma = 0.5;
data.wave.XB.gammax = 2;
data.wave.XB.alpha =1;
data.wave.XB.breakerdelay = 1;
data.wave.XB.roller =1;
data.wave.XB.beta = 0.15;
data.wave.XB.rfb = 0;
data.wave.XB.shoaldelay = 0;
data.wave.XB.facsd =1;
data.wave.XB.n = 10;
data.wave.XB.wci = 0;
data.wave.XB.hwci = 0.1;
data.wave.XB.cats = 4;
data.wave.XB.taper = 0;
data.wave.XB.useStockdon = 0;
data.wave.XB.dtbc = 1;

data.wave.Aeolis.swashDryTimeSteps = 5;

data.wave.Hs = Hs;
data.wave.Tp = Tp;
data.wave.dir = wrapTo360(wavedir)+270;

%-------------- water level data
data.twl = twl;

%-------------- tide parameters
data.tide.waterlevel = waterlevel;

%-------------- flow parameters
data.flow.XB.bedfriction = 'manning';
data.flow.XB.bedfriccoef = 0.0228;
data.flow.XB.nuh = 0.15;

%-------------- sediment parameters
data.sed.XB.morphology = 1;
data.sed.XB.avalanche = 1;
data.sed.XB.wetslope = 0.3;
data.sed.XB.dryslope = 1;
data.sed.XB.facSk = 0.1;
data.sed.XB.facAs = 0.1;
data.sed.XB.morfac = 1;
data.sed.XB.D10 = 0.0001732;
data.sed.XB.D50 = 0.0002474;
data.sed.XB.D90 = 0.0003352;
data.sed.XB.sedcal = 1;
data.sed.XB.gwflow = 0;
data.sed.XB.gw0 = 0;
data.sed.XB.waveform = 1;
data.sed.XB.form = 1;
data.sed.XB.hmin = -1;
data.sed.XB.turb = 1;
data.sed.XB.rhos = 2650;
data.sed.XB.por = 0.4;
data.sed.XB.q3d = 0;
data.sed.XB.vonkar = 0.4;
data.sed.XB.vicmol = 1e-06;
data.sed.XB.kmax = 1;
data.sed.XB.sigfac = 1.3;
data.sed.XB.sourcesink = 0;
data.sed.XB.thetanum = 1;
data.sed.XB.cmax = 0.1;
data.sed.XB.lwt = 0;
data.sed.XB.betad = 1;
data.sed.XB.sus = 1;
data.sed.XB.bed = 1;
data.sed.XB.bulk = 0;
data.sed.XB.lws = 1;
data.sed.XB.sws = 1;
data.sed.XB.BRfac = 1;
data.sed.XB.z0 = 0.006;
data.sed.XB.smax = -1;
data.sed.XB.tsfac = 0.1;
data.sed.XB.Tbfac = 1;
data.sed.XB.Tsmin = 0.5;
data.sed.XB.facsl = 1.6;
data.sed.XB.bdslpeffmag = 'soulsby_bed';
data.sed.XB.bdslpeffdir = 'talmon';
data.sed.XB.facDc = 0;
data.sed.XB.turbadv = 'none';
data.sed.XB.fallvelred = 0;
data.sed.XB.ucrcal = 1;
data.sed.XB.bdslpeffdirfac = 1;
data.sed.XB.bdslpeffini = 'none';
data.sed.XB.dilatancy = 1;
data.sed.XB.lsgrad = 0;

data.sed.CDM.D = 2.474e-04;

data.sed.Aeolis.D10 = 0.0001732;
data.sed.Aeolis.D50 = 0.0002474;
data.sed.Aeolis.D90 = 0.0003352;
data.sed.Aeolis.Cb = 1;
data.sed.Aeolis.m = 0.5;
data.sed.Aeolis.A = 0.085;

%-------------- veg parameters
data.veg.XB.vegUse = 0;
data.veg.XB.ah = 0.5;
data.veg.XB.Cd = 1;
data.veg.XB.bvdata = 0.02;
data.veg.XB.n = 1200;

data.veg.CDM.sigma = 0.75;
data.veg.CDM.beta = 15;
data.veg.CDM.m = 1;
data.veg.CDM.Tveg = 10;
data.veg.CDM.startingDensity = 1;
data.eg.CDM.maximumDensity = 1;
data.veg.CDM.shearType = 1;
data.veg.CDM.elevMin = 3;
data.veg.CDM.elevMax = 100;

data.veg.erosion_threshold = -0.1;
data.veg.accretion_threshold = 0.2;
data.veg.flood_threshold = 0.5;

%-------------- save data and parameters
save('C:\Users\fyousef1\Projects\Dune Model\Codes\example1' ,'data')

end

