enum Environment {
  dev,
  staging,
  prod,
}

class EnvConfig {
  static const Environment _environment = Environment.dev;
  
  static bool get isDevelopment => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.prod;

  static String get apiHost {
    switch (_environment) {
      case Environment.dev:
        return 'https://dev-api.example.com';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.prod:
        return 'https://api.example.com';
      default:
        return 'https://api.example.com';
    }
  }

  static int get keepItemsDays {
    switch (_environment) {
      case Environment.dev:
        return 7;  // 开发环境保留7天
      case Environment.staging:
        return 14;  // 测试环境保留14天
      case Environment.prod:
        return 30;  // 生产环境保留30天
      default:
        return 30;
    }
  }

  // 可以添加更多环境相关的配置
} 