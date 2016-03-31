import numpy as np
import csv

def normalize(X):
    mn = np.min(X, axis=0)
    mx = np.max(X, axis=0)
    rn = mx - mn
    X = np.array([(r - mn)/rn for r in X])
    return X

def log_transform(X, norm=False):
    X = np.log(normalize(X) + 1) if norm else np.log(X + 1)
    return X

def sqrt_transform(X, norm=False):
    X = np.sqrt(normalize(X)) if norm else np.sqrt(X)
    return X

def main():
    with open('/Users/Tyler/synapsinR_7thA.tif.Pivots.txt.2011Features.txt?dl=0','r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        X = np.array([[float(e) for e in r] for r in reader])
        Xlog = log_transform(X)
        Xsq = sqrt_transform(X)
        np.save('/Users/Tyler/synapse_data/synapse_features_log.npy',Xlog)
        np.save('/Users/Tyler/synapse_data/synapse_features_sqrt.npy',Xsq)
        Xlog = log_transform(X, norm=True)
        Xsq = sqrt_transform(X, norm=True)
        np.save('/Users/Tyler/synapse_data/synapse_features_log_normalized.npy',Xlog)
        np.save('/Users/Tyler/synapse_data/synapse_features_sqrt_normalized.npy',Xsq)

def main2():
    with open('/Users/Tyler/synapsinR_7thA.tif.Pivots.txt.2011Features.txt?dl=0','r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        X = np.array([[float(e) for e in r] for r in reader])
        X = X[:,0:24]
        np.save('/Users/Tyler/synapse_data/synapse_f0_features.npy',X)

if __name__ == "__main__":
#    main()
    main2()
