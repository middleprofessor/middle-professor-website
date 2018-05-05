---
title: "Interpreting coefficients in glms"
output: html_document
---
[This is an archive of an external source. The original is here](http://environmentalcomputing.net/interpreting-coefficients-in-glms/)

In linear models, the interpretation of model parameters is linear. For example, if a you were modelling plant height against altitude and your coefficient for altitude was -0.9, then plant height will decrease by 1.09 for every increase in altitude of 1 unit.

For generalised linear models, the interpretation is not this straightforward. Here, I will explain how to interpret the co-efficients in generalised linear models (glms). First you will want to read our pages on glms for [binary](http://environmentalcomputing.net/generalised-linear-models-1/) and [count](http://environmentalcomputing.net/generalised-linear-models-1/) data page on [interpreting coefficients in linear models](http://environmentalcomputing.net/how-to-interpret-linear-models/).
<br><br>

### Poisson and negative binomial GLMs
<br>
In Poisson and negative binomial glms, we use a log link. The actual model we fit with one covariate $x$ looks like this

$$ Y \sim \text{Poisson} (\lambda) $$
$$  log(\lambda) = \beta_0 + \beta_1 x $$

here $\lambda$ is the mean of Y. So if we have an initial value of the covariate $x_0$, then the predicted value of the mean $\lambda_0$ is given by 

$$  log(\lambda_0) = \beta_0 + \beta_1 x_0 $$

If we now increase the covariate by 1, we get a new mean $\lambda_1$,

$$  log(\lambda_1) = \beta_0 + \beta_1 (x_0 +1) = \beta_0 + \beta_1 x_0 +\beta_1 = log(\lambda_0) + \beta_1$$

So the log of the mean of Y increases by $\beta_1$ when we increase x by 1. But we are not really interested in how the log mean changes, we would like to know on average how Y changes. If we take the exponential of both sides 

$$  \lambda_1 = \lambda_0 exp(\beta_1)$$

So the mean of Y is multiplied by $exp( \beta_1 )$ when we increase $x$ by 1 unit.


```r
N <- 120
x <- rnorm(N)
mu <- exp(1+0.2*x)
Y <- rpois(N, lambda = mu)
glm1 <- glm(Y~x, family = poisson)
glm1$coefficients
```

```
## (Intercept)           x 
##   1.0424635   0.1365189
```

```r
exp(glm1$coefficients[2])
```

```
##        x 
## 1.146277
```

So here increasing $x$ by 1 unit multiplies the mean value of Y by $exp( \beta_1 ) = 1.25$. The same thing is true for negative binomial glms as they have the same link function.
<br><br>

### Binomial GLMs
<br>
#### Logistic regression
<br>
Things become much more complicated in binomial glms. The model here is actually a model of log odds, so we need to start with an explanation of those. The odds of an event are the probability success divided by the probability of failure. So if the probability of success is $p$ then the odds are:

$$\text{Odds} = \frac{p}{1-p} $$

As p increases, so do the odds. The equation for a logistic regression looks like this:

$$ Y \sim \text{binomial} (p) $$
$$  log\left(\frac{p}{1-p}\right)  =  \beta_0 + \beta_1 x $$

Skipping some maths that is very similar to the above, we can obtain an interpretation for the coefficient of $x$ in the model in terms of the odds. When we increase $x$ by one unit the odds are multiplied by $exp( \beta_1 )$. Odds are not the most intuitive thing to interpret, but they do increase when p increases, so that if your coefficient $\beta_1$ is positive, increasing $x$ will increase your probability. 


```r
bY <- Y>0 #turning counts into presence absence
bin1 <- glm(bY~x,family = binomial)
summary(bin1)
```

```
## 
## Call:
## glm(formula = bY ~ x, family = binomial)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.6749   0.2569   0.3195   0.3703   0.7484  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)   2.8821     0.4239   6.798 1.06e-11 ***
## x             0.5698     0.3943   1.445    0.148    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 53.366  on 119  degrees of freedom
## Residual deviance: 51.347  on 118  degrees of freedom
## AIC: 55.347
## 
## Number of Fisher Scoring iterations: 6
```
So when we increase $x$ by one unit, the odds of Y are multiplied by $exp( \beta_1 ) = 2.11$
<br><br>

#### Complementary log-log
<br>
Possibly a more intuitive model is a binomial regression with a complementary log-log link function. This link function is based on the assumption that you have some counts, which are Poisson distributed, but you've decided to turn them into presence/absence. 

$$ Y \sim \text{binomial} (p) $$
$$  log(-log(1-p)) = \beta_0 + \beta_1 x $$

In that case you can interpret your coefficients in a similar way as the Poisson regression. When you increase $x$ by 1, the mean of your underlying count (which you have turned into presence/absence) is multiplied by $exp( \beta_1 )$.  


```r
library(mvabund)
bin2 <- manyglm(bY~x, family = binomial(link = "cloglog"))
coef(bin2)
```

```
##                    bY
## (Intercept) 1.0637146
## x           0.1881527
```

The interpretation is now the same as in the Poisson case, when we increase $x$ by 1, the mean of the underlying count is multiplied by $exp( \beta_1 )$.
<br><br>

#### Log binomial model
<br>
It is possible to use a log link function with the binomial distribution `family = binomial(link = log)`. In this case you can interpret the coefficients as multiplying the probabilities by $exp( \beta_1 )$, however these models can give you predicted probabilities greater than 1, and often don't converge (don't give an answer).
<br><br>

### Offsets
<br>
Sometimes we know the effect of a particular variable (call it $z$) on the response is proportional, so that when we double $z$ we expect the response to double on average. The most common time you see this is with sampling intensity. 

![](glm_coefficients_image.jpg)

If you sample soil and count critters, all other things being equal, you would expect twice the critters in twice the amount of soil. If you have a variable like this it is tempting to divide your response (count) by the amount of soil to standardise the data. Unfortunately this will take counts, which we know how to model with glms, and turn them into something we do not know how to model. Fortunately this situation is easily dealt with using offsets. First, let's simulate some data for amount of soil, depth (our predictor variable) and count data (with a poisson distribution) where the couunts depend on how much soil was sampled.


```r
soil <- exp(rbeta(N, shape1 = 8, shape2 = 1))
depth <- rnorm(N)
mu <- soil*exp(0.5+0.5*depth)
count <- rpois(N, lambda = mu)
```

Now, we can model counts with depth as our predictor and soil quantity as an offset.


```r
off_mod <- glm(Y~depth+offset(log(soil)), family = poisson)
summary(off_mod)
```

```
## 
## Call:
## glm(formula = Y ~ depth + offset(log(soil)), family = poisson)
## 
## Deviance Residuals: 
##      Min        1Q    Median        3Q       Max  
## -2.53850  -0.62472  -0.04006   0.59313   1.94389  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)   
## (Intercept)  0.16137    0.05384   2.997  0.00272 **
## depth        0.05332    0.05767   0.925  0.35518   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for poisson family taken to be 1)
## 
##     Null deviance: 124.96  on 119  degrees of freedom
## Residual deviance: 124.11  on 118  degrees of freedom
## AIC: 455.46
## 
## Number of Fisher Scoring iterations: 5
```

If we ignored the soil amount, we could have misleading conclusions. If the soil amount is correlated with another variable in your model, then leaving out the offset will affect the coefficient of that variable, as in the discussion of conditional/marginal interpretations [here](http://environmentalcomputing.net/how-to-interpret-linear-models/). The offset will also often account for a lot of the variation in the response, so including it will give you a better model overall. What if you're not sure if the relationship is exactly proportional? In that case just include the variable in your model as a coefficient, and the model will decide the best relationship between it and your response. 


```r
coef_mod <- glm(Y~depth+log(soil), family = poisson)
summary(coef_mod)
```

```
## 
## Call:
## glm(formula = Y ~ depth + log(soil), family = poisson)
## 
## Deviance Residuals: 
##      Min        1Q    Median        3Q       Max  
## -2.44209  -0.63328  -0.01757   0.57093   2.13790  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)  
## (Intercept)  1.23061    0.53834   2.286   0.0223 *
## depth        0.06503    0.05772   1.127   0.2599  
## log(soil)   -0.19319    0.60080  -0.322   0.7478  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for poisson family taken to be 1)
## 
##     Null deviance: 121.63  on 119  degrees of freedom
## Residual deviance: 120.33  on 117  degrees of freedom
## AIC: 453.68
## 
## Number of Fisher Scoring iterations: 5
```

The coefficient the model estimated is close to 1, which would be equivalent to an offset.
<br><br>

**Author**: Gordana Popovic
<br>
Last updated:

```
## [1] "Sat May  5 10:53:28 2018"
```

