import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Box notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box('notes');
  }

  void _addOrEditNote({int? index, Map? note}) {
    final titleController =
        TextEditingController(text: note != null ? note['title'] : '');
    final contentController =
        TextEditingController(text: note != null ? note['content'] : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(note == null ? 'Yeni Not' : 'Notu Düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Başlık'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'İçerik'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newNote = {
                'title': titleController.text,
                'content': contentController.text,
              };

              if (note == null) {
                notesBox.add(newNote);
              } else {
                notesBox.putAt(index!, newNote);
              }
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(int index) {
    notesBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlarım '),
      ),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Henüz not yok.'));
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final note = box.getAt(index) as Map;
                return Card(
                  child: ListTile(
                    title: Text(note['title']),
                    subtitle: Text(note['content']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _addOrEditNote(index: index, note: note),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteNote(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
