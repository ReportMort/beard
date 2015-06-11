Deploy scoring model
====================

This package illustrates how to deploy a model for remote scoring/prediction. 


    # Install in R
    library(devtools)
    install_github("reportmort/beard")

    # Score in R
    library(beard)
    mydata <- data.frame(year=c(1915))
    beard(input = mydata)

    # Score remotely
    curl https://public.opencpu.org/ocpu/github/ReportMort/beard/R/beard/json \
      -H "Content-Type: application/json" \
      -d '{"input" : [ {"year":1914} ]}'
      
    # Score from R using RCurl
    library(RCurl)
    library(RJSONIO)
    res <- postForm("https://public.opencpu.org/ocpu/github/ReportMort/beard/R/beard/json",
            .opts = list(postfields = toJSON(list(input=list(year=1890))),
            httpheader = c('Content-Type' = 'application/json', Accept = 'application/json'),
            ssl.verifypeer = FALSE))
    fromJSON(res)
      
The model is included in the `data` directory of the package, and was created
using the [createmodel.R](https://github.com/reportmort/beard/blob/master/inst/beard/createmodel.R) script. It predicts in the early 20th century the prevelance of beards among men.