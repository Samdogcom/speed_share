// 响应式布局
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:file_manager_view/file_manager_view.dart';
import 'package:speed_share/global/constant.dart';

import 'desktop_drawer.dart';
import 'file_page.dart';
import 'home_page.dart';
import 'nav.dart';
import 'remote_page.dart';
import 'setting_page.dart';
import 'share_chat_window.dart';
// 自动响应布局
class AdaptiveEntryPoint extends StatefulWidget {
  const AdaptiveEntryPoint({Key key}) : super(key: key);

  @override
  State<AdaptiveEntryPoint> createState() => _AdaptiveEntryPointState();
}

class _AdaptiveEntryPointState extends State<AdaptiveEntryPoint> {
  ChatController chatController = Get.put(ChatController());
  String address;

  @override
  void initState() {
    super.initState();
    if (!GetPlatform.isWeb) {
      chatController.createChatRoom();
    }
  }

  int page = 0;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWrapper.of(context).isDesktop) {
      return Scaffold(
        body: SafeArea(
          left: false,
          child: Column(
            children: [
              Container(
                height: 1.w,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Row(
                  children: [
                    DesktopDrawer(
                      value: page,
                      onChange: (value) {
                        page = value;
                        setState(() {});
                      },
                    ),
                    GetBuilder<DeviceController>(builder: (controller) {
                      return Expanded(
                        child: [
                          HomePage(
                            onMessageWindowTap: () {
                              page = 1;
                              setState(() {});
                            },
                            onJoinRoom: (value) {
                              address = value;
                              page = 1;
                              setState(() {});
                            },
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: ShareChatV2(
                                chatServerAddress: address,
                              ),
                            ),
                          ),
                          for (int i = 0;
                              i < controller.connectDevice.length;
                              i++)
                            Builder(
                              builder: (context) {
                                Uri uri = Uri.tryParse(
                                  controller.connectDevice[i].address,
                                );
                                String addr = 'http://${uri.host}:20000';
                                return FileManager(
                                  address: addr,
                                  usePackage: true,
                                  path:
                                      controller.connectDevice[i].deviceType ==
                                              desktop
                                          ? '/User'
                                          : '/sdcard',
                                );
                              },
                            ),
                          const FilePage(),
                          const SettingPage(),
                        ][page],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: [
                const HomePage(),
                const RemotePage(),
                const SizedBox(),
                const FilePage(),
                const SettingPage(),
              ][page],
            ),
            Nav(
              value: page,
              onTap: (value) {
                page = value;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}