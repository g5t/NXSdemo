# This demonstration relies upon 6 Julia modules which are as-of-yet not
# registered in the Julia METADATA package, and therefore can not be installed
# with the built-in Julia package manager directly.
# Running the following in a Julia REPL (or as a script) should pull all six
# modules from GitHub and install them for your use.
pkgs = ("Structs","SimpleNamedArrays","PyPlot2TikZ","Measureds","Lattices","NXS")
for pkg in pkgs
  try Pkg.installed(pkg) # throws an error if pkg is not installed
    Pkg.update(pkg) # Make sure any installed package is up to date
  catch
    try Pkg.clone("https://github.com/g5t/$pkg.jl")
    catch something_went_wrong
      Pkg.rm(pkg) # since we don't want to leave things in a bad-state
      error("$something_went_wrong\nUnable to install $pkg. Check previous output. Halting")
    end
  end
end

# with all packages cloned from GitHub, make sure to build the C code for NXS:
Pkg.build("NXS")

