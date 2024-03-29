% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parallel_coord.R
\name{parallel_coord}
\alias{parallel_coord}
\title{Parallel Coordinates Plot}
\usage{
parallel_coord(
  irace_results,
  id_configuration = NULL,
  param_names = NULL,
  iterations = NULL,
  only_elite = TRUE,
  by_n_param = NULL,
  file_name = NULL
)
}
\arguments{
\item{irace_results}{The data generated when loading the \code{Rdata} file created by \code{irace}}

\item{id_configuration}{Numeric vector, configurations ids whose performance should be included in the plot
(example: id_configuration = c(20,50,100,300,500,600,700))}

\item{param_names}{String vector, names of the parameters that should be included in the plot
(example: param_names = c("algorithm","alpha","rho","q0","rasrank"))}

\item{iterations}{Numeric vector, iteration number that should be included in the plot
(example: iterations = c(1,4,5))}

\item{only_elite}{logical (default TRUE), only print elite configurations (argument ignored when 
id_configuration is provided)}

\item{by_n_param}{Numeric (optional), maximum number of parameters to be displayed.}

\item{file_name}{String, file name to save plot (example: "~/patch/example/file_name.png"). 
Orca is required. See more details in: https://github.com/plotly/orca.}
}
\value{
parallel coordinates plot
}
\description{
The `parallel_coord` function creates a parallel coordinates plot of a set of 
selected configurations. Each line in the plot represents a configuration. By
default, the final elite configurations are shown. To visualize configurations 
of other iterations these must be provided setting the argument
iterations, configurations of different iterations are shown in different 
colors. Setting the only_elites argument to FALSE allows to display all 
configurations in the selected iterations, specific configurations can
be selected providing their ids in the id_configuration argument. 

The parameters to be included in the plot can be selected with the param_names
argument. Additionally, the maximum number of parameters to be displayed in one
plot. A list of plots is returned by this function in several plots are required
to display the selected data.

To export the plot to a file, it is possible to do it so manually using the
functionality provided by plotly in the plot. If a file_name is provided,  
orca server will be used to export the plots and thus, it requires the library
to be installed (https://github.com/plotly/orca).
}
\examples{
parallel_coord(iraceResults)
parallel_coord(iraceResults, by_n_param = 5)
parallel_coord(iraceResults, only_elite = FALSE)
parallel_coord(iraceResults, id_configuration = c(20, 50, 100, 300, 500, 600, 700))
parallel_coord(iraceResults, param_names = c("algorithm", "alpha", "rho", "q0", "rasrank"))
parallel_coord(iraceResults, iterations = c(1, 4, 6))
}
