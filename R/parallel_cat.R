#' Parallel Coordinates Category
#'
#' @description
#' 
#' The `parallel_cat` function creates a parallel categories plot of a set of 
#' selected configurations. Numerical parameters are discretized to maximum n_bins 
#' intervals. To visualize configurations of other iterations these must be 
#' provided setting the argument iterations, groups of configurations of different 
#' iterations are shown in different colors. Specific configurations can be 
#' selected providing their ids in the id_configurations argument.
#' 
#' The parameters to be included in the plot can be selected with the param_names
#' argument. Additionally, the maximum number of parameters to be displayed in one
#' plot. A list of plots is returned by this function in several plots are required
#' to display the selected data.
#' 
#'
#' @template arg_irace_results
#'
#' @param id_configurations
#' Numeric vector, configuration ids to be included in the plot
#' (example: id_configurations = c(20,50,100,300,500,600,700))
#'
#' @param param_names
#' String vector, parameters to be included in the plot
#' (example: param_names = c("algorithm","alpha","rho","q0","rasrank"))
#'
#' @param iterations
#' Numeric vector, iterations from which configuration should be obtained
#' (example: iterations = c(1,4,5))
#' 
#' @param by_n_param
#' Numeric (optional), maximum number of parameters to be displayed.
#' 
#' @param n_bins
#' Numeric (default 3), number of intervals to generate for numerical parameters.
#'
#' @param file_name
#' String, file name to save plot (example: "~/path/to/file_name.png")
#'
#' @return parallel categories plot
#' @export
#'
#' @examples
#' parallel_cat(iraceResults)
#' parallel_cat(iraceResults, by_n_param = 6)
#' parallel_cat(iraceResults, id_configurations = c(20, 50, 100, 300, 500, 600, 700))
#' parallel_cat(iraceResults, param_names = c("algorithm", "alpha", "rho", "q0", "rasrank"))
#' parallel_cat(iraceResults, iterations = c(1, 4, 6), n_bins=4)
parallel_cat <- function(irace_results, id_configurations = NULL, param_names = NULL, 
                         iterations = NULL,  by_n_param = NULL, n_bins=3, file_name = NULL) {

  # Variable assignment
  configuration <- dim <- tickV <- vectorP <- x <- y <- id <- freq <- NULL
  id_configurations <- unlist(id_configurations)
  
  # Parameters to be included
  if (is.null(param_names))
    param_names <- irace_results$parameters$names
  else
    param_names <- unlist(param_names)
  
  # Check parameter values
  if (any(!(param_names %in% irace_results$parameters$names))) {
    cat("Error: Unknown parameter names were encountered\n")
    stop()
    # verify that param_names contain more than one parameter
  } else if (length(param_names) < 2) {
    cat("Error: Data must have at least two parameters\n")
    stop()
  }
  
  # Check by_n_param
  if (is.null(by_n_param)) 
    by_n_param <- length(param_names)
  if (!is.numeric(by_n_param)){
    cat("Error: argument by_n_param must be numeric\n")
    stop()
  } else if (by_n_param < 2) {
    cat("Error: argument by_n_param must > 1\n")
    stop()
  }
  by_n_param <- min(length(param_names), by_n_param)
  
  # Check iterations
  if (!is.null(iterations)) {
    if (any(!(iterations %in% 1:length(irace_results$allElites)))) {
      cat("Error: The interactions entered are outside the possible range\n")
      stop()
    }
  } else {
    iterations <- 1:length(irace_results$allElites)
  }
  
  # Check configurations
  if (!is.null(id_configurations)) {
    # Verify that the entered id are within the possible range
    if (any(id_configurations[id_configurations < 1]) || any(id_configurations[id_configurations > nrow(irace_results$allConfigurations)])) {
      cat("Error: IDs provided are outside the range of settings\n")
      stop()
    }
    # Verify that the id entered are more than 1 or less than the possible total
    if (length(id_configurations) <= 1 || length(id_configurations) > nrow(irace_results$allConfigurations)) {
      cat("Error: You must provide more than one configuration id\n")
      stop()
    }
    iterations <- 1:length(irace_results$allElites)
  } else {
    id_configurations <- unique(irace_results$experimentLog[irace_results$experimentLog[,"iteration"] %in% iterations, "configuration"])
  }

  if (!is.numeric(n_bins) || n_bins < 1) {
    cat("Error: n_bins must be numeric > 0")
    stop()
  }
  
  # Select data 
  tabla <- irace_results$allConfigurations[irace_results$allConfigurations[, ".ID."] %in% id_configurations, ]
  filtro <- unique(irace_results$experimentLog[, c("iteration", "configuration")])
  filtro <- filtro[filtro[, "configuration"] %in% id_configurations, ]
  filtro <- filtro[filtro[, "iteration"] %in% iterations, ]
  
  # Merge iteration and configuration data
  colnames(filtro)[colnames(filtro) == "configuration"] <- ".ID."
  tabla <- merge(filtro, tabla, by=".ID.")
  
  # adding discretization for numerical variables and replace NA values 
  # FIXME: Add proper ordering for each axis
  # FIXME: add number of bins as an argument (maybe a list?)
  for (pname in irace_results$parameters$names) {
    n_bins_param <- n_bins
    if (irace_results$parameters$types[pname] %in% c("i", "r", "i,log", "r,log")) {
      not.na <- !is.na(tabla[,pname])
      u_data <- unique(tabla[not.na, pname])
      if (length(u_data) >= n_bins_param) {
        snot.na <- sum(not.na) 
        if(snot.na < nrow(tabla)) {
          n_bins_param <- max(n_bins - 1, 1)
          if (snot.na < nrow(tabla)/3)
            n_bins_param <- 2
        }
        val  <- tabla[not.na, pname]
        bb <- seq(irace_results$parameters$domain[[pname]][1], 
                  irace_results$parameters$domain[[pname]][2], 
                  length.out=(n_bins_param+1))
        if (irace_results$parameters$types[pname] %in% c("i", "i,log"))
          bb <- round(bb)
        #quartile based ranges
        #val  <- c(irace_results$parameters$domain[[pname]], tabla[not.na, pname])
        #bb   <- unique(c(quantile(val, probs=seq(0,1, by=1/n_bins_param))))
        #bins <- as.character(bins[3:length(bins)],scientific = F)
        bins <- cut(val, breaks=bb, include.lowest = TRUE, ordered_result=TRUE)
        bins <- as.character(bins)
        tabla[not.na, pname] <- bins
      } 
    }

    # replace NA values
    rna <- is.na(tabla[,pname])
    if (any(rna)) {
      tabla[rna,pname] <- "NA"
    }
    tabla[, pname] <- factor(tabla[, pname])
  }

  # Column .ID. and .PARENT. are removed
  tabla <- tabla[, !(colnames(tabla) %in% c(".ID.", ".PARENT."))]
  tabla$iteration <- factor(tabla$iteration, ordered=TRUE)
  
  n_parts <- ceiling(length(param_names) / by_n_param)
  start_i <- 1
  end_i <- by_n_param
  plot_list <- list()
  # Create plots
  for (i in 1:n_parts) {
    # stop if we reach the end
    if (end_i > length(param_names))
      break;
    
    # add las parameter as we cant  plot 
    # one parameter in the next plot
    if (length(param_names) == (end_i+1))
      end_i <- end_i + 1
    
    params <- param_names[start_i:end_i]
    ctabla <- tabla[,c(params, "iteration")]
    
    # Format data
    ctabla <- ctabla %>%
      group_by(ctabla[1:ncol(ctabla)]) %>%
      summarise(freq = n())# %>% filter(freq > 1)
    ctabla <- gather_set_data(ctabla, params)
    ctabla <- ctabla[ctabla$x != "iteration", ]
    
    # Create plot
    p <- ggplot(ctabla, aes(x, id = id, split = y, value = freq)) +
      geom_parallel_sets(aes(fill = iteration), alpha = 0.8, axis.width = 0.2) +
      geom_parallel_sets_axes(axis.width = 0.3, alpha = 0.4, color = "lightgrey", fill = "lightgrey") +
      geom_parallel_sets_labels(colour = "black", angle = 90, size = 3) +
      theme_bw() +
      theme(
        axis.text.x = element_text(angle = 90, size = 9),
        axis.title.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()
      )
    plot_list[[i]] <- p
    start_i <- start_i + by_n_param 
    end_i   <- min(end_i + by_n_param, length(param_names))
  }
  

  # If the value in file_name is added the pdf file is created
  if (!is.null(file_name)) {
    if (length(plot_list) == 1) {
      ggsave(file_name, plot = plot_list[[1]])
    } else {
      directory <- paste0(dirname(file_name), sep = "/")
      base_name = strsplit(basename(file_name),split = '[.]')[[1]][1]
      ext <- strsplit(basename(file_name),split = '[.]')[[1]][2]
      for (i in 1:length(plot_list)) {
        part <- paste0("-", i)
        ggsave(paste0(directory, "/", base_name, part,"." ,ext), plot = plot_list[[i]])
      }
    }
  } 
  
  if (length(plot_list) == 1)
    return(plot_list[[1]])
  return(plot_list)
}
