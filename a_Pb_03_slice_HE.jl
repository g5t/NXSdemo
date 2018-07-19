# This file displays data from the 2017 EPFL student practicum at TASP
# Specifically the (200)+(h00) phonons in a lead single crystal at room temperature.
# As is evident from the file 'a_Pb_02_disp_qh00.jl' the phonons become difficult to fit
# for large q due to the intensity dying away. This file creates image plots to
# illustrate this fact.

using NXS,PyPlot2TikZ,Measureds
# Force NXS to use a local copy of SINQ data:
NXS.config["/sinq/afsroot"]="data"
# a useful helper function for figuring out plotting axes limits:
multiextrema(z)=extrema(vcat([vcat(x...) for x in extrema.(z)]...));

# Energy scans were measured at constant Q=(2-h 0 0) 
# but not on a regular grid. Still, we can display the data as a colorplot:
allh00=prod(TASPload(6627:6661,2017)) # load and concatenate all scans
normalize!(allh00,"m1",3000) # this isn't strictly necessary, but can't hurt

# due to the irregularity of the grid, we want to overlay multiple binned
# versions of the same data to "fill in" missing information without interpolating
# while preserving fine-grain details where possible
#
# we can construct binning specifications as irregular literal strings, specifying
# the column name, starting bin-center, bin step size, and ending bin-center
bh0=bin"qh 1 0.1 2"
bh1=bin"qh 1 0.05 2"
be0=bin"en 0 0.5 10"
be1=bin"en 0 0.25 10"
be2=bin"en 0 0.1 10"
# Then we can construct a list of which two binning specifications to use to create
# each image plot, from coarsest to finest bins:
bv=([bh0,be0],[bh0,be1],[bh1,be1],[bh1,be2])
# And then bin the data in allh00 for each set of binning specifications
slices=[slice(allh00,xy) for xy in bv]

# finally, we can plot the multiple slices on top of each other:
(fig,ax)=subplots(1,2;sharex=true,sharey=true)
axes(ax[1])
r=plot.(log10.(slices),showcolorbar=false,vmin=-1,vmax=4)
xlim(multiextrema([x[1] for x in bv]))
ylim(multiextrema([y[2] for y in bv]))
colorbar(r[1],log10(slices[1]))

axes(ax[2])
r=plot.(slices,showcolorbar=false,vmin=0,vmax=100)
xlim(multiextrema([x[1] for x in bv]))
ylim(multiextrema([y[2] for y in bv]))
colorbar(r[1],slices[1])
