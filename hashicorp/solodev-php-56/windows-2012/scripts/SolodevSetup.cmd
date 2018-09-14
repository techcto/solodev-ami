@echo off
echo ---------------------
echo IMPORTANT!! DO NOT CLOSE!!
echo Please Wait - Initializing Solodev CMS and Database
echo ---------------------

iisreset /stop

cd C:\inetpub\

mkdir Solodev\clients\solodev
copy Solodev\core\aws\Client_Settings.xml Solodev\clients\solodev

icacls "C:\inetpub\Solodev" /t /grant Users:F

@powershell invoke-restmethod -uri http://169.254.169.254/latest/meta-data/instance-id > instance_id.txt
set /p EC2_INSTANCE_ID=<instance_id.txt
del instance_id.txt

echo sql_mode=NO_ENGINE_SUBSTITUTION >> C:\tools\mysql\current\my.ini
net stop MySQL
net start MySQL
C:\tools\mysql\current\bin\mysql.exe -uroot -e "CREATE DATABASE solodev_solodev" 
C:\tools\mysql\current\bin\mysql.exe -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('%EC2_INSTANCE_ID%');"


set MONGO_DIR=C:\Program Files\MongoDB\Server\3.2

mkdir "%MONGO_DIR%\data\db"
mkdir "%MONGO_DIR%\log"
(
echo logpath=%MONGO_DIR%\log\mongo.log 
echo dbpath=%MONGO_DIR%\data\db
) > "%MONGO_DIR%\mongod.cfg"
"%MONGO_DIR%\bin\mongod.exe" --config "%MONGO_DIR%\mongod.cfg" --install
net start MongoDB
"%MONGO_DIR%\bin\mongo.exe" --eval "use solodev_views"
"%MONGO_DIR%\bin\mongo.exe" --eval "db.createUser({\"user\": \"root\", \"pwd\": \"%EC2_INSTANCE_ID%\", \"roles\": [ { role: \"readWrite\", db: \"solodev_views\" } ] })"


cd C:\inetpub\Solodev\clients\solodev\
@powershell "(Get-Content Client_Settings.xml) | ForEach-Object { $_ -replace 'REPLACE_WITH_DBHOST', 'localhost' } | Set-Content Client_Settings.xml"
@powershell "(Get-Content Client_Settings.xml) | ForEach-Object { $_ -replace 'REPLACE_WITH_MONGOHOST', 'localhost' } | Set-Content Client_Settings.xml"
@powershell "(Get-Content Client_Settings.xml) | ForEach-Object { $_ -replace 'REPLACE_WITH_DATABASE', 'solodev_solodev' } | Set-Content Client_Settings.xml"
@powershell "(Get-Content Client_Settings.xml) | ForEach-Object { $_ -replace 'REPLACE_WITH_DBUSER', 'root'} | Set-Content Client_Settings.xml"
@powershell "(Get-Content Client_Settings.xml) | ForEach-Object { $_ -replace 'REPLACE_WITH_DBPASSWORD', '%EC2_INSTANCE_ID%' } | Set-Content Client_Settings.xml"


C:\Windows\System32\inetsrv\appcmd.exe delete site "Default Web Site"
C:\Windows\System32\inetsrv\appcmd.exe add site /name:"Solodev" /id:1 /physicalPath:"C:\inetpub\Solodev\core\solodevX\www"
C:\Windows\System32\inetsrv\appcmd.exe set site /site.name:Solodev /+bindings.[protocol='http',bindingInformation='*:80:']
C:\Windows\System32\inetsrv\appcmd.exe add vdir /app.name:"Solodev/" / /path:"/api" /physicalPath:"C:\inetpub\Solodev\core\api"
C:\Windows\System32\inetsrv\appcmd.exe add vdir /app.name:"Solodev/" / /path:"/CK" /physicalPath:"C:\inetpub\Solodev\core\CK"
C:\Windows\System32\inetsrv\appcmd.exe add vdir /app.name:"Solodev/" / /path:"/core" /physicalPath:"C:\inetpub\Solodev\core\html_core"


C:\Windows\System32\inetsrv\appcmd.exe stop site /site.name:Solodev
C:\Windows\System32\inetsrv\appcmd.exe start site /site.name:Solodev

icacls "C:\inetpub\Solodev" /t /grant Users:F
icacls "C:\Windows\Temp" /grant Users:F
icacls "C:\Windows\System32\inetsrv\config" /t /grant IUSR:F

"C:\tools\php\php.exe" C:\inetpub\Solodev\core\update.php solodevadmin %EC2_INSTANCE_ID% www.demo.com business
icacls "C:\inetpub\Solodev" /t /grant Users:F

C:\Windows\System32\inetsrv\appcmd.exe add site /name:"www.demo.com" /id:2 /physicalPath:"C:\inetpub\Solodev\clients\solodev\Websites\www.demo.com\www"
C:\Windows\System32\inetsrv\appcmd.exe set site /site.name:"www.demo.com" /+bindings.[protocol='http',bindingInformation='*:80:www.demo.com']
C:\Windows\System32\inetsrv\appcmd.exe set site /site.name:"www.demo.com" /+bindings.[protocol='http',bindingInformation='*:80:demo.com']
C:\Windows\System32\inetsrv\appcmd.exe set config "www.demo.com" -section:system.webServer/rewrite/rules /-"[name='CanonicalHostNameRule1']" 
C:\Windows\System32\inetsrv\appcmd.exe set config "www.demo.com" -section:system.webServer/rewrite/rules /+"[name='CanonicalHostNameRule1']" 
C:\Windows\System32\inetsrv\appcmd.exe set config "www.demo.com" -section:system.webServer/rewrite/rules /"[name='CanonicalHostNameRule1'].match.url:(.*)"
C:\Windows\System32\inetsrv\appcmd.exe set config "www.demo.com" -section:system.webServer/rewrite/rules /+"[name='CanonicalHostNameRule1'].conditions.[input='{HTTP_HOST}',pattern='^www\.demo\.com$',negate='true']" 
C:\Windows\System32\inetsrv\appcmd.exe set config "www.demo.com" -section:system.webServer/rewrite/rules /"[name='CanonicalHostNameRule1'].action.type:Redirect" /"[name='CanonicalHostNameRule1'].action.url:http://www.demo.com/{R:1}"  
C:\Windows\System32\inetsrv\appcmd.exe add vdir /app.name:"www.demo.com/" / /path:"/api" /physicalPath:"C:\inetpub\Solodev\core\api"
C:\Windows\System32\inetsrv\appcmd.exe add vdir /app.name:"www.demo.com/" / /path:"/CK" /physicalPath:"C:\inetpub\Solodev\core\CK"
C:\Windows\System32\inetsrv\appcmd.exe add vdir /app.name:"www.demo.com/" / /path:"/core" /physicalPath:"C:\inetpub\Solodev\core\html_core"
echo 127.0.0.1  www.demo.com >> C:\Windows\System32\drivers\etc\hosts
echo 127.0.0.1  demo.com >> C:\Windows\System32\drivers\etc\hosts

iisreset /start

echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%HOMEDRIVE%%HOMEPATH%\Desktop\IIS Manager.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%windir%\system32\inetsrv\InetMgr.exe" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs
del CreateShortcut.vbs

echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%HOMEDRIVE%%HOMEPATH%\Desktop\Solodev Admin.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" >> CreateShortcut.vbs
echo oLink.Arguments = "localhost --profile-directory=Default " >> CreateShortcut.vbs
echo oLink.IconLocation = "C:\inetpub\Solodev\core\solodevX\www\assets\images\solodev.ico, 0" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs
del CreateShortcut.vbs

echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%HOMEDRIVE%%HOMEPATH%\Desktop\Demo Site.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" >> CreateShortcut.vbs
echo oLink.Arguments = "www.demo.com  --profile-directory=Default " >> CreateShortcut.vbs
echo oLink.IconLocation = "C:\inetpub\Solodev\core\solodevX\www\assets\images\webcorpco.ico, 0" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs
del CreateShortcut.vbs

echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%HOMEDRIVE%%HOMEPATH%\Desktop\Solodev Quick Start Guide.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" >> CreateShortcut.vbs
echo oLink.Arguments = "solodev.zendesk.com/hc/en-us/sections/206208667-Quick-Start-Guide --profile-directory=Default " >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs
cscript CreateShortcut.vbs
del CreateShortcut.vbs


del "C:\Program Files\Amazon\Ec2ConfigService\Scripts\SolodevSetup.cmd"

