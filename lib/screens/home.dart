import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:only_for_me/screens/search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_tabController?.index == 0 ? '내 음악' : '내 카테고리'),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.deepPurple[400],
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.deepPurple[400],
            tabs: const [
              Tab(
                icon: FaIcon(FontAwesomeIcons.music),
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.box),
              ),
            ],
            onTap: (index) {
              setState(() {});
            },
          ),
          elevation: 0,
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _myMusic(),
            _myMusicBox(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple[400],
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => Get.to(() => const SearchPage()),
        ),
      ),
    );
  }

  Widget _myMusic() {
    return Column();
  }

  Widget _myMusicBox() {
    return Column();
  }
}
