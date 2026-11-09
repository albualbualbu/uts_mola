import 'package:flutter/material.dart';
import 'models/project_model.dart';
import 'screens/edit_screen.dart';
import 'screens/template_screen.dart';
import 'screens/proyek_screen.dart';
import 'screens/saya_screen.dart';

void main() {
  runApp(const CapCutApp());
}

class CapCutApp extends StatefulWidget {
  const CapCutApp({super.key});

  @override
  State<CapCutApp> createState() => _CapCutAppState();
}

class _CapCutAppState extends State<CapCutApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CapCut Clone',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color.fromARGB(255, 48, 204, 0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 44, 204, 0),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF00C4CC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C4CC),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: MainNavigationScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainNavigationScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late List<ProjectModel> _projects;

  @override
  void initState() {
    super.initState();
    _projects = ProjectModel.getInitialProjects();
  }

  void _addProject(ProjectModel newProject) {
    setState(() {
      _projects.insert(0, newProject);
    });
  }

  void _renameProject(String id, String newTitle) {
    setState(() {
      final index = _projects.indexWhere((p) => p.id == id);
      if (index != -1) {
        _projects[index].title = newTitle;
      }
    });
  }

  void _duplicateProject(ProjectModel project) {
    setState(() {
      _projects.insert(
        0,
        project.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: '${project.title} (Salinan)',
          date: 'Baru saja',
        ),
      );
    });
  }

  void _deleteProject(String id) {
    setState(() {
      _projects.removeWhere((p) => p.id == id);
    });
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          EditScreen(
            projects: _projects,
            onNavigateToProjects: () => _navigateToTab(2),
            onProjectCreated: _addProject,
          ),
          const TemplateScreen(),
          ProyekScreen(
            projects: _projects,
            onAddProject: _addProject,
            onRenameProject: _renameProject,
            onDuplicateProject: _duplicateProject,
            onDeleteProject: _deleteProject,
          ),
          SayaScreen(
            isDarkMode: widget.isDarkMode,
            onToggleDarkMode: widget.onToggleTheme,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141416) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
              width: 0.8,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF141416) : Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.shade500,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.content_cut_outlined),
              activeIcon: Icon(Icons.content_cut, color: Colors.black),
              label: 'Edit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.crop_portrait_outlined),
              activeIcon: Icon(Icons.crop_portrait, color: Colors.black),
              label: 'Template',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              activeIcon: Icon(Icons.folder, color: Colors.black),
              label: 'Proyek',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, color: Colors.black),
              label: 'Saya',
            ),
          ],
        ),
      ),
    );
  }
}
