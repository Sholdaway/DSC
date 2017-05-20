# DSC configuration for Pull Server using registration

# The Sample_xDscWebServiceRegistration configuration sets up a DSC pull server that is capable for client nodes
# to register with it and retrieve configuration documents with configuration names instead of configuration id

# Prerequisite: Install a certificate in "CERT:\LocalMachine\MY\" store
#               For testing environments, you could use a self-signed certificate. (New-SelfSignedCertificate cmdlet could generate one for you).
#               For production environments, you will need a certificate signed by valid CA.
#               Registration only works over https protocols. So to use registration feature, a secure pull server setup with certificate is necessary


# The Sample_MetaConfigurationToRegisterWithLessSecurePullServer register a DSC client node with the pull server

# =================================== Section Request and install Cert =================================== #

#Turn this into a function...
#Do an 'If exists on the local cert store before choosing whether to request the cert or not

Set-Location 'Cert:\LocalMachine\My'
#$Cert = Get-Certificate -Template "WebServer" -Url ldap:///CN=blue-sca-1 -DnsName brl-dscpull.bluecrest.local -CertStoreLocation Cert:\LocalMachine\My
#$Thumbprint = $Cert.Certificate.Thumbprint
$Thumbprint = (Get-ChildItem .\ | Where-Object {$_.DnsNameList.Unicode -like 'dsc-server*'}).Thumbprint



# =================================== Section Request and install Cert =================================== #



# =================================== Section Pull Server =================================== #
configuration DscWebServiceRegistration
{
    param 
    (
        [string[]]$NodeName = 'localhost',

        [ValidateNotNullOrEmpty()]
        [string] $CertificateThumbPrint,

        [Parameter(HelpMessage='This should be a string with enough entropy (randomness) to protect the registration of clients to the pull server.  We will use new GUID by default.')]
        [ValidateNotNullOrEmpty()]
        [string] $RegistrationKey   # A guid that clients use to initiate conversation with pull server
    )

    Import-DSCResource -ModuleName xPSDesiredStateConfiguration
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $NodeName
    {   
        
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"            
        }

        xDscWebService PSDSCPullServer
        {
            Ensure                  = "Present"
            EndpointName            = "PSDSCPullServer"
            Port                    = 8080
            PhysicalPath            = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint   = $certificateThumbPrint
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"            
            State                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature" 
            RegistrationKeyPath     = "$env:PROGRAMFILES\WindowsPowerShell\DscService"   
            UseSecurityBestPractices = $false
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $RegistrationKey
        }

        WindowsFeature IISManagementTools
        {
            Ensure               = 'Present'
            Name                 = 'Web-Mgmt-Tools'
            IncludeAllSubFeature = $true
            DependsOn            = "[xDSCWebService]PSDSCPullServer"                   
        }
    }
}


# Sample use (please change values of parameters according to your scenario):
$RegistrationKey = [guid]::NewGuid()
DscWebServiceRegistration -RegistrationKey $RegistrationKey -certificateThumbPrint $Thumbprint -OutputPath 'c:\Configs\PullServer'
Start-DscConfiguration -Path c:\Configs\PullServer -Wait -Verbose -Force



# =================================== Section Pull Server =================================== #


#Test DSC Pull Server endpoint

Get-Website psdscpullserver

Invoke-WebRequest -Uri https://dsc-server.bluecrest.local:8080/psdscpullserver.svc



