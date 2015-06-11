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
    read.csv(input, stringsAsFactors=FALSE)
  } else {
    as.data.frame(input, stringsAsFactors=FALSE)
  }
  stopifnot("year" %in% names(newdata))
  # only 1 year at a time
  stopifnot(nrow(newdata) == 1)
  
  a <- 0
  b <- 100
  dat <- data.frame(year=c("1866", "1867", "1868", "1869", "1870", "1871", "1872", "1873", "1874", "1875", "1876", "1877", "1878", "1879", "1880", "1881", "1882", "1883", "1884", "1885", "1886", "1887", "1888", "1889", "1890", "1891", "1892", "1893", "1894", "1895", "1896", "1897", "1898", "1899", "1900", "1901", "1902", "1903", "1904", "1905", "1906", "1907", "1908", "1909", "1910", "1911"),
                    data=c("20%", "24%", "10%", "21%", "28%", "10%", "21%", "16%", "35%", "75%", "37%", "29%", "45%", "34%", "24%", "41%", "44%", "58%", "34%", "88%", "43%", "46%", "42%", "49%", "93%", "41%", "40%", "53%", "62%", "68%", "12%", "48%", "34%", "28%", "40%", "59%", "52%", "43%", "67%", "53%", "91%", "50%", "73%", "26%", "95%", "66%"))
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
