# This file analyzes data from the 2017 EPFL student practicum at TASP
# Specifically the (200)+(0k0) phonons in a lead single crystal at room temperature.

# Load modules for the analysis of neutron scattering data
using NXS, PyPlot2TikZ, Measureds
# Force NXS to use a local copy of SINQ data:
NXS.config["/sinq/afsroot"]="data"

# load the measured data:
q2k0=TASPload(6617:6626,2017);
# ensure all detector counts are normalized to the beam monitor
normalize!.(q2k0,"m1",3000)
# for fitting purposes, it's useful to ignore spurious and elastic signals:
mask!.(q2k0,800) # any point with more than 800 counts is ignored
mask!.(q2k0,[[0.1,11]],"en") # any point with E>11 or E<0.1 is ignored

# Perform a simple gaussian fit for each scan 
# with starting parameters estimated from the scan points
autofit!.(q2k0,peaksat=[3]) # help the estimation a bit by specifying E=3 meV to start

k=[ mean(getDat(x,"qk")) for x in q2k0]
ω=[ x.fitres.pM[2] for x in q2k0 ]

figure()
plot(q2k0+value.(k)*1000)
title("Offset Q=(2 k 0) energy scans\nPhonons in Pb")
ylim([0,1200]);

figure()
errorbar(k,ω,marker="o",linestyle="")
xlabel("k in (2 k 0) [rlu]"); ylabel("ħω₀ [meV]")
title("Phonon dispersion in Pb along (2 0 0)+[0 k 0]")
ylim([0,10]);
