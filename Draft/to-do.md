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

# To do list
1. What is Pamk doing differnetly from kmeans?
2. Take only excitatory and presynaptic and excitatory postsynaptic and inhibitory presynaptic and inhibitory postsynaptic
-> do they cluster into 2 groups?
3. Filtering out rows of data that don't look like synapses
