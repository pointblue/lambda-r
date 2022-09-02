#!/usr/bin/env Rscript
library('logger')
library('logging')
library('httr')
library('jsonlite')
library('yaml')
library('rgeos')
library('rgdal')
library('raster')
library('airtabler')
library('aws.s3')
library('remotes')
library('data.table')
library('dotenv')

# get the argument passed to this script
args <- commandArgs(trailingOnly = TRUE)

##
# This is for debugging the lambda image
##
printArgs <- function(){
   print('The following arguments were passed from lambda to nodejs, then to Rscript:')
   noquote(args)
}

# get the path to the cloned repo from the environment
clonePath<-Sys.getenv("TARGET_REPO_CLONE_PATH")
# get the R source file in the repo that will be executed
sourceFile<-Sys.getenv("R_SOURCE_FILE")
# load the file using the full path
source(paste(clonePath, "/", sourceFile, sep=""))

# execute the main handler function
mainOutput<-main(args)

# this the main output
print( mainOutput )