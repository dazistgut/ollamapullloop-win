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


$ollamaCommand = "ollama pull llama3.3:70b"
$maxRetries = 100
$retryCount = 0
$modelPath = "$env:USERPROFILE\.ollama\models\llama3.3:70b"

Write-Host "Starting Ollama pull script. Press Ctrl+C to stop manually."

while ($retryCount -lt $maxRetries) {
    Write-Host "$(Get-Date -Format 'HH:mm:ss'): Attempt #$($retryCount + 1)/$($maxRetries): Running the command..."

    # Start the job
    $job = Start-Job -ScriptBlock {
        param ($command)
        Invoke-Expression $command
    } -ArgumentList $ollamaCommand

    # Wait for a specific duration to allow progress
    Start-Sleep -Seconds 60

    # Stop the job if it's still running
    if (Get-Job -Id $job.Id | Where-Object { $_.State -eq "Running" }) {
        Write-Host "$(Get-Date -Format 'HH:mm:ss'): Stopping the job..."
        Stop-Job -Id $job.Id

        # Wait to ensure the job is stopped
        Start-Sleep -Milliseconds 500

        # Ensure the job is removed
        if (Get-Job -Id $job.Id) {
            Remove-Job -Id $job.Id
        }
    }

    # Check if the model has been downloaded
    if (Test-Path $modelPath) {
        Write-Host "$(Get-Date -Format 'HH:mm:ss'): Model download complete!"
        break
    }
	
    Write-Host "$(Get-Date -Format 'HH:mm:ss'): Model not yet complete.."
    # Increment the retry count and move to the next attempt
    $retryCount++
}

# Final message if retries are exhausted
if ($retryCount -ge $maxRetries) {
    Write-Host "$(Get-Date -Format 'HH:mm:ss'): Maximum retries reached. Exiting script."
}
