const { execSync } = require('child_process');
const fs = require("fs"); // Or `import fs from "fs";` with ESM

/**
 * Main handler function for lambda events
 * @param event
 * @param context
 * @returns {Promise<*>}
 */
exports.handler =  async function(event, context) {
  //TODO: If /tmp/OffShoreWind_public doesn't exist, clone it (make it conditional)
  if ( ! fs.existsSync("/tmp/OffShoreWind_public") ) {
    //go to the /tmp directory and clone our target repo from github
    execSync("cd /tmp && git clone https://github.com/pointblue/OffShoreWind_public.git")
  }

  //execute the main.R script, passing in the 'event' JSON object as the only argument.
  // then, converting the result of the script output to a plain string and returning that value e-on
  // as the result of this handler function
  return execSync("Rscript main.R '" + JSON.stringify(event) + "'").toString()
}