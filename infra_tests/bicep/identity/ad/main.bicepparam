using 'main.bicep' /*TODO: Provide a path to a bicep template*/

param location = 'norwayeast'
param virtualNetworkPeeringEnabled = false
param hubVirtualNetworkResourceId = '/subscriptions/4cb2be95-bb60-4223-8362-ec257c18f906/resourceGroups/rg-alz-connectivity/providers/Microsoft.Network/virtualHubs/alz-vhub-norwayeast'
param keyVaultName = 'kv-ad'

param tags = {
  serviceowner: 'Infrastructure Team'
  costcenter: '12345'
  environment: 'production'
}
