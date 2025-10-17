class AppConstants {
  static const String appName = 'ZDatar Marketplace';
  static const String appVersion = '1.0.0';
  
  // Hive Box Names
  static const String userBox = 'user_box';
  static const String datasetBox = 'dataset_box';
  static const String transactionBox = 'transaction_box';
  
  // API Endpoints
  static const String baseUrl = 'https://api.zdatar.com';
  static const String solanaRpcUrl = 'https://api.mainnet-beta.solana.com';
  
  // Blockchain
  static const String zdatarTokenMint = 'ZDATARTokenMintAddress';
  static const String marketplaceProgramId = 'MarketplaceProgramId';
  
  // Data Categories
  static const List<String> dataCategories = [
    'Location',
    'Motion',
    'Health',
    'App Usage',
    'Battery',
    'Network',
    'Device Info',
    'Sensor Data',
  ];
  
  // Supported Tokens
  static const List<String> supportedTokens = [
    'SOL',
    'USDC',
    'ZDATA',
  ];
  
  // File Limits
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB
  static const List<String> supportedFileTypes = [
    'json',
    'csv',
    'parquet',
    'zip',
  ];
}
