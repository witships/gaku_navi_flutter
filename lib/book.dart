// 本棚
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gaku_navi_flutter/book_index.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  // Data
  List<dynamic> bookList = [
    {
      "id": "jh_mathematics",
      "title": "ザックリ中学数学",
      "thumbnail": "jh_mathematics.png",
      "release": "2022/11/06~",
      "tags": ["中学", "数学"],
      "open": true
    }
  ];

  // Json
  Future<void> readJson() async {
    final resJson =
        await rootBundle.loadString('assets/scenario/bookList.json');
    List<dynamic> data = jsonDecode(resJson);
    // debugPrint(resJson);
    setState(() {
      bookList = data;
    });
    // debugPrint("$bookList");
  }

  // 初期化：onMount
  @override
  void initState() {
    super.initState();
    readJson();
  }

  // 画面
  @override
  Widget build(BuildContext context) {
    return
        // 全体
        Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black45,
            BlendMode.darken,
          ),
          image: AssetImage('assets/common/school.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // ヘッダー
        appBar: AppBar(
          backgroundColor: Colors.black45,
          title: const Text(
            "がくなび",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: GridView.extent(
            maxCrossAxisExtent: 350,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.2,
            children: [
              for (var item in bookList)
                BookCard(
                  // id: item.id,
                  id: item["id"],
                  title: item["title"],
                  thumbnail: item["thumbnail"],
                  tags: item["tags"],
                  release: item["release"],
                  open: item["open"],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  const BookCard(
      {super.key,
      required this.id, // id
      required this.title, // 本のタイトル
      required this.thumbnail, // サムネイル
      required this.tags, // タグ
      required this.release, // 公開
      required this.open});

  final String id;
  final String title;
  final String thumbnail;
  final List tags;
  final String release;
  final bool open;
  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (widget.open)
          ? InkWell(
              onTap: () {
                debugPrint(widget.title);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BookIndex(
                      id: widget.id,
                      title: widget.title,
                      thumbnail: widget.thumbnail);
                }));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/thumbnail/${widget.thumbnail}"),
                  SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white, // 背景色
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // id
                              Text(
                                widget.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                              // タイトル
                              Row(
                                children: [
                                  for (var tag in widget.tags)
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        child: Text(tag)),
                                ],
                              ),
                              // タグ
                              Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Text(widget.release)),
                              // 公開日
                            ])),
                  )
                ],
              ),
            )
          : // 公開
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/thumbnail/${widget.thumbnail}"),
                SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // id タイトル
                            Text(
                              widget.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                            // タグ
                            Row(
                              children: [
                                for (var tag in widget.tags)
                                  Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.blueGrey.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      child: Text(tag)),
                              ],
                            ),
                            // 公開日
                            Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(widget.release)),
                          ])),
                )
              ],
            ),
    );
  }
}
