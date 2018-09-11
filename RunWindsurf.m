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

%-------------- set up initial models requirements
load example1
SetupRequirements(data);

%-------------- run simulations
WindsurfCoupler

%-------------- display model output

end


