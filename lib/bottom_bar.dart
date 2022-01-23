import 'package:dopplerv1/inner_screens/comments_n_chat.dart';
import 'package:provider/provider.dart';
import 'package:dopplerv1/consts/my_icons.dart';
import 'package:dopplerv1/screens/adminScreens/all_users.dart';
import 'package:flutter/material.dart';
import 'package:dopplerv1/screens/user_info.dart';
import 'package:dopplerv1/screens/chat_lists.dart';
import 'package:dopplerv1/consts/collections.dart';
import 'package:dopplerv1/screens/camera_screen.dart';
import 'consts/collections.dart';

import 'provider/bottom_navigation_bar_provider.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final List<Widget> pages = currentUser!.isAdmin!
      ? <Widget>[
          UserNSearch(),
          ChatLists(),
        ]
      : <Widget>[
          CommentsNChat(
              isPostComment: false,
              postId: currentUser!.id,
              isProductComment: false),
          Upload(),
          UserInfo(),
        ];

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarProvider _page =
        Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: pages[_page.selectedPage],
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          onTap: (int updatedPage) => _page.updateSelectedPage(updatedPage),
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.grey.shade700,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          currentIndex: _page.selectedPage,
          items: currentUser!.isAdmin!
              ? [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.people_rounded),
                    label: 'All Users',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_rounded),
                    label: 'Admin Chats',
                  ),
                ]
              : [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline_rounded),
                      label: 'Contact Admin'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.camera_rounded), label: 'Camera'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_rounded), label: 'User'),
                ],
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: Icon(_userTileIcons[index]),
    );
  }

  Widget userTitle({required String title, Color color: Colors.yellow}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
      ),
    );
  }
}
