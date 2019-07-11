# synaptiplicative-response

Conductance-based models of dendrites to come up with plausible models of multiplicative
response in NMDA synapses.

## Installing

You will need [xolotl](https://github.com/sg-s/xolotl) and dependencies, [xgrid](https://github.com/sg-s/xfit) and [xfit](https://github.com/sg-s/xfit).
`xolotl` can be installed via a MATLAB toolbox or through git.
`xfit` should be installed via git (or by downloading the zip).
Make sure `xolotl` and its dependencies are on your MATLAB path.

If you install `xolotl` using the [MATLAB toolbox](https://xolotl.readthedocs.io/en/master/tutorials/start-here/#installing-xolotl), you only need `xfit` and `xgrid`.

If you install via git, you also need [cpplab](https://github.com/sg-s/cpplab),
[mtools](https://github.com/sg-s/srinivas.gs_mtools), and [puppeteer](https://github.com/sg-s/puppeteer).

More information can be found [here](https://go.brandeis.edu/xolotl).
Note also that you will need a [C++ compiler](https://xolotl.readthedocs.io/en/master/tutorials/start-here/#installing-a-compiler).

You will need the Global Optimization Toolbox, Signal Processing Toolbox, and Parallel Computing Toolbox for MATLAB.

## Description

The various experimental conditions are stored in folders beginning with `experiment`.
To enable a given experiment, add that folder and the `utils` folder to the MATLAB path.

For example:

```matlab
addpath experiment_double_pulse utils
```

The double-pulse experiment was originally designed to test the effects of distance from the synapse,
so there are three conditions, corresponding to 1-compartment, 2-compartment, and 3-compartment models.
In actuality, only the single-compartment models were tested.

The model in all experimental cases consists of three compartments, two presynaptic and one postsynaptic.
Synapses are NMDAergic, and all properties of the compartments are identical except for connectivity.
The only non-synaptic channels are leak channels.

### Optimization experiments

In the double-pulse experiment, one presynaptic compartment is pulsed,
and the EPSP is recorded. Then, the second presynaptic compartment is pulsed,
and the EPSP is recorded.
This process repeats for the condition where both presynaptic compartments are pulsed simultaneously.

The pulses performed in voltage clamp, stepping from the resting potential to 60 mV for 2 ms.
The response is defined as the maximum of the resultant EPSP.

In the excitation experiment, one synapse is changed to an AMPAergic synapse.
The corresponding presynaptic compartment is pulsed for 90 ms,
and the presynaptic compartment corresponding to the NMDAergic synapse is pulsed at the 60-ms mark.

Response height was optimized over maximal conductances to find conditions
where the response height in the combined case was a multiplicative function of
responses in the single cases.

### Brute-force experiments

Brute-force experiments abandoned the parameter optimization approach.
Instead, parameters were chosen from an equidistance-spaced grid.
The brute-force experiment corresponds to the double-pulse experiment.

The brute-force delay experiment adds delay between the two pulses, so that the
second lags behind the first.
Both delays and maximal conductances are varied.
