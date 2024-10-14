// ページ
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class BookPage extends StatefulWidget {
  const BookPage({
    super.key,
    required this.id,
    required this.title,
    required this.href,
  });

  final String id;
  final String title;
  final String href;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List scenarioData = [
    {
      "title": {"ja-JA": "初めから", "en-EN": "Start"},
      "message": [
        {
          "slide": "00.jpg",
          "actor": "no",
          "actorImg": "noImage.png",
          "ja-JA": "ここをクリックしてね",
          "en-EN": "Click me"
        },
        {
          "slide": "00.jpg",
          "actor": "01",
          "actorImg": "noImage.png",
          "ja-JA": "皆さん、こんにちは。学習ナビゲーターのハルミナです。",
          "en-EN":
              "Hello everyone. My name is Harumina and I am a learning navigator."
        },
      ]
    },
  ];
  String? selectLang = "ja-JA";

  double sliderValue = 0;
  int pageLength = 0; // ページ数
  int pageIndex = 0; // 現在ページ
  int messageLength = 1; // メッセージ数
  int messageIndex = 0; // 現在メッセージ
  String actorName = "あくたー";
  String actorImageFile = "null.png";
  String actorImageSrc = "assets/scenario/actor/noImage.png";
  String slideFile = "oo.jpg";
  String slideSrc = "assets/scenario/jh_mathematics/minus/end.jpg";
  String message = "Hello World!";
  bool isMenu = true;
  bool isText = true;
  bool isVoice = false;
  bool isAuto = false;

  // late FlutterTts flutterTts; // テキストtoスピーチ

  // 言語切り替え
  void changeLang(value) {
    setState(() {
      selectLang = value;
    });
    review();
  }

  // Json
  void readJson() async {
    final resJson = await rootBundle.loadString(
        'assets/scenario/${widget.id}/${widget.href}/scenario.json');
    var decoJson = jsonDecode(resJson);
    // debugPrint("しなりお：$decoJson");
    setState(() {
      scenarioData = decoJson["page"];
    });
  }

  // 画面更新
  void review() {
    // debugPrint("${widget.id}/${widget.href}");
    setState(() {
      pageLength = scenarioData.length;
      messageLength = scenarioData[pageIndex]['message'].length;
      slideFile = scenarioData[pageIndex]['message'][messageIndex]["slide"];
      slideSrc = "assets/scenario/${widget.id}/${widget.href}/$slideFile";
      message = scenarioData[pageIndex]['message'][messageIndex][selectLang];
      actorName = scenarioData[pageIndex]['message'][messageIndex]["actor"];
    });
    debugPrint("ページ：$pageIndex/$pageLength、メッセージ:$messageIndex/$messageLength");
    debugPrint("スライド:$slideSrc");
  }

  // Next
  void next() async {
    setState(() {
      if (messageIndex == messageLength - 1) {
        // 改ページ
        if (pageIndex == pageLength - 1) {
          // 最後
          debugPrint("end");
          return;
        }
        messageIndex = 0;
        pageIndex++;
      } else {
        messageIndex++; // メッセージ送り
      }
      if (isVoice) {
        voicePlay();
      }
      review();
    });
  }

// もくじ選択
  void changePage(index) {
    setState(() {
      pageIndex = index;
      messageIndex = 0;
    });
    review();
  }

  // スライダー
  void setSlider(value) {
    setState(() {
      messageIndex = value.toInt();
    });
    review();
  }

  // voicePlay
  Future<void> voicePlay() async {
    // var lang = selectLang.toString();
    // await flutterTts.stop();
    await Future.delayed(const Duration(milliseconds: 550));
    // await flutterTts.setLanguage(lang);
    //   if (selectLang == "ja-JA") {
    // await flutterTts.setSpeechRate(1.2);
// } else {
    // await flutterTts.setSpeechRate(1.0);
    //  }
    // await flutterTts.setVolume(1.0);
    // await flutterTts.setPitch(1.0);
    // await flutterTts.speak(message);
    // flutterTts.setCompletionHandler(() {
    //   if (isAuto) {
    //     next();
    //   }
    // });
  }

  Future<void> voiceStop() async {
    // await flutterTts.stop();
  }

  // 初期化
  @override
  void initState() {
    super.initState();
    readJson();
    review();
    // flutterTts = FlutterTts();
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
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          leadingWidth: 150,
          leading: Row(
            children: [
              IconButton(
                onPressed: () {
                  voiceStop();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton(
                onPressed: () {
                  // voiceStop();
                  setState(() {
                    isMenu = !isMenu;
                  });

                  debugPrint("$isMenu");
                },
                icon: const Icon(Icons.menu_book_outlined),
              ),
            ],
          ),
          actions: [
            DropdownButton(
                dropdownColor: Colors.black54,
                style: const TextStyle(color: Colors.white),
                value: selectLang,
                items: const [
                  DropdownMenuItem(
                    value: "ja-JA",
                    child: Text("日本語"),
                  ),
                  DropdownMenuItem(
                    value: "en-EN",
                    child: Text("English"),
                  )
                ],
                onChanged: (String? value) {
                  setState(() {
                    changeLang(value);
                  });
                })
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // もくじ/スライド
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMenu)
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              // for(var item in scenarioData)
                              for (int index = 0;
                                  index < scenarioData.length;
                                  index++)
                                Column(children: [
                                  if (index == pageIndex)
                                    Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        margin:
                                            const EdgeInsets.only(bottom: 2),
                                        // child: ElevatedButton(onPressed: (){}, child: Text('${scenarioData[index]["title"][selectLang]}',maxLines: 1,)))
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                changePage(index);
                                              });
                                            },
                                            child: Text(
                                              '${scenarioData[index]["title"][selectLang]}',
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            )))
                                  else
                                    Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.white38,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        margin:
                                            const EdgeInsets.only(bottom: 2),
                                        // child: ElevatedButton(onPressed: (){}, child: Text('${scenarioData[index]["title"][selectLang]}',maxLines: 1,)))
                                        child: InkWell(
                                            onTap: () {
                                              changePage(index);
                                            },
                                            child: Text(
                                              '${scenarioData[index]["title"][selectLang]}',
                                              maxLines: 1,
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ))),
                                ])
                            ],
                          ),
                        ),
                      Expanded(
                          child: InkWell(
                        child: Image.asset(slideSrc),
                        onTap: () {
                          next();
                        },
                      )),
                    ],
                  ),
                ),
                // メニュー
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        actorName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                          value: messageIndex.toDouble(),
                          min: 0,
                          max: messageLength.toDouble() - 1,
                          divisions: messageLength,
                          activeColor: Colors.blueGrey.withOpacity(0.7),
                          inactiveColor: Colors.grey.withOpacity(0.3),
                          onChanged: (value) {
                            setSlider(value);
                          }),
                    ),
                    // 字幕
                    isText
                        ? TextButton(
                            style: TextButton.styleFrom(
                                // backgroundColor: Colors.white,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                isText = !isText;
                              });
                            },
                            child: const Icon(Icons.chat),
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                                // backgroundColor: Colors.white,
                                foregroundColor: Colors.white38),
                            onPressed: () {
                              setState(() {
                                isText = !isText;
                              });
                            },
                            child: const Icon(Icons.chat),
                          ),
                    // 音声on/off
                    isVoice
                        ? TextButton(
                            style: TextButton.styleFrom(
                                // backgroundColor: Colors.white,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                isVoice = !isVoice;
                              });
                            },
                            child: const Icon(Icons.volume_down_alt),
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                                // backgroundColor: Colors.black26,
                                foregroundColor: Colors.white38),
                            onPressed: () {
                              setState(() {
                                isVoice = !isVoice;
                              });
                            },
                            child: const Icon(Icons.volume_down_alt),
                          ),
                    // 音声連続
                    isAuto
                        ? TextButton(
                            style: TextButton.styleFrom(
                                // backgroundColor: Colors.white,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                isAuto = !isAuto;
                              });
                            },
                            child: const Icon(Icons.loop),
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                                // backgroundColor: Colors.white,
                                foregroundColor: Colors.white38),
                            onPressed: () {
                              setState(() {
                                isAuto = !isAuto;
                              });
                            },
                            child: const Icon(Icons.loop),
                          ),
                    // 音声再生
                    TextButton(
                      style: TextButton.styleFrom(
                          // backgroundColor: Colors.white,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          voicePlay();
                        });
                      },
                      child: const Icon(Icons.play_arrow),
                    ),
                    // 音声ストップ
                    TextButton(
                      style: TextButton.styleFrom(
                          // backgroundColor: Colors.white,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          voiceStop();
                        });
                      },
                      child: const Icon(Icons.stop_rounded),
                    )
                  ],
                ),
                // 字幕
                if (isText)
                  InkWell(
                    onTap: () {
                      next();
                    },
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        message,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    ),
                  )
              ]),
        ),
      ),
    );
  }
}
