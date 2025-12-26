enum EnvType { dev, test, prod }

class EnvConfig {
  final String baseUrl;
  final bool enableLog;
  final String? proxy;

  const EnvConfig({required this.baseUrl, this.enableLog = true, this.proxy});

  static const EnvConfig dev = EnvConfig(
    baseUrl: 'https://bn-api-dev.boosterlabs.xyz',
    enableLog: true,
  );

  // static const EnvConfig test = EnvConfig(
  //   baseUrl: 'https://test-api.example.com',
  //   enableLog: true,
  // );

  static const EnvConfig prod = EnvConfig(
    baseUrl: 'https://api.vestorai.xyz',
    enableLog: false,
  );
}
