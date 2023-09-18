⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣠⣴⣾⡿⠿⠟⠛⠿⠿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢀⣴⣿⢿⣿⣿⣧⠀⠀⠀⠀⢠⣿⣿⣿⢿⣷⡄⠱⣦⡀⠀⠀⠀⠀⠀⠀
⠀⠀⢀⣾⠏⠀⠀⠙⢿⣿⣧⡀⠀⣠⣿⣿⠟⠁⠀⠹⣿⣆⠈⠻⣦⡀⠀⠀⠀⠀
⠀⠀⣾⡏⠀⠀⠀⠀⠈⣿⣿⣷⣾⣿⣿⡏⠀⠀⠀⠀⢸⣿⡆⠀⠈⢻⣄⠀⠀⠀
⠀⢸⣿⣷⣤⣤⣤⣤⣴⣿⠋⣠⣤⡈⢻⣷⣤⣤⣤⣤⣴⣿⣷⠀⠀⠀⢻⣆⠀⠀
⠀⢸⣿⣿⠿⠿⠿⠿⠿⣿⡀⠻⠿⠃⣸⡿⠿⠿⠿⠿⢿⣿⣿⠀⠀⠀⠀⢿⡄⠀
⠀⠀⣿⣇⠀⠀⠀⠀⠀⣿⣿⣶⣶⣾⣿⡇⠀⠀⠀⠀⢰⣿⡇⠀⠀⠀⠀⢸⡇⠀
⠀⠀⠘⣿⣆⠀⠀⢀⣼⣿⡟⠁⠈⠻⣿⣿⣄⠀⠀⢠⣾⡟⠀⠀⠀⠀⠀⢸⡇⠀
⠀⠀⠀⠘⢿⣷⣶⣿⣿⡟⠀⠀⠀⠀⠘⣿⣿⣷⣶⣿⠏⠀⠀⠀⠀⠀⠀⢸⡇⠀
⠀⠀⠀⠀⠀⠉⠻⢿⣿⣷⣤⣤⣤⣤⣴⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠀⠀
⠀⠀⠀⠀⠀⣀⣤⣴⠶⠶⠶⠷⠶⠶⢶⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⢠⡿⠀⠀⠀
⠀⢀⣠⡶⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠳⢶⣤⣄⣀⣴⠟⠁⠀⠀⠀
⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀


Movie Reviews Data Analysis 

README

**Introduction**

In this project, we embarked on a comprehensive analysis of a movie reviews dataset. We meticulously worked on data preprocessing, analysis, and visualization to prepare the data for training predictive models. This README provides a brief synopsis of the methodologies implemented and the outputs generated during the process.
Process Overview

   **Data Preprocessing** and Grouping: In the initial stages, the dataset underwent a cleaning process where the data was grouped by critic names to identify and filter out critics with less than 10 reviews, considering them as insignificant for the analysis. Meanwhile, critics with 10 or more reviews were earmarked for further analysis.

   **Data Visualization** : Post data preprocessing, we engaged in data visualization, where we plotted graphs to observe trends in both the removed and remaining critics' datasets. The visualization enabled us to notice normalization trends and further understand the relationship between the number of reviews and the scores assigned.

    **Top Reviewers Identification** : Following visualization, we identified the top 100 reviewers based on the number of reviews they contributed. This step enabled us to create a robust dataset comprising only the critiques from the best reviewers, setting a reliable ground for the subsequent analysis.

    **Data Normalization** : In this phase, the scores for each critic were normalized by calculating the mean and standard deviation of their respective scores. This normalization was instrumental in eliminating potential bias that might have arisen due to individual critic tendencies.

    **Normalized Data Analysis** : The normalized data was then analyzed, correlating the number of reviews with normalized scores. This analysis unearthed interesting patterns and potential areas for focused studies, particularly looking into reviews with unusually low normalized scores.

**Output Files**
    remaining_critics.csv: This file consists of the data concerning critics who have posted 10 or more reviews. It includes an average numeric score for each critic, helping to normalize the data.

    removed_critics.csv: This file archives data of the removed critics - those who have less than 10 reviews. It serves as a reference to understand the trends and insights derived from critics with fewer reviews.

    top_reviewers_data.csv: This file contains the filtered data of the top 100 reviewers, curated based on the number of reviews they have contributed, and devoid of any empty scores or missing critic names.

    top_critic_counts.csv: This output file collates information regarding the number of reviews each top critic has contributed, forming a basis for further analysis and visualization efforts.

**Conclusion**

Through this initiative, we have successfully refined our dataset to include reviews from the most reliable and prolific critics, preparing a solid foundation for subsequent predictive model training. The normalization process and data visualization have enabled a deeper understanding of the trends and patterns within the movie reviews dataset, paving the way for insightful explorations in the next steps of the project.
