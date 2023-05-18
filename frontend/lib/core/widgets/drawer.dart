import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hop_on/core/auth/screens/auth_screen.dart';
import 'package:hop_on/core/map/screens/home.dart';
import 'package:hop_on/core/profile/screens/profile_screen.dart';
import 'package:hop_on/core/profile/viewmodel/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/colors.dart';
import '../../config/sizeconfig/size_config.dart';
import '../auth/provider/login_store.dart';

class AppDrawer extends StatefulWidget {
  final double width;
  const AppDrawer({Key? key, required this.width}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final SizeConfig config = SizeConfig();
  bool isDriver = false;

  Future<String> checkCurrentMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userMode') != 'DRIVER' ? 'driver' : 'passenger';
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const AuthScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileViewModel viewModel = context.watch<ProfileViewModel>();

    var textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: AppColors.PRIMARY_500);

    return Drawer(
      backgroundColor: Colors.white,
      child: Theme(
        data: ThemeData(brightness: Brightness.light),
        child: SizedBox(
          width: widget.width,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(height: 40),
              ListTile(
                leading: const Icon(Icons.person_rounded,
                    size: 22, color: AppColors.PRIMARY_500),
                title: Text('Profile', style: textStyle),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  )
                },
              ),
              ListTile(
                leading: const Icon(Icons.map,
                    size: 22, color: AppColors.PRIMARY_500),
                title: Text('Map', style: textStyle),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MapScreen()),
                  )
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined,
                    size: 22, color: AppColors.PRIMARY_500),
                title: Text('Logout', style: textStyle),
                onTap: () async {
                  logoutUser();
                },
              ),
              const Spacer(),
              Consumer<LoginStore>(builder: (_, loginStore, __) {
                return Observer(
                  builder: (_) => viewModel.hasRegisteredForDriver
                      ? ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.PRIMARY_500),
                                child: FutureBuilder<String>(
                                  future: checkCurrentMode(),
                                  builder: (_, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    return Text(
                                      'Switch to ${snapshot.data.toString().toLowerCase()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.0,
                                            color: AppColors.WHITE,
                                          ),
                                    ); //👈 Your valid data here
                                  },
                                ),
                                onPressed: () async {
                                  await viewModel.switchCurrentMode();
                                  if (mounted) {
                                    Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return const AuthScreen();
                                              },
                                            ),
                                          );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                        )
                      : const SizedBox.shrink(),
                );
              }),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
