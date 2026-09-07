import 'package:flutter/foundation.dart';

import 'models/page.dart';

class WorkspaceStore extends ChangeNotifier {
  WorkspaceStore() {
    pages = SeedData.pages();
    selectedId = pages.first.id;
  }

  late List<WorkspacePage> pages;
  late String selectedId;
  bool sidebarOpen = true;

  WorkspacePage get selected =>
      pages.firstWhere((p) => p.id == selectedId, orElse: () => pages.first);

  List<WorkspacePage> get favorites =>
      pages.where((p) => p.favorite).toList(growable: false);

  List<WorkspacePage> get privatePages =>
      pages.where((p) => !p.favorite).toList(growable: false);

  void select(String id) {
    selectedId = id;
    notifyListeners();
  }

  void toggleSidebar() {
    sidebarOpen = !sidebarOpen;
    notifyListeners();
  }

  void setTitle(String value) {
    selected.title = value;
    selected.updatedAt = DateTime.now();
    notifyListeners();
  }

  void setBody(String value) {
    selected.body = value;
    selected.updatedAt = DateTime.now();
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final page = pages.firstWhere((p) => p.id == id);
    page.favorite = !page.favorite;
    notifyListeners();
  }

  void createPage() {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final page = WorkspacePage(
      id: id,
      title: 'Untitled',
      icon: '📄',
      body: '',
    );
    pages = [...pages, page];
    selectedId = id;
    notifyListeners();
  }

  void deletePage(String id) {
    if (pages.length <= 1) return;
    pages = pages.where((p) => p.id != id).toList();
    if (selectedId == id) {
      selectedId = pages.first.id;
    }
    notifyListeners();
  }
}
