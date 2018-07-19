# This file analyzes data from the 2017 EPFL student practicum at TASP
# Specifically the (200)+(h00) phonons in a lead single crystal at room temperature.

# Load modules for the analysis of neutron scattering data
using NXS, PyPlot2TikZ, Measureds
# Force NXS to use a local copy of SINQ data:
NXS.config["/sinq/afsroot"]="data"

# load the measured data:
# Scans were repeated up to three times. To make fitting the scans easier it 
# is worthwhile to combine them in advance:
x=hcat(6629:6635,6639:6645,6660:-2:6648)'
nos=vcat([[6627]],[[6628,6638]],[x[:,i] for i=1:7],[[6636,6646]],[[6637]],[[z] for z in  6661:-2:6647])
# Load the (up to 3) scan(s) for each Q point and then combine them with sum
qh00=[sum(TASPload(n,2017)) for n in nos];
# ensure all detector counts are normalized to the beam monitor
normalize!.(qh00,"m1",3000)
# for fitting purposes, it's useful to ignore spurious and elastic signals:
mask!.(qh00,800) # any point with more than 800 counts is ignored
mask!.(qh00,[[0.1,11]],"en") # any point with E>11 or E<0.1 is ignored

# Perform a simple gaussian fit for each scan 
# Most of these scans have both longitudinal and transverse phonon branches present
# so we need to do a little bit of work to get the fitting right:
h=abs([ mean(getDat(x,"qh")) for x in qh00]-2)
omega(A,q)=A*sin(π*q/2) #
A0=4.0; A1=8.5;
for (th,ts) in zip(h,qh00)
	p=((0.71>th>0.11)&& maximum(getVal(ts,"en"))>9) ? omega.([A0,A1],th) : [omega(A0,th)]
	p=((th>0.11)&& maximum(getVal(ts,"en"))>9) ? omega.([A0,A1],th) : [omega(A0,th)]
	autofit!(ts,peaksat=p)
end

ω0=[ x.fitres.pM[2] for x in qh00 ]
ω1=[ length(x.fitres.pM)>4 ? x.fitres.pM[5] : Measured(NaN,0) for x in qh00 ]

figure()
plot(qh00+value.(h)*1000)
title("Offset Q=(2-h 0 0) energy scans\nPhonons in Pb")
ylim([0,1200]);

figure()
errorbar(h,ω0,marker="o",color="r",linestyle="")
errorbar(h,ω1,marker="o",color="b",linestyle="")
xlabel("h in (2-h 0 0) [rlu]"); ylabel("ħω₀ [meV]")
title("Phonon dispersion in Pb along (2 0 0)-[h 0 0]")
ylim([0,10]);
