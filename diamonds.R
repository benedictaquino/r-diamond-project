# Load packages 
library(tidyverse)
library(mosaic)
library(multcomp)
library(car)

# Load dataset
diamonds<-read.csv("data/diamondData.csv")

# Check for homoscedasticity

xyplot(price~carat, data=diamonds)            # heteroscedastic

# log transformation
diamonds<-mutate(diamonds,lnprice=log(price)) 
xyplot(lnprice~carat, data=diamonds)          # homoscedastic

bwplot(lnprice~color, data=diamonds)         
bwplot(lnprice~clarity, data=diamonds)       
bwplot(lnprice~certification, data=diamonds) #

# Levene's Test
leveneTest(lnprice~color, data=diamonds)      # Not significant
leveneTest(lnprice~clarity, data=diamonds)    # not
leveneTest(lnprice~certification, data=diamonds) # significant

# Univariate
summary(lm(lnprice~carat, diamonds))
diamonds<-mutate(diamonds,carat2=carat^2)   # better adjusted R-squared
summary(lm(lnprice~carat+carat2, data=diamonds))  # significant
summary(lm(lnprice~color, data=diamonds))         # not significant
diamonds$recolor[diamonds$color == "D"] <- "DEF"
diamonds$recolor[diamonds$color == "E"] <- "DEF"
diamonds$recolor[diamonds$color == "F"] <- "DEF"
diamonds$recolor[diamonds$color == "G"] <- "GHI"
diamonds$recolor[diamonds$color == "H"] <- "GHI"
diamonds$recolor[diamonds$color == "I"] <- "GHI"

bwplot(lnprice~recolor, data=diamonds)
summary(lm(lnprice~recolor, data=diamonds))         # not significant

summary(lm(lnprice~clarity, data=diamonds))       # significant


diamonds$reclarity[diamonds$clarity == "IF"]<- "IF"
diamonds$reclarity[diamonds$clarity == "VVS1"]<- "VVS"
diamonds$reclarity[diamonds$clarity == "VVS2"]<-"VVS"
diamonds$reclarity[diamonds$clarity == "VS1"]<-"VS"
diamonds$reclarity[diamonds$clarity == "VS2"]<-"VS"

summary(lm(lnprice~certification, data=diamonds)) # significant

diamonds$recertification[diamonds$certification == "GIA"] <- "GIA"
diamonds$recertification[diamonds$certification == "HRD"] <- "HRD or IGI"
diamonds$recertification[diamonds$certification == "IGI"] <- "HRD or IGI"

bwplot(lnprice~recertification, diamonds)


# Multivariate

# Full model
model0<-lm(lnprice~carat+carat2+recolor+reclarity+certification, data=diamonds)
summary(model0)
anova(model0)

# Test individual variables
full<-model0
reduced<-lm(lnprice~carat2+recolor+reclarity+certification, diamonds)
anova(full,reduced)   # significant => there is an association

reduced<-lm(lnprice~carat+recolor+reclarity+certification, diamonds)
anova(full,reduced)

reduced<-lm(lnprice~carat+carat2+reclarity+certification, diamonds)
anova(full,reduced)   # significant

reduced<-lm(lnprice~carat+carat2+recolor+certification, diamonds)
anova(full,reduced)   # significant

reduced<-lm(lnprice~carat+carat2+recolor+reclarity, diamonds)
anova(full,reduced)   # not significant => drop certification

# Check interactions
model1<-lm(lnprice~carat+carat2+recolor+reclarity+recolor*carat+reclarity*carat+recolor*carat2+reclarity*carat2, diamonds)
anova(model1)

full<-model1
reduced<-lm(lnprice~carat+carat2+recolor+reclarity, data=diamonds)
anova(full,reduced) # not significant => drop interactions

model2<-lm(lnprice~carat+carat2+recolor+reclarity, diamonds)
summary(model2)
anova(model2)

# Contrasts

# Difference in lnprice between carat and carat^2
contrast <- matrix(c(0,1,-1,0,0,0),1)
t <- glht(model2, linfct = contrast)
summary(t)

# Difference in lnprice between VVS and VS
contrast <- matrix(c(0,0,0,0,-1,-1),1)
t <- glht(model2, linfct = contrast)
summary(t)

