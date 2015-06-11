#' Score the beard model
#' 
#' Simple model with one predictor \code{year}
#' 
#' @export
#' @importFrom forecast forecast
#' @param input data passed on as \code{h} to \code{\link{forecast}}
#' @examples 
#'    mydata <- data.frame(year=c(1921))
#'    beard(mydata)
beard <- function(input){
  #input can either be csv file or data	
  newdata <- if(is.character(input) && file.exists(input)){
    read.csv(input)
  } else {
    as.data.frame(input)
  }
  stopifnot("year" %in% names(newdata))
  # only 1 year at a time
  stopifnot(nrow(newdata) == 1)
  
  a <- 0
  b <- 100
  dat <- read.csv('./data/percent-of-men-with-full-beards.csv')
  dat <- head(dat, -1)
  y <- as.numeric(gsub('%','',dat[,2]))
  last_year <- max(as.numeric(dat[,1]))
  
  year <- as.numeric(newdata$year)
  
  prediction_type <- NA_character_
  
  if (year > last_year) {
    prediction_type <- 'FORECASTED'
    yearstoforecast <- year-last_year
    fc <- tail(as.numeric(forecast(beard_model, h=yearstoforecast)$mean),1)
    point_pred <- (b-a)*exp(fc)/(1+exp(fc)) + a
    result <- data.frame(year=year,prediction_type=prediction_type, prediction=point_pred)
  } else {
    prediction_type <- 'HISTORICAL'
    point_pred <- y[which(as.numeric(dat[,1]) == year)]
    result <- data.frame(year=year,prediction_type=prediction_type, prediction=point_pred)
  }

  return(result)
}
