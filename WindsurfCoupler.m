function WindsurfCoupler(Z, n)
% WindsurfCoupler runs XBeach, CDM, and Aeolis models successively and
% passes the relevant parameters between them.
%
% Fateme Yousefi Lalimi, Arizona State University, Sep 2018
%
%--------------------------------------------------------------------------

for i = 1 : n
    
    %============================ run XBeach ============================
    dlmwrite('z.dep', Z, 'delimiter', ' ', 'precision', '%6.20f');
    system('xbeach');
     [Z, wl, H] = ReadXBeachOutput;
    
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


