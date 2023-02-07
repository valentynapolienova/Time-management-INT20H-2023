import 'package:fimber/fimber.dart';

enum Configs {
  local,
  dev,
  prod,
  staging,
}

abstract class AppConfig {
  AppConfig._({
    required this.apiHostName,
    required this.isProductionEnvironment,
  });

  final String apiHostName;
  final bool isProductionEnvironment;

  String get api => 'http://$apiHostName';

  static AppConfig get init => _getForFlavor;

  static AppConfig get _getForFlavor {
    Configs flavor = Configs.values.firstWhere(
      (e) =>
          e.toString() ==
          "Configs.${const String.fromEnvironment('envFlavour', defaultValue: 'prod')}",
    );

    switch (flavor) {
      case Configs.dev:
        Fimber.plantTree(DebugTree());
        Fimber.e('debug mode');
        return DevConfig();
      case Configs.prod:
        Fimber.e('release mode');
        return ProdConfig();
      default:
        throw UnimplementedError();
    }
  }
}

class DevConfig extends AppConfig {
  DevConfig()
      : super._(
          apiHostName:
              'deltaplan-env.eba-8xhutzd9.eu-central-1.elasticbeanstalk.com',
          isProductionEnvironment: false,
        );
}

class ProdConfig extends AppConfig {
  ProdConfig()
      : super._(
          apiHostName:
              'deltaplan-env.eba-8xhutzd9.eu-central-1.elasticbeanstalk.com',
          isProductionEnvironment: true,
        );
}
