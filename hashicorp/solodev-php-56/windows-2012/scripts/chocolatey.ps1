# Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Globally Auto confirm every action
choco feature enable -n allowGlobalConfirmation

choco install IIS-WebServerRole -source windowsfeatures
choco install IIS-ISAPIFilter -source windowsfeatures
choco install IIS-ISAPIExtensions -source windowsfeatures
choco install IIS-NetFxExtensibility -source windowsfeatures
choco install IIS-CGI -source windowsfeatures
choco install urlrewrite -y
choco install vcredist2012 -y
choco install vcredist2013 -y
choco install mysql -y --initialize-insecure
choco install php -version 5.6.3 -y --forcex86 --allow-empty-checksums
choco install mongodb -y
choco install awscli -y
choco install googlechrome -y

Invoke-WebRequest -OutFile ioncube.zip http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_win_nonts_vc11_x86.zip
7z x ioncube.zip
copy /Y ioncube\ioncube_loader_win_5.6.dll "C:\tools\php\ext" 
rd /s /q ioncube
del ioncube.zip