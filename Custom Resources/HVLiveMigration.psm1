enum Ensure 
{
    Present
    Absent
}

[DscResource()]

class HVLiveMigration 
{
[DscProperty(Key)]
[Ensure]$Ensure

[DscProperty(Mandatory)]
[System.UInt32]$MigrationThreshold

    [void] Set()
    {
        Set-VMHost -MaximumVirtualMachineMigrations 5
    }


    [bool] Test() 
    {
        $LiveMigrationTheshold = Get-VMHost | Select-Object -ExpandProperty MaximumVirtualMachineMigrations

        if ($LiveMigrationTheshold -eq 5) 
        {
            Write-Verbose ("Live migration threshold is correct, setting is: " + $LiveMigrationTheshold)
            return $True
        }
        else
        {
            Write-Verbose ("Live migration threshold is incorrect, setting is: " + $LiveMigrationTheshold)
            return $False
        }
    }

    [HVLiveMigration] Get()
    {
        $ReturnValue = @{
                    MigrationThreshold = Get-VMHost | Select-Object -ExpandProperty MaximumVirtualMachineMigrations
                    }

        return $ReturnValue
    }


}
