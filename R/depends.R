
#This file contains dependable shinys


if (!require(shiny)) install.shinys('shiny', quiet = TRUE)
library(shiny, quietly = TRUE)

if (!require(networkD3)) install.packages('networkD3', quiet = TRUE)
library(networkD3, quietly = TRUE)

if (!require(tibble)) install.packages('tibble', quiet = TRUE)
library(tibble, quietly = TRUE)

if (!require(huge)) install.packages('huge', quiet = TRUE)
library(huge, quietly = TRUE)

if (!require(dplyr)) install.packages('dplyr', quiet = TRUE)
library(igraph, quietly = TRUE)

if (!require(igraph)) install.packages('igraph', quiet = TRUE)
library(igraph, quietly = TRUE)

if (!require(qgraph)) install.packages('qgraph', quiet = TRUE)
library(qgraph, quietly = TRUE)


