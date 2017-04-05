[DscResource()]
class HVLiveMigration 
{
    [DscProperty(Key)]
    [System.UInt32]$MigrationThreshold

    [void] Set()
    {
        Set-VMHost -MaximumVirtualMachineMigrations $this.MigrationThreshold
    }


    [bool] Test() 
    {
        $LiveMigrationTheshold = Get-VMHost | Select-Object -ExpandProperty MaximumVirtualMachineMigrations

        if ($LiveMigrationTheshold -eq $this.MigrationThreshold) 
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
