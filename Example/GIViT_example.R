

# In this file is presented a code were user can test their own
# ability to choose a regularization parameter for graphical LASSO
# Ran through the code and it will present a matrix with scores.


library(GIViT)
library(huge)

create_and_save_networks <- function(p, n, v = 0.3){
  if(!file.exists("./data")){
    dir.create("./data")
  }

  for (i in 1:20) {
    if (i >= 1 && i <= 4) {
      network <- huge.generator(n = n, d = p, graph = "hub", v = v)
    } else if (i >= 5 && i <= 9) {
      network <- huge.generator(n = n, d = p, graph = "cluster", v = v)
    } else if (i >= 10 && i <= 13) {
      network <- huge.generator(n = n, d = p, graph = "band", v = v)
    } else if (i >= 14 && i <= 17) {
      network <- huge.generator(n = n, d = p, graph = "scale-free", v = v)
    } else if (i >= 17 && i <= 20) {
      network <- huge.generator(n = n, d = p, graph = "random", prob = 0.05)
    }
    save(network, file = paste("./data/Network_", i, ".RData", sep = ""))
  }
}


p <- 100
n <- floor(0.75*p)
v = 0.5
create_and_save_networks(p = p, n = n, v = v)

set.seed(123456)
order <- sample(seq(1, 20), replace = FALSE)
dir.create("./Results")


for(i in order){
  og_url <- paste("data/Network_", i, ".Rdata", sep = "")
  load(og_url)
  file <- paste("./Results/manual_selection", i, ".Rdata", sep = "")
  app <- glasso_manual(data = network$data, file = file)
  shiny::runApp(app)
}

manual_score <- matrix(nrow = 20, ncol = 14)
for(i in 1:20){
  og_url <- paste("./data/Network_", i, ".Rdata", sep = "")
  load(og_url)
  load(paste("./Results/manual_selection",i,".RData",sep=""))
  cm <- GIViT:::conf_matrix(estimation = selected_solution, truth = network$theta )
  manual_score[i,1:14] <-  GIViT:::unpack_score_list(GIViT:::calculate_scores(cm))
}
colnames(manual_score) <- c("ACC", "ACC_bal", "MCC", "F1", "TPR", "TNR", "PPV", "NPV", "FPR", "FNR", "FDR", "FOR", "LRp", "LRn")
round(colMeans(manual_score),2)

