# Sagnac
Matlab programs for Sagnac experiment. 

## Requirements:
* Matlab 2018b or later
* [Instrument Control toolbox](https://www.mathworks.com/products/instrument.html)

## Implemented packages and classes:
* **Drivers**: GPIB/visa and Serial interfaces for laboratory instruments such 
    * Agilent 33220A
    * Keithley 2XXX
    * LakeShore 3XX
    * Stanford Research 8XX
    * Agilis piezo stage
    * and others...
* **Recorder**: Universal data acquisition class.
* **make**: helper functions for Recorder class.
* **plot**: Data plotting functions.
* **util**: data analysis/modification helper functions.

## Applications:
* **slicer**: GUI to browse 2D data such as frequency-amplitude modulation scans and plot 1D slices.
