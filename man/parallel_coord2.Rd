% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parallel_coord.R
\name{parallel_coord2}
\alias{parallel_coord2}
\title{Parallel Coordinates Plot (configurations)}
\usage{
parallel_coord2(
  configurations,
  parameters,
  param_names = parameters$names,
  by_n_param = NULL,
  file_name = NULL
)
}
\arguments{
\item{configurations}{Data frame, configurations in irace format 
(example: configurations = iraceResults$allConfigurations)}

\item{parameters}{List, parameter object in irace format
(example: configurations = iraceResults$parameters)}

\item{param_names}{String vector, names of the parameters that should be included in the plot
(example: param_names = c("algorithm","alpha","rho","q0","rasrank"))}

\item{by_n_param}{Numeric (optional), maximum number of parameters to be displayed}

\item{file_name}{String, file name to save plot (example: "~/patch/example/file_name.png"). 
Orca is required. See more details in: https://github.com/plotly/orca}
}
\value{
parallel coordinates plot
}
\description{
The `parallel_coord2` function creates a parallel coordinates plot of a set of 
provided configurations. Each line in the plot represents a configuration. 

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
parallel_coord2(iraceResults$allConfigurations[iraceResults$iterationElites,], iraceResults$parameters)
parallel_coord2(iraceResults$allConfigurations[iraceResults$iterationElites,], iraceResults$parameters, param_names = c("algorithm", "alpha", "rho", "q0", "rasrank"))
parallel_coord2(iraceResults$allConfigurations[iraceResults$iterationElites,], iraceResults$parameters, by_n_param = 5)
}
