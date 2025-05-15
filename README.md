# Cellular-Raman
Codes for processing and analysis of Raman spectra from single cells collected via Raman microspectroscopy.

**Codes and datasets included:**

**linearbaseline.m** 
This code enables smoothing of the raw spectral data using a Savitzky-Golay filter as well as linear baseline subtraction of the background signal.

**linearfit.m** 
This code is used to deconvolute the cellular Raman spectrum by linear combination of reference Raman spectra from purified biomolecules via least squares solution.

**library.mat** 
This dataset comprises a library of reference Raman spectra from purified biomolecules.

**test dataset.txt** 
This file contains raw data from Raman microspectroscopy of single E. coli K-12 BW25113 cells collected via the WiRE 5.2 interface on an inVia™ confocal Raman microscope (Renishaw) using 1200l/mm (780/633) grating. This will generate an output with 1015 data points of Raman intensities per spectrum in the 4th column of a .txt file. 

xx.mat 
This is the wavenumber range (= 1015 wavenumbers as x-values) used for Raman microspectroscopy.

**How to perform Raman data processing and analysis:**

1.	Upload the codes, library and test dataset to the MATLAB workspace.
2.	Install the CVX toolbox in MATLAB. This is necessary to run linearfit.m.
3. Input the Raman intensities (4th column of the test dataset.txt file) as data and run linearbaseline.m. 
Alternatively, read the Raman intensity data (y-values) and the wavenumbers (x-values) in the .txt file by using: txt = importdata('test dataset.txt'); data = txt.data(:,4); xx = txt.data(1:1015,3);
4. Run linearbaseline.m. The code is specific for the number of data points collected (here: 1015 wavenumbers). You will need to change parameters in the code if collecting more data points. The code can process multiple cell spectra at once. The processed data (i.e. smoothed and background subtracted Raman spectra) are stored in result1.mat. 
5. Run linearfit.m. The results, i.e. the fitting parameters and hence the Raman intensities of each biomolecule, are stored in params.mat in a single column for each cell spectrum analysed.
