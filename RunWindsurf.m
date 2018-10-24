function RunWindsurf
% RunWindsurf runs Windsurf model which couples XBeach, CDM, and Aeolis to  
% simulate beach-dune dynamics and their response to climate change.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------
format compact
format longG
clear
         
cd('C:\Users\fyousef1\Main Drive\Codes\Matlab\Output')

%-------------- set up initial models requirements
data = ReadData;
XBeachRequirements(data)
% CDMRequirements(data)
% AeolisRequirements(data)

%-------------- run simulations
WindsurfCoupler(data.grid.Z, data.timestep.n)

%-------------- display model output

end


