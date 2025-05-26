# Marketing Models: Linear Regression vs. XGBoost

[![R](https://img.shields.io/badge/R-4.3.1-blue?logo=r)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Made With Love](https://img.shields.io/badge/made%20with-%E2%9D%A4-red)](https://blog.marketingdatascience.ai)

This project compares a classic **linear regression model** with a modern **XGBoost model** using a real-world-style marketing dataset. The goal is to predict sales based on advertising spend and visualize model performance, accuracy, and feature importance.

Created by [Joe Domaleski](https://blog.marketingdatascience.ai), June 2025.

## 🔍 What's Inside

- ✅ Test/train split on marketing data from the `datarium` R package  
- 📉 Model performance comparison (RMSE and R²)  
- 📊 Visuals: actual vs. predicted plots, feature importance charts  
- 🧠 Interpretation of model coefficients vs. gradient-boosted gain  
- 💻 Clean, documented R code — ready to run

## 📦 Requirements

You'll need the following R packages:

```r
install.packages(c("datarium", "xgboost", "Metrics", "tidyverse", "reshape2"))
```

## 🚀 Running the Script

Run the provided R script (`marketing-xgboost-vs-regression.R`) to:

1. Load and split the data  
2. Train both models  
3. Compare their performance  
4. Visualize the results  

## 📈 Example Output

- **RMSE / R² Comparison Table**
- **Actual vs. Predicted Scatterplot**
- **Bar charts for feature importance**

## 📜 License

This project is licensed under the [MIT License](LICENSE).

## 📚 References

- Chen, Tianqi, and Carlos Guestrin. _“XGBoost: A Scalable Tree Boosting System.”_ Proceedings of the 22nd ACM SIGKDD Conference, 2016. [doi:10.1145/2939672.2939785](https://doi.org/10.1145/2939672.2939785)

- Chen, Tianqi, et al. _“xgboost: Extreme Gradient Boosting.”_ CRAN, Version 1.7.11.1, 2025. [https://CRAN.R-project.org/package=xgboost](https://CRAN.R-project.org/package=xgboost)

- Kassambara, Alboukadel. _“datarium: Data Bank for Statistical and Machine Learning Analysis.”_ CRAN, 2019. [https://CRAN.R-project.org/package=datarium](https://CRAN.R-project.org/package=datarium)

