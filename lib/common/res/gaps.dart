import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 定义了一些从常见的组件
extension Gaps on double {
  Widget get sbw => SizedBox(
        width: this,
      );

  Widget get sbh => SizedBox(
        height: this,
      );

  // toSLW(){
  //   return SliverToBoxAdapter(
  //     child: SizedBox(width: this,),
  //   );
  // }
  Widget get lbh => SliverToBoxAdapter(
        child: SizedBox(
          height: this,
        ),
      );
}

Widget line = const Divider();

final Widget vLine = SizedBox(
  width: 0.6.w,
  height: 24.0.h,
  child: const VerticalDivider(),
);

// 这两行代码定义了两个空的小部件
Widget empty = const SizedBox.shrink();
Widget emptyExpand = const Expanded(child: SizedBox.shrink());
