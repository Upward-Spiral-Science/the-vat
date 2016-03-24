## Progress Report - March 24th, 2016
**Table of Contents:**
- [Overview](./progress_report.md#overview)
- [Scientific Questioning](./progress_report.md#scientific-questioning)
    - [Descriptive Analysis](./progress_report.md#descriptive-analysis)
    - [Exploratory Analysis](./progress_report.md#exploratory-analysis)
    - [Inferential Analysis](./progress_report.md#inferential-analysis)
    - [Predictive Analysis](./progress_report.md#predictive-analysis)
    - [Testing Assumptions](./progress_report.md#testing-assumptions)
    - [Next Steps](./progress_report.md#next-steps)
- [Methods](./progress_report.md#methods)
    - [Decriptive Analysis](./progress_report.md#descriptive-analysis-1)
    - [Exploratory Analysis](./progress_report.md#exploratory-analysis-1)
    - [Inferential Analysis](./progress_report.md#inferential-analysis-1)
    - [Predictive Analysis](./progress_report.md#predictive-analysis-1)
    - [Testing Assumptions](./progress_report.md#testing-assumptions-1)

--------

### Overview
Currently, very little is understood about the synaptic connections within our brain. Our original belief is that there are only two types of synapses: excitatory and inhibitory. However, it is now known that there is a much more diverse synapse population. We want to characterize these different subpopulations.

### Scientific Questionsing
Here we discuss our analysis of the data.

### Descriptive Analysis
Our data is a organized into a feature matrix and a location matrix. Our feature matrix is (1119299, 144), but we trim it down to (1119299, 96). Each 24 columns represent one measurement metric/channel of data. 

The measurement metrics are:
    f0 = integrated brightness 
    f1 = local brightness 
    f2 = distance to Center of Mass 
    f3 = moment of inertia around synapse
each with a shape of (1119299, 24).

Each channel/measurement has 24 data points representing 4 different protein markers, ordered as the following: 

['Synap', 'Synap', 'VGlut1', 'VGlut1', 'VGlut2', 'Vglut3', 'psd', 'glur2', 'nmdar1', 'nr2b', 'gad', 'VGAT', 'PV', 'Gephyr', 'GABAR1', 'GABABR', 'CR1', '5HT1A', 'NOS', 'TH', 'VACht', 'Synapo', 'tubuli', 'DAPI']

The location data is (1119299, 3). They represent pixel locations on a 3D image with resolution at the nm scale. 

The ranges on each axis are:
- x: [28, 1513]
- y: [23, 12980]
- z: [2, 40]

### Exploratory Analysis
First we looked at our feature data.

<img src="../figures/corrplot.png">