




#' General_selection
#'
#' This function takes a user selected set of variables,
#' e.g. regularization parameter, and displays the resulting
#' graph in a interactive manner.
#' User has to provide both corresponding graph and their
#' variables.
#' For now, it only accepts solution paths that are in "results[[index]]$path[[1]]" format
#' user should make sure that their solution path is formated this way.
#' @param 'data' dataframe of used data.
#' @param 'solution_space' a matrix of the solution space.
#' @param adjadency_list List of adjacency matrices. Dim. must correspond to the nrow of parameters
General_selection <- function(data, solution_space, results, output_file = "./Selected_Solution.RData"){

  # number of columns and rows in data
  n <- nrow(data)
  p <- ncol(data)


  # Check if names given to the solution_space
  if(is.null(colnames(solution_space))){
    param_names <- c(1:ncol(solution_space))
  }else{
    param_names <- colnames(solution_space)
  }

  find_coordinates <- function(solution_space, target){

    conditions_met <- rep(TRUE, nrow(solution_space))

    for(col_name in names(target)){
      if(col_name %in% names(solution_space)) {
        conditions_met <- (conditions_met & unlist(solution_space[col_name]) == unlist(target[col_name]))
      } else {
        stop(paste("Column", col_name, "not found", sep = " "))
      }
    }
    coordinates <- which(conditions_met)
    return(coordinates)
  }


  # Function to convert adjacency-matrix to a tibble format for shiny
  adjacency_to_tibble <- function(adj_matrix) {
    if (sum(adj_matrix) == 0) {
      edge_list <- tibble(from = integer(0), to = integer(0)) # Tyhjä edge-lista
    } else {
      edges <- which(adj_matrix == 1, arr.ind = TRUE)
      edge_list <- tibble(from = edges[, 1] - 1, to = edges[, 2] - 1) # Muunna 0-indeksointiin
    }
    return(edge_list)
  }

  # Function to check if node names given in data
  NodeID_identity <- function(data){
    if(is.null(colnames(data))){
      # Use the variable numbers as nodeID
      return(data.frame(NodeID = 0:(p-1)))
    }else{
      return(data.frame(NodeID = colnames(data)))
    }
  }

  nodes <- NodeID_identity(data)

  # Create Shiny-application
  ui <- fluidPage(
    titlePanel("Generalized selection"),
    sidebarLayout(
      sidebarPanel(
        # Dynamically create inputs for all parameters
        lapply(param_names, function(par) { #lapply() applies the function from a vector of parameter names
          par_in_question <- solution_space[, par]
          unique_values <- unique.default(par_in_question)
          if (length(unique_values) < 3) {
            # Use radio buttons for fewer than 3 unique solutions
            radioButtons(
              inputId = par,
              label = par,
              choices = unique_values,
              selected = unique_values[1]  # Default choice
            )
          } else {
            # Use slider input for 3 or more unique solutions
            sliderInput(
              inputId = par,
              label = par,
              min = min(par_in_question, na.rm = TRUE),
              max = max(par_in_question, na.rm = TRUE),
              step = diff(sort(unique(par_in_question)))[1],  # Valid step size
              value = mean(par_in_question, na.rm = TRUE)  # Default value
            )
          }
        }),
        actionButton("saveButton", "Save choice")
      ),
      mainPanel(
        forceNetworkOutput("network")
      )
    )
  )


  server <- function(input, output, session) {
    # Reactive expression to collect inputs
    target <- reactive({
      # Dynamically collect all user inputs based on param_names
      sapply(param_names, function(par) input[[par]], simplify = TRUE, USE.NAMES = TRUE)
    })


    edges <- reactive({
      user_inputs <- target()  # Collect all user inputs as a named vector

      # Convert user_inputs into the proper format for find_coordinates
      target_matrix <- as.data.frame(t(user_inputs))  # Transpose to match matrix format
      colnames(target_matrix) <- names(user_inputs)  # Assign names as column he

      index <- find_coordinates(solution_space, target_matrix)
      adj_matrix <- as.matrix(results[[index]]$path[[1]]) # CHANGE HERE  YOUR OWN SOLUTION PATH.
      adjacency_to_tibble(adj_matrix)
    })

    output$network <- renderForceNetwork({
      links <- as.data.frame(edges())
      if (nrow(links) == 0) {
        links <- data.frame(matrix(0, nrow = p, ncol = 2)) # Create an empty edge-list.
        colnames(links) <- c("from", "to")
      }
      forceNetwork(
        Links = links,
        Nodes = nodes,
        Group = 1,
        Source = "from",
        Target = "to",
        NodeID = "NodeID",
        opacity = 0.8,
        zoom = TRUE
      )
    })

    observeEvent(input$saveButton, {
      user_inputs <- target()  # Collect all user inputs as a named vector

      # Convert user_inputs into the proper format for find_coordinates
      target_matrix <- as.data.frame(t(user_inputs))  # Transpose to match matrix format
      colnames(target_matrix) <- names(user_inputs)  # Assign names as column he

      save(target_matrix, file = output_file)
      stopApp()  # Stop Shiny-application after model is saved
    })
  }

  return(list(ui = ui, server = server))
}

