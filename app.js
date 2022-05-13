const { execSync } = require('child_process');

/**
 * Main handler function for lambda events
 * @param event
 * @param context
 * @returns {Promise<*>}
 */
exports.handler =  async function(event, context) {
  //execute the main.R script, passing in the 'event' JSON object as the only argument.
  // then, converting the result of the script output to a plain string and returning that value
  // as the result of this handler function
  return execSync("Rscript main.R '" + JSON.stringify(event) + "'").toString()
}