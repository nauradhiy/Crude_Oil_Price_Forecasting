# WTI Crude Oil Price Forecasting: Time Series Analysis 🛢️

## Company & Market Overview

West Texas Intermediate (WTI) crude oil serves as one of the world's primary oil price benchmarks and a fundamental leading indicator of global economic conditions. As the main reference point for oil markets, WTI prices reflect not only supply and demand dynamics but also investor sentiment and geopolitical conditions. For net oil-importing countries like Indonesia, every fluctuation in WTI transmits significant impact: on the fiscal channel, price increases directly pressure the state budget through energy subsidy burdens; on the monetary channel, it triggers cost-push inflation, a critical consideration for Bank Indonesia's interest rate policy; and on the external balance, it risks widening the trade deficit, which can weaken the Rupiah.

This project applies rigorous time series econometrics to model and forecast WTI crude oil prices, enabling policymakers and industry stakeholders to move from reactive to proactive risk management strategies.

## Business Problem Statement

Despite the availability of historical oil price data, analysts and policymakers often lack a structured, statistically validated forecasting framework for WTI prices. Without a reliable model, energy-related budget planning, subsidy policy decisions, and corporate hedging strategies rely on intuition rather than evidence, exposing institutions to unnecessary financial risk.

## Why This Project Matters

Crude oil price movements affect everything from national fiscal policy to consumer energy bills. Without rigorous time series modelling, there is no systematic way to quantify price uncertainty, stress-test budget assumptions, or validate hedging positions. This analysis builds a replicable, diagnostic-tested ARIMA forecasting pipeline that can be adapted for ongoing monitoring and decision support.

## Key Business Objectives

| Objective | Analytical Question |
| --- | --- |
| Build a validated forecasting model | Which ARIMA specification best captures WTI price dynamics? |
| Assess price stationarity | Does the raw price series require differencing before modelling? |
| Identify candidate model structures | What do ACF and PACF patterns suggest about AR and MA orders? |
| Select the best model | Which model achieves the lowest AIC with all significant parameters? |
| Validate model diagnostics | Do residuals satisfy white noise assumptions (Ljung-Box)? |
| Evaluate forecast accuracy | How closely does the model track actual 1997 prices out-of-sample? |

## Key Analyses

**1. Exploratory Data Analysis (EDA)**

- Time series visualisation of WTI monthly prices from January 1986 to December 1996
- Descriptive statistics including mean, median, standard deviation, skewness, and kurtosis
- Boxplot analysis to identify price distribution and outliers (e.g. Gulf War spike, October 1990)
- Identification of structural breaks and volatility regimes across the 11-year training window

**2. Stationarity Testing & Differencing**

- Augmented Dickey-Fuller (ADF) test on the original price series (p-value = 0.284, non-stationary)
- First-order differencing applied to achieve stationarity
- Re-confirmation via ADF test on differenced series (p-value = 0.010, stationary)
- ACF and PACF plots before and after differencing to guide model order selection

**3. Model Identification & Candidate Selection**

- ACF and PACF analysis post-differencing reveals cut-off at lag 2
- Three candidate ARIMA models identified: ARIMA(1,1,2), ARIMA(0,1,2), ARIMA(2,1,0)
- Parameter estimation via maximum likelihood for all three candidates
- AIC comparison and parameter significance testing (z-test) across all candidates

**4. Diagnostic Testing & Model Validation**

- Ljung-Box test on residuals of the selected model (Q* = 7.59, p-value = 0.370)
- Residual ACF plot to confirm absence of remaining autocorrelation
- Histogram inspection to assess normality of residuals
- Homoscedasticity assessment of residual variance

## R Techniques Used

- Time Series Objects (`ts()`, `start`, `frequency`)
- Stationarity Testing (`adf.test()` from `tseries`)
- ACF & PACF Visualisation (`acf()`, `pacf()`)
- ARIMA Estimation (`arima()`, `auto.arima()` from `forecast`)
- Parameter Significance Testing (`coeftest()` from `lmtest`)
- Diagnostic Testing (`Box.test()` with Ljung-Box method)
- Forecasting & Confidence Intervals (`forecast()`)
- Accuracy Metrics (`accuracy()` — ME, RMSE, MAE, MAPE, MASE)
- Visualisation (`ggplot2`, `plotly`, `dygraphs`)

## Analytical Framework

- Conducted structured EDA on 132 monthly WTI price observations (1986–1996) across 3 variables: Year, Date, and Price.
- Applied the Box-Jenkins methodology — identification, estimation, and diagnostic checking — to build a statistically sound ARIMA model.
- Used AIC minimisation combined with parameter significance and model parsimony as the three-criteria model selection framework.
- Validated the selected model against 12 months of held-out 1997 actual price data to assess real-world forecast performance.

## Model Selection Results

| Model | AIC | Parameter Significance | Parsimony |
| --- | --- | --- | --- |
| **ARIMA(1,1,2)** | **547.9** | **All significant (p < 0.001)** | ✓ |
| ARIMA(0,1,2) | 555.3 | ma2 not significant (p = 0.119) | ✓ |
| ARIMA(2,1,0) | 556.1 | All significant | ✓ |

**Selected Model: ARIMA(1,1,2)** - lowest AIC, all parameters significant at the 0.1% level, satisfies model parsimony.

## Forecast Accuracy (Test Set - 1997)

| Model | ME | RMSE | MAE | MAPE | MASE |
| --- | --- | --- | --- | --- | --- |
| **ARIMA(1,1,2)** | **-1.422** | **1.885** | **1.626** | **8.12%** | **1.223** |
| ARIMA(0,1,2) | -5.538 | 5.711 | 5.538 | 27.78% | 4.165 |
| ARIMA(2,1,0) | -5.627 | 5.793 | 5.627 | 28.22% | 4.232 |

ARIMA(1,1,2) achieves the smallest error across all metrics. Its ME and MPE are the closest to zero among all candidates, confirming that its forecasts most closely track the actual 1997 price trajectory.

## Business Impact

The ARIMA(1,1,2) model achieves a MAPE of 8.12% on the 1997 out-of-sample test set, demonstrating reliable short-term forecast performance. The Ljung-Box test confirms residuals satisfy white noise assumptions, validating the model's suitability for production forecasting. Residuals are approximately normally distributed with constant variance, making the 95% confidence intervals statistically interpretable for risk quantification in budget and hedging applications.

## Decision Support

The validated ARIMA forecasting pipeline enables:
- **Budget planners** to generate probabilistic price scenarios for subsidy cost modelling
- **Risk managers** to quantify price uncertainty via confidence intervals and stress-test hedging strategies
- **Policy analysts** to monitor when actual prices deviate significantly from model forecasts, triggering early-warning reviews

## Dataset

**Source:** [Kaggle - Crude Oil Prices: 70 Year Data](https://www.kaggle.com/)  
**Period:** January 1986 – December 1997 (144 monthly observations)  
**Training set:** January 1986 – December 1996 (132 observations)  
**Validation set:** January 1997 – December 1997 (12 observations)  
**Variables:** Year, Date, Oil Price (USD/barrel)  
*This project is prepared for educational and professional portfolio purposes only.*
