$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\BundleConfig.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()

foreach ($element in $xmlElement.Property)
{
    if ($element.Name -eq "AutoSysprep")
    {
        $element.Value="Yes"
    }
}

$xml_switches = $xml.SelectSingleNode("//Switches[1]")
foreach ($switch in $xml_switches) {
    $switch.'#text' = "/quit /oobe /generalize"
}

$xml.Save($EC2SettingsFile)


$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

$enableElements = "Ec2SetPassword", `
                  "Ec2SetComputerName", `
                  "Ec2HandleUserData", `
                  "Ec2DynamicBootVolumeSize"

$xmlElementToModify.Plugin | Where-Object {$enableElements -contains $_.name} | Foreach-Object {$_.State="Enabled"}

$xml.Save($EC2SettingsFile)


$sysprepFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\sysprep2008.xml"
$xml = [xml](get-content $sysprepFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToAddTo = $xmlElement.settings.Where{($_.pass -eq 'specialize')}.component.Where{($_.name -eq 'Microsoft-Windows-Deployment')}.RunSynchronous

$child = $xml.CreateElement("RunSynchronousCommand", $xml.unattend.NamespaceURI)
$attrib = $xml.CreateAttribute('wcm', 'action', 'http://schemas.microsoft.com/WMIConfig/2002/State')
$attrib.Value = 'add'
$child.Attributes.Append($attrib)
$Order = $xml.CreateElement("Order", $xml.unattend.NamespaceURI)
$Order.InnerXml='10'
$Path = $xml.CreateElement("Path", $xml.unattend.NamespaceURI)
$Path.InnerXml = 'C:\Program Files\Amazon\Ec2ConfigService\Scripts\SolodevSetup.cmd';
$child.AppendChild($Order);
$child.AppendChild($Path);

$xmlElementToAddTo.AppendChild($child)

$xml.Save($sysprepFile)

#initialize sysprep for aws win2012
$p = Start-Process "C:\Program Files\Amazon\Ec2ConfigService\Ec2Config.exe" -ArgumentList "-sysprep" -Wait