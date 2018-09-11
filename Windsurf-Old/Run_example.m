load windsurf_example_case3
xnull=grids.XGrid;
znull=grids.ZGrid;
project.Directory='C:\Users\fyousef1\Projects\Dune Model\Codes\Windsurf-Old\Outputs';
project.XB.XBExecutable='C:\Users\fyousef1\Projects\Dune Model\Codes\Windsurf-Old\Outputs\xbeach';
project.CDM.CDMExecutable='C:\Users\fyousef1\Projects\Dune Model\Codes\Windsurf-Old\Outputs\cdm';
project.Aeolis.AeolisExecutable='C:\Users\fyousef1\Projects\Dune Model\Codes\Windsurf-Old\Outputs\aeolis';
project.twl=tides.waterlevel;
dbstop if error
Windsurf_Run