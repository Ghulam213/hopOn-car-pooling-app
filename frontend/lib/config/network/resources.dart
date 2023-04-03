class Resource<T> {
  const Resource(this._ops, this._modelResponse, this._networkError);

  Resource.loading()
      : _ops = NetworkStatus.LOADING,
        _modelResponse = null,
        _networkError = "";

  Resource.idle()
      : _ops = NetworkStatus.IDLE,
        _modelResponse = null,
        _networkError = "";

  Resource.success(this._modelResponse)
      : _ops = NetworkStatus.SUCCESSFUL,
        _networkError = "";

  Resource.failed(this._networkError)
      : _ops = NetworkStatus.FAILED,
        _modelResponse = null;

  final NetworkStatus _ops;
  final T? _modelResponse;
  final String? _networkError;

  NetworkStatus get ops => _ops;
  T? get modelResponse => _modelResponse;
  String? get networkError => _networkError;
}

enum NetworkStatus { IDLE, LOADING, SUCCESSFUL, FAILED }
