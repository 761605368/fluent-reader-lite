class ServiceImport {
  String endpoint = '';
  String username = '';
  String password = '';
  String apiId = '';
  String apiKey = '';

  static const typeMap = {
    "f": "/settings/service/fever",
    "g": "/settings/service/greader",
    "i": "/settings/service/inoreader",
    "fb": "/settings/service/feedbin"
  };

  ServiceImport({
    this.endpoint = '',
    this.username = '',
    this.password = '',
    this.apiId = '',
    this.apiKey = '',
  });
}
