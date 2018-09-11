function WindsurfCoupler
% WindsurfCoupler runs XBeach, CDM, and Aeolis models successively and
% passes the relevant parameters between them.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------

n = length(inputdata.winds);

for i = 1 : n
    
    %============================ run XBeach ============================
    SetupXBeachInput
    system('xbeach')
    ReadXBeachOutput
    
    %============================  run CDM   ============================
    SetupCDMInput
    system('dune')
    ReadCDMOutput
    
    %============================ run Aeolis ============================
    SetupAeolisInput
    system('C://Users/fyousef1/AppData/Roaming/Python/Python37/Scripts/aeolis aeolis.txt')
    ReadAeolisOutput
    
end

end


