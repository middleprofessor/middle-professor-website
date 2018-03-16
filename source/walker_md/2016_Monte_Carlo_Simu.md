+++
title = "Monte Carlo Simulation of OLS and Linear Mixed Model Inference of Phenotypic Effects on Gene Expression"
date = "2016-01-01"
authors = ["Jeffrey A. Walker"]
publication_types = ["2"]
publication = "PeerJ, (4), _pp. e2575_, https://doi.org/10.7717/peerj.2575"
publication_short = "PeerJ, (4), _pp. e2575_, https://doi.org/10.7717/peerj.2575"
abstract = "Background Self-contained tests estimate and test the association between a phenotype and mean expression level in a gene set defined a priori. Many self-contained gene set analysis methods have been developed but the performance of these methods for phenotypes that are continuous rather than discrete and with multiple nuisance covariates has not been well studied. Here, I use Monte Carlo simulation to evaluate the performance of both novel and previously published (and readily available via R) methods for inferring effects of a continuous predictor on mean expression in the presence of nuisance covariates. The motivating data are a high-profile dataset which was used to show opposing effects of hedonic and eudaimonic well-being (or happiness) on the mean expression level of a set of genes that has been correlated with social adversity (the CTRA gene set). The original analysis of these data used a linear model (GLS) of fixed effects with correlated error to infer effects of Hedonia and Eudaimonia on mean CTRA expression. Methods The standardized effects of Hedonia and Eudaimonia on CTRA gene set expression estimated by GLS were compared to estimates using multivariate (OLS) linear models and generalized estimating equation (GEE) models. The OLS estimates were tested using O'Brien's OLS test, Anderson's permutation \$\{r\}\_\{F\}\^\{2\}\$ r F 2 -test, two permutation F-tests (including GlobalAncova), and a rotation z-test (Roast). The GEE estimates were tested using a Wald test with robust standard errors. The performance (Type I, II, S, and M errors) of all tests was investigated using a Monte Carlo simulation of data explicitly modeled on the re-analyzed dataset. Results GLS estimates are inconsistent between data sets, and, in each dataset, at least one coefficient is large and highly statistically significant. By contrast, effects estimated by OLS or GEE are very small, especially relative to the standard errors. Bootstrap and permutation GLS distributions suggest that the GLS results in downward biased standard errors and inflated coefficients. The Monte Carlo simulation of error rates shows highly inflated Type I error from the GLS test and slightly inflated Type I error from the GEE test. By contrast, Type I error for all OLS tests are at the nominal level. The permutation F-tests have $\sim$1.9X the power of the other OLS tests. This increased power comes at a cost of high sign error ($\sim$10\%) if tested on small effects. Discussion The apparently replicated pattern of well-being effects on gene expression is most parsimoniously explained as ``correlated noise'' due to the geometry of multiple regression. The GLS for fixed effects with correlated error, or any linear mixed model for estimating fixed effects in designs with many repeated measures or outcomes, should be used cautiously because of the inflated Type I and M error. By contrast, all OLS tests perform well, and the permutation F-tests have superior performance, including moderate power for very small effects."
abstract_short = ""
image_preview = ""
selected = false
projects = []
tags = []
url_pdf = ""
url_preprint = ""
url_code = ""
url_dataset = ""
url_project = ""
url_slides = ""
url_video = ""
url_poster = ""
url_source = ""
math = true
highlight = true
[header]
image = ""
caption = ""
+++
