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



---
---


## Code style convention
I'm planning to clean all code here to satisfy following styling style guide
### Variables
All lowercase, underscore is used to separate words for better readibility if desired.
Short and non-descriptive names are preferred over extremely long names.
CamelCase is avoided.

Good examples:
* filename
* num_words
* i (dummy variable in a for loop)

Bad examples:
* numWords
* letter_index_in_target_words

### Functions
All lowercase, neither underscore, nor CamelCase are used.
Namespaces (packages) are encouraged, see [this](https://www.mathworks.com/help/matlab/matlab_oop/scoping-classes-with-packages.html).

Good examples:
* combine
* beamspotsize

Bad examples:
* beam_spot_size
* beamSpotSize
* Beamspotsize

### Classes
Starts with capital letter, CamelCase is used for readibility.

Good examples:
* Recorder
* MyClass

Bad examples:
* recorder
* my_class
* myClass