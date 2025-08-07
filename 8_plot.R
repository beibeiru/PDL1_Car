library(ggplot2)

comb <- read.csv("combined_all_results.txt", header = FALSE, stringsAsFactors = FALSE)

# Extract gene name before first underscore
comb$V3 <- sapply(strsplit(comb$V1, "_"), `[`, 1)
comb$V4 <- sapply(strsplit(comb$V1, "_"), `[`, 2)
comb$V4 <- sapply(strsplit(comb$V4, "@"), `[`, 1)
comb$V5 <- sapply(strsplit(comb$V1, "@"), `[`, 2)
comb$V6 <- substr(comb$V5, 1, 1)
comb$V5 <- substring(comb$V5, 2)
comb$V7 <- "other"

comb <- comb[!comb$V3%in%c("exampleALBU","exampleLACB","VISTA"),]

# Rename columns for clarity (optional)
colnames(comb) <- c("Full_ID", "Prediction", "Gene", "Uniprot", "Position", "AA", "Domain")
comb$Position <- as.numeric(comb$Position)
comb$Prediction <- as.numeric(comb$Prediction)

# View first few rows
head(comb)





anno <- read.csv("Cytoplasmic.txt", header = FALSE, stringsAsFactors = FALSE)
anno$Gene <- sapply(strsplit(anno$V1, "_"), `[`, 1)
anno$Uniprot <- sapply(strsplit(anno$V1, "_"), `[`, 2)
anno$V6 <- sapply(strsplit(anno$V2, "-"), `[`, 1)
anno$V7 <- sapply(strsplit(anno$V2, "-"), `[`, 2)
anno$V8 <- sapply(strsplit(anno$V3, "-"), `[`, 1)
anno$V9 <- sapply(strsplit(anno$V3, "-"), `[`, 2)

anno$V6 <- as.numeric(anno$V6)
anno$V7 <- as.numeric(anno$V7)
anno$V8 <- as.numeric(anno$V8)
anno$V9 <- as.numeric(anno$V9)



for(i in unique(comb[,"Uniprot"]))
{
	leftAA <- anno[anno[,"Uniprot"]==i,"V6"]
	rightAA <- anno[anno[,"Uniprot"]==i,"V7"]

	comb[
		comb[,"Uniprot"]==i&
		comb[,"Position"]>=leftAA&
		comb[,"Position"]<=rightAA,
		"Domain"] <- "Cytoplasmic"

	leftAA <- anno[anno[,"Uniprot"]==i,"V8"]
	rightAA <- anno[anno[,"Uniprot"]==i,"V9"]

	comb[
		comb[,"Uniprot"]==i&
		comb[,"Position"]>=leftAA&
		comb[,"Position"]<=rightAA,
		"Domain"] <- "Transmembrane"
}

comb[comb[,"Domain"]%in%c("Cytoplasmic","Transmembrane"),]

write.csv(comb,"combined_all_results.csv",quote=F)



for(j in c("Complete","CytoplasmicAndTransmembrane","Cytoplasmic"))
{
	if(j=="CytoplasmicAndTransmembrane")
	{
		comb <- comb[comb[,"Domain"]%in%c("Cytoplasmic","Transmembrane"),]
	}
	if(j=="Cytoplasmic")
	{
		comb <- comb[comb[,"Domain"]=="Cytoplasmic",]
	}
	
	
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
	  theme(panel.grid = element_blank(),
		  panel.background = element_blank(),
		  axis.text.x = element_text(angle = 45, hjust = 1),
	        legend.position = "none") +
	  xlab("Gene") + ylab("Value") +
	  ggtitle("Protein Carbonylation Scores")
	
	ggsave(paste0("bar_",j,"_Comb.png"), p, width = 10, height = 15, dpi=200, units = "cm", limitsize = FALSE)
	
	
	# Create scatter plot
	library(ggrepel)
	p <- ggplot(protein_scores, aes(x = Mean_Score, y = Sum_Score, label=Gene)) +
	  geom_point(color="brown") +
	  geom_text_repel(max.overlaps=20)+
	  theme_bw() +
	  theme(panel.grid = element_blank(),
		  panel.background = element_blank(),
	        legend.position = "none") +
	  ggtitle(" ")
	
	ggsave(paste0("scatter_",j,"_Mean_Sum_Comb.pdf"), p, width = 10, height = 10, units = "cm")
	
	# Create scatter plot
	library(ggrepel)
	p <- ggplot(protein_scores, aes(x = Mean_Score, y = Max_Score, label=Gene)) +
	  geom_point(color="purple") +
	  geom_text_repel(max.overlaps=20)+
	  theme_bw() +
	  theme(panel.grid = element_blank(),
		  panel.background = element_blank(),
	        legend.position = "none") +
	  ggtitle(" ")
	
	ggsave(paste0("scatter_",j,"_Mean_Max_Comb.pdf"), p, width = 10, height = 10, units = "cm")
	
	
	
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
	  theme(panel.grid = element_blank(),
		  panel.background = element_blank(),
		  axis.text.x = element_text(angle = 45, hjust = 1),
	        legend.position = "none") +
	  xlab("Gene") + ylab("Value") +
	  ggtitle("Protein Carbonylation Scores by Amino Acid")
	  
	ggsave(paste0("bar_",j,"_Single.png"), p, width = 30, height = 15, dpi=200, units = "cm", limitsize = FALSE)


}