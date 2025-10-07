import '../../../../core/constants/app_constants.dart';

class AppSettings {
  final double fontSize;
  final bool isDarkMode;

  AppSettings({
    required this.fontSize,
    required this.isDarkMode,
  });

  factory AppSettings.defaultSettings() {
    return AppSettings(
      fontSize: AppConstants.defaultFontSize,
      isDarkMode: AppConstants.defaultDarkMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'isDarkMode': isDarkMode,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      fontSize: json['fontSize'] as double? ?? AppConstants.defaultFontSize,
      isDarkMode: json['isDarkMode'] as bool? ?? AppConstants.defaultDarkMode,
    );
  }

  AppSettings copyWith({
    double? fontSize,
    bool? isDarkMode,
  }) {
    return AppSettings(
      fontSize: fontSize ?? this.fontSize,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}