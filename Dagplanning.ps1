#==============================================================================================
# XAML Code - Imported from Visual Studio Express WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[System.Reflection.Assembly]::LoadWithPartialName("System.Net") 
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
	
	
}

Function FrmNoEmailFormBtnOke-click {
	$noEmailForm.Hide()
}

Function FrmMainWindowBtnToevoegen-Click() {
	$fullname=""

	createEmailUser($fullname,$FrmMainWindowtxtEmail.Text)
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
	write-host $fullname
		if ( ValidEmailAddress($email) -eq $false) {
	   $noEmailForm.ShowDialog() | Out-Null
			}
		
	
}

Function ValidEmailAddress($address)
{Write-Host "test"
 #try
 #{
  $x = New-Object System.Net.Mail.MailAddress($address)
	 
 # return $true
 #}
 #catch
 #{
  return $false
 #}
}

#===========================================================================
# Add events to Form Objects
#===========================================================================

# FrmMainForm
$btnAnnuleren.Add_Click({btnAnnuleren-click})
$btnVerwijderen.Add_Click({btnVerwijderen-click})
$FrmMainWindowBtnToevoegen.Add_Click({FrmMainWindowBtnToevoegen-Click})

# FrmNoEmailForm
$FrmNoEmailFormBtnOke.Add_Click({FrmNoEmailFormBtnOke-click})


#===========================================================================
# Main programma
#===========================================================================
$arr_listAgencies="ADMIN1","ADMIN2"
filllbxAdressen
$MainForm.ShowDialog() | out-null