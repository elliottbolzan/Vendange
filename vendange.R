# Obtain Data

wine_data <- read.csv("https://xdataset.s3.amazonaws.com/production/dataset/97/source/Wine_Dataset_V3.csv", na.strings = "", stringsAsFactors = F)
wine_data <- wine_data[c("Final.Price", "Rating.Name", "Rating.Score")]
wine_data <- wine_data[!is.na(wine_data$Rating.Name),]
wine_data$Final.Price <- as.double(gsub('\\$', '', wine_data$Final.Price))

# Retain Best Data

critics <- split(wine_data, f = wine_data$Rating.Name)
critics <- Filter(function(x) {sd(x$Rating.Score) != 0}, critics)

# Calculate Correlations

correlations <- lapply(critics, function(x) cor(x$Final.Price, x$Rating.Score))
correlations<- correlations[order(-unlist(correlations))]

# Change List to Data Frame

results <- do.call(rbind.data.frame, correlations)
results$critic <- rownames(results)

# Fix Row Names

rownames(results) <- NULL
names(results)[1] <- "correlation"

# Change Critic Names (http://www.wine.com/v6/aboutwine/wineratings.aspx?ArticleTypeId=2)

results$critic[results$critic == "JS"] <- "James Suckling"
results$critic[results$critic == "ST"] <- "Stephen  Tanzer"
results$critic[results$critic == "TP"] <- "The Tasting Panel"
results$critic[results$critic == "WE"] <- "Wine Enthusiast"
results$critic[results$critic == "RP"] <- "Robert Parker"
results$critic[results$critic == "D"] <- "Decanter"
results$critic[results$critic == "JH"] <- "James Halliday"
results$critic[results$critic == "V"] <- "Antonio Galloni"
results$critic[results$critic == "WS"] <- "Wine Spectator"
results$critic[results$critic == "W&S"] <- "Wine & Spirits"
results$critic[results$critic == "WW"] <- "Wilfred Wong"

# Export Plot

png("vendange.png", width = 4, height = 4, units="in", res = 300)
par(mar = c(3, 7, 1, 2))
barplot(results$correlation, col = gray.colors(11), names.arg = results$critic, horiz = T, xlim = c(0, 1), las = 1, cex.names = 0.8)
dev.off()
