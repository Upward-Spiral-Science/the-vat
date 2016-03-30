# Already Done:
1. Raw, Log and Rank Transformations
-> normalize and then Log transformations is the best initial transformation for transforming outliers
-> focused on integrated brightness
2. PCA and scree plots
3. Pamk
- robust version of kmeans based on mediods instead of centroids.
4. ari plots vs. channel types
5. kernel density estimation of each channel for f0 using gaussian kernel

** Should we just scale data? log transform seems to have overlaying kernel density estimations?

Excitatory presynaptic: ‘Synap’, ‘Synap’, ‘VGlut1’, ‘VGlut1’, ‘VGlut2’,
Excitatory postsynaptic: ‘psd’, ‘glur2’, ‘nmdar1’, ‘nr2b’, ‘NOS’, ‘Synapo’ (but further away than PSD, gluR2, nmdar1 and nr2b)
Inhibitory presynaptic: ‘gad’, ‘VGAT’, ‘PV’,
Inhibitory postsynaptic: ‘Gephyr’, ‘GABAR1’, ‘GABABR’, ‘NOS’,
At a very small number of inhibitory: ‘Vglut3’ (presynaptic), ‘CR1’(presynaptic),
Other synapses:‘5HT1A’, ‘TH’, ‘VACht’,
Not at synapses: ‘tubuli’, ‘DAPI’.


# Questions:
1. What is Pamk doing differnetly from kmeans?
2. how they identify synapses for sure?


# To do list
1. Take only excitatory and presynaptic and excitatory postsynaptic and inhibitory presynaptic and inhibitory postsynaptic
    -> do they cluster into 2 groups?
2. Filtering out rows of data that don't look like synapses
- how 

3. Normalize between 0 and 1 and then log-transform
    - subtract min and then divide by range
4. Square-root transformation 
    - to compress data 
5. Remove all rows for a certain channel that is below a certain threshold
    -> histograms of the 24 channels again
    -> try clustering with k-means again
    -> testing for normality