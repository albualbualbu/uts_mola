import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../widgets/media_picker_sheet.dart';

class ProyekScreen extends StatefulWidget {
  final List<ProjectModel> projects;
  final Function(ProjectModel newProject)? onAddProject;
  final Function(String id, String newTitle)? onRenameProject;
  final Function(ProjectModel project)? onDuplicateProject;
  final Function(String id)? onDeleteProject;

  const ProyekScreen({
    super.key,
    required this.projects,
    this.onAddProject,
    this.onRenameProject,
    this.onDuplicateProject,
    this.onDeleteProject,
  });

  @override
  State<ProyekScreen> createState() => _ProyekScreenState();
}

class _ProyekScreenState extends State<ProyekScreen> {
  final List<String> _categoryTabs = [
    'Lokal',
    'Dihasilkan',
    'Ruang',
    'Galeri',
    'Sampah',
  ];
  int _selectedCategoryIndex = 0;

  final List<String> _filters = [
    'Semua',
    'Video',
    'Foto',
    'Template',
    'Kamera',
  ];
  String _selectedFilter = 'Semua';

  bool _isSelectionMode = false;
  final Set<String> _selectedProjectIds = {};

  List<ProjectModel> get _displayedProjects {
    if (_selectedFilter == 'Semua') {
      return widget.projects;
    } else if (_selectedFilter == 'Video') {
      return widget.projects.where((p) => p.type == 'video').toList();
    } else if (_selectedFilter == 'Foto') {
      return widget.projects.where((p) => p.type == 'photo').toList();
    } else if (_selectedFilter == 'Template') {
      return widget.projects.where((p) => p.type == 'template').toList();
    }
    return widget.projects;
  }

  void _showRenameDialog(ProjectModel project) {
    final textController = TextEditingController(text: project.title);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Ganti Nama Proyek'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nama Proyek',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00C4CC), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C4CC),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final newName = textController.text.trim();
              if (newName.isNotEmpty) {
                if (widget.onRenameProject != null) {
                  widget.onRenameProject!(project.id, newName);
                } else {
                  setState(() {
                    project.title = newName;
                  });
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Proyek diubah menjadi "$newName"'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(ProjectModel project) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Proyek?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus proyek "${project.title}"? Proyek akan dipindahkan ke Sampah.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (widget.onDeleteProject != null) {
                widget.onDeleteProject!(project.id);
              } else {
                setState(() {
                  widget.projects.removeWhere((p) => p.id == project.id);
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Proyek "${project.title}" telah dihapus.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDuplicateDialog(ProjectModel project) {
    if (widget.onDuplicateProject != null) {
      widget.onDuplicateProject!(project);
    } else {
      setState(() {
        widget.projects.insert(
          0,
          project.copyWith(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: '${project.title} (Salinan)',
            date: 'Baru saja',
          ),
        );
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proyek "${project.title}" berhasil diduplikasi.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showProjectMenu(ProjectModel project) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Ganti Nama'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showRenameDialog(project);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Duplikat'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDuplicateDialog(project);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Hapus', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDeleteConfirmation(project);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        title: const Text(
          'Proyek',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pencarian Proyek (Simulasi)'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Cari',
          ),
          IconButton(
            icon: const Icon(Icons.swap_vert, color: Colors.black87),
            onPressed: () {
              setState(() {
                widget.projects.sort((a, b) => b.title.compareTo(a.title));
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proyek diurutkan.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Urutkan',
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opsi Proyek Lainnya'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Lainnya',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Color(0xFF00C4CC)),
                        SizedBox(width: 8),
                        Text('Buat Karakter AI'),
                      ],
                    ),
                    content: const Text(
                      'Jadikan diri Anda, hewan peliharaan, dan karakter animasi menjadi video menarik menggunakan kecerdasan buatan CapCut.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Coba Sekarang'),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF6F8FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buat karakter AI',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Jadikan diri Anda, hewan peliharaan, dan ...',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categoryTabs.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                final title = _categoryTabs[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.black87 : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (isSelected)
                          Container(
                            height: 2.5,
                            width: 22,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? Colors.white : Colors.black)
                            : (isDark ? const Color(0xFF222226) : const Color(0xFFF2F4F7)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark ? Colors.grey.shade300 : Colors.black87),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_displayedProjects.length} proyek',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSelectionMode = !_isSelectionMode;
                      _selectedProjectIds.clear();
                    });
                  },
                  child: Text(
                    _isSelectionMode ? 'Selesai' : 'Pilih',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _isSelectionMode ? Colors.red : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E22) : const Color(0xFFF8FCFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0F7FA),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F7FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.cloud_outlined,
                          color: Color(0xFF00B4D8),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ruang',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Unggah dan kelola proyek Anda >',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.grey),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menu Ruang Cloud CapCut'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                ..._displayedProjects.map((p) {
                  final isChecked = _selectedProjectIds.contains(p.id);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (_isSelectionMode) {
                          setState(() {
                            if (isChecked) {
                              _selectedProjectIds.remove(p.id);
                            } else {
                              _selectedProjectIds.add(p.id);
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Membuka editor untuk "${p.title}"'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          if (_isSelectionMode)
                            Checkbox(
                              value: isChecked,
                              activeColor: const Color(0xFF00C4CC),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedProjectIds.add(p.id);
                                  } else {
                                    _selectedProjectIds.remove(p.id);
                                  }
                                });
                              },
                            ),

                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: p.coverColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                p.type == 'video'
                                    ? Icons.play_arrow
                                    : Icons.image,
                                color: Colors.white70,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.date,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.content_cut,
                                      size: 11,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${p.size}  |  ${p.duration}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.more_horiz, color: Colors.grey),
                            onPressed: () => _showProjectMenu(p),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00C4CC),
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () {
          MediaPickerSheet.show(
            context,
            title: 'Buat Proyek Baru',
            onConfirmed: (selectedName) {
              final newProj = ProjectModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: 'Proyek $selectedName',
                date: 'Hari ini',
                size: '15MB',
                duration: '00:30',
                type: 'video',
                coverColor: const Color(0xFF263238),
              );
              if (widget.onAddProject != null) {
                widget.onAddProject!(newProj);
              } else {
                setState(() {
                  widget.projects.insert(0, newProj);
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Proyek "${newProj.title}" berhasil dibuat!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          'Buat',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}
