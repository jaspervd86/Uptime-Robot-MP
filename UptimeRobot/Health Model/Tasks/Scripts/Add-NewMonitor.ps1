param(
    [Parameter(Mandatory=$true)]
    [string]$newUrl,
    [Parameter(Mandatory=$true)]
    [string]$name,
    [Parameter(Mandatory=$true)]
    [int]$interval,
	[Parameter(Mandatory=$true)]
    [string]$APIKey
)

#Create Discovery Property Bag
$api = new-object -comObject 'MOM.ScriptAPI'
$api.LogScriptEvent("Add-NewMonitor.ps1", 8004, 0, "TASK started: Adding a new Uptime Robot monitor")

$Header = @{
    "Content-Type" = "application/x-www-form-urlencoded"
    "Cache-Control" = "no-cache"
    
}

$body = @{
	"api_key" = $APIKey
    "url" = $newUrl
    "friendly_name" = $name
    "type" = "1"
    "interval" = $interval
}

$URL = 'https://api.uptimerobot.com/v2/newMonitor' 

$newMonitor = (Invoke-RestMethod -Method POST -uri $URL -Headers  $header -Body $body)
if ($newMonitor.stat -ne "ok")
    {
        Write-Output "Failed to create monitor for $newUrl"
    }

else
    {
        Write-Output $newMonitor.monitor
    }

$api.LogScriptEvent("Add-NewMonitor.ps1", 8005, 0, "TASK executed: Adding a new Uptime Robot monitor")
  