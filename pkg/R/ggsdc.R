ggsdc_helper <- function(data, mapping, frequency, method, start, s.window, 
                         type = c("additive", "multiplicative")){
   data <- data[order(data[ , as.character(mapping$x)]), ]
   
   
   if(method == "decompose"){
      type <- match.arg(type)
      y <- ts(data[ , as.character(mapping$y)], frequency = frequency)
      model <- decompose(y, type = type)
      y2 <- as.numeric(model$trend)
      y3 <- as.numeric(model$seasonal)
      y4 <- as.numeric(model$random)
   }
   
   if(method == "stl"){
      if(is.null(s.window)){
         stop("A value is needed for s.window.  See ?stl for help.")
      }
      y <- ts(data[ , as.character(mapping$y)], frequency = frequency)
      model <- stl(y, s.window = s.window)
      y2 <- as.numeric(model$time.series[ , 2])
      y3 <- as.numeric(model$time.series[ , 1])
      y4 <- as.numeric(model$time.series[ , 3])
   }
   
   if(method == "seas"){
      # not sure this is robust enough. Is the residual always just multiplicative?
      y <- ts(data[ , as.character(mapping$y)], frequency = frequency, start = start)
      model <- seas(y)
      y2 <- series(model, "s12", reeval = FALSE)
      y3 <- series(model, "s10", reeval = FALSE)
      y4 <- y / y2 / y3
      
   }
   
   sdc <- rbind(
      data.frame(x = data[ , as.character(mapping$x)],
                 y = as.numeric(y),
                 component = factor("observed", 
                                    levels = c("observed", "trend", "seasonal", "random")))  ,
      data.frame(x = data[ , as.character(mapping$x)],
                 y = y2,
                 component = "trend",
                 stringsAsFactors = FALSE),
      data.frame(x = data[ , as.character(mapping$x)],
                 y = y3,
                 component = "seasonal",
                 stringsAsFactors = FALSE),
      data.frame(x = data[ , as.character(mapping$x)],
                 y = y4,
                 component = "random",
                 stringsAsFactors = FALSE)
   )
   
   return(sdc)
   
 
   
}

#' Visualise seasonal decomposition
#' 
#' Creates a standard plot of seasonal decomposition with four facets
#' 
#' @export
#' @import ggplot2
#' @param data dataset to use for plot.  
#' @param mapping List of aesthetic mappings.  Must include x and y, and optionally
#' can include colour/color 
#' @param frequency frequency of the period of the time series eg 12 = monthly
#' @param method function to use for performing the seasonal decomposition. stl
#' and decompose are functions in the \code{stats} package; \code{seas} is access
#' to the \code{seats} program from X-13-SEATS-ARIMA via the \code{seasonal} package
#' @param start starting time for the data; only needed if \code{method = 'seas'}.
#' @param s.window parameter to pass to \code{stl()}
#' @param type parameter to pass to \code{decompose()}
#' @seealso \code{\link{decompose}}, \code{\link{stl}}, \code{\link{seas}}
#' @details etc etc etc
#' @examples
#' print("hello world")
ggsdc <- function(data, mapping, frequency, method = c("stl", "decompose", "seas"),
                  start, s.window, 
                  type = c("additive", "multiplicative")) {
   # data = ldeaths_df; mapping = aes(x = YearMon, y = deaths, colour = sex)
   # frequency = 12; method = "decompose"; type = "multiplicative"; start = c(1949,1); s.window = 7
   # data = ap_df; mapping = aes(x = x, y = y)
   
   if(is.null(frequency)){
      stop("frequency is needed")
   }
   
   method <- match.arg(method)
   
   # Australian/British spelling please:
   names(mapping)[names(mapping) == "color"] <- "colour"
   
   if(!is.null(mapping$colour)){
      # Multivariate - a dimension mapped to colour
      
      # make a convenient vector of the variable mapped to colour
      cv <- data[ , as.character(mapping$colour)]
      all_cols <- unique(cv)
      for(this_col in all_cols){
         this_data <- data[cv == this_col, ]
         this_sdc <- ggsdc_helper(this_data, mapping, frequency, method, start, s.window, type)
         this_sdc$colour <- this_col
      
         if(exists("sdc")){
            sdc <- rbind(sdc, this_sdc)
         } else {
            sdc <- this_sdc
         }
      }
      
      p <- ggplot(sdc, aes(x = x, y = y, colour = colour)) +
         facet_wrap(~component, ncol = 1, scale = "free_y") 
      
      
   } else {
      # Univariate
      sdc <- ggsdc_helper(data, mapping, frequency, method, start, s.window, type)
      
      p <- ggplot(sdc, aes(x = x, y = y)) +
         facet_wrap(~component, ncol = 1, scale = "free_y") 
      
   }
   
   
   return(p)  
   
   
}