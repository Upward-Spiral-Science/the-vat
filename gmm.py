from sklearn import mixture
import numpy as np
from scipy.stats import cumfreq

def gmm_test(X,k0,k1,nboot):
    nsample = X.shape[0]

    gmm0 = mixture.GMM(n_components=k0, covariance_type='full')
    gmm0.fit(X)
    L0 = sum(gmm0.score(X))
    gmm1 = mixture.GMM(n_components=k1, covariance_type='full')
    gmm1.fit(X)
    L1 = sum(gmm1.score(X))
    LRstat = -2*(L1 - L0)
    
    LRstat0 = []

    for i in range(nboot):
        Xboot = gmm0.sample(n_samples=nsample)
        gmm0_boot = mixture.GMM(n_components=k0, covariance_type = 'full')
        gmm0_boot.fit(Xboot)
        L0_boot = sum(gmm0_boot.score(Xboot))
        gmm1_boot = mixture.GMM(n_components=k1, covariance_type = 'full')
        gmm1_boot.fit(Xboot)
        L1_boot = sum(gmm1_boot.score(Xboot))
        LRstat0.append(-2*(L1_boot - L0_boot))

    ecdf, lowlim, binsize, extrapoints = cumfreq(LRstat0)
    ecdf = ecdf/len(LRstat0)

    bin = np.mean([lowlim,lowlim+binsize])
    bins = []

    for i in range(len(ecdf)):
        bins.append(bin)
        bin = bin + binsize

    p = max(ecdf[bins<=LRstat])

    return p
