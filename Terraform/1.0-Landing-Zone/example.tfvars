# global configuration data
companyNamePrefix = "" /* company acronym */
environment = "" /* production, test, dev, training...*/
location = "" /* Azure region - AzureCLI: Az account list-locations --query [].displayName */

# Networking specific configuration data
vNETs = {
    hub = {
        addressSpace = [""]
        dnsServers = ["",""]
        subnets = {
            GatewaySubnet = "" /* Must be named GatewaySubnet */
            AzureLoadBalancer = "" 
            AzureFirewallSubnet = "" /* Must be named AzureFirewallSubnet */
            InfrastructureServices = ""
        }
    }
}
spokes = {
    spoke1 = { /* usually defined by a project */
        addressSpace = [""]
        dnsServers = ["",""]
        subnets = {
            AzureLoadBalancer = ""
            Application = ""
        }
        Peer = 1 /* 1 to peer, 0 not to peer */
    } /* repeat the spoke blocks per spoke */
    spoke2 = {
        addressSpace = [""]
        dnsServers = ["",""]
        subnets = {
            AzureLoadBalancer = ""
            Application = ""
        }
        Peer = 0
    }
}
# The tags below are mandatory. Feel free to add additional tags too.
networkTags = {
    department = ""
    applicationName = ""
    costCenter = ""
    technicalContact = ""
}
vpnClientAddressSpace = "" /* must be address space outside of the VNet.*/
publicCertData = "" /* x509 representation of the certificate */