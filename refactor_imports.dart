import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) return;

  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    var content = file.readAsStringSync();
    
    // Convert absolute package imports
    content = content.replaceAll(RegExp(r"import 'package:taqikrdnawa/models/"), "import 'package:taqikrdnawa/backend/models/");
    content = content.replaceAll(RegExp(r"import 'package:taqikrdnawa/providers/"), "import 'package:taqikrdnawa/backend/providers/");
    content = content.replaceAll(RegExp(r"import 'package:taqikrdnawa/services/"), "import 'package:taqikrdnawa/backend/services/");
    content = content.replaceAll(RegExp(r"import 'package:taqikrdnawa/screens/"), "import 'package:taqikrdnawa/frontend/screens/");
    content = content.replaceAll(RegExp(r"import 'package:taqikrdnawa/widgets/"), "import 'package:taqikrdnawa/frontend/widgets/");
    content = content.replaceAll(RegExp(r"import 'package:taqikrdnawa/theme/"), "import 'package:taqikrdnawa/frontend/theme/");

    // Let's use a simpler strategy for relative imports:
    // Just find 'models/...', 'providers/...', 'services/...' and replace with 'backend/models/...' relative to the current file.
    // However, if the current file is inside 'backend/...' it shouldn't go back up unless needed.
    // The safest way is to change all relative imports to package imports!
    
    // Instead of replacing all relative with package imports naively, we can match:
    // import '.../screens/
    // import '../screens/
    
    content = content.replaceAll(RegExp(r"import '(\.\./)*models/"), "import 'package:taqikrdnawa/backend/models/");
    content = content.replaceAll(RegExp(r"import '(\.\./)*providers/"), "import 'package:taqikrdnawa/backend/providers/");
    content = content.replaceAll(RegExp(r"import '(\.\./)*services/"), "import 'package:taqikrdnawa/backend/services/");
    
    content = content.replaceAll(RegExp(r"import '(\.\./)*screens/"), "import 'package:taqikrdnawa/frontend/screens/");
    content = content.replaceAll(RegExp(r"import '(\.\./)*widgets/"), "import 'package:taqikrdnawa/frontend/widgets/");
    content = content.replaceAll(RegExp(r"import '(\.\./)*theme/"), "import 'package:taqikrdnawa/frontend/theme/");

    // And firebase backend dir:
    content = content.replaceAll(RegExp(r"import '(\.\./)*backend/firebase/"), "import 'package:taqikrdnawa/backend/firebase/");

    // Handle imports resolving locally without any ../ (e.g., inside screens directory importing another screen)
    // Actually, if we are in frontend/screens/a.dart and it imports 'b.dart', it remains 'b.dart'.
    // If it was importing 'category_screen.dart', it's fine.

    file.writeAsStringSync(content);
  }
  print("Import refactoring completed.");
}
