# r-diamond-project

Diamond pricing model created using multivariate linear regression techniques on a data set containing information on ***n*** = **308** round diamonds, including their **price**, **carat**, **clarity**, **color**, and **cut** (the "4 C's).

  - **Carat**: The weight of a diamond stone is indicated in terms of carat units. One carat is equivalent to 0.2 grams. All other things being equal, larger diamond stones command higher prices in view of their rarity.
  
  - **Clarity**: Diamonds with no inclusion under a loupe with a 10 power magnification are labelled IF (“internally flawless”). Lesser diamonds are categorizedin descending order as “very very slightly imperfect” (VVS1 or VVS2)and “very slightly imperfect” (VS1 or VS2).
  
  - **Color**: The most prized diamonds display color purity. They are not contaminated with yellow or brown tones. Top color purity attracts a grade of D. Subsequent degrees of color purity are rated E, F, G, etc.
  
  - **Cut**: The cut (or faceting) of a raw diamond stone relies on the experience and the craftsmanship of the diamond cutter. The optimal cut should neither be too deep nor too shallow for it will impede the trajectory of light and thereby the brilliance or “fire” of a diamond stone. To assist shoppers, independent certification bodies assay diamond stones and provide each of them with a certificate listing their caratage and their grades of clarity, color and cut. Three of the most common certification bodies include the New York based Gemmological Institute of America (GIA), the Antwerp based International Gemmological Institute (IGI),and HogeRaad Voor Diamant (HRD). Their reputations could be a factor in the pricing of the diamond stones.


## Technical Report
###### R code, outputs, additional plots, and other specifics can be found in the diamonds.md markdown file.

### Summary

This study is designed to create a sensible pricing model for diamonds based on the “4 C’s.” The objective of this analysis is to use regression methods to test for associations between *price* and the other characteristics of diamonds. We found that there was a significant quadratic relationship between *price* and *carat*, and significant associations *with clarity* and *color* as well. Our final model was a second-order regression model which included *carat*, *clarity*, and *color* as our covariates.

### Data Source and Management

Our dataset consisted of 308 round diamonds and information on their *price*, *carat*, *color*, *clarity* and *certification*. We derived three new variables, *lnprice*, *recolor*, and *reclarity*. These are described within Table 1.

##### Table 1. Variable Descriptions

| Variable  |    Description       |Values|
|:----------|----------------------|------------------------|
| **price** | Price of the diamond |      |
| **carat** | The weight of a diamond stone is indicated in terms of carat units.<br>One carat is equivalent to 0.2 grams.||
| **color** | The most prized diamonds display color purity. They are not<br>contaminated with yellow or brown tones.|D, E, F, G, H, I<br> (D being the purest)
|**clarity**| The amount of inclusions within a diamond, IF being the highest<br>grade, and VS2 being the lowest.|IF = internally flawless<br>VVS1 = Very, very, slightly imperfect<br>VVS2<br>VS1 = Very slightly imperfect<br>VS2 
|**certification**| Three of the most common certification. Their reputations could<br>be a factor in the pricing of the diamond stones| GIA = Gemmological Institute of America <br>IGI = International Gemmological Institute<br>HRD = Hoge Raad Voor Diamant|
|**lnprice***|A log transformation was used to adjust for homoscedasticity
|**recolor***|Regrouping of the color variable|DEF or GHI
|**reclarity***|Regrouping of the clarity variable|IF, VVS, VS
###### * derived by Benedict Aquino and John Collins

We looked at the scatterplot of *price* on carat to check for homoscedasticity. The scatterplot looked heteroscedastic, so we used a log transformation to fix this issue. Boxplots and Levene’s Test were used to check for homoscedasticity amongst the categorical values. We then proceeded with univariate analyses of the transformed *lnprice* on each covariate individually. If the univariate linear regression was significant, it was included in the multivariate model. Using the F-test recipe, individual covariates were tested if it seemed that they had no association with *price* after adjusting for the other covariates. Interactions were then included and we repeated the F-test recipe process on the interactive covariates.

### Results

Table 2 shows the results of Levene’s Test on the categorical values to check for homoscedasticity. 

##### Table 2. Levene’s Test for Homogeneity of Variances Results

|lnprice~|Df|F-value|p-value|
|---|---|---|---|
|**color**|5|302|1.2052|0.3066|
|**clarity**|4|303|0.2385|0.9164|
|**certification**|2|305|6.6127|0.001544|
|**recolor**|1|306|0.0067|0.9346|
|**reclarity**|2|305|0.3246|0.7231|

The variances appear equal for *color* and *clarity*, but not *certification* in the boxplots, and Levene’s Test confirms this.

The scatterplot for *price* on *carat* looked heteroscedastic, so we used a log transformation to adjust for this, creating the new variable *lnprice*.

Table 3 shows the results of our univariate analyses of *lnprice* regressed on each variable individually, and Table 4 shows the results of our contrasts on *clarity* and *certification*. Tables 5 and 6 show our multivariate analyses and interaction models.

##### Table 3. Univariate Linear Regression Summary Statistics

|lnprice~|Covariate|Parameter Estimate|Standard Error|t-value|p-value|Adjusted R<sup>2</sup>|
|-|-|-|-|-|-|-|
|**carat**|Intercept<br>carat|6.44488<br>2.84155|0.02938<br>0.04264|219.40<br>66.64|< 0.001<br>< 0.001|0.9353|
|**carat+carat<sup>2</sup>**|Intercept<br>carat<br>carat<sup>2</sup>|5.7806<br>5.4368<br>-2.0501|0.0483<br>0.1709<br>0.1326|119.68<br>31.81<br>-15.46|< 0.001<br>< 0.001<br>< 0.001|0.9636|
|**color**|Intercept<br>colorE<br>colorF<br>colorG<br>colorH<br>colorI|8.42636<br>-0.06481<br>-0.22473<br>-0.34753<br>-0.15231<br>-0.12408|0.20362<br>0.23777<br>0.22260<br>0.22730<br>0.22877<br>0.24092|41.383<br>-0.273<br>-1.010<br>-1.529<br>-0.666<br>-0.515|< 0.001<br>0.785<br>0.314<br>0.127<br>0.506<br>0.607|-0.0003821|
|**clarity**|Intercept<br>clarityVS1<br>clarityVS2<br>clarityVVS1<br>clarityVVS2|7.4988<br>0.7800<br>0.9614<br>0.8926<br>0.8593|0.1144<br>0.1421<br>0.1547<br>0.1554<br>0.1431|65.558<br>5.490<br>6.213<br>5.743<br>6.007|< 0.001<br>< 0.001<br>< 0.001<br>< 0.001<br>< 0.001|0.1318
|**certification**|Intercept<br>certificationHRD<br>certificationIGI|8.36473<br>0.42766<br>-0.93498|0.05229<br>0.08922<br>0.08959|159.976<br>4.793<br>-10.436|< 0.001<br>< 0.001<br>< 0.001|0.3774|
|**recolor**|Intercept<br>colorGHI|8.27650<br>-0.07209|0.06838<br>0.09314|121.036<br>-0.774|< 0.001<br>0.44|-0.001308|
|**reclarity**|Intercept<br>clarityVS<br>clarityVVS|7.4988<br>0.8518<br>0.8726|0.1144<br>0.1318<br>0.1323|65.570<br>6.462<br>6.595|< 0.001<br>< 0.001<br>< 0.001|0.1322|

##### Table 4. Contrasts
|Variable|Contrast|t-value|p-value|
|-|-|-|-|
|**clarity**|β1 = β2<br>β3 = β4|-1.353<br>0.245|0.177<br>0.807|
|**reclarity**|β0 = β1<br>β0 = β2|27.94<br>27.82|< 0.001<br>< 0.001|

The first-order linear regression of *lnprice* on *carat* is significant, but the scatterplot looks like there may be a quadratic association between *lnprice* and *carat*, so we check if the second-order linear regression is significant and compare the adjusted R-squared values. The adjusted R-squared value for the second-order model is greater than the first-order, so we will proceed with the quadratic model. 

The linear regression between *lnprice* on *color* is not significant, and since it is a ranking of color purity, we can combine the six categories into two with no real repercussions for the multivariate analysis to create recolor**. 

The regression of *lnprice* on *clarity* is significant, so there is an association. Then we check the contrasts to see if we can group any categories together. Intuitively, we check if there is a difference in mean price values between *VVS1* and *VVS2* (p = 0.177), and between *VS1* and *VS2* (p = 0.807). The tests are not statistically significant, so we can group together *VVS1* with *VVS2* and *VS1* with *VS2*. Then we tested to see if there is a difference in mean prices between the new *VVS* and *VS* against the *IF* reference group. These tests were significant (both tests found p < 0.001), so our final categories for our new *recolor* variable were *IF*, *VVS*, and *VS*. Then we found that the linear regression of *lnprice* on certification was significant.

##### Table 5. Multivariate Linear Regression Summary Statistics

|Covariate|Parameter Estimate|Standard Error|t-value|p-value|Adjusted R<sup>2</sup>|
|-|-|-|-|-|-|
|<b>Intercept<br>carat<br>carat<sup>2</sup><br>recolorGHI<br>reclarityVS<br>reclarityVVS<br>certificationHRD<br>certificationIGI<b>|5.974185<br>5.637065<br>-2.120293<br>-0.218185<br>-0.255039<br>-0.126158<br>0.005082<br>-0.024360|0.042676<br>0.128391<br>0.093700<br>0.011285<br>0.020555<br>0.019158<br>0.014308<br>0.018685|139.989<br>43.906<br>-22.629<br>-19.334<br>-12.408<br>-6.585<br>0.355<br>-1.304|< 0.001<br>< 0.001<br>< 0.001<br>< 0.001<br>< 0.001<br>< 0.001<br>0.723<br>0.193|0.986|

From the summary statistics it is suggested that there is no association between *lnprice* and *certification* when adjusted for the other covariates. So we use our F-test recipe and it shows that the association between *lnprice* and *certification* is not significant (p = 0.3473) when adjusted for the other covariates, so we drop it from the multivariate model. Although *recolor* did not show an association with lnprice in the univariate model, when adjusted for the other covariates, there was a statistically significant association.

##### Table 6. Multivariate Linear Regression with Interactions Summary Statistics 

|Covariate|Parameter Estimate|Standard Error|t-value|p-value|Adjusted R2|
|-|-|-|-|-|-|
|<b>Intercept<br>carat<br>carat<sup>2</sup><br>recolorGHI<br>reclarityVS<br>reclarityVVS<br>carat:recolorGHI<br>carat:reclarityVS<br>carat:reclarityVVS</b>|5.92016<br>5.73953<br>-2.15696<br>-0.20402<br>-0.23369<br>-0.10545<br>-0.02058<br>-0.02624<br>-0.03118|0.03747<br>0.11779<br>0.09216<br>0.02842<br>0.03999<br>0.03994<br>0.04109<br>0.07526<br>0.07558|157.985<br>48.727<br>-23.403<br>-7.178<br>-5.844<br>-2.640<br>-0.501<br>-0.349<br>-0.413|< 0.001<br>< 0.001<br>< 0.001<br>< 0.001<br>< 0.001<br>0.00872<br>0.61686<br>0.72764<br>0.68027|0.9859

The summary indicates that the interaction covariates may not be significant, so we test to see if there is any association between the price and interaction covariates after adjusting for the non-interaction covariates with our F-test recipe. This test is not significant so we can drop the interaction variables. 

### Conclusion

In order to correct for heteroscedasticity we modeled the natural logarithm of price, *lnprice* against the covariates rather than *price*. Our *certification* variable was insignificant so we left it out of the final model. The six *color* groups were consolidated into two groups and the six *clarity* groups were consolidated into three groups for the final model. Since *carat* showed statistical significance of a quadratic relationship we have also included a *carat<sup>2</sup>* covariate.
So our final model is: 

<center><i><big>Y<sub>i</sub> = β<sub>0</sub> + β<sub>1</sub>carat + β<sub>2</sub>carat<sup>2</sup> + β<sub>3</sub>D<sub>GHI</sub> + β<sub>4</sub>D<sub>VVS</sub> + β<sub>5</sub>D<sub>VS</sub></big><i></center>
