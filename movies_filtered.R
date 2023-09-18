data <- read.csv("rotten_tomatoes_critic_reviews.csv")

head(data)


sum(is.na(data))

summary(data)

library(ggplot2)
library(dplyr)
library(stringr)



#standardizing the reviews from 3.5/5 and 1/4 to one scale

data <- data %>%
  mutate(
    # Remove all spaces from review_score
    review_score = str_replace_all(review_score, " ", "")
  )

data <- data %>%
  mutate(
    # Create the letter_grade column, and fill it up with letters
    letter_grade = case_when(
      review_score %in% c("A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F") ~ review_score,
      TRUE ~ NA_character_
    )
  )
data <- data %>%
  mutate(
    
    # Replace letter grades in review_score with an empty field, so that we are only left with numerical values
    review_score = case_when(
      review_score %in% c("A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F") ~ "",
      TRUE ~ review_score
    ))

# 
# 

#Convert letter grades to numeric scores using a nested ifelse statement
data$numeric_score <- ifelse(data$letter_grade == "A+", 10,
                             ifelse(data$letter_grade == "A", 9,
                                    ifelse(data$letter_grade == "A-", 8,
                                           ifelse(data$letter_grade == "B+", 7,
                                                  ifelse(data$letter_grade == "B", 6,
                                                         ifelse(data$letter_grade == "B-", 5,
                                                                ifelse(data$letter_grade == "C+", 4,
                                                                       ifelse(data$letter_grade == "C", 3,
                                                                              ifelse(data$letter_grade == "C-", 2,
                                                                                     ifelse(data$letter_grade == "D+", 1.5,
                                                                                            ifelse(data$letter_grade == "D", 1,
                                                                                                   ifelse(data$letter_grade == "D-", 0.5,
                                                                                                          ifelse(data$letter_grade == "F", 0,
                                                                                                                 as.numeric(as.character(data$letter_grade)) )))))))))))))



# Identify scores that contain a "/" character
fractional_scores <- grepl("/", data$review_score)

# Split these scores at the "/" character
split_scores <- strsplit(data$review_score[fractional_scores], "/")

# Convert the fractional scores to the 0-10 scale
converted_scores <- sapply(split_scores, function(x) {
  numerator <- as.numeric(x[1])
  denominator <- as.numeric(x[2])
  return((numerator/denominator) * 10)
})

# Update the numeric_score column with the converted scores
data$numeric_score[fractional_scores] <- converted_scores

# Check if there were any non-numeric values that weren't converted
if(sum(is.na(data$numeric_score)) > 0) {
  print("There are some scores that were not converted. Please check the unique values.")
  print(unique(data$review_score[is.na(data$numeric_score)]))
}

#convert "Fresh" and "Rotten" into 1/0
# 
data$binary_score_numeric <- ifelse(data$review_type == "Fresh", 1, 0)
# 
####################################################################################
####################################################################################


#############################EXTRA STEP#############################################




# Group by critic_name and count the number of entries
critic_counts <- data %>%
  group_by(critic_name) %>%
  summarise(count = n(), numeric_score = mean(numeric_score, na.rm = TRUE))

# Filter out critics with less than 10 entries
remaining_critics <- critic_counts %>%
  filter(count >= 10)

# Get the removed critics
removed_critics <- critic_counts %>%
  filter(count < 10)

# Save the removed critics' names in a list
removed_critics_list <- list(removed_critics$critic_name)
names(removed_critics_list) <- "removed_critics"

# Plot for remaining critics
plot1 <- ggplot(remaining_critics, aes(x = count, y = numeric_score)) +
  geom_point() +
  labs(title = "Critics with 10 or more reviews", 
       x = "Number of Reviews", 
       y = "Numeric Score")

# Plot for removed critics
plot2 <- ggplot(removed_critics, aes(x = count, y = numeric_score)) +
  geom_point() +
  labs(title = "Critics with less than 10 reviews", 
       x = "Number of Reviews", 
       y = "Numeric Score")

# Display the plots
print(plot1)
print(plot2)

#I just spotted an interesting feature with the higher reviews, there is an extreme outlier with 17000 reviews?
#also, there seems to be a relationship with less reviews being more variable in their rating, with more reviews 
#seemingly to squeeze into higher scores. 

# Group by critic_name and count the number of reviews
top_reviewers <- data %>%
  group_by(critic_name) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  head(100)

# Display the top 100 reviewers and their review counts
print(top_reviewers)

#############
############# that explains it. we have 18529 entries without a name, which was never something I ever considered
############# when first looking at the dataset.
#############
############# Either way, it is super impressive that the top 10 have thousands of reviews.
####################################################################################
####################################################################################
number <- data[,c("critic_name", "rotten_tomatoes_link", "numeric_score")]
#binary <- data[,c("critic_name", "rotten_tomatoes_link", "binary_score_numeric")]


number <- number %>%
  group_by(critic_name) %>%
  filter(n() > 10) %>%
  ungroup()


# Calculate mean and standard deviation for each critic
critic_stats <- data %>%
  group_by(critic_name) %>%
  summarise(mu = mean(numeric_score, na.rm = TRUE),
            sigma = sd(numeric_score, na.rm = TRUE))

# Join the stats back to the original data and normalize
normalized_data <- data %>%
  left_join(critic_stats, by = "critic_name") %>%
  mutate(normalized_score = (numeric_score - mu) / sigma) %>%
  select(-mu, -sigma)  # Remove the mean and standard deviation columns

# Display the normalized data
print(normalized_data)


# Join normalized_data with critic_counts to get the count of reviews for each critic
plot_data <- cleaned_normalized_data %>%
  left_join(critic_counts, by = "critic_name") %>%
  filter(!is.na(count), !is.na(normalized_score))  # Filter out rows with NA values

# Plot and Save normalized_data
plot3 <- ggplot(plot_data, aes(x = count, y = normalized_score)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Normalized Scores by Number of Reviews", 
       x = "Number of Reviews", 
       y = "Normalized Score")
ggsave(filename = "normalized_data_plot.png", plot = plot, width = 10, height = 6)
print(plot3)


# 2. Create cleaned_normalized_data without Empty Names
empty_names <- normalized_data %>%
  filter(critic_name == "" | is.na(critic_name))
write.csv(empty_names, "empty_names.csv", row.names = FALSE)



library(dplyr)

# Join normalized_data with critic_stats to get the mean and standard deviation for each critic
normalized_data <- normalized_data %>%
  left_join(critic_stats, by = "critic_name")

# For rows where normalized_score is NA or NaN, and numeric_score has a value,
# compute the normalized score using the critic's mean and standard deviation
normalized_data <- normalized_data %>%
  mutate(normalized_score = ifelse(
    (is.na(normalized_score) | is.nan(normalized_score)) & !is.na(numeric_score),
    (numeric_score - mu) / sigma,
    normalized_score
  ))

# Remove the mean and standard deviation columns (optional)
normalized_data <- critic_stats %>%
  select(-mu, -sigma)

# Display the updated normalized_data
print(normalized_data)

# cleaned_normalized_data <- normalized_data %>%
#   filter(critic_name != "" & !is.na(critic_name))
# # Get the removed critics
# cleaned_normalized_data <- cleaned_normalized_data %>%
#   filter(count > 10)


# 3. Filter Out Rows with Empty numeric_score
empty_scores <- cleaned_normalized_data %>%
  filter(is.na(numeric_score))
write.csv(empty_scores, "empty_scores.csv", row.names = FALSE)

cleaned_normalized_data <- cleaned_normalized_data %>%
  filter(!is.na(numeric_score))

# Save the cleaned_normalized_data
write.csv(cleaned_normalized_data, "cleaned_normalized_data.csv", row.names = FALSE)




#########################STEP-2########################3
#install.packages("recommenderlab")

library(recommenderlab)


# Convert data to a matrix format suitable for recommenderlab
rating_matrix_number <- as(number, "realRatingMatrix")
#rating_matrix_binary <- as(binary, "binaryRatingMatrix")

list_number <- evaluationScheme(rating_matrix_number, method = "split", train = 0.2, given = -1)
#list_binary <- evaluationScheme(rating_matrix_binary, method = "split", train = 0.2, given = -1)

summary(list_number)
#summary(list_binary)

model_number <- Recommender(getData(list_number, "train"), method = "IBCF")
#model_binary <- Recommender(getData(list_binary, "train"), method = "IBCF")


pred_number <- predict(model_number, getData(list_number, "known"), type = "ratings")
#pred_binary <- predict(model_binary, getData(list_binary, "known"), type = "ratings")

error_number <- calcPredictionAccuracy(pred_number, getData(list_number, "unknown"))
print(list_number)
saveRDS(error_number, file = "error_number.rds")


#error_binary <- calcPredictionAccuracy(pred_binary, getData(list_binary, "unknown"))

print(error_number)
#print(error_binary)

recommendations_number <- predict(model_number, rating_matrix_number[1:5,], n=5)
print(recommendations_number)

#this will display 100 recommendations and 
recommendations_number_1 <- predict(model_number, rating_matrix_number[1:100,], n=10)
print(recommendations_number_1)
recommendations_list <- as(recommendations_number_1, "list")


saveRDS(model_number, file = "model_number.rds")

#recommendations_binary <- predict(model_binary, binary_matrix[1:5,], n=5)

recommendations_matrix <- as(recommendations_number, "matrix")
recommendations_list <- as(recommendations_number, "list")
