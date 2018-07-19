# NXSdemo
This project holds triple-axis neutron scattering data and analysis scripts
which demonstrate the use of NXS.jl.

You should install the Julia binaries from your system repository or from [the JuliaLang website](https://julialang.org/downloads). 
This project has been tested successfully with Julia v0.6.3 and should work with any v0.6 patch.
Other versions of Julia might work but are prone to cause trouble due to syntax changes.

After cloning this project setup NXS.jl and its dependencies by 
either executing `setupNXS.sh` from a terminal
or running "setupNXS.jl" with Julia, e.g., `julia setupNXS.jl` or 
`include("setupNXS.jl")` from the julia REPL.

Once NXS.jl is configured successfully you can run the example analysis scripts.
