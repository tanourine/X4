import 'package:flutter/material.dart';

/// صفحة "العدة والأدوات" متكاملة للاستخدام داخل مشروع Flutter حقيقي
/// ضع الملف في `lib/pages/tools_equipment_page.dart` وسجل المسار في `main.dart`.

enum UserRole { admin, manager, technician, assistant }

/// نموذج بيانات الأداة
class Tool {
  String name;
  String? imagePath;
  Tool({required this.name, this.imagePath});
}

class ToolsEquipmentPage extends StatefulWidget {
  static const String routeName = '/tools_equipment';
  final UserRole role;
  const ToolsEquipmentPage({Key? key, required this.role}) : super(key: key);

  @override
  _ToolsEquipmentPageState createState() => _ToolsEquipmentPageState();
}

class _ToolsEquipmentPageState extends State<ToolsEquipmentPage> {
  final List<String> _technicians = [
    'Mohammed Kashif (محمد كاشف)',
    'Ali Urous (علي عروس)',
  ];
  final Map<String, List<Tool>> _toolsByTech = {
    'Mohammed Kashif (محمد كاشف)': [],
    'Ali Urous (علي عروس)': [],
  };
  static const int _requiredToolsCount = 3;

  void _showAddToolDialog() {
    String? selectedTech;
    final nameCtrl = TextEditingController();
    String? imageChoice;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Tool (إضافة أداة جديدة)'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Technician (الفني المسؤول)',
                  border: OutlineInputBorder(),
                ),
                items: _technicians
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => selectedTech = v,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tool Name * (اسم الأداة)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Attach Photo (الكاميرا/المعرض)'),
                onPressed: () async {
                  final choice = await showModalBottomSheet<String>(
                    context: ctx,
                    builder: (sheetCtx) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Camera (كاميرا)'),
                          onTap: () => Navigator.pop(sheetCtx, 'camera'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo),
                          title: const Text('Gallery (معرض)'),
                          onTap: () => Navigator.pop(sheetCtx, 'gallery'),
                        ),
                      ],
                    ),
                  );
                  if (choice != null) {
                    imageChoice = choice == 'camera'
                        ? 'Image from Camera'
                        : 'Image from Gallery';
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('Photo: \$imageChoice')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel (إلغاء)'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text('Save (حفظ)'),
            onPressed: () {
              final tech = selectedTech;
              final name = nameCtrl.text.trim();
              if (tech == null || name.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Fill all fields (املأ البيانات)')),
                );
                return;
              }
              setState(() {
                _toolsByTech[tech]!.add(Tool(name: name, imagePath: imageChoice));
              });
              print('Telegram -> Channel "صور تشييك العدة": Tool "\$name" for \$tech');
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  void _showUpdatePhotoDialog(String tech, Tool tool) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetCtx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera (كاميرا)'),
            onTap: () => Navigator.pop(sheetCtx, 'camera'),
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery (معرض)'),
            onTap: () => Navigator.pop(sheetCtx, 'gallery'),
          ),
        ],
      ),
    );
    if (choice != null) {
      setState(() {
        tool.imagePath =
            choice == 'camera' ? 'Updated from Camera' : 'Updated from Gallery';
      });
      print('Telegram -> Channel "صور تشييك العدة": Updated image for tool "\${tool.name}"');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo updated for \${tool.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tools & Equipment (العدة والأدوات)')),
        body: const Center(child: Text('Access Denied (غير مصرح)')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Tools & Equipment (العدة والأدوات)')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: _technicians.map((tech) {
            final tools = _toolsByTech[tech]!;
            final warning = tools.length < _requiredToolsCount;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('👨‍🔧 \$tech', style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    if (warning) const Icon(Icons.warning, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 8),
                if (tools.isEmpty)
                  const Text('No tools added (لم تتم إضافة أدوات)')
                else
                  ...tools.map((tool) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: tool.imagePath != null
                            ? const CircleAvatar(child: Icon(Icons.photo))
                            : const CircleAvatar(child: Icon(Icons.build)),
                        title: Text(tool.name),
                        subtitle: Text(tool.imagePath ?? 'No image'),
                        trailing: TextButton(
                          child: const Text('Update Photo (تحديث الصورة)'),
                          onPressed: () => _showUpdatePhotoDialog(tech, tool),
                        ),
                      ),
                    );
                  }).toList(),
                const Divider(),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddToolDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add New Tool (إضافة أداة جديدة)',
      ),
    );
  }
}

// ------------------------ main.dart ------------------------

void main() {
  runApp(const ToolsEquipmentApp());
}

class ToolsEquipmentApp extends StatelessWidget {
  const ToolsEquipmentApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tools & Equipment (العدة والأدوات)',
      debugShowCheckedModeBanner: false,
      initialRoute: ToolsEquipmentPage.routeName,
      routes: {
        ToolsEquipmentPage.routeName: (_) => const ToolsEquipmentPage(role: UserRole.admin),
      },
    );
  }
}
