% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sampling_frequency_iteration.R
\name{sampling_frequency_iteration}
\alias{sampling_frequency_iteration}
\title{Frequency and Density plot based on its iteration}
\usage{
sampling_frequency_iteration(irace_results, parameter, file_name = NULL)
}
\arguments{
\item{irace_results}{The data generated when loading the \code{Rdata} file created by \code{irace}}

\item{parameter}{String, value of the parameter to be analyzed (example: parameter = "algorithm")}

\item{file_name}{String, A pdf will be created in the location and with the assigned
name (example: "~/patch/example/file_name")}
}
\value{
bar plot
}
\description{
The function will return a frequency plot used
for categorical data (its values are string, show a bar plot) or
numeric data (show a histogram and density plot) by each iteration
}
\examples{
sampling_frequency_iteration(iraceResults,parameter = "alpha")

}
