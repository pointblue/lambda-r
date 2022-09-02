const { execSync } = require('child_process');
const fs = require("fs"); // Or `import fs from "fs";` with ESM
require('dotenv').config(); // use local environment variable if available

//
// GLOBAL/ENVIRONMENT VARIABLES
//
// All variables can be passed in as lambda environment variables:
// https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html#configuration-envvars-config
//
// If running on a local development machine, you can also use a .env file. See the README.md for details.
//
//the target repo to clone. must be https url
const TARGET_REPO_HTTPS_URL = process.env.TARGET_REPO_HTTPS_URL
//a branch to checkout (optional)
const TARGET_REPO_BRANCH_NAME = process.env.TARGET_REPO_BRANCH_NAME
//the path that the repo should be cloned to
const TARGET_REPO_CLONE_PATH = process.env.TARGET_REPO_CLONE_PATH

/**
 * Main handler function for lambda events
 * @param event
 * @param context
 * @returns {Promise<*>}
 */
exports.handler =  async function(event, context) {
  // If /tmp/OffShoreWind_public does not exist
  if ( ! fs.existsSync(TARGET_REPO_CLONE_PATH) ) {
    //go to the /tmp directory and clone our target repo from github
    execSync(`git clone ${TARGET_REPO_HTTPS_URL} ${TARGET_REPO_CLONE_PATH}`)

    //if a branch name has been defined for the target repo, check it out
    if(TARGET_REPO_BRANCH_NAME.length > 0){
      execSync(`cd ${TARGET_REPO_CLONE_PATH} && git checkout ${TARGET_REPO_BRANCH_NAME}`)
    }
  }

  //execute the main script, passing in the 'event' JSON object as the only argument.
  // then, converting the result of the script output to a plain string and returning that value
  // as the output of this handler function
  return execSync(`/usr/bin/Rscript main.R '${JSON.stringify(event)}'`).toString()
}