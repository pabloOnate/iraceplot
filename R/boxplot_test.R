#' Box Plot Testing
#'
#' @description
#' The function will return a box plot, using the data generated in the test
#' settings coloring the best configuration in each iteration
#'
#' @template arg_irace_results
#'
#' @param type
#' String, either "all", "ibest" or "best". By default it is "all" which shows all the configurations,
#' "best" shows the best configurations of each iteration and
#' "ibest" shows the configurations of the last iteration
#' @param rpd
#' Logical (default TRUE) to fit through an equation of minimum percentage distance between
#' the values of each row of all configurations
#' @param file_name
#' String, A pdf will be created in the location and with the assigned
#' name (example: "~/patch/example/file_name")
#' @return box plot
#' @export
#'
#' @examples
#' boxplot_test(iraceResults)
#' boxplot_test(iraceResults, type = "ibest")
#' boxplot_test(iraceResults, type = "best")
boxplot_test <- function(irace_results, type = "all", rpd = TRUE, file_name = NULL) {

  # verify that test this in irace_results
  if (!("testing" %in% names(irace_results))) {
    return("irace_results does not contain the testing data")
  }

  if (!(type == "all" | type == "best" | type == "ibest")) {
    print("The type parameter entered is incorrect")
  }

  ids <- performance <- v_allElites <- names_col <- best_conf <- ids_f <- iteration_f <- NULL
  # the table is created with all the data from testing experiments
  tabla <- as.data.frame(irace_results$testing$experiments)

  # the table values are modified
  if (rpd == TRUE) {
    tabla <- 100 * (tabla - apply(tabla, 1, min)) / apply(tabla, 1, min)
  }

  # all testing experiments settings
  if (type == "all") {
    for (j in 1:length(irace_results$allElites)) {
      v_allElites <- c(v_allElites, irace_results$allElites[[j]])
    }
    datos <- tabla[as.character(v_allElites)]

    # the last iteration of the elite settings
  } else if (type == "best") {
    num_it <- length(irace_results$allElites)
    v_allElites <- as.character(irace_results$allElites[[num_it]])
    datos <- tabla[v_allElites]

    # the best settings of each iteration
  } else if (type == "ibest") {
    v_allElites <- as.character(irace_results$iterationElites)
    datos <- tabla[v_allElites]
  } else {
    return("non existent type")
  }

  names_col <- colnames(datos)
  # the data is processed
  datos <- reshape(datos,
    varying = as.vector(colnames(datos)),
    v.names = "performance",
    timevar = "ids",
    times = as.vector(colnames(datos)),
    new.row.names = 1:(dim(datos)[1] * dim(datos)[2]),
    direction = "long"
  )

  # column iteration is added
  if (type == "all" || type == "ibest") {
    iteration <- sample(NA, size = dim(datos)[1], replace = TRUE)
    datos <- cbind(datos, iteration)

    if (type == "all") {
      a <- 1
      for (i in 1:length(irace_results$allElites)) {
        for (k in 1:length(irace_results$allElites[[i]])) {
          datos$iteration[datos$ids == names_col[a]] <- i
          a <- a + 1
        }
      }
    } else if (type == "ibest") {
      for (i in 1:length(unique(datos$ids))) {
        datos$iteration[datos$ids == unique(datos$ids)[i]] <- i
      }
    }

    datos$iteration_f <- factor(datos$iteration, levels = (unique(datos$iteration)))
  }

  for (k in 1:length(names_col)) {
    if (!(names_col[k] == as.character(v_allElites)[k])) {
      datos$ids[datos$ids == names_col[k]] <- as.character(v_allElites)[k]
    }
  }

  if (type == "all" || type == "best") {
    best_conf <- sample(NA, size = dim(datos)[1], replace = TRUE)
    datos <- cbind(datos, best_conf)
    if (type == "all") {
      for (i in 1:length(irace_results$allElites)) {
        datos$best_conf[datos$iteration == i & datos$ids == as.character(irace_results$iterationElites[i])] <- "best" # as.character(i)
      }
    } else {
      datos$best_conf[datos$ids == v_allElites[1]] <- "best" # as.character(1)
    }
  }

  datos$ids_f <- factor(datos$ids, levels = unique(datos$ids))

  # the box plot is created
  if (type == "best") {
    p <- ggplot(datos, aes(x = ids_f, y = performance, color = best_conf)) +
      scale_color_hue(h = c(220, 270))
  } else if (type == "ibest") {
    p <- ggplot(datos, aes(x = ids_f, y = performance, color = iteration_f)) +
      labs(subtitle = "iterations") +
      theme(plot.subtitle = element_text(hjust = 0.5))
  } else {
    p <- ggplot(datos, aes(x = ids_f, y = performance, colour = best_conf)) +
      labs(subtitle = "iterations") +
      theme(
        plot.subtitle = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 6.4, angle = 90)
      ) +
      scale_color_hue(h = c(220, 270))
  }

  p <- p +
    geom_boxplot() +
    theme(legend.position = "none") +
    labs(x = "ID", y = "Performance")

  # each box plot is divided by iteration
  if (type == "all" || type == "ibest") {
    p <- p + facet_grid(cols = vars(datos$iteration_f), scales = "free")
  }

  # If the value in file_name is added the pdf file is created
  if (!is.null(file_name)) {
    ggsave(file_name, plot = p)
    # If you do not add the value of file_name, the plot is displayed
  } else {
    p
    return(p)
  }
}
