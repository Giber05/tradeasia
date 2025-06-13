# Network Layer

This module contains the networking components for the application. It follows clean architecture principles and is designed to be maintainable and testable.

## Structure

- **client/**: Contains the Dio HTTP client implementation

  - `dio_api_client.dart`: Main Dio implementation of API client that implements the original APIClient interface directly

- **constants/**: Contains constants used by the network layer

  - `network_constants.dart`: Timeout values, header names, and other constants

- **interceptors/**: Contains Dio interceptors for authentication, logging, etc.

  - `auth_interceptor.dart`: Adds authorization headers to requests
  - `logging_interceptor.dart`: Logs request and response details

- **models/**: Contains data models used by the network layer
  - `multipart_file_model.dart`: Models for multipart file uploads

## Features

1. **Centralized Error Handling**: All error handling is centralized in the DioApiClient class
2. **Logging**: Comprehensive logging of requests and responses
3. **Interceptors**: Authentication, logging, and other interceptors
4. **Timeout Settings**: Configurable timeout settings
5. **Request Inspector**: Integration with requests_inspector for debugging in the UI
   - View all network requests and responses directly in the app during development
   - Shake device or use floating action button to access inspector panel

## Usage

The network layer is designed to be used through dependency injection. It preserves the same interface as the original networking layer, making the migration transparent to the rest of the app.

```dart
// Example usage in a repository:
@Injectable(as: ProjectRemoteDts)
class ProjectRemoteDtsImpl implements ProjectRemoteDts {
  final APIClient _apiClient;

  ProjectRemoteDtsImpl(this._apiClient);

  @override
  Future<APIResult<List<ProjectModel>>> getProjects(UserSessionModel session) {
    return _apiClient.get(
      path: '/project',
      session: session,
      shouldPrint: true,
      mapper: (json, _) => ProjectRemoteMapper().fromJSONList(json['data']['data']),
    );
  }
}
```

## Using Request Inspector

The network layer integrates with the `requests_inspector` package to provide runtime inspection of network requests:

1. In debug mode, shake your device or use the floating action button to open the inspector
2. View all network requests, their responses, and details
3. Filter requests by status code, method, etc.

## Benefits of Dio over HTTP

This implementation migrates the application from using the `http` package to `dio` while preserving the API interface. The benefits include:

1. Better error handling with typed exceptions
2. Built-in support for request cancellation
3. Robust interceptor system
4. Timeout configuration
5. Streamlined multipart request handling
6. Better debugging with Request Inspector
7. Simpler API for common operations
