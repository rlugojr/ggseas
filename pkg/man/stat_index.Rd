% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stat_index.R
\name{stat_index}
\alias{stat_index}
\title{Index Stat}
\usage{
stat_index(mapping = NULL, data = NULL, geom = "line",
  position = "identity", show.legend = NA, inherit.aes = TRUE,
  index.ref = NULL, index.basis = 100, ...)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by \code{\link{aes}} or
\code{\link{aes_}}. If specified and \code{inherit.aes = TRUE} (the
default), it is combined with the default mapping at the top level of the
plot. You must supply \code{mapping} if there is no plot mapping.}

\item{data}{The data to be displayed in this layer. There are three
   options:

   If \code{NULL}, the default, the data is inherited from the plot
   data as specified in the call to \code{\link{ggplot}}.

   A \code{data.frame}, or other object, will override the plot
   data. All objects will be fortified to produce a data frame. See
   \code{\link{fortify}} for which variables will be created.

   A \code{function} will be called with a single argument,
   the plot data. The return value must be a \code{data.frame.}, and
   will be used as the layer data.}

\item{geom}{The geometric object to use display the data}

\item{position}{Position adjustment, either as a string, or the result of
a call to a position adjustment function.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link{borders}}.}

\item{index.ref}{if not NULL, a vector of integers indicating which elements of
the beginning of each series to use as a reference point for converting to an index.  
If NULL, no conversion takes place and the data are presented on the original scale.}

\item{index.basis}{if index.ref is not NULL, the basis point for converting
to an index, most commonly 100 or 1000.  See examples.}

\item{...}{other arguments for the geom}
}
\description{
Convert a time series from the original scale to an index for ggplot2
}
\examples{
ap_df <- tsdf(AirPassengers)

ggplot(ldeaths_df, aes(x = YearMon, y = deaths, color = sex)) +
   stat_index(index.ref = 1:12, index.basis = 1000) +
   ylab("Deaths index\\n(average of first 12 months = 1000")
   
}
\seealso{
Other time.series.stats.for.ggplot2: \code{\link{stat_decomp}},
  \code{\link{stat_rollapplyr}}, \code{\link{stat_seas}},
  \code{\link{stat_stl}}
}

