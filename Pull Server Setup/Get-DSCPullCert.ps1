Set-Location 'Cert:\LocalMachine\My'
$Cert = Get-Certificate -Template "WebServer" -Url ldap:///CN=cert-server -DnsName dsc-server -CertStoreLocation Cert:\LocalMachine\My
$Thumbprint = $Cert.Certificate.Thumbprint





