#!/usr/bin/env Rscript
library('logger')
library('logging')
library('httr')
library('jsonlite')
library('yaml')
library('rgeos')
library('rgdal')
library('raster')
args <- commandArgs(trailingOnly = TRUE)

##
# This is for debugging the lambda image
##
printArgs <- function(){
   print('The following arguments were passed from lambda to nodejs, then to Rscript:')
   noquote(args)
}

##
# This is the 'kick off' function
##
importRasters_toOSW<-function(inpJSON){
	source("/tmp/OffShoreWind_public/scripts/batchProcessRasters.R")
	ret<-batchImportRasters_toOSW(inpJSON)
	return(ret)
}

# will this print the output of this function?
importRasters_toOSW(args)