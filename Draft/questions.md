Questions About my Project

We have a text file with a D = 1,119,299 data points on synapses located in 3D space. Each data point has a corresponding space vector of (x,y,z) coordinates and also feature vectors with 144 elements in each vector. 

D = 1,119,299 data points 
Each data point contains V = (x,y,z)
Each data point contains A = 144 features.

Descriptive 

1. What does each A_i stand for?
2. Does A_i contain any inf/NaN values?
3. Does D have any duplicate points?


Exploratory 
1. What is the mean and variance of V?
2. What is the PCA analysis of A downsampled?
3. what is the min of V in (x,y,z) direction and max?

Inferential 
Depends on answers above...
1. Does mean protein expression vary based on location?
2. Is there significant correlation between any features?

Predictive 
1. What is the best block model to cluster the data better? Can we use stochastic block modelling?
2. How many classes of synapses can we identify?
3. What features are relevant for predicting synapse type?

Causal 
1. Does a certain protein cause certain synapse subcluster?

Mechanistic 
1. What mechanism causes synaptic diversion within neuronal growth?
2. How do different profiles of protein expression relate to overall function?

Things to Do:
shiny.neurodata.io
1. dendrogram of data
2. histogram of data - good for large datasets (LLN)
3. average
4. variance
5. PCA
6. outlier plot
- if outliers, can convert to ranks, or robust estimators
7. covaraiance plot, halla
8. correlation heat map
9. violin plot - kernel density estimators for plots