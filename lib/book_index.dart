// カード
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:gaku_navi_flutter_4/book_page.dart';

class BookIndex extends StatefulWidget {
  const BookIndex(
      {super.key,
        required this.id,
        required this.title,
        required this.thumbnail});

  final String id;
  final String title;
  final String thumbnail;

  @override
  State<BookIndex> createState() => _BookIndexState();
}

class _BookIndexState extends State<BookIndex> {
  // もくじ
  List<dynamic> indexData = [
    {
      "part": "プロローグ",
      "chapter": [
        {"title": "オリエンテーション", "href": "01"},
        {"title": "中学数学のゴール", "href": "02"}
      ]
    }
  ];

  // Json
  Future<void> readJson() async {
    final resJson =
    await rootBundle.loadString('assets/scenario/${widget.id}/index.json');
    var data = jsonDecode(resJson);

    debugPrint("$indexData");
    // var res2 = jsonDecode(resJson);
    // debugPrint("$res2");
    setState(() {
      indexData = data["index"];
    });
  }

  // 初期化
  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          appBar: AppBar(
            backgroundColor: Colors.black45,
            iconTheme: const IconThemeData(color: Colors.white70),
            title: Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            double width = constraints.maxWidth; // 画面幅を取得
            bool isPcSize = true;
            // PCサイズ以上の場合は4列
            if (width < 600) {
              isPcSize = false;
              // debugPrint("$width:スマホサイズ：$isPcSize");
            }

            return Container(
              padding: const EdgeInsets.all(10),
              child: isPcSize
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Image.asset(
                          "assets/thumbnail/${widget.thumbnail}")),
                  const SizedBox(height: 5, width: 5),
                  IndexItem(id: widget.id, itemList: indexData)
                ],
              )
                  : Column(
                children: [
                  Image.asset("assets/thumbnail/${widget.thumbnail}"),
                  const SizedBox(height: 5, width: 5),
                  IndexItem(id: widget.id, itemList: indexData)
                ],
              ),
            );
          })),
    );
  }
}

// もくじ
class IndexItem extends StatefulWidget {
  const IndexItem({super.key, required this.id, required this.itemList});

  final String id;
  final List itemList;

  @override
  State<IndexItem> createState() => _IndexItemState();
}

class _IndexItemState extends State<IndexItem> {
  List<dynamic> indexData = [
    {
      "part": "プロローグ",
      "chapter": [
        {"title": "オリエンテーション", "href": "01"},
        {"title": "中学数学のゴール", "href": "#"}
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.itemList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(bottom: 3),
              child: ListTile(
                tileColor: Colors.white70,
                title: Text(widget.itemList[index]["part"]),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var item in widget.itemList[index]["chapter"])
                      item['href'] != '#'
                          ? InkWell(
                          onTap: () {
                            debugPrint(item["title"]);
                            // Navigator.push(context,
                                // MaterialPageRoute(builder: (context) {
                                //   return BookPage(
                                //       id: widget.id,
                                //       title: item["title"],
                                //       href: item["href"]);
                                // }));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: double.infinity,
                              child: Text(item["title"],
                                  style: const TextStyle(fontSize: 17))))
                          : Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(bottom: 2),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            item["title"],
                            style: const TextStyle(fontSize: 17),
                          )),
                    const SizedBox(
                      height: 1,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
