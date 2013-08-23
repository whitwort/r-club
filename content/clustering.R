LiCl <- read.delim("data/LiCl.txt")

rownames(LiCl) <- LiCl$NAME
head(LiCl)

m.LiCl <- as.matrix( na.omit(LiCl) ) 

d <- dist(m.LiCl, method = "euclidean")
fit <- hclust(d, method="ward")
plot(fit)

heatmap(m.LiCl)

install.packages("gplots")
library(gplots)

heatmap(m.LiCl, col=colorpanel(100,"royalblue3","black","yellow"))

heatmap(m.LiCl, col=colorpanel(100,"royalblue3","black","yellow"), Colv=NA)

heatmap(m.LiCl, col=colorpanel(100,"royalblue3","black","yellow"), Colv=NA, zlim=c(-2.5,2.5))

heatmap(m.LiCl, col=colorpanel(100,"royalblue3","black","yellow"), Colv=NA
      , RowSideColors = ifelse( grepl("protein biosynthesis", rownames(m.LiCl)), "darkgrey", "white"), labRow=c(""), labCol=c(""))

groups <- cutree(fit, k=3)
plot(fit)
rect.hclust(fit, k=5, border="red")
?kmeans