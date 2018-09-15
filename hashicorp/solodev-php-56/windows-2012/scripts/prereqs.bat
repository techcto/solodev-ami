@echo off
echo ---------------------
echo Installing pre-reqs and solodev files 
echo ---------------------

SET PHP_DIR=C:\tools\php

C:\Windows\System32\inetsrv\appcmd.exe set config /section:system.webServer/fastCgi "/+[fullPath='%PHP_DIR%\php-cgi.exe']"
C:\Windows\System32\inetsrv\appcmd.exe set config /section:system.webServer/handlers "/+[name='PHP-Files',path='*.php',verb='GET,HEAD,POST',modules='FastCgiModule',scriptProcessor='%PHP_DIR%\php-cgi.exe',resourceType='Either']"
C:\Windows\System32\inetsrv\appcmd.exe set config /section:system.webServer/handlers "/+[name='STML-Files',path='*.stml',verb='GET,HEAD,POST',modules='FastCgiModule',scriptProcessor='%PHP_DIR%\php-cgi.exe',resourceType='Either']"
C:\Windows\System32\inetsrv\appcmd.exe set config /section:system.webServer/defaultDocument "/+files.[value='index.php']"
C:\Windows\System32\inetsrv\appcmd.exe set config /section:system.webServer/defaultDocument "/+files.[value='index.stml']"

copy /Y "%PHP_DIR%\php.ini-production" "%PHP_DIR%\php.ini" 

(
echo [SolodevSpecific]
echo short_open_tag=On
echo.
echo [WebPIChanges]
echo error_log=C:\Windows\temp\PHP56_errors.log
echo upload_tmp_dir=C:\Windows\temp
echo session.save_path=C:\Windows\temp
echo cgi.force_redirect=0
echo cgi.fix_pathinfo=1
echo fastcgi.impersonate=1
echo fastcgi.logging=0
echo max_execution_time=300
echo date.timezone=America/New_York
echo extension_dir="%PHP_DIR%\ext"
echo.
echo [ExtensionList]
echo extension=php_mysql.dll
echo extension=php_mysqli.dll
echo extension=php_mbstring.dll
echo extension=php_gd2.dll
echo extension=php_gettext.dll
echo extension=php_curl.dll
echo extension=php_exif.dll
echo extension=php_xmlrpc.dll
echo extension=php_openssl.dll
echo extension=php_soap.dll
echo extension=php_pdo_mysql.dll
echo extension=php_pdo_sqlite.dll
echo extension=php_imap.dll
echo extension=php_tidy.dll
) >> "%PHP_DIR%\php.ini"

echo zend_extension = "%PHP_DIR%\ext\ioncube_loader_win_5.6.dll" >> "%PHP_DIR%\php.ini"


echo ---------------------
echo Thanks for Playing!
echo ---------------------