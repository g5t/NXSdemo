# multiFLEXX has sets of analyzers at different a4 values and 5 final energies per analyzer set.
# This allows for a mapping of the horizontal Q-plane for 5 energy transfers simultaneously.
# This file reads in data from a multiFLEXX experiment where two overlapping a3 scans were performed 
# with slightly different <a4> values.
# The combined data is then displayed in a single figure.

using NXS, PyPlot2TikZ, Measureds
# Some definitions to make loading the FLEXX data a bit nicer
fdir=joinpath(pwd(),"data","flexx","")
loadFLEXX(o...)=NXS.loadFLEXX(o...,fdir*"scans"); # this is possible because NXS.loadFLEXX isn't exported
corrFLEXX(o...)=NXS.applycorrections!(o...;int_corr_csv=fdir*"int_corr.csv",alive_csv=fdir*"alive.csv")

# load multiFLEXX data, concatenate all files:
mfd=prod(loadFLEXX(65549:65556));
# mask-out dead pixels and apply intensity normalization
corrFLEXX(mfd)
# rescale the intensity to something nicer to work with:
normalize!(mfd,"m1",3e6)

# You may already know that a bin specification can be created with, e.g.,
#	bin"a3 -125 1 -35
# The slice function will also interpret a Tuple of (up to) four values as 
# a binning specification, as is used below.
# This call to slice forces it to use OpenMP C code to fill-in the binned data
# once all pixels are assigned to output bins. If you did not successfully create the 
# shared library libnxs.so with, e.g., Pkg.Build("NXS"), this will cause an error.
# The OpenMP C code is more advantageous for slices which contain a large number of bins.
mfd_slices=slice(mfd,("a3",-125,1,-35),("a4",22.5,1.25,116.25),("en",0.5,0.5,2.5),useccode=true)

# With the slicing done, display the measured planes on a single intensity<->color scale.
# Note that we have not specified plotting axes, so NXS takes the default values stored
# inside of the multiFLEXXd object, which are "[H00]" and "[0K0]" in this case.
plot(mfd_slices,vmax=30)

# We could, of course, take smaller-dimension slices out of the data as well:
# Here the third binning specification is an integration range
mfd_slice=slice(mfd,("a3",-125,1,-35),("a4",22.5,1.25,116.25),("en",1.25,1.75),useccode=true)

mfd_cut=slice(mfd,("[0K0]",0,0.01,3),("[H00]",1.45,1.55),("en",1.25,1.75))

figure()
plot(mfd_slice,vmax=30)
figure()
plot(mfd_cut); ylim([0,30])

