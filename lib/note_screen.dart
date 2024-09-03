import 'package:flutter/material.dart';
import 'package:note_app/note_hive_helper.dart';
import 'package:note_app/note_text.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    NoteHiveHelper.getNotes();
    super.initState();
    NoteHiveHelper.filteredNotes = NoteHiveHelper.notelist;
    
  }

  void _filterNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        NoteHiveHelper.filteredNotes = NoteHiveHelper.notelist;
      } else {
        NoteHiveHelper.filteredNotes = NoteHiveHelper.notelist
            .where((note) => note.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isSearching
              ? TextField(
                  controller: searchController,
                  onChanged: _filterNotes,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                )
              : Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 43,
                  ),
                ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Color(0xff3B3B3B),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          if (isSearching) {
                            searchController.clear();
                            _filterNotes('');
                            isSearching = false;
                          } else {
                            isSearching = true;
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Color(0xff3B3B3B),
                    ),
                    child: Icon(Icons.info_outline),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final updatedList = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return NoteText();
                },
              ),
            );
            if (updatedList != null) {
              setState(() {
                NoteHiveHelper.notelist = updatedList;
                _filterNotes(searchController.text);
              });
            }
          },
          backgroundColor: Color(0xff3B3B3B),
          child: Icon(Icons.add),
        ),
        body: NoteHiveHelper.filteredNotes.isEmpty
            ? Center(
                child: NoteHiveHelper.filteredNotes.length == 0 &&
                        searchController.text.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              width: 350,
                              height: 287,
                              child: Image.asset('assets/images/cuate.png'),
                            ),
                          ),
                          Text(
                            'File not found. Try searching again.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      )
                    // Text(
                    //     'No notes found matching "${searchController.text}".',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //     ),
                    //   )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              width: 350,
                              height: 287,
                              child: Image.asset('assets/images/rafiki.png'),
                            ),
                          ),
                          Text(
                            'Create your first note !',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ))
            : ListView.separated(
                separatorBuilder: (c, i) => SizedBox(
                      height: 10,
                    ),
                itemCount: NoteHiveHelper.filteredNotes.length,
                itemBuilder: (c, i) => Dismissible(
                      key: ValueKey(NoteHiveHelper.filteredNotes[i]),
                      direction: DismissDirection.endToStart,
                      background: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          NoteHiveHelper.removeNote(i);
                          _filterNotes(searchController.text);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Note deleted'),
                        ));
                      },
                      child: GestureDetector(
                        onTap: () async {
                          final updatedList = await Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NoteText(
                              initialText: NoteHiveHelper.filteredNotes[i],
                              noteIndex: NoteHiveHelper.notelist
                                  .indexOf(NoteHiveHelper.filteredNotes[i]),
                            );
                          }));
                          if (updatedList != null) {
                            setState(() {
                              NoteHiveHelper.notelist = updatedList;
                              _filterNotes(searchController.text);
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: i == 0
                                    ? Color(0xffFD99FF)
                                    : i % 2 == 0
                                        ? Color(0xffFF9E9E)
                                        : i % 3 == 0
                                            ? Color(0xff91F48F)
                                            : i % 4 == 0
                                                ? Color(0xffFFF599)
                                                : i % 5 == 0
                                                    ? Color(0xff9EFFFF)
                                                    : Color(0xffB69CFF)),
                            child: Center(
                                child: Text(
                              NoteHiveHelper.filteredNotes[i].length > 10
                                  ? '${NoteHiveHelper.filteredNotes[i].substring(0, 10)}...'
                                  : NoteHiveHelper.filteredNotes[i],
                              style: TextStyle(
                                fontSize: 25,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black,
                              ),
                            )),
                          ),
                        ),
                      ),
                    )));
  }
}
