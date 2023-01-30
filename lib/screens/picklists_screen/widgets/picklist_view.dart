import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanner/models/picklist.dart';

class PicklistView extends StatelessWidget {
  const PicklistView({
    required this.list,
    required this.refreshController,
    required this.onRefresh,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final List<Picklist> list;
  final void Function() onRefresh;
  final RefreshController refreshController;
  final Function(Picklist) onTap;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      header: MaterialClassicHeader(),
      controller: refreshController,
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16),
          separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
          itemCount: list.length,
          itemBuilder: (context, index) => ListTile(
                onTap: () {
                  onTap(list[index]);
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  color: statusColor(list[index]),
                  alignment: Alignment.center,
                  child: Text(
                    '${list[index].lines}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          list[index].uid,
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(list[index].debtor.city ?? '',
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    Text(list[index].debtor.name),
                  ],
                ),
                trailing: Icon(Icons.chevron_right),
              )),
    );
  }

  Color statusColor(Picklist picklist) {
    switch (picklist.status) {
      case PicklistStatus.inProgress:
        return Color(0xFF034784);
      case PicklistStatus.added:
        return Colors.black;
      case PicklistStatus.check:
        return Color(0Xff777777);
      case PicklistStatus.priority:
        return Color(0xFFed6f56);
      default:
        return Colors.black;
    }
  }
}
