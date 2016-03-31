# Questions:
1. What is Pamk doing differnetly from kmeans?
2. how they identify synapses for sure?
3. What are the 'synapsin' values?
4. throw out outliers e.g. synapses that aren't synapses and get rid of dapuli and tubuluar?


# To do list
<<<<<<< HEAD
1. Take only excitatory and presynaptic and excitatory postsynaptic and inhibitory presynaptic and inhibitory postsynaptic
    -> do they cluster into 2 groups?
    
3. Normalize between 0 and 1 and then log-transform
    - subtract min and then divide by range
4. Square-root transformation 
    - to compress data 
5. Remove all rows for a certain channel that is below a certain threshold
    -> histograms of the 24 channels again
    -> try clustering with k-means again
    -> testing for normality
    
7. Rank transformation
- pamk
- compute BIC score as a function of k plot

8. Z-scoring and then removing all rows +/- 3
- ? ask jovo how to do multivariate ?
- use scikit.learn outlier detection
- look at distribution of outlier points and distributions of inlier points

9. ARI plots vs. channel types

10. kernel density estimation of each channel before and after each preprocessing step of transformation, filtering


    
=======
1. Log-transform data 
2. Normalize data between 0 and 1 then log-transform
3. Square-root transform
4. Remove synapses corresponding to the bottom 25% synapsin values
5. Same as (4) at bottom 50%
6. Same as (5) at bottom 75%
7. BIC of k-means with only excitatory and inhibitory neurons
8. Same as (7) using data from (1)       // testing on transformations
9. Same as (7) using data from (2)       // transformations
10. Same as (7) using data from (3)      // transformations
11. Same as (7) using data from (1+4)    // transformations + filter out by synapsin value
12. Same as (7) using data from (2+4)
13. Same as (7) using data from (3+4)
14. Same as (7) using data from (1+5)
15. Same as (7) using data from (2+5)
16. Same as (7) using data from (3+5)
17. Same as (7) using data from (1+6)
18. Same as (7) using data from (2+6)
19. Same as (7) using data from (3+6)
20. Kernel density estimates of raw data // kernel density estimation
21. Kernel density estimates of (4)
22. Kernel density estimates of (5)
23. Kernel density estimates of (6)
24. Detect outliers                     // use http://scikit-learn.org/stable/modules/outlier_detection.html

>>>>>>> 83d51d6bd79a7af98e19fc6a7c45d5ee496753e4
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
