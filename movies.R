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

number <- data[,c("critic_name", "rotten_tomatoes_link", "numeric_score")]
#binary <- data[,c("critic_name", "rotten_tomatoes_link", "binary_score_numeric")]





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
