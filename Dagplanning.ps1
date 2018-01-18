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

$MainForm=LoadForm('MainWindow.xaml')
$noEmailForm=LoadForm('noEmailForm.xaml')

#===========================================================================
# Formulier Functies 
#===========================================================================
Function btnAnnuleren-click{
		Get-PSSession | Remove-PSSession
		$MainForm.Close()
}

Function btnVerwijderen-click{
	$noEmailForm.ShowDialog() | Out-Null
	
}

Function FrmNoEmailFormBtnOke-click {
	$noEmailForm.Hide()
}

#===========================================================================
# Algemene Functies 
#===========================================================================
Function filllbxAdressen {
	
	$arr_listAgencies | ForEach-Object {
		$lbxAdressen.Items.Add($_) | Out-Null
	}
}



Function createEmailUser($fullname,$email) {
	if ($email -eq "") {
	   $noEmailForm.ShowDialog() | Out-Null

		exit
	}
}

#===========================================================================
# Add events to Form Objects
#===========================================================================
$btnAnnuleren.Add_Click({btnAnnuleren-click})
$btnVerwijderen.Add_Click({btnVerwijderen-click})
$FrmNoEmailFormBtnOke.Add_Click({FrmNoEmailFormBtnOke-click})
$FrmMainWindowBtnToevoegen.Add_Click({createEmailUser})

#===========================================================================
# Main programma
#===========================================================================
$arr_listAgencies="ADMIN1","ADMIN2"
filllbxAdressen
$MainForm.ShowDialog() | out-null