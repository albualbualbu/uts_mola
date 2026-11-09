import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../widgets/media_picker_sheet.dart';

class EditScreen extends StatelessWidget {
  final List<ProjectModel> projects;
  final VoidCallback? onNavigateToProjects;
  final Function(ProjectModel newProject)? onProjectCreated;

  const EditScreen({
    super.key,
    required this.projects,
    this.onNavigateToProjects,
    this.onProjectCreated,
  });

  static const List<Map<String, dynamic>> _features = [
    {
      'title': 'AutoCut',
      'icon': Icons.movie_filter_outlined,
    },
    {
      'title': 'Retouch',
      'icon': Icons.face_retouching_natural_outlined,
    },
    {
      'title': 'Pembuat AI',
      'icon': Icons.auto_awesome_outlined,
    },
    {
      'title': 'Alat foto',
      'icon': Icons.photo_library_outlined,
    },
    {
      'title': 'Ambil gambar\ndan rekam',
      'icon': Icons.camera_alt_outlined,
    },
    {
      'title': 'Sempurnakan\nsecara otomatis',
      'icon': Icons.auto_fix_high_outlined,
    },
    {
      'title': 'Pembuat sampul',
      'icon': Icons.crop_original_outlined,
    },
    {
      'title': 'Keterangan\notomatis',
      'icon': Icons.subtitles_outlined,
    },
    {
      'title': 'Pemotong klip AI',
      'icon': Icons.content_cut_outlined,
    },
  ];

  void _showSimulationSnackBar(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur "$featureName" masih berupa simulasi.'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEditFotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.photo_outlined, color: Color(0xFF00C4CC)),
            SizedBox(width: 8),
            Text('Edit Foto (Simulasi)'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitur Edit Foto CapCut menyediakan alat retouch wajah, penghapus latar belakang AI, penyesuaian warna, dan efek estetis.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              'Versi: Nano Banana 2.1 (Preset Terpasang)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Mengerti',
              style: TextStyle(color: Color(0xFF00C4CC), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectDetail(BuildContext context, ProjectModel project) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: project.coverColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.movie_outlined, color: Colors.white70),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${project.date} • ${project.size} • ${project.duration}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showSimulationSnackBar(context, 'Buka Editor ${project.title}');
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Proyek'),
                  ),
                ),
                const SizedBox(width: 12),
                if (onNavigateToProjects != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C4CC),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        onNavigateToProjects!();
                      },
                      icon: const Icon(Icons.folder_open, size: 18),
                      label: const Text('Ke Proyek'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    right: 16,
                    bottom: 24,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 33, 188, 27),
                        Color.fromARGB(255, 0, 240, 36),
                        Color(0xFF00B4D8),
                        Color(0xFFF9FAFB),
                      ],
                      stops: [0.0, 0.45, 0.75, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _showSimulationSnackBar(
                                context,
                                'Coba Standar 7 Hari',
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.diamond,
                                      color: Color(0xFF00C4CC),
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Coba Standar selama 7 hari dengan biaya Rp0',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.search, color: Colors.white),
                              onPressed: () => _showSimulationSnackBar(
                                context,
                                'Pencarian Video/Efek',
                              ),
                              tooltip: 'Cari',
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Video create',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          MediaPickerSheet.show(
                            context,
                            title: 'Buat Video Baru',
                            onConfirmed: (name) {
                              if (onProjectCreated != null) {
                                onProjectCreated!(
                                  ProjectModel(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    title: 'Proyek $name',
                                    date: 'Hari ini',
                                    size: '8MB',
                                    duration: '00:15',
                                    type: 'video',
                                    coverColor: const Color(0xFF2E3D44),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Get started',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                MediaPickerSheet.show(
                                  context,
                                  title: 'Buat Video Baru',
                                  onConfirmed: (name) {
                                    if (onProjectCreated != null) {
                                      onProjectCreated!(
                                        ProjectModel(
                                          id: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          title: 'Video Baru ($name)',
                                          date: 'Hari ini',
                                          size: '12MB',
                                          duration: '00:20',
                                          type: 'video',
                                          coverColor: const Color(0xFF1E272C),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                              child: Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Video baru',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: GestureDetector(
                              onTap: () => _showEditFotoDialog(context),
                              child: Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 8, right: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'Nano Banana 2.1',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.photo_library_outlined,
                                              color: Colors.black87,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Edit foto',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: projects.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    if (index == projects.length) {
                      return GestureDetector(
                        onTap: onNavigateToProjects,
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6E4ED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.black54,
                            size: 28,
                          ),
                        ),
                      );
                    }

                    final p = projects[index];
                    return GestureDetector(
                      onTap: () => _showProjectDetail(context, p),
                      child: Container(
                        width: 72,
                        decoration: BoxDecoration(
                          color: p.coverColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                p.type == 'video'
                                    ? Icons.movie_outlined
                                    : Icons.image_outlined,
                                color: Colors.white24,
                                size: 36,
                              ),
                            ),
                            Positioned(
                              left: 4,
                              right: 4,
                              bottom: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.content_cut,
                                      size: 9,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Text(
                                        p.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final feature = _features[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showSimulationSnackBar(
                      context,
                      feature['title'].toString().replaceAll('\n', ' '),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A2A2E) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            feature['icon'] as IconData,
                            size: 26,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          feature['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
