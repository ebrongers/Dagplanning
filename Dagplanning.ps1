#==============================================================================================
# XAML Code - Imported from Visual Studio Express WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

$inputXML = Get-Content('MainWindow.xaml')
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'

[xml]$XAML = $inputXML

#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#===========================================================================
# Functies 
#===========================================================================
Function btnAnnuleren-click{
		Get-PSSession | Remove-PSSession
		$Form.Close()
}

Function btnVerwijderen-click{
	Get-PSSession | Remove-PSSession
	$Form.Close()
}


#===========================================================================
# Add events to Form Objects
#===========================================================================
$btnAnnuleren.Add_Click({btnAnnuleren-click})
$btnVerwijderen.Add_Click({btnVerwijderen-click})
$Form.ShowDialog() | out-null