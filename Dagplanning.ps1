#==============================================================================================
# XAML Code - Imported from Visual Studio Express WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
function LoadForm($formname) {
	$inputXML = Get-Content($formname)
	$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'

	[xml]$xaml = $inputXML

	#Read XAML
	$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
	try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
	catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}

	#===========================================================================
	# Store Form Objects In PowerShell
	#===========================================================================
	$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name) -Scope Global}
	return $Form
}

$Form=LoadForm('MainWIndow.xaml')


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

Function filllbxAdressen {
	
	$arr_listAgencies | ForEach-Object {
		$lbxAdressen.Items.Add($_) | Out-Null
	}
}

Function createEmailUser($fullname,$email) {
	if ($email -eq "") {
	   $Label1.Text = "Fout: Geen adres aangemaakt! `n E-mail adres ongeldig"
	   Start-Sleep -Seconds 2
	   $Form.Close();
		exit
	}
}

#===========================================================================
# Add events to Form Objects
#===========================================================================
$btnAnnuleren.Add_Click({btnAnnuleren-click})
$btnVerwijderen.Add_Click({btnVerwijderen-click})

#===========================================================================
# Main programma
#===========================================================================
$arr_listAgencies="ADMIN1","ADMIN2"
filllbxAdressen
$Form.ShowDialog() | out-null