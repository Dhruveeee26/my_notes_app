import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Notes App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const NotesHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final List<String> _notes = [];
  final TextEditingController _noteController = TextEditingController();
  String? _userName;

  @override
  void initState() {
    super.initState();
    _askUserName();
  }

  void _askUserName() {
    final TextEditingController nameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Welcome!"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter your name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _userName = nameController.text.trim().isEmpty
                      ? "User"
                      : nameController.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      );
    });
  }

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;
    setState(() {
      _notes.add(_noteController.text.trim());
      _noteController.clear();
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Note"),
        content: TextField(
          controller: _noteController,
          decoration: const InputDecoration(hintText: "Enter your note"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addNote();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildLinedBackground() {
    return CustomPaint(
      painter: LinedPaperPainter(),
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildLinedBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Row(
              children: [
                const Text('Simple Notes App'),
                const Spacer(),
                ElevatedButton(
                  onPressed: _showAddNoteDialog,
                  child: const Text("Add Note"),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                if (_userName != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Hey $_userName! 👋',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Welcome to your notes.',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                ],
                Expanded(
                  child: _notes.isEmpty
                      ? const Center(child: Text("No notes yet."))
                      : ListView.builder(
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(
                                  _notes[index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.pink),
                                  onPressed: () => _deleteNote(index),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddNoteDialog,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class LinedPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0D7FF)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
