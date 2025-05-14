abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  // Can use a package like connectivity_plus or data_connection_checker
  // to check the network status
  @override
  Future<bool> get isConnected async => true;
}
