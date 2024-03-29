% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parallel_cat.R
\name{parallel_cat}
\alias{parallel_cat}
\title{Parallel Coordinates Category}
\usage{
parallel_cat(
  irace_results,
  id_configurations = NULL,
  param_names = NULL,
  iterations = NULL,
  by_n_param = NULL,
  n_bins = 3,
  file_name = NULL
)
}
\arguments{
\item{irace_results}{The data generated when loading the \code{Rdata} file created by \code{irace}}

\item{id_configurations}{Numeric vector, configuration ids to be included in the plot
(example: id_configurations = c(20,50,100,300,500,600,700))}

\item{param_names}{String vector, parameters to be included in the plot
(example: param_names = c("algorithm","alpha","rho","q0","rasrank"))}

\item{iterations}{Numeric vector, iterations from which configuration should be obtained
(example: iterations = c(1,4,5))}

\item{by_n_param}{Numeric (optional), maximum number of parameters to be displayed.}

\item{n_bins}{Numeric (default 3), number of intervals to generate for numerical parameters.}

\item{file_name}{String, file name to save plot (example: "~/path/to/file_name.png")}
}
\value{
parallel categories plot
}
\description{
The `parallel_cat` function creates a parallel categories plot of a set of 
selected configurations. Numerical parameters are discretized to maximum n_bins 
intervals. To visualize configurations of other iterations these must be 
provided setting the argument iterations, groups of configurations of different 
iterations are shown in different colors. Specific configurations can be 
selected providing their ids in the id_configurations argument.

The parameters to be included in the plot can be selected with the param_names
argument. Additionally, the maximum number of parameters to be displayed in one
plot. A list of plots is returned by this function in several plots are required
to display the selected data.
}
\examples{
parallel_cat(iraceResults)
parallel_cat(iraceResults, by_n_param = 6)
parallel_cat(iraceResults, id_configurations = c(20, 50, 100, 300, 500, 600, 700))
parallel_cat(iraceResults, param_names = c("algorithm", "alpha", "rho", "q0", "rasrank"))
parallel_cat(iraceResults, iterations = c(1, 4, 6), n_bins=4)
}
