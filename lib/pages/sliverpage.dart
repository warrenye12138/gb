import 'package:flutter/material.dart';
import 'package:gb/common/widgets/sliver.dart';

class PersistentHeaderRoute extends StatelessWidget {
  const PersistentHeaderRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate(
              minHeight: 50, maxHeight: 80, child: builderHeader(1)),
        ),
        buildSliverList(),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverHeaderDelegate.fixedHeight(
              height: 50, child: builderHeader(2)),
        ),
        buildSliverList(),
      ]),
    );
  }

  Widget buildSliverList([int count = 20]) {
    return SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return ListTile(
            title: Text('$index'),
          );
        }, childCount: count),
        itemExtent: 50);
  }

  Widget builderHeader(int i) {
    return Container(
      color: Colors.lightBlue.shade200,
      alignment: Alignment.centerLeft,
      child: Text('PersistentHeader:$i'),
    );
  }
}
