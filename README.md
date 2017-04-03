# DSC

# New-ModuleManifest -Path "$env:ProgramFiles\WindowsPowerShell\Modules\cHVLiveMigration\cHVLiveMigration.psd1" -Guid (New-Guid).Guid -Author 'Sam Holdaway' -CompanyName SamCo -ModuleVersion 1.0 -Description 'Class based DSC Resource module to set live migration threshold' -PowerShellVersion 5.0 -DscResourcesToExport * -RootModule cHVLiveMigration.psm1
