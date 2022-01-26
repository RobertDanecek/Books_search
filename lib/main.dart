import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'descriptionscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IT Books search ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'IT Books search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool listPicture = true; //chose List view or Image view
  int numberFound = -1;  //number of found books
  String keyWord = '';  //searchin keqword
  int page = 0;         //actual page number

  //list of books in this page
  dynamic bookList = [];

  // Text editor controller
  TextEditingController bookNameTextController = TextEditingController();

  // book searchin engine
  void _searchbooks(String bookName, int searchPage) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final http.Response response;
    keyWord = bookName;
    if (searchPage != 0) {
      response = await http.get(Uri.parse(
          'https://api.itbook.store/1.0/search/' +
              bookName +
              '/' +
              searchPage.toString()));
    } else {
      response = await http
          .get(Uri.parse('https://api.itbook.store/1.0/search/' + bookName));
    }

    final responseAll = jsonDecode(response.body);

    final responseBooks = responseAll["books"];
//    final responseError = responseAll["error"];
    final responseTotal = responseAll["total"];
//    final responsePage = responseAll["page"];

    setState(() {
      numberFound = int.parse(responseTotal);
      bookList = responseBooks;
    });
  }

  // widget Books list choice
  Widget booksListWidget() {
    return Column(children: <Widget>[
      for (var item in bookList)
        InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => descriptionScreen(data: item as Map)));
            },
            child: Row(
              children: <Widget>[
                Image.network(item['image'], width: 150, height: 150),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 150 - 20,
                  child: Text(
                    item['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ))
    ]);
  }

  // click widget
  Widget booksItemLink(double pictSize, Map item) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => descriptionScreen(data: item)));
        },
        child: Image.network(item['image'], width: pictSize, height: pictSize));
  }

  // widget picture list choice
  Widget booksPictureWidget(context) {
    List<Widget> list = [];

    double pictSize = MediaQuery.of(context).size.width / 3 - 5;
    if (bookList.length != 0) {
      for (var i = 0; i < (bookList.length ~/ 3) + 1; i++) {
        List<Widget> rowList = [];
        rowList.add(booksItemLink(pictSize, bookList[i * 3])
            //Image.network(bookList[i * 3]['image'],
            //width: pictSize, height: pictSize)
            );
        if ((i * 3 + 1) < bookList.length) {
          rowList.add(
              //Image.network(bookList[i * 3 + 1]['image'],
              //width: pictSize, height: pictSize)
              booksItemLink(pictSize, bookList[i * 3 + 1]));
        }
        if ((i * 3 + 2) < bookList.length) {
          rowList.add(
              //        Image.network(bookList[i * 3 + 2]['image'],
//              width: pictSize, height: pictSize)
              booksItemLink(pictSize, bookList[i * 3 + 2]));
        }

        list.add(Row(
          children: rowList,
        ));
      }
    }

    if (list.isNotEmpty) {
      return Column(children: list);
    } else {
      return Container();
    }
  }

  // searching helper function
  void _startSearch()
  {
    page = 1;
    _searchbooks(bookNameTextController.text, 0);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          //shrinkWrap: true,
          children: <Widget>[
            Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              Row(children: const <Widget>[
                Spacer(),
                Text('IT ',
                    style: TextStyle(color: Colors.black, fontSize: 50)),
                Text('B', style: TextStyle(color: Colors.blue, fontSize: 50)),
                Text('o', style: TextStyle(color: Colors.red, fontSize: 50)),
                Text('o', style: TextStyle(color: Colors.orange, fontSize: 50)),
                Text('k', style: TextStyle(color: Colors.blue, fontSize: 50)),
                Text('s', style: TextStyle(color: Colors.green, fontSize: 50)),
                Spacer(),
              ]),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  onEditingComplete: (){
                    _startSearch();
                  },
                  controller: bookNameTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter name of the book',
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(children: <Widget>[
                    InkWell(
                        onTap: () {
                          setState(() {
                            listPicture = true;
                          });
                        },
                        child: Icon(
                          Icons.image_outlined,
                          size: 60,
                          color: listPicture ? Colors.black : Colors.grey,
                        )),
                    InkWell(
                        onTap: () {
                          setState(() {
                            listPicture = false;
                          });
                        },
                        child: Icon(
                          Icons.list,
                          size: 60,
                          color: !listPicture ? Colors.black : Colors.grey,
                        )),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          _startSearch();
                        },
                        child: const Text('Search')),
                  ])),
              numberFound >= 0
                  ? Row(
                      children: [
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              if (page > 1) {
                                page--;
                                _searchbooks(keyWord, page);
                              }
                            },
                            child: Icon(
                              Icons.navigate_before,
                              size: 60,
                              color: page > 1 ? Colors.black : Colors.grey,
                            )),
                        Text('Page: ' +
                            page.toString() +
                            '/' +
                            ((numberFound ~/ 10) + 1).toString()),
                        InkWell(
                            onTap: () {
                              if (page < (numberFound ~/ 10) + 1) {
                                page++;
                                _searchbooks(keyWord, page);
                              }
                            },
                            child: Icon(
                              Icons.navigate_next,
                              size: 60,
                              color: (page < (numberFound ~/ 10) + 1)
                                  ? Colors.black
                                  : Colors.grey,
                            )),
                        const Spacer(),
                      ],
                    )
                  : Container(),
              listPicture ? booksPictureWidget(context) : booksListWidget(),
              numberFound >= 0
                  ? Text('Found ' + numberFound.toString() + ' books')
                  : Container(),
              const SizedBox(
                height: 20,
              ),
            ])
            //    : Container(),
          ],
        ),
      ),
    );
  }
}



