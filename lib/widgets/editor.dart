import 'package:flutter/material.dart';

import '../theme.dart';
import '../workspace.dart';

class PageEditor extends StatefulWidget {
  const PageEditor({super.key, required this.store});

  final WorkspaceStore store;

  @override
  State<PageEditor> createState() => _PageEditorState();
}

class _PageEditorState extends State<PageEditor> {
  late final TextEditingController _title;
  late final TextEditingController _body;
  late final VoidCallback _sync;

  WorkspaceStore get store => widget.store;

  @override
  void initState() {
    super.initState();
    final page = store.selected;
    _title = TextEditingController(text: page.title);
    _body = TextEditingController(text: page.body);
    _sync = () {
      final page = store.selected;
      if (_title.text != page.title) {
        _title.value = TextEditingValue(
          text: page.title,
          selection: TextSelection.collapsed(offset: page.title.length),
        );
      }
      if (_body.text != page.body) {
        _body.value = TextEditingValue(
          text: page.body,
          selection: TextSelection.collapsed(offset: page.body.length),
        );
      }
    };
    store.addListener(_sync);
  }

  @override
  void dispose() {
    store.removeListener(_sync);
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final page = store.selected;
        final updated = _formatUpdated(page.updatedAt);

        return ColoredBox(
          color: AppColors.bg,
          child: Column(
            children: [
              _TopBar(
                store: store,
                updated: updated,
                onMenu: () {
                  if (MediaQuery.sizeOf(context).width < 720) {
                    Scaffold.of(context).openDrawer();
                  } else {
                    store.toggleSidebar();
                  }
                },
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(48, 24, 48, 80),
                      children: [
                        Text(page.icon, style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _title,
                          onChanged: store.setTitle,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            color: AppColors.text,
                            letterSpacing: -0.6,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Untitled',
                            hintStyle: TextStyle(
                              color: AppColors.textFaint,
                              fontWeight: FontWeight.w700,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _body,
                          onChanged: store.setBody,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: AppColors.text,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type something…',
                            hintStyle: TextStyle(
                              color: AppColors.textFaint,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatUpdated(DateTime time) {
    final local = time.toLocal();
    final h = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final m = local.minute.toString().padLeft(2, '0');
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    return 'Edited $h:$m $ampm';
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.store,
    required this.updated,
    required this.onMenu,
  });

  final WorkspaceStore store;
  final String updated;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final page = store.selected;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenu,
            tooltip: 'Toggle sidebar',
            icon: const Icon(Icons.menu, size: 18),
          ),
          Text(
            page.icon,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              page.title.isEmpty ? 'Untitled' : page.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            updated,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textFaint,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: page.favorite ? 'Unfavorite' : 'Favorite',
            onPressed: () => store.toggleFavorite(page.id),
            icon: Icon(
              page.favorite ? Icons.star : Icons.star_border,
              size: 18,
              color: page.favorite
                  ? const Color(0xFFF2C94C)
                  : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
