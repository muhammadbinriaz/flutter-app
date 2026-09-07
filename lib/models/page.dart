class WorkspacePage {
  WorkspacePage({
    required this.id,
    required this.title,
    required this.icon,
    required this.body,
    this.favorite = false,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  final String id;
  String title;
  String icon;
  String body;
  bool favorite;
  DateTime updatedAt;

  WorkspacePage copy() {
    return WorkspacePage(
      id: id,
      title: title,
      icon: icon,
      body: body,
      favorite: favorite,
      updatedAt: updatedAt,
    );
  }
}

class SeedData {
  static List<WorkspacePage> pages() {
    return [
      WorkspacePage(
        id: '1',
        title: 'Getting started',
        icon: '👋',
        favorite: true,
        body:
            'Welcome to your workspace.\n\n'
      ),
      WorkspacePage(
        id: '2',
        title: 'Product roadmap',
        icon: '🗺️',
        favorite: true,
        body:
            'Q1\n'
            '• Ship auth and workspaces\n'
            '• Mobile layout for sidebar\n'
            '• Offline draft sync\n\n'
            'Q2\n'
            '• Share links\n'
            '• Comments\n'
            '• Templates',
      ),
      WorkspacePage(
        id: '3',
        title: 'Meeting notes',
        icon: '📝',
        body:
            'Mar 12 — Design sync\n\n'
            'Attendees: you, design, eng\n\n'
            'Decisions\n'
            '• Keep the editor single-column\n'
            '• Sidebar collapses under 720px\n'
            '• No floating AI panels\n\n'
            'Next\n'
            '• Wire page create/delete\n'
            '• Persist locally later',
      ),
      WorkspacePage(
        id: '4',
        title: 'Hiring',
        icon: '👥',
        body:
            'Open roles\n'
            '• Senior Flutter engineer\n'
            '• Product designer\n\n'
            'Notes\n'
            'Prefer people who ship calm, readable UI over flashy demos.',
      ),
      WorkspacePage(
        id: '5',
        title: 'Untitled',
        icon: '📄',
        body: '',
      ),
    ];
  }
}
