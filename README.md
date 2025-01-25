# ollamapullloop-win
A workaround for the current bug with the Ollama pull timeout/cache clear.

# Script: olpull.ps1
# Author: dazistgut
# Date: 25/01/25
#
# Description:
# This script addresses the issue where Ollama deletes progress during model downloads 
# if connectivity is lost for a brief period (e.g., 5 seconds). It automates the process 
# by repeatedly interrupting and restarting the download, ensuring progress is retained.
#
# Steps to Use:
# 1. Update the `$ollamaCommand` variable with the model you want to pull.
# 2. Set the desired number of retries in `$maxRetries`.
# 3. Adjust the sleep duration (in seconds) to control the timeout period.
# 4. Save and run the script using: `./olpull.ps1`.
#
# Notes:
# - Ensure Ollama is installed and available in your system PATH.
# - The script will stop automatically once the model is fully downloaded 
#   or the maximum number of retries is reached.
# - Logs will indicate progress and any issues encountered during execution.
#
# Example Usage:
# ./olpull.ps1
