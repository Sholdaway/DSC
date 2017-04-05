[DscResource()]
class HVLiveMigration 
{
    [DscProperty(Key)]
    [System.UInt32]$MigrationThreshold

    [DscProperty(Mandatory)]
    [bool]$Enabled

    [void] Set()
    {
        if ($this.Enabled -eq $true)
        {
            Enable-VMMigration
            Set-VMHost -MaximumVirtualMachineMigrations $this.MigrationThreshold
        }
        else
        {
            Disable-VMMigration
        }   
        
    }


    [bool] Test() 
    {
        $LiveMigrationTheshold = (Get-VMHost).MaximumVirtualMachineMigrations

        if (($LiveMigrationTheshold -eq $this.MigrationThreshold) -and (Get-VMHost).virtualmachinemigrationenabled -eq $this.Enabled)
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
                    MigrationThreshold = (Get-VMHost).MaximumVirtualMachineMigrations
                    Enabled = (Get-VMHost).virtualmachinemigrationenabled
                    }

        return $ReturnValue
    }


}
