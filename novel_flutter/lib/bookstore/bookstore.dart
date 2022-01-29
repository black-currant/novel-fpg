import 'package:novel_flutter/bookstore/book_type_list.dart';
import 'package:novel_flutter/model/book_channel.dart';
import 'package:novel_flutter/search/search_delegate.dart';
import 'package:flutter/material.dart';

/// 书库
class BookstorePage extends StatefulWidget {
  const BookstorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<BookstorePage>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        RouteAware {
  final List<int> tabs = [BookChannel.male, BookChannel.female];

  late TabController _controller;
  int _selectedIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: _selectedIndex,
    );
    _controller.addListener(() {
      setState(() {
        if (_selectedIndex != _controller.index) {
          _selectedIndex = _controller.index;
        }
      });
    });

//    tabIds.add(BookChannel.shortStory);
//    tabIds.add(BookChannel.comic);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate(context));
//              Navigator.of(context).pushNamed(RouteName.search);
            },
          ),
        ],
        title: TabBar(
          controller: _controller,
          isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: List.generate(
              tabs.length,
              (index) => Tab(
                    text: BookChannel.getLabel(context, tabs[index]),
                  )),
          labelStyle: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: List.generate(
          tabs.length,
          (index) => BookTypeListPage(channelId: tabs[index]),
        ),
      ),
    );
  }

  @override
  void didPush() {}

  @override
  void didPopNext() {}
}
