Set-Location 'Cert:\LocalMachine\My'
$Cert = Get-Certificate -Template "WebServer" -Url ldap:///CN=blue-sca-1 -DnsName brl-dscpull.bluecrest.local -CertStoreLocation Cert:\LocalMachine\My
$Thumbprint = $Cert.Certificate.Thumbprint





