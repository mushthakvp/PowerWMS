import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanner/models/picklist.dart';

class PicklistView extends StatelessWidget {
  const PicklistView(
    this._list,
    this._refreshController,
    this.onRefresh, {
    Key? key,
  }) : super(key: key);

  final List<Picklist> _list;
  final void Function() onRefresh;
  final RefreshController _refreshController;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      header: MaterialClassicHeader(),
      controller: _refreshController,
      onRefresh: onRefresh,
      child: ListView(
        children: _list
            .map((picklist) => Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/picklist',
                            arguments: picklist);
                      },
                      leading: Container(
                        width: 40,
                        height: 40,
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: Text(
                          '${picklist.lines}',
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
                                picklist.uid,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(picklist.debtor.city ?? '',
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          Text(picklist.debtor.name),
                        ],
                      ),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
