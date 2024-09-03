import 'package:flutter/material.dart';
import 'package:note_app/note_hive_helper.dart';


class NoteText extends StatefulWidget {
  final String? initialText;
  final int? noteIndex;
  const NoteText({super.key, this.initialText, this.noteIndex});

  @override
  State<NoteText> createState() => _NoteTextState();
}

class _NoteTextState extends State<NoteText> {
  final _textController = TextEditingController();
  bool isUpdate = false;
  int? index;
  void initState() {
    NoteHiveHelper.getNotes();
    super.initState();

    // Check if we're updating an existing note
    if (widget.initialText != null && widget.noteIndex != null) {
      _textController.text = widget.initialText!;
      isUpdate = true;
      index = widget.noteIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context, NoteHiveHelper.notelist);
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Color(0xff3B3B3B),
            ),
            child: Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                if (_textController.text.isNotEmpty) {
                  if (isUpdate) {
                    NoteHiveHelper.updateNote(
                        index: index!, text: _textController.text);
                  } else {
                    NoteHiveHelper.addNote(_textController.text);
                    _textController.clear();
                  }
                  setState(() {});
                  Navigator.pop(context, NoteHiveHelper.notelist);
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color(0xff3B3B3B),
                ),
                child: Icon(Icons.edit),
              ),
            ),
          ),
        ],
      ),
      body: _buildTextField(),
    );
  }

  Widget _buildTextField() {
    final maxline = 100;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: TextField(
          controller: _textController,
          maxLines: maxline,
          autofocus: false,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 20),
            hintText: 'Type something....',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
