import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isGoldTheme = true;
  String _language = 'ar';

  bool get isDarkMode => _isDarkMode;
  bool get isGoldTheme => _isGoldTheme;
  String get language => _language;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isGoldTheme = prefs.getBool('isGoldTheme') ?? true;
    _language = prefs.getString('language') ?? 'ar';
    notifyListeners();
  }

  // تبديل الوضع المظلم
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // تبديل الثيم الذهبي
  Future<void> toggleGoldTheme() async {
    _isGoldTheme = !_isGoldTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGoldTheme', _isGoldTheme);
    notifyListeners();
  }

  // تغيير اللغة
  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  // النصوص العربية
  Map<String, String> get ar => {
    'app_name': 'ورشة الذهب',
    'dashboard': 'الرئيسية',
    'customers': 'العملاء',
    'orders': 'الطلبات',
    'inventory': 'المخزون',
    'expenses': 'المصاريف',
    'workers': 'العمال',
    'reports': 'التقارير',
    'search': 'بحث...',
    'add_new': 'إضافة جديد',
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'delete': 'حذف',
    'edit': 'تعديل',
    'gold_price': 'سعر الذهب عيار 21',
    'sales': 'المبيعات',
    'purchases': 'المشتريات',
    'profit': 'صافي الربح',
    'settings': 'الإعدادات',
    'dark_mode': 'الوضع المظلم',
    'gold_theme': 'الثيم الذهبي',
    'language': 'اللغة',
    'arabic': 'العربية',
    'english': 'English',
    'about': 'حول التطبيق',
    'version': 'الإصدار 1.0.0',
    'no_results': 'لا توجد نتائج',
    'confirm_delete': 'هل أنت متأكد من الحذف؟',
    'success': 'تم بنجاح',
    'error': 'حدث خطأ',
    'close': 'إغلاق',
  };

  // النصوص الإنجليزية
  Map<String, String> get en => {
    'app_name': 'Gold Workshop',
    'dashboard': 'Dashboard',
    'customers': 'Customers',
    'orders': 'Orders',
    'inventory': 'Inventory',
    'expenses': 'Expenses',
    'workers': 'Workers',
    'reports': 'Reports',
    'search': 'Search...',
    'add_new': 'Add New',
    'save': 'Save',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'edit': 'Edit',
    'gold_price': 'Gold Price 21K',
    'sales': 'Sales',
    'purchases': 'Purchases',
    'profit': 'Net Profit',
    'settings': 'Settings',
    'dark_mode': 'Dark Mode',
    'gold_theme': 'Gold Theme',
    'language': 'Language',
    'arabic': 'العربية',
    'english': 'English',
    'about': 'About',
    'version': 'Version 1.0.0',
    'no_results': 'No results found',
    'confirm_delete': 'Are you sure you want to delete?',
    'success': 'Success',
    'error': 'Error occurred',
    'close': 'Close',
  };

  // الحصول على النص
  String t(String key) {
    final map = _language == 'ar' ? ar : en;
    return map[key] ?? key;
  }

  // الثيم الفاتح
  ThemeData get lightTheme {
    final primaryColor = _isGoldTheme ? Colors.amber : Colors.blue;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: primaryColor.withOpacity(0.8),
        surface: Colors.white,
        background: Colors.grey[50]!,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey[300],
        thickness: 1,
      ),
    );
  }

  // الثيم الداكن
  ThemeData get darkTheme {
    final primaryColor = _isGoldTheme ? Colors.amber : Colors.blue;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E1E1E),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor.withOpacity(0.9),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}