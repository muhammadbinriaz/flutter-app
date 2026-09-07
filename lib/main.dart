import 'package:flutter/material.dart';

import 'theme.dart';
import 'widgets/editor.dart';
import 'widgets/sidebar.dart';
import 'workspace.dart';

void main() {
  runApp(const AtlasApp());
}

class AtlasApp extends StatelessWidget {
  const AtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const WorkspaceShell(),
    );
  }
}

class WorkspaceShell extends StatefulWidget {
  const WorkspaceShell({super.key});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  final store = WorkspaceStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final wide = MediaQuery.sizeOf(context).width >= 720;

        return Scaffold(
          drawer: wide
              ? null
              : Drawer(
                  backgroundColor: AppColors.sidebar,
                  width: 280,
                  child: WorkspaceSidebar(store: store, compact: true),
                ),
          body: Row(
            children: [
              if (wide && store.sidebarOpen)
                WorkspaceSidebar(store: store)
              else if (wide)
                const SizedBox.shrink(),
              if (wide && store.sidebarOpen)
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.border,
                ),
              Expanded(
                child: PageEditor(store: store),
              ),
            ],
          ),
        );
      },
    );
  }
}
