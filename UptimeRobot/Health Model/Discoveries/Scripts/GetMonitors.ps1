param($sourceId,$managedEntityId,$computerName,$APIkey)

#Create Discovery Property Bag
$api = new-object -comObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $SourceId, $ManagedEntityId)
$api.LogScriptEvent("WebChecksDiscovery.ps1", 8001, 0, "Discovery Started")

$Header = @{
    "Content-Type" = "application/x-www-form-urlencoded"
    "Cache-Control" = "no-cache"
}

$body = @{
	"api_key" = $APIKey
	"time_zone" = "1"
	"format" = "json"
}

$URL = 'https://api.uptimerobot.com/v2/getMonitors'

$WebMonitors = (Invoke-RestMethod -Method POST -uri $URL -Headers  $header -Body $body).Monitors

#Loop through each web check.

Foreach($WebMonitor in $WebMonitors)
    {
	#Determinate the type
    $monitorType = $webMonitor.type
	#Set friendly name for type
    switch ($monitorType)
        {
            1 {$type = "HTTP(s)"}
            2 {$type = "keyWord"}
            3 {$type = "ping"}
            4 {$type = "Port"}
        }

    #Create Class Instance
    $instance = $discoveryData.CreateClassInstance("$MPElement[Name='UptimeRobot.WebCheck']$")
    #Fill up properties of class
        $instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/FriendlyName$", $WebMonitor.friendly_name)
        $instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/URL$", $WebMonitor.url)
        $instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/Interval$", $WebMonitor.interval)
        $instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/FriendlyName$", $WebMonitor.friendly_name)
        $instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/Interval$", $WebMonitor.interval)
		$instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/Type$", $type)
			if($WebMonitor.port){$instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/Port$", $WebMonitor.port)}
			if($WebMonitor.keyword_value){$instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/KeywordValue$", $WebMonitor.keyword_value)}
			if($WebMonitor.keyword_type){$instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/KeywordType$", $WebMonitor.keyword_type)}
			if($WebMonitor.http_userName){$instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/HTTPUserName$", $WebMonitor.http_username)}
		$instance.AddProperty("$MPElement[Name='UptimeRobot.WebCheck']/ID$", $WebMonitor.id)
     #Add the displayname, path of the server and key property of the parent class. (always recurring)
        $instance.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$", $WebMonitor.friendly_name)
        $instance.AddProperty("$MPElement[Name='UptimeRobot.WatcherNode']/APIkey$", $apiKey)
        $instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $computerName) 
    #Add the instance to the discoverydate propertybag
    
    $discoveryData.AddInstance($instance) 
    $api.LogScriptEvent("WebChecksDiscovery.ps1", 8003, 0, "Added instance $WebMonitor.friendly_name")   
    }

$api.LogScriptEvent("WebChecksDiscovery.ps1", 8002, 0, "Discovery Ended")

$discoveryData

