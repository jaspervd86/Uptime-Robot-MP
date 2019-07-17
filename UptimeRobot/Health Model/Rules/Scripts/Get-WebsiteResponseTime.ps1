param(
$id,
$apiKey                  
)
                  
# Add the SCOM API and Propertybag for output
$api = New-Object -comObject "MOM.ScriptAPI"
$bag = $api.CreatePropertyBag()
$ScriptName = "Get-WebSiteResponseTime.ps1"

#Accept TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Logging
$api.LogScriptEvent($ScriptName,8106,0,"Getting Response time for $id")
	$Header = @{
	"Content-Type" = "application/x-www-form-urlencoded"
	"Cache-Control" = "no-cache"

	}

	$body = @{
	"api_key" = $apiKey
	"time_zone" = "1"
	"format" = "json"
	"response_times" = "1"
	}

$URL = 'https://api.uptimerobot.com/v2/getMonitors'

$webMonitor = (Invoke-RestMethod -Method POST -uri $URL -Headers  $header -Body $body).monitors | where id -EQ $id
[int]$ResponseTime = ($webMonitor.Response_times | select -First 1).Value

#Adding the value from the script into the propertybag
$bag.AddValue("ResponseTime", $ResponseTime)

#Logging
$api.LogScriptEvent($ScriptName,8107,0,"$ScriptName script is complete")

#Outputting the bag
$bag