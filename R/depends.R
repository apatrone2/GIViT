
#This file contains dependable packages:
# shiny     # required for shiny-application
# networkD3 # force network and others for interactive visualization
# tibble    # used in shiny
# huge      # glasso solution path and other
# igraph    # walktrap
# qgraph    # clustercoefficents


if (!requireNamespace("shiny")) install.packages('shiny')
library(shiny, quietly = TRUE)

if (!requireNamespace("networkD3")) install.packages('networkD3')
library(networkD3, quietly = TRUE)

if (!requireNamespace("tibble")) install.packages('tibble')
library(tibble, quietly = TRUE)

if (!requireNamespace("huge")) install.packages('huge')
library(huge, quietly = TRUE)

if (!requireNamespace("igraph")) install.packages('igraph')
library(igraph, quietly = TRUE)

if (!requireNamespace("qgraph")) install.packages('qgraph')
library(qgraph, quietly = TRUE)









