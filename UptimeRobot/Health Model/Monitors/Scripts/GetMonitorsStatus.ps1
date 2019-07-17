﻿param($ID,$APIkey)

#Create monitor property bag
$api = new-object -comObject 'MOM.ScriptAPI'
$bag = $api.CreatePropertyBag() 
#check Uptime Robot status page

#Accept TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$Header = @{
    "Content-Type" = "application/x-www-form-urlencoded"
    "Cache-Control" = "no-cache"
    
}

$body = @{
	"api_key" = $APIkey
	"time_zone" = "1"
	"format" = "json"
}

$URL = 'https://api.uptimerobot.com/v2/getMonitors'

Try{

	$webMonitor = (Invoke-RestMethod -Method POST -uri $URL -Headers  $header -Body $body).monitors | where id -EQ $id

}

Catch

{
	$api.LogScriptEvent($ScriptName, 10014, 2, "Failed to query the API, the error was: $Error")
}
#Declare variables containing status
[int]$strStatus = $WebMonitor.status

#add the values to the bag
$bag.AddValue('Status', $strStatus)
$bag 

