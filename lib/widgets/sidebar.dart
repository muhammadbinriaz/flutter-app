import 'package:flutter/material.dart';

import '../models/page.dart';
import '../theme.dart';
import '../workspace.dart';

class WorkspaceSidebar extends StatelessWidget {
  const WorkspaceSidebar({
    super.key,
    required this.store,
    this.compact = false,
  });

  final WorkspaceStore store;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return Material(
          color: AppColors.sidebar,
          child: SafeArea(
            right: false,
            child: SizedBox(
              width: compact ? double.infinity : 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  _WorkspaceHeader(compact: compact),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _NavButton(
                      icon: Icons.search,
                      label: 'Search',
                      muted: true,
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _NavButton(
                      icon: Icons.add,
                      label: 'New page',
                      onTap: store.createPage,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      children: [
                        if (store.favorites.isNotEmpty) ...[
                          const _SectionLabel('Favorites'),
                          ...store.favorites.map(
                            (page) => _PageRow(
                              page: page,
                              selected: page.id == store.selectedId,
                              onTap: () {
                                store.select(page.id);
                                if (compact) Navigator.of(context).maybePop();
                              },
                              onFavorite: () => store.toggleFavorite(page.id),
                              onDelete: () => store.deletePage(page.id),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const _SectionLabel('Private'),
                        ...store.privatePages.map(
                          (page) => _PageRow(
                            page: page,
                            selected: page.id == store.selectedId,
                            onTap: () {
                              store.select(page.id);
                              if (compact) Navigator.of(context).maybePop();
                            },
                            onFavorite: () => store.toggleFavorite(page.id),
                            onDelete: () => store.deletePage(page.id),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF2F3437),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Atlas',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.text,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (compact)
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.close, size: 18),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textFaint,
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      hoverColor: AppColors.sidebarHover,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: muted ? AppColors.textFaint : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: muted ? AppColors.textFaint : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageRow extends StatelessWidget {
  const _PageRow({
    required this.page,
    required this.selected,
    required this.onTap,
    required this.onFavorite,
    required this.onDelete,
  });

  final WorkspacePage page;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.sidebarActive : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        hoverColor: AppColors.sidebarHover,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Text(page.icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  page.title.isEmpty ? 'Untitled' : page.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: AppColors.text,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                iconSize: 16,
                tooltip: 'Page actions',
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.border),
                ),
                onSelected: (value) {
                  if (value == 'favorite') onFavorite();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'favorite',
                    child: Text(
                      page.favorite ? 'Remove from favorites' : 'Add to favorites',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(color: AppColors.danger),
                    ),
                  ),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.more_horiz, size: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
