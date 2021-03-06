/// Base url for environments
const _baseUrl = "baseUrl";

enum Environment { dev, stage, prod }

Map<String, dynamic>? _config;

void setEnvironment(Environment env) {
  switch (env) {
    case Environment.dev:
      _config = devConstants;
      break;
    case Environment.stage:
      _config = stageConstants;
      break;
    case Environment.prod:
      _config = prodConstants;
      break;
  }
}

dynamic get apiBaseUrl {
  return _config![_baseUrl];
}

Map<String, dynamic> devConstants = {
  _baseUrl: "https://jsonplaceholder.typicode.com/comments",
};

Map<String, dynamic> stageConstants = {
  _baseUrl: "https://jsonplaceholder.typicode.com/comments",
};

Map<String, dynamic> prodConstants = {
  _baseUrl: "https://jsonplaceholder.typicode.com/comments",
};
