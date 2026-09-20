import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';
import 'theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: themeProvider.t('app_name'),
          debugShowCheckedModeBanner: false,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}

// ==================== الصفحة الرئيسية ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper.instance;
  int currentIndex = 0;

  final List<IconData> navIcons = [
    Icons.dashboard,
    Icons.people,
    Icons.shopping_cart,
    Icons.inventory_2,
    Icons.money_off,
    Icons.engineering,
    Icons.bar_chart,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final screens = [
      const DashboardScreen(),
      const CustomersScreen(),
      const OrdersScreen(),
      const InventoryScreen(),
      const ExpensesScreen(),
      const WorkersScreen(),
      const ReportsScreen(),
    ];

    final titles = [
      themeProvider.t('dashboard'),
      themeProvider.t('customers'),
      themeProvider.t('orders'),
      themeProvider.t('inventory'),
      themeProvider.t('expenses'),
      themeProvider.t('workers'),
      themeProvider.t('reports'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
        destinations: List.generate(7, (index) {
          return NavigationDestination(
            icon: Icon(navIcons[index]),
            label: titles[index],
          );
        }),
      ),
    );
  }
}

// ==================== الشاشة الجانبية - مُصلحة 100% ====================
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Drawer(
          child: SafeArea(
            child: Column(
              children: [
                // ===== Header =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        themeProvider.isGoldTheme ? Colors.amber : Colors.blue,
                        themeProvider.isGoldTheme ? Colors.orange : Colors.blueAccent,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.store,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        themeProvider.t('app_name'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gold Workshop Management',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== Settings =====
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // عنوان الإعدادات
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Text(
                          themeProvider.t('settings'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),

                      // الوضع المظلم - شغال 100%
                      _buildSettingTile(
                        icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        title: themeProvider.t('dark_mode'),
                        value: themeProvider.isDarkMode ? 'مفعل' : 'معطل',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleDarkMode();
                          },
                          activeColor: themeProvider.isGoldTheme ? Colors.amber : Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // الثيم الذهبي - شغال 100%
                      _buildSettingTile(
                        icon: Icons.palette,
                        title: themeProvider.t('gold_theme'),
                        value: themeProvider.isGoldTheme ? 'مفعل' : 'معطل',
                        trailing: Switch(
                          value: themeProvider.isGoldTheme,
                          onChanged: (value) {
                            themeProvider.toggleGoldTheme();
                          },
                          activeColor: themeProvider.isGoldTheme ? Colors.amber : Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // عنوان اللغة
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Text(
                          themeProvider.t('language'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),

                      // اللغة العربية - شغال 100%
                      _buildLanguageTile(
                        title: themeProvider.t('arabic'),
                        code: 'ar',
                        isSelected: themeProvider.language == 'ar',
                        onTap: () {
                          themeProvider.setLanguage('ar');
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 8),

                      // اللغة الإنجليزية - شغال 100%
                      _buildLanguageTile(
                        title: themeProvider.t('english'),
                        code: 'en',
                        isSelected: themeProvider.language == 'en',
                        onTap: () {
                          themeProvider.setLanguage('en');
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // عنوان حول التطبيق
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: Text(
                          themeProvider.t('about'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),

                      // معلومات التطبيق
                      _buildInfoTile(
                        icon: Icons.info_outline,
                        title: themeProvider.t('version'),
                      ),
                    ],
                  ),
                ),

                // ===== زر الإغلاق =====
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: Text(themeProvider.t('close')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // بناء عنصر الإعداد
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String value,
    required Widget trailing,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: themeProvider.isGoldTheme ? Colors.amber : Colors.blue,
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: TextStyle(
            color: value == 'مفعل' || value == 'Enabled'
                ? Colors.green
                : Colors.grey,
            fontSize: 12,
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  // بناء عنصر اللغة
  Widget _buildLanguageTile({
    required String title,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? (themeProvider.isGoldTheme ? Colors.amber : Colors.blue).withOpacity(0.1)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? (themeProvider.isGoldTheme ? Colors.amber : Colors.blue)
              : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.language,
          color: isSelected
              ? (themeProvider.isGoldTheme ? Colors.amber : Colors.blue)
              : Colors.grey,
        ),
        title: Text(title),
        trailing: isSelected
            ? Icon(
          Icons.check_circle,
          color: themeProvider.isGoldTheme ? Colors.amber : Colors.blue,
        )
            : null,
        onTap: onTap,
      ),
    );
  }

  // بناء عنصر المعلومات
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }
}

// ==================== باقي الشاشات ====================

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final db = DatabaseHelper.instance;
  double goldPrice = 245;
  Map<String, dynamic> stats = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      goldPrice = await db.getGoldPrice();
      stats = await db.getReports();
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // سعر الذهب
            Card(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      themeProvider.isGoldTheme ? Colors.amber : Colors.blue,
                      themeProvider.isGoldTheme ? Colors.orange : Colors.blueAccent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.white, size: 30),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              themeProvider.t('gold_price'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () => _showEditPriceDialog(themeProvider),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$goldPrice ريال',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // الإحصائيات
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildStatCard(themeProvider.t('sales'), stats['sales'] ?? 0, Colors.green, Icons.trending_up),
                _buildStatCard(themeProvider.t('purchases'), stats['purchases'] ?? 0, Colors.red, Icons.trending_down),
                _buildStatCard(themeProvider.t('expenses'), stats['expenses'] ?? 0, Colors.orange, Icons.money_off),
                _buildStatCard(themeProvider.t('profit'), stats['profit'] ?? 0,
                    (stats['profit'] ?? 0) >= 0 ? Colors.blue : Colors.red,
                    Icons.account_balance_wallet),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, double value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              '${value.toStringAsFixed(0)} ريال',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPriceDialog(ThemeProvider themeProvider) {
    final controller = TextEditingController(text: goldPrice.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('edit')),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(suffixText: 'ريال'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPrice = double.tryParse(controller.text);
              if (newPrice != null && newPrice > 0) {
                await db.updateGoldPrice(newPrice);
                Navigator.pop(context);
                loadData();
              }
            },
            child: Text(themeProvider.t('save')),
          ),
        ],
      ),
    );
  }
}

// ==================== شاشة العملاء مع البحث ====================
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final db = DatabaseHelper.instance;
  List<Map<String, dynamic>> allCustomers = [];
  List<Map<String, dynamic>> filteredCustomers = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      allCustomers = await db.getCustomers();
      filteredCustomers = List.from(allCustomers);
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  void _filterCustomers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCustomers = List.from(allCustomers);
      } else {
        filteredCustomers = allCustomers.where((customer) {
          final name = (customer['name'] as String).toLowerCase();
          final phone = (customer['phone'] ?? '').toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search) || phone.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(themeProvider),
        icon: const Icon(Icons.add),
        label: Text(themeProvider.t('add_new')),
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _filterCustomers,
              decoration: InputDecoration(
                hintText: themeProvider.t('search'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filterCustomers('');
                  },
                )
                    : null,
              ),
            ),
          ),

          // قائمة العملاء
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCustomers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    searchController.text.isEmpty
                        ? 'لا يوجد عملاء'
                        : themeProvider.t('no_results'),
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: loadCustomers,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = filteredCustomers[index];
                  final balance = (customer['balance'] as num).toDouble();
                  final isDebt = balance > 0;
                  final isCredit = balance < 0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          (customer['name'] as String)[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        customer['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(customer['phone'] ?? 'لا يوجد هاتف'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDebt
                              ? Colors.red.withOpacity(0.1)
                              : isCredit
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${balance.abs().toStringAsFixed(0)} ${isDebt ? 'عليه' : isCredit ? 'له' : ''}',
                          style: TextStyle(
                            color: isDebt ? Colors.red : isCredit ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onLongPress: () => _deleteCustomer(customer['id'], themeProvider),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(ThemeProvider themeProvider) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('add_new')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'الاسم *'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'الهاتف'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال الاسم')),
                );
                return;
              }
              await db.addCustomer(nameCtrl.text.trim(), phoneCtrl.text.trim());
              Navigator.pop(context);
              loadCustomers();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(themeProvider.t('success'))),
              );
            },
            child: Text(themeProvider.t('save')),
          ),
        ],
      ),
    );
  }

  void _deleteCustomer(int id, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('delete')),
        content: Text(themeProvider.t('confirm_delete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await db.deleteCustomer(id);
              Navigator.pop(context);
              loadCustomers();
            },
            child: Text(themeProvider.t('delete'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ==================== باقي الشاشات (نفس النمط) ====================

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final db = DatabaseHelper.instance;
  List<Map<String, dynamic>> allOrders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      allOrders = await db.getOrders();
      filteredOrders = List.from(allOrders);
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  void _filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOrders = List.from(allOrders);
      } else {
        filteredOrders = allOrders.where((order) {
          final name = (order['customer_name'] as String).toLowerCase();
          final desc = (order['description'] ?? '').toLowerCase();
          final type = (order['type'] as String).toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search) || desc.contains(search) || type.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(themeProvider),
        icon: const Icon(Icons.add),
        label: Text(themeProvider.t('add_new')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _filterOrders,
              decoration: InputDecoration(
                hintText: themeProvider.t('search'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filterOrders('');
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredOrders.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    searchController.text.isEmpty
                        ? 'لا يوجد طلبات'
                        : themeProvider.t('no_results'),
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: loadOrders,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  final isSell = order['type'] == 'بيع';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSell ? Colors.green : Colors.red,
                        child: Icon(
                          isSell ? Icons.arrow_upward : Icons.arrow_downward,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(order['customer_name']),
                      subtitle: Text('${order['type']} - ${order['description'] ?? ''}'),
                      trailing: Text(
                        '${(order['amount'] as num).toStringAsFixed(0)} ريال',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onLongPress: () => _deleteOrder(order['id'], themeProvider),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(ThemeProvider themeProvider) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final weightCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String type = 'بيع';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(themeProvider.t('add_new')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'بيع', label: Text('بيع')),
                    ButtonSegment(value: 'شراء', label: Text('شراء')),
                  ],
                  selected: {type},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() => type = newSelection.first);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'اسم العميل *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'الوصف'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: weightCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الوزن',
                    suffixText: 'جرام',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  decoration: const InputDecoration(
                    labelText: 'المبلغ *',
                    suffixText: 'ريال',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(themeProvider.t('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty || amountCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إدخال الاسم والمبلغ')),
                  );
                  return;
                }
                await db.addOrder(
                  nameCtrl.text.trim(),
                  type,
                  descCtrl.text.trim(),
                  double.tryParse(weightCtrl.text) ?? 0,
                  double.tryParse(amountCtrl.text) ?? 0,
                );
                Navigator.pop(context);
                loadOrders();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(themeProvider.t('success'))),
                );
              },
              child: Text(themeProvider.t('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteOrder(int id, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('delete')),
        content: Text(themeProvider.t('confirm_delete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await db.deleteOrder(id);
              Navigator.pop(context);
              loadOrders();
            },
            child: Text(themeProvider.t('delete'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final db = DatabaseHelper.instance;
  List<Map<String, dynamic>> allInventory = [];
  List<Map<String, dynamic>> filteredInventory = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadInventory();
  }

  Future<void> loadInventory() async {
    try {
      allInventory = await db.getInventory();
      filteredInventory = List.from(allInventory);
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  void _filterInventory(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredInventory = List.from(allInventory);
      } else {
        filteredInventory = allInventory.where((item) {
          final name = (item['name'] as String).toLowerCase();
          final type = (item['type'] as String).toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search) || type.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(themeProvider),
        icon: const Icon(Icons.add),
        label: Text(themeProvider.t('add_new')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _filterInventory,
              decoration: InputDecoration(
                hintText: themeProvider.t('search'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filterInventory('');
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredInventory.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    searchController.text.isEmpty
                        ? 'المخزون فارغ'
                        : themeProvider.t('no_results'),
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: loadInventory,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredInventory.length,
                itemBuilder: (context, index) {
                  final item = filteredInventory[index];
                  final isGold = item['type'] == 'ذهب';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isGold ? Colors.amber : Colors.grey,
                        child: Icon(
                          isGold ? Icons.monetization_on : Icons.diamond,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(item['name']),
                      subtitle: Text('${item['type']} - ${item['weight']}g'),
                      trailing: Text('${item['labor_cost'].toStringAsFixed(0)} ريال'),
                      onLongPress: () => _deleteItem(item['id'], themeProvider),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(ThemeProvider themeProvider) {
    final nameCtrl = TextEditingController();
    final weightCtrl = TextEditingController();
    final karatCtrl = TextEditingController(text: '21');
    final laborCtrl = TextEditingController();
    String type = 'ذهب';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(themeProvider.t('add_new')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'الاسم *'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(labelText: 'النوع'),
                  items: ['ذهب', 'فضة', 'حجر']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => type = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: weightCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الوزن *',
                    suffixText: 'جرام',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                if (type == ' الذهب') ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: karatCtrl,
                    decoration: const InputDecoration(labelText: 'العيار'),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: laborCtrl,
                  decoration: const InputDecoration(
                    labelText: 'أجرة الصياغة',
                    suffixText: 'ريال',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(themeProvider.t('cancel')),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty || weightCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إدخال الاسم والوزن')),
                  );
                  return;
                }
                await db.addInventory(
                  nameCtrl.text.trim(),
                  type,
                  double.parse(weightCtrl.text),
                  int.tryParse(karatCtrl.text) ?? 21,
                  double.tryParse(laborCtrl.text) ?? 0,
                );
                Navigator.pop(context);
                loadInventory();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(themeProvider.t('success'))),
                );
              },
              child: Text(themeProvider.t('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteItem(int id, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('delete')),
        content: Text(themeProvider.t('confirm_delete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await db.deleteInventory(id);
              Navigator.pop(context);
              loadInventory();
            },
            child: Text(themeProvider.t('delete'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});
  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final db = DatabaseHelper.instance;
  List<Map<String, dynamic>> allExpenses = [];
  List<Map<String, dynamic>> filteredExpenses = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      allExpenses = await db.getExpenses();
      filteredExpenses = List.from(allExpenses);
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  void _filterExpenses(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExpenses = List.from(allExpenses);
      } else {
        filteredExpenses = allExpenses.where((expense) {
          final title = (expense['title'] as String).toLowerCase();
          final notes = (expense['notes'] ?? '').toLowerCase();
          final search = query.toLowerCase();
          return title.contains(search) || notes.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(themeProvider),
        icon: const Icon(Icons.add),
        label: Text(themeProvider.t('add_new')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _filterExpenses,
              decoration: InputDecoration(
                hintText: themeProvider.t('search'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filterExpenses('');
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredExpenses.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    searchController.text.isEmpty
                        ? 'لا يوجد مصاريف'
                        : themeProvider.t('no_results'),
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: loadExpenses,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredExpenses.length,
                itemBuilder: (context, index) {
                  final expense = filteredExpenses[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.money_off, color: Colors.white),
                      ),
                      title: Text(expense['title']),
                      subtitle: Text(expense['notes'] ?? ''),
                      trailing: Text(
                        '${(expense['amount'] as num).toStringAsFixed(0)} ريال',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      onLongPress: () => _deleteExpense(expense['id'], themeProvider),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(ThemeProvider themeProvider) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('add_new')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'البيان *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(
                labelText: 'المبلغ *',
                suffixText: 'ريال',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(labelText: 'ملاحظات'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty || amountCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال البيان والمبلغ')),
                );
                return;
              }
              await db.addExpense(
                titleCtrl.text.trim(),
                double.parse(amountCtrl.text),
                notesCtrl.text.trim(),
              );
              Navigator.pop(context);
              loadExpenses();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(themeProvider.t('success'))),
              );
            },
            child: Text(themeProvider.t('save')),
          ),
        ],
      ),
    );
  }

  void _deleteExpense(int id, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('delete')),
        content: Text(themeProvider.t('confirm_delete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await db.deleteExpense(id);
              Navigator.pop(context);
              loadExpenses();
            },
            child: Text(themeProvider.t('delete'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});
  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  final db = DatabaseHelper.instance;
  List<Map<String, dynamic>> allWorkers = [];
  List<Map<String, dynamic>> filteredWorkers = [];
  bool isLoading = true;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWorkers();
  }

  Future<void> loadWorkers() async {
    try {
      allWorkers = await db.getWorkers();
      filteredWorkers = List.from(allWorkers);
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  void _filterWorkers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWorkers = List.from(allWorkers);
      } else {
        filteredWorkers = allWorkers.where((worker) {
          final name = (worker['name'] as String).toLowerCase();
          final specialty = (worker['specialty'] ?? '').toLowerCase();
          final phone = (worker['phone'] ?? '').toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search) || specialty.contains(search) || phone.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(themeProvider),
        icon: const Icon(Icons.add),
        label: Text(themeProvider.t('add_new')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _filterWorkers,
              decoration: InputDecoration(
                hintText: '${themeProvider.t('search')} (اسم، تخصص، هاتف)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filterWorkers('');
                  },
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredWorkers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    searchController.text.isEmpty
                        ? 'لا يوجد عمال'
                        : themeProvider.t('no_results'),
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: loadWorkers,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredWorkers.length,
                itemBuilder: (context, index) {
                  final worker = filteredWorkers[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.engineering, color: Colors.white),
                      ),
                      title: Text(worker['name']),
                      subtitle: Text('${worker['specialty'] ?? 'بدون تخصص'} - ${worker['phone'] ?? ''}'),
                      trailing: Text(
                        '${(worker['salary'] as num).toStringAsFixed(0)} ريال',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onLongPress: () => _deleteWorker(worker['id'], themeProvider),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(ThemeProvider themeProvider) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final salaryCtrl = TextEditingController();
    final specialtyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('add_new')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'الاسم *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'الهاتف'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: salaryCtrl,
              decoration: const InputDecoration(
                labelText: 'الراتب *',
                suffixText: 'ريال',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: specialtyCtrl,
              decoration: const InputDecoration(labelText: 'التخصص'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty || salaryCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال الاسم والراتب')),
                );
                return;
              }
              await db.addWorker(
                nameCtrl.text.trim(),
                phoneCtrl.text.trim(),
                double.parse(salaryCtrl.text),
                specialtyCtrl.text.trim(),
              );
              Navigator.pop(context);
              loadWorkers();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(themeProvider.t('success'))),
              );
            },
            child: Text(themeProvider.t('save')),
          ),
        ],
      ),
    );
  }

  void _deleteWorker(int id, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(themeProvider.t('delete')),
        content: Text(themeProvider.t('confirm_delete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(themeProvider.t('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await db.deleteWorker(id);
              Navigator.pop(context);
              loadWorkers();
            },
            child: Text(themeProvider.t('delete'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final db = DatabaseHelper.instance;
  Map<String, dynamic> reports = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    try {
      reports = await db.getReports();
    } catch (e) {
      print('Error: $e');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: loadReports,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReportCard(
              themeProvider.t('sales'),
              reports['sales'] ?? 0,
              Colors.green,
              Icons.trending_up,
            ),
            _buildReportCard(
              themeProvider.t('purchases'),
              reports['purchases'] ?? 0,
              Colors.red,
              Icons.trending_down,
            ),
            _buildReportCard(
              themeProvider.t('expenses'),
              reports['expenses'] ?? 0,
              Colors.orange,
              Icons.money_off,
            ),
            _buildReportCard(
              themeProvider.t('profit'),
              reports['profit'] ?? 0,
              (reports['profit'] ?? 0) >= 0 ? Colors.blue : Colors.red,
              Icons.account_balance_wallet,
            ),
            _buildReportCard(
              themeProvider.t('inventory'),
              '${(reports['gold_weight'] ?? 0).toStringAsFixed(2)} جرام',
              Colors.amber,
              Icons.scale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(String title, dynamic value, Color color, IconData icon) {
    final displayValue = value is double ? value.toStringAsFixed(0) : value.toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Text(
          displayValue.contains('جرام') ? displayValue : '$displayValue ريال',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}