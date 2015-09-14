# Define some IIS specific variables.
$inetdir = 'C:\Windows\System32\inetsrv'
$appcmd = $inetdir + '\appcmd.exe'
$appHostCfgPath = $INETDIR + '\config\applicationHost.config'

# Read in the xml of the existing IIS configuration.
[xml]$appHostCfgXml = Get-Content $appHostCfgPath
$poolNodeXml = $appHostCfgXml | Select-Xml -Xpath "//applicationPools" | Select-Object -ExpandProperty "node"

# V-13704 (defined globally)
& $appcmd set config -section:system.applicationHost/applicationPools /applicationPoolDefaults.recycling.periodicRestart.time:29:00:00 /commit:apphost

foreach ($pool in $poolNodeXml.add.name) {
  # V-13704 (defined per app pool)
  & $appcmd set config -section:system.applicationHost/applicationPools "/[name='$pool'].recycling.periodicRestart.time:29:00:00" /commit:apphost
}