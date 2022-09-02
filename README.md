# Lambda + R script + Node.js stack for Docker

This stack adds Rscript and some spatial libraries to a docker image for AWS Lambda. The default language
for the image is Node.js, but the entry point function immediately passes arguments to an R script and returns
any console output.  

## Installation

Installation in only require if you're running the container outside of lambda in the AWS cloud.

### Local Installation

Copy the `.env-example` file and rename it `.env`, in the same path.

## Files  

  - **Dockerfile** - recipe for docker image
  - **apps.js** - App handler code for lambda events
  - **main.R** - Main R script that is called by app.js and passed any information from the lambda event
  - **.env-example** - An example configuration file

## Examples  

### Build image, create container, and test
NOTE: `docker` commands must be run as root user or by using `sudo` command, depending on your installation.  

  - **Build the image**: `docker build -r lambda-r .`  
  This commands says: Build a Docker image using the files in the current folder and name it "lambda-r"
  - **Create and run a container**: `docker run -p 9000:8080 --name my-lambda-r -d lambda-r`.  
  This command says: Create a container with the name "my-lambda-r" from the "lambda-r" image, 
  run it, and expose port 8080 of the container to 9000 on my machine.
  - **Test the lambda api**:  
  ```
  curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"Records":[{"eventVersion":"2.1","eventSource":"aws:s3","awsRegion":"us-west-2","eventTime":"1970-01-01T00:00:00.000Z","eventName":"ObjectCreated:Put","userIdentity":{"principalId":"AIDAJDPLRKLG7UEXAMPLE"},"requestParameters":{"sourceIPAddress":"127.0.0.1"},"responseElements":{"x-amz-request-id":"C3D13FE58DE4C810","x-amz-id-2":"FMyUVURIY8/IgAtTv8xRjskZQpcIZ9KG4V5Wp6S7S/JRWeUWerMUE5JgHvANOjpD"},"s3":{"s3SchemaVersion":"1.0","configurationId":"testConfigRule","bucket":{"name":"mybucket","ownerIdentity":{"principalId":"A3NL1KOZZKExample"},"arn":"arn:aws:s3:::mybucket"},"object":{"key":"FirstProcess/triggerYamls/testYaml.yaml","size":1024,"eTag":"d41d8cd98f00b204e9800998ecf8427e","versionId":"096fKKXTRTtl3on89fVO.nfljtsv6qko","sequencer":"0055AED6DCD90281E5"}}}]}'
  ```  
  This command emulates how the docker container would respond to requests from AWS lambda.  
  **Expected output**:  
  ```
You will receive an error because your local environment will not contain the image file necessary for processing. This
is the current development target, but it should be updated to something stable.
  ```

### Command Line Access  

To access the container using the command line, use: `docker exec -it my-lambda-r bash`.  

