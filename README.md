# Lambda + R script + Node.js stack for Docker

This stack adds Rscript and some spatial libraries to a docker image for AWS Lambda. The default language
for the image is Node.js, but the handler entry point immediately passed arguments to an R script.  

## Files  

  - **Dockerfile** - recipe for docker image
  - **apps.js** - App handler code for lambda events
  - **main.R** - Main R script that is called by app.js and passed any information from the lambda event

## Examples  

### Build image, create container, and test
NOTE: `docker` commands must be run as root user or by using `sudo` command, depending on your installation.  

  - **Build the image**: `docker build -r lambda-r .`  
  This commands says: Build a Docker image using the files in the current folder and name it "lambda-r"
  - **Create and run a container**: `docker run -p 9000:8080 --name my-lambda-r -d lambda-r`.  
  This command says: Create a container with the name "my-lambda-r" from the "lambda-r" image, 
  run it, and expose port 8080 of the container to 9000 on my machine.
  - **Test the lambda api**:  
  `curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"payload":"hello world!"}'`  
  This command emulates how the docker container would respond to requests from AWS lambda.  
  **Expected output**:  
  ```
  "[1] \"The following arguments were passed from lambda to nodejs, then to Rscript:\"\n[1] {\"payload\":\"hello world!\"}\n"
  ```

### Command Line Access  

To access the container using the command line, use: `docker exec -it my-lambda-r bash`.  

