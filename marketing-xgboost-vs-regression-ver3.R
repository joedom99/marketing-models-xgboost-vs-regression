# =======================================
# Marketing Models - Linear Regression vs XGBoost
# Compares a linear regression model with XGBoost on marketing data
# By: Joe Domaleski, 6/1/25
# https://blog.marketingdatascience.ai
# =======================================

# Step 1: Load required packages
# install.packages(c("datarium", "xgboost", "Metrics", "tidyverse", "reshape2"), dependencies = TRUE)

library(datarium)   # Marketing dataset
library(xgboost)    # XGBoost modeling
library(Metrics)    # RMSE calculation
library(tidyverse)  # Data wrangling and plotting
library(reshape2)   # Melting data for plotting

# Step 2: Load the marketing dataset
data("marketing")
head(marketing)

# Step 3: Split the data into training and testing sets
set.seed(123)
split_index <- sample(1:nrow(marketing), 0.8 * nrow(marketing))
train_data <- marketing[split_index, ]
test_data  <- marketing[-split_index, ]

# Step 4: Train a linear regression model
lm_model <- lm(sales ~ ., data = train_data)
summary(lm_model)

# Step 5: Predict sales using the linear regression model
lm_preds <- predict(lm_model, newdata = test_data)

# Step 6: Evaluate linear regression performance (RMSE and R²)
lm_rmse <- rmse(test_data$sales, lm_preds)
lm_r2 <- summary(lm_model)$r.squared
cat("Linear Regression RMSE:", lm_rmse, "\n")
cat("Linear Regression R²:", lm_r2, "\n")

# Step 7: Prepare data for XGBoost
train_matrix <- xgb.DMatrix(data = as.matrix(train_data[, -4]), label = train_data$sales)
test_matrix  <- xgb.DMatrix(data = as.matrix(test_data[, -4]), label = test_data$sales)

# Step 8: Set XGBoost parameters and train the model
params <- list(
  objective = "reg:squarederror",
  eval_metric = "rmse"
)

xgb_model <- xgb.train(
  params = params,
  data = train_matrix,
  nrounds = 100,
  verbose = 0
)

# Step 9: Predict sales using the XGBoost model
xgb_preds <- predict(xgb_model, test_matrix)

# Step 10: Evaluate XGBoost performance (RMSE and R²)
xgb_rmse <- rmse(test_data$sales, xgb_preds)
ss_res <- sum((test_data$sales - xgb_preds)^2)
ss_tot <- sum((test_data$sales - mean(test_data$sales))^2)
xgb_r2 <- 1 - ss_res / ss_tot
cat("XGBoost RMSE:", xgb_rmse, "\n")
cat("XGBoost R²:", xgb_r2, "\n")

# Step 11: Compare the results
results <- data.frame(
  Model = c("Linear Regression", "XGBoost"),
  RMSE_TestSet = c(lm_rmse, xgb_rmse),
  R2_TestSet   = c(lm_r2, xgb_r2)
)
print(results)

# Step 12: Feature Importance Data Prep

# 12a: Linear Regression - absolute value of coefficients
lm_importance <- summary(lm_model)$coefficients[-1, , drop = FALSE] %>%
  as.data.frame() %>%
  rownames_to_column("Feature") %>%
  mutate(AbsEstimate = abs(Estimate)) %>%
  arrange(desc(AbsEstimate))

cat("\nLinear Regression Feature Importance (by abs(coefficients)):\n")
print(lm_importance[, c("Feature", "Estimate", "AbsEstimate")])

# 12b: XGBoost - importance by Gain
xgb_importance <- xgb.importance(model = xgb_model)
cat("\nXGBoost Feature Importance:\n")
print(xgb_importance)

# Step 13: Actual vs. Predicted Plot for Both Models
plot_data <- data.frame(
  Actual = test_data$sales,
  Linear_Regression = lm_preds,
  XGBoost = xgb_preds
)

plot_melt <- melt(plot_data, id.vars = "Actual", variable.name = "Model", value.name = "Predicted")

ggplot(plot_melt, aes(x = Actual, y = Predicted, color = Model)) +
  geom_point(alpha = 0.7) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
  labs(
    title = "Actual vs. Predicted Sales",
    subtitle = "Linear Regression vs. XGBoost",
    x = "Actual Sales",
    y = "Predicted Sales"
  ) +
  theme_minimal()

# Step 14: Feature Importance Bar Charts for Both Models

# Linear Regression
ggplot(lm_importance, aes(x = reorder(Feature, AbsEstimate), y = AbsEstimate)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Linear Regression Feature Importance",
    x = "Feature", y = "Absolute Coefficient"
  ) +
  theme_minimal()

# XGBoost (use Gain for importance)
xgb_importance_df <- xgb_importance %>%
  mutate(Feature = reorder(Feature, Gain))

ggplot(xgb_importance_df, aes(x = Feature, y = Gain)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(
    title = "XGBoost Feature Importance (by Gain)",
    x = "Feature", y = "Gain"
  ) +
  theme_minimal()
