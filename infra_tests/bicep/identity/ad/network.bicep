@description('Optional. The location to deploy resources to.')
param location string = 'norwayeast'
param virtualNetworkPeeringEnabled bool
param hubVirtualNetworkResourceId string

@description('Required Tags')
param tags object = {
  serviceowner: 'Infrastructure Services'
  service: 'Domain Controller'
  costcenter: '60132'
  environment: 'production'
}

module nsgdc 'br/public:avm/res/network/network-security-group:0.4.0' = {
  name: 'nsg-dc-deployment'
  params: {
    // Required parameters
    name: 'nsg-domaincontroller'
    // Non-required parameters
    location: location
    securityRules: [
      {
        name: 'Allow-All-Inbound-TCP-10_'
        properties: {
          access: 'Allow'
          description: 'Allow All Inbound'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: '10.0.0.0/8'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Inbound-TCP-172_'
        properties: {
          access: 'Allow'
          description: 'Allow All Inbound'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 110
          protocol: 'Tcp'
          sourceAddressPrefix: '172.16.0.0/12'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Inbound-UDP-10_'
        properties: {
          access: 'Allow'
          description: 'Allow All Inbound'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 120
          protocol: 'Udp'
          sourceAddressPrefix: '10.0.0.0/8'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Inbound-UDP-172_'
        properties: {
          access: 'Allow'
          description: 'Allow All Inbound'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 130
          protocol: 'Udp'
          sourceAddressPrefix: '172.16.0.0/12'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Inbound-10-ICMP'
        properties: {
          access: 'Allow'
          description: 'Allow All Inbound'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 140
          protocol: 'Icmp'
          sourceAddressPrefix: '10.0.0.0/8'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Inbound-172-ICMP'
        properties: {
          access: 'Allow'
          description: 'Allow All Inbound'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 150
          protocol: 'Icmp'
          sourceAddressPrefix: '172.16.0.0/12'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Deny-All-Inbound'
        properties: {
          access: 'Deny'
          description: 'Default deny all inbound traffic'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 4096
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Outbound-TCP-10_'
        properties: {
          access: 'Allow'
          description: 'Allow All Outbound'
          destinationAddressPrefix: '10.0.0.0/8'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Outbound-TCP-172_'
        properties: {
          access: 'Allow'
          description: 'Allow All Outbound'
          destinationAddressPrefix: '172.16.0.0/12'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 110
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Outbound-10_'
        properties: {
          access: 'Allow'
          description: 'Allow All Outbound UDP'
          destinationAddressPrefix: '10.0.0.0/8'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 120
          protocol: 'Udp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Outbound-172_'
        properties: {
          access: 'Allow'
          description: 'Allow All Outbound UDP'
          destinationAddressPrefix: '172.16.0.0/12'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 130
          protocol: 'Udp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Outbound-10-ICMP'
        properties: {
          access: 'Allow'
          description: 'Allow All Outbound ICMP'
          destinationAddressPrefix: '10.0.0.0/8'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 140
          protocol: 'Icmp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-All-Outbound-172-ICMP'
        properties: {
          access: 'Allow'
          description: 'Allow All Outbound ICMP'
          destinationAddressPrefix: '172.16.0.0/12'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 150
          protocol: 'Icmp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-KMS-Outbound-TCP1688_'
        properties: {
          access: 'Allow'
          description: 'Allow KMS Outbound TCP1688'
          destinationAddressPrefixes: [
            '20.118.99.224/32'
            '40.83.235.53/32'
            '23.102.135.246/32'
          ]
          destinationPortRange: '1688'
          direction: 'Outbound'
          priority: 180
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Deny-All-Outbound'
        properties: {
          access: 'Deny'
          description: 'Default deny all inbound traffic'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 4096
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
    tags: tags
  }
}
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.2.0' = {
  name: 'vnet-ad-deployment'
  params: {
    name: 'vnet-ad'
    location: location
    addressPrefixes: [
      '10.48.12.0/24'
    ]
    subnets: [
      {
        addressPrefix: '10.48.12.0/26'
        name: 'snet-domaincontrollers'
        networkSecurityGroupResourceId: nsgdc.outputs.resourceId
      }
    ]
    dnsServers: [
      '172.16.2.3'
      '172.16.2.4'
    ]

    peerings: (virtualNetworkPeeringEnabled)
      ? [
          {
            allowForwardedTraffic: true
            allowVirtualNetworkAccess: true
            allowGatewayTransit: false
            useRemoteGateways: true
            remotePeeringEnabled: virtualNetworkPeeringEnabled
            remoteVirtualNetworkId: hubVirtualNetworkResourceId
            remotePeeringAllowForwardedTraffic: true
            remotePeeringAllowVirtualNetworkAccess: true
            remotePeeringAllowGatewayTransit: true
            remotePeeringUseRemoteGateways: false
          }
        ]
      : []
    tags: tags
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.outputs.subnetResourceIds[0]

@description('The resource ID of the created Virtual Network .')
output vnetResourceId string = virtualNetwork.outputs.resourceId
