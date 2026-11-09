import 'package:flutter/material.dart';

class MediaPickerSheet extends StatefulWidget {
  final String title;
  final Function(String selectedItemName)? onConfirmed;

  const MediaPickerSheet({
    super.key,
    this.title = 'Pilih media',
    this.onConfirmed,
  });

  static Future<void> show(
    BuildContext context, {
    String title = 'Pilih media',
    Function(String selectedItemName)? onConfirmed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MediaPickerSheet(
        title: title,
        onConfirmed: onConfirmed,
      ),
    );
  }

  @override
  State<MediaPickerSheet> createState() => _MediaPickerSheetState();
}

class _MediaPickerSheetState extends State<MediaPickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _selectedIndices = {};

  final List<Map<String, dynamic>> _mockVideos = [
    {'title': 'VID_20261019_001.mp4', 'duration': '00:15', 'color': const Color(0xFF263238)},
    {'title': 'VID_20261018_002.mp4', 'duration': '00:32', 'color': const Color(0xFF37474F)},
    {'title': 'VID_20261017_003.mp4', 'duration': '01:05', 'color': const Color(0xFF455A64)},
    {'title': 'VID_20261016_004.mp4', 'duration': '00:08', 'color': const Color(0xFF546E7A)},
    {'title': 'VID_20261015_005.mp4', 'duration': '00:45', 'color': const Color(0xFF1E272C)},
    {'title': 'VID_20261014_006.mp4', 'duration': '00:20', 'color': const Color(0xFF2E3D44)},
  ];

  final List<Map<String, dynamic>> _mockPhotos = [
    {'title': 'IMG_20261019_001.jpg', 'color': const Color(0xFF5D4037)},
    {'title': 'IMG_20261018_002.jpg', 'color': const Color(0xFF6D4C41)},
    {'title': 'IMG_20261017_003.jpg', 'color': const Color(0xFF795548)},
    {'title': 'IMG_20261016_004.jpg', 'color': const Color(0xFF8D6E63)},
    {'title': 'IMG_20261015_005.jpg', 'color': const Color(0xFFA1887F)},
    {'title': 'IMG_20261014_006.jpg', 'color': const Color(0xFF4E342E)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF00C4CC),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF00C4CC),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Video'),
              Tab(text: 'Foto'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMediaGrid(_mockVideos, isVideo: true),
                _buildMediaGrid(_mockPhotos, isVideo: false),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF141416) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedIndices.isEmpty
                      ? 'Pilih satu atau lebih klip'
                      : '${_selectedIndices.length} item dipilih',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4CC),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _selectedIndices.isEmpty
                      ? null
                      : () {
                          final selectedName = _tabController.index == 0
                              ? _mockVideos[_selectedIndices.first]['title']
                              : _mockPhotos[_selectedIndices.first]['title'];
                          Navigator.pop(context);
                          if (widget.onConfirmed != null) {
                            widget.onConfirmed!(selectedName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Berhasil memilih ${_selectedIndices.length} media untuk simulasi editor.',
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                  child: Text(
                    _selectedIndices.isEmpty
                        ? 'Tambah'
                        : 'Tambah (${_selectedIndices.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid(List<Map<String, dynamic>> items, {required bool isVideo}) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = _selectedIndices.contains(index);

        return GestureDetector(
          onTap: () => _toggleSelection(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: item['color'] as Color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xFF00C4CC) : Colors.transparent,
                width: 3,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    isVideo ? Icons.videocam_outlined : Icons.image_outlined,
                    color: Colors.white70,
                    size: 32,
                  ),
                ),
                if (isVideo)
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['duration'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFF00C4CC) : Colors.black38,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.black,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
