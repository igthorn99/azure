// Creates a network security group preconfigured for use with Azure ML
// To learn more, see https://docs.microsoft.com/en-us/azure/machine-learning/how-to-access-azureml-behind-firewall
@description('Azure region of the deployment')
param location string = 'eastus'

@description('Name of the network security group')
param nsgName string

var isubs = [
  '10.1.0.0/24'
  '10.2.0.0/24'
]
var esubs = [
  '10.5.0.0/24'
  '10.6.0.0/24'
]

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgName
  location: location
  tags: {
    location: 'useast'
    zone: 'internal'
  }
  properties: {
    securityRules: [
      {
        name: 'BatchNodeManagement2'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '29876-29877'
          sourceAddressPrefixes: isubs
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'external-connection'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '29876-29877'
          sourceAddressPrefixes: esubs
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 140
          direction: 'Inbound'
        }
      }
      {
        name: 'external-connection-udp'
        properties: {
          protocol: 'udp'
          sourcePortRange: '*'
          destinationPortRange: '29876-29877'
          sourceAddressPrefixes: esubs
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 150
          direction: 'Inbound'
        }
      }
    ]
  }
}

output networkSecurityGroup string = nsg.id
