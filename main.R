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
printArgs <- function(){
   print('The following arguments were passed from lambda to nodejs, then to Rscript:')
   noquote(args)
}

printArgs()