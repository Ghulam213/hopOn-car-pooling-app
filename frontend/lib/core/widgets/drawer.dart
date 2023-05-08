import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    return prefs.getString('userMode')!;
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
              const Spacer(),
              Consumer<LoginStore>(builder: (_, loginStore, __) {
                return Observer(
                  builder: (_) => ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            // Center(
                            //   child: SizedBox(
                            //     width: config.sw(30).toDouble(),
                            //     height: config.sh(65).toDouble(),
                            //     child: FittedBox(
                            //       fit: BoxFit.fitHeight,
                            //       child: Switch.adaptive(
                            //         trackColor:
                            //             MaterialStateProperty.all(Colors.black38),
                            //         activeColor: AppColors.LM_BACKGROUND_BASIC,
                            //         inactiveThumbColor:
                            //             AppColors.LM_BACKGROUND_BASIC,
                            //         activeThumbImage: const AssetImage(
                            //             'assets/images/carpool.png'),
                            //         inactiveThumbImage: const AssetImage(
                            //             'assets/images/driver.png'),
                            //             value: loginStore.isDriver,
                            //         onChanged: (value) => setState(() {
                            //               isDriver = !loginStore.isDriver;
                            //         }),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.PRIMARY_500),
                                child: Text(
                                    checkCurrentMode() != 'PASSENGER'
                                        ? 'Switch to passenger'
                                        : 'Switch to driver',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.0,
                                            color: AppColors.WHITE)),
                                onPressed: () async {
                                  viewModel.updateProfile(
                                      currentMode: await checkCurrentMode());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
