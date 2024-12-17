// ignore_for_file: unused_field
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/TradeCenters/Detail.dart';
import 'package:my_app/pages/Drawer.dart';
import 'package:page_transition/page_transition.dart';
import '../../dB/textStyle.dart';
import '../Search/search.dart';

class TradeCenters extends StatefulWidget {
  TradeCenters({Key? key}) : super(key: key);
  @override
  State<TradeCenters> createState() => _TradeCentersState();
}

class _TradeCentersState extends State<TradeCenters> {
  var keyword = TextEditingController();
  bool searchMode = true;
  var scrollController = new ScrollController();

  List<dynamic> dataSlider = [];

  List<dynamic> data = [];
  int _current = 0;

  bool tryAgain = true;
  bool filter = false;
  int totalCount = 0;
  int currentPage = 0;
  bool isLoading = true;
  int pageSize = 12;

  var query_params = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollControllerEvent);

    _pageNumber = 1;
    _isLastPage = false;
    isLoading = true;
    _error = false;

    getList();
  }

  void scrollControllerEvent() {
    if (scrollController.offset / scrollController.position.maxScrollExtent >
        0.7) {
      setState(() {
        this.currentPage++;
      });
      addMoreItems();
    }
  }

  void addMoreItems() async {
    setState(() {
      this.currentPage++;
    });
    String url = tradeCenters + "?page=$currentPage&page_size=$pageSize";
    final uri = Uri.parse(url);

    final response = await http.get(uri, headers: global_headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isLoading = false;
      data.addAll(json['data']);
      totalCount = data.length;
    });
  }

  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  final int _numberOfPostPerRequest = 12;
  final ScrollController _controller = ScrollController();
  final double _height = 100.0;
  late int total_page = 0;
  late int current_page = 0;

  void _animateToIndex(int index) {
    _controller.animateTo(
      index * 1,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
          title: Text('Söwda merkezler', style: CustomText.appBarText),
          actions: [
            Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Search(index: 0)));
                    },
                    child: Icon(Icons.search, color: Colors.white, size: 25)))
          ]),
      body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: CustomColors.appColor,
          onRefresh: () async {
            this.getList();
          },
          child: SingleChildScrollView(
              controller: scrollController,
              child: Column(children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: TextFormField(
                      controller: keyword,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(2),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _pageNumber = 1;
                                _isLastPage = false;
                                isLoading = true;
                                _error = false;
                                data = [];
                              });
                              getList();
                            },
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _pageNumber = 1;
                                _isLastPage = false;
                                isLoading = true;
                                _error = false;
                                data = [];
                                keyword.text = '';
                              });
                              getList();
                            },
                          ),
                          hintText: 'Ady boýunça gözleg...',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  children: data.map((item) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: TradeCenterDetail(id: item['id']),
                          ),
                        );
                      },
                      child: Container(
                        // height: 170,
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2,
                                            color: Color.fromARGB(
                                                255, 135, 135, 135))
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  clipBehavior: Clip.hardEdge,
                                  height:
                                      MediaQuery.of(context).size.width * 0.30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Image.network(
                                      serverIp + item['img'].toString(),
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: double.infinity,
                                      errorBuilder: (b, o, s) {
                                    return Image.asset(
                                      defaulImageUrl,
                                      fit: BoxFit.cover,
                                    );
                                  })),
                              Container(
                                color: Colors.white,
                                child: Text(
                                  item['name'],
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.appColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (this.isLoading)
                  Container(
                      height: 100,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: CustomColors.appColor)))
              ]))),
      drawer: MyDrawer(),
    );
  }

  void getList() async {
    var keywordText = keyword.text;
    final response = await http.get(Uri.parse(tradeCenters +
        "?name=$keywordText&page=$_pageNumber&page_size=$_numberOfPostPerRequest"));

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    var postList = [];
    for (var i in json['data']) {
      postList.add(i);
    }
    setState(() {
      tryAgain = false;
      current_page = json['current_page'];
      total_page = json['total_page'];
      totalCount = json['count'];

      isLoading = false;
      _isLastPage = data.length < _numberOfPostPerRequest;
      isLoading = false;
      _pageNumber = _pageNumber + 1;

      if (json['count'] > data.length) {
        data.addAll(postList);
      }
    });
  }

  Widget errorDialog({required double size}) {
    return GestureDetector(
        onTap: () {
          _animateToIndex(1);
        },
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 5),
              Icon(
                Icons.arrow_upward,
                color: CustomColors.appColor,
              )
            ]));
  }

  void _controllListener() {
    if (_controller.offset == _controller.position.maxScrollExtent &&
        data.length < totalCount) {
      getList();
    }
  }
}
