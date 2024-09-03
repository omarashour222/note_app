import 'package:hive/hive.dart';

class NoteHiveHelper {
  static const notebox = 'NOTE_BOX';
  static const notekey = 'NOTE_BOX';
  static List<String> notelist = [];
  static List<String> filteredNotes = [];

  static void addNote(String text) {
    notelist.add(text);
    Hive.box(notebox).put(notekey, notelist);
  }

  static void removeNote(int index) {
    notelist.remove(filteredNotes[index]);
    Hive.box(notebox).put(notekey, notelist);
  }

  static void updateNote({
    required int index,
    required String text,
  }){
    notelist[index] = text;
    Hive.box(notebox).put(notekey, notelist);

  }

  static void getNotes() {
    // notelist = Hive.box(notebox).get(notekey);
    notelist = Hive.box(notebox).get(notekey, defaultValue: <String>[])!;
  }
}
