dependency "network" {
  config_path = "../0.network"

  mock_outputs = {
    subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
  }
}

inputs = {
  subnet_id = dependency.network.outputs.subnet_id
}
