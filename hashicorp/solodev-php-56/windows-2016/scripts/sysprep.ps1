$sysprepFile="C:\\ProgramData\\Amazon\\EC2-Windows\\Launch\\Sysprep\\unattend.xml"
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
$Path.InnerXml = 'C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\SolodevSetup.cmd';
$child.AppendChild($Order);
$child.AppendChild($Path);

$xmlElementToAddTo.AppendChild($child)

$xml.Save($sysprepFile)