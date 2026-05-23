const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://54.193.8.75:5000',
);

Uri apiUri(String path) {
  final base = apiBaseUrl.endsWith('/')
      ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
      : apiBaseUrl;
  final normalizedPath = path.startsWith('/') ? path : '/$path';
  return Uri.parse('$base$normalizedPath');
}
