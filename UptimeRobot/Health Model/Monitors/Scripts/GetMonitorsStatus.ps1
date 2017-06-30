param($ID,$APIkey)

#Create monitor property bag
$api = new-object -comObject 'MOM.ScriptAPI'
$bag = $api.CreatePropertyBag() 
#check Uptime Robot status page
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



$webMonitor = (Invoke-RestMethod -Method POST -uri $URL -Headers  $header -Body $body).monitors | where id -EQ $id

#Declare variables containing status
[int]$strStatus = $WebMonitor.status

#add the values to the bag
$bag.AddValue('Status', $strStatus)
$bag 