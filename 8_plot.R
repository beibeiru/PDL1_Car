library(ggplot2)

comb <- read.csv("combined_all_results.txt", header = FALSE, stringsAsFactors = FALSE)

# Extract gene name before first underscore
comb$V3 <- sapply(strsplit(comb$V1, "_"), `[`, 1)
comb$V4 <- sapply(strsplit(comb$V1, "_"), `[`, 2)
comb$V4 <- sapply(strsplit(comb$V4, "@"), `[`, 1)
comb$V5 <- sapply(strsplit(comb$V1, "@"), `[`, 2)
comb$V6 <- substr(comb$V5, 1, 1)

comb <- comb[!comb$V3%in%c("exampleALBU","exampleLACB"),]

# Rename columns for clarity (optional)
colnames(comb) <- c("Full_ID", "Prediction", "Gene", "Uniprot", "Position", "AA")

# View first few rows
head(comb)

write.csv(comb,"combined_all_results.csv",quote=F)


comb$Prediction <- as.numeric(comb$Prediction)

library(dplyr)

protein_scores <- comb %>%
  group_by(Gene) %>%
  summarise(
    Mean_Score = mean(Prediction),
    Sum_Score = sum(Prediction),
    Max_Score = max(Prediction),
    #High_Risk_Count_0.2 = sum(Prediction > 0.2),
    Total_Sites = n()
  )

library(tidyr)  # for pivot_longer

# Assuming 'protein_scores' is already created as before

# Reshape data to long format for faceting
protein_scores_long <- protein_scores %>%
  pivot_longer(cols = c(Mean_Score, Sum_Score, Max_Score, Total_Sites),
               names_to = "Metric", values_to = "Value")

# Create bar plot with facets
p <- ggplot(protein_scores_long, aes(x = Gene, y = Value, fill = Metric)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Metric, scales = "free_y", ncol = 1) +  # one facet per metric
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  xlab("Gene") + ylab("Value") +
  ggtitle("Protein Carbonylation Scores")

ggsave(paste0("Comb.png"), p, width = 10, height = 15, dpi=200, units = "cm", limitsize = FALSE)


protein_scores_long <- comb %>%
  group_by(Gene, AA) %>%
  summarise(
    Mean_Score = mean(Prediction),
    Sum_Score = sum(Prediction),
    Max_Score = max(Prediction),
    Total_Sites = n(),
    .groups = 'drop'
  ) %>%
  pivot_longer(cols = c(Mean_Score, Sum_Score, Max_Score, Total_Sites),
               names_to = "Metric", values_to = "Value")

# Plot: Facet by Metric (vertical) and AA (horizontal)
p <- ggplot(protein_scores_long, aes(x = Gene, y = Value, fill = Metric)) +
  geom_bar(stat = "identity") +
  facet_grid(Metric ~ AA, scales = "free_y") +  # Rows = Metric, Columns = AA
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  xlab("Gene") + ylab("Value") +
  ggtitle("Protein Carbonylation Scores by Amino Acid")
  
ggsave(paste0("Single.png"), p, width = 30, height = 15, dpi=200, units = "cm", limitsize = FALSE)
  