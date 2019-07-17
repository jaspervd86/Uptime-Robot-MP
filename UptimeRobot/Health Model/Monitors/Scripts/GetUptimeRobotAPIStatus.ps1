param($APIkey)

#Create monitor property bag
$api = new-object -comObject 'MOM.ScriptAPI'
$bag = $api.CreatePropertyBag()

#Accept TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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

Try{

	$webMonitor = Invoke-RestMethod -Method POST -uri $URL -Headers  $header -Body $body
	If($webMonitor)
		{
			$bag.AddValue('Status',"NOK")
			$bag.AddValue('URL',$URL)
		}
	Else
		{
			$bag.AddValue('Status',"OK")
			$bag.AddValue('URL',$URL)
		}
}
Catch
{
	$api.LogScriptEvent($ScriptName, 10016, 2, "Failed to query the API, the error was: $Error")
	$bag.AddValue('Error',$Error)
}

