# synaptiplicative-response

Conductance-based models of dendrites to come up with plausible models of multiplicative
response in NMDA synapses.

## Installing

You will need [xolotl](https://github.com/sg-s/xolotl) and dependencies and [xfit](https://github.com/sg-s/xfit).
`xolotl` can be installed via a MATLAB toolbox or through git.
`xfit` should be installed via git (or by downloading the zip).
Make sure `xolotl` and its dependencies are on your MATLAB path.

If you install `xolotl` using the [MATLAB toolbox](https://xolotl.readthedocs.io/en/master/tutorials/start-here/#installing-xolotl), you only need `xfit`.

If you install via git, you also need [cpplab](https://github.com/sg-s/cpplab),
[mtools](https://github.com/sg-s/srinivas.gs_mtools), and [puppeteer](https://github.com/sg-s/puppeteer).

More information can be found [here](https://go.brandeis.edu/xolotl).
Note also that you will need a [C++ compiler](https://xolotl.readthedocs.io/en/master/tutorials/start-here/#installing-a-compiler).

You will need the Global Optimization Toolbox, Signal Processing Toolbox, and Parallel Computing Toolbox for MATLAB.

## File structure

The `models` folder contains different types of "experiments" performed.
For example, the `comp2` folder contains experiments performed on a 2-compartment model.
That folder is subdivided into `passive`, for experiments on 2-compartment models with only leak channels,
and spiking neurons, and so on.

Within these folders, the `cost` function is used to evaluate the fitness of the model
with respect to multiplicative EPSPs or phasic relations.
The `model` script contains the code that constructs the `xolotl` object,
and the `optimize` function performed the parameter optimization procedure with `xfit`.
