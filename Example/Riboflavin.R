library(devtools)
#===============================================================================
# Riboflavin data
#===============================================================================
install.packages("hdi")
library(hdi)
data("riboflavin")
dim(riboflavin)
dim(riboflavin$x)
library(RColorBrewer)
library(grDevices)
library(viridis)
vars <- var(riboflavin$x)
vars <- diag((vars))
vars_ord <- order(vars,decreasing = T )
# only considering the 100 high variance variables
data_R <- riboflavin$x[,c(sort(vars_ord[c(1:100)],decreasing = F )) ]
data_R <- cbind(riboflavin$y, data_R) # including the riboflavin production

data_R <- huge::huge.npn(data_R)

n <- dim(data_R)[1]
p <- dim(data_R)[2]
#===============================================================================
library(GIViT)
library(networkD3)
library(tibble)

app <- GIViT::glasso_manual(data = data_R)
shiny::runApp(app)
