import 'package:flutter/material.dart';
import 'package:hop_on/core/map/screens/home.dart';
import 'package:hop_on/core/profile/screens/profile_screen.dart';

import '../../Utils/colors.dart';
import '../../config/sizeconfig/size_config.dart';

class AppDrawer extends StatefulWidget {
  final double width;
  const AppDrawer({Key? key, required this.width}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final SizeConfig _config = SizeConfig();
  bool isDriver = false;

  @override
  Widget build(BuildContext context) {
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
                leading: Icon(Icons.person_rounded,
                    size: 22, color: AppColors.PRIMARY_500),
                title: Text('Profile', style: textStyle),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProfileScreen()),
                  )
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.map, size: 22, color: AppColors.PRIMARY_500),
                title: Text('Map', style: textStyle),
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MapScreen()),
                  )
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.star, size: 22, color: AppColors.PRIMARY_500),
                title: Text('Ride History', style: textStyle),
              ),
              ListTile(
                leading: Icon(Icons.settings,
                    size: 22, color: AppColors.PRIMARY_500),
                title: Text('Settings', style: textStyle),
              ),
              
              Spacer(),
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 1.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            width: _config.sw(30).toDouble(),
                            height: _config.sh(65).toDouble(),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Switch.adaptive(
                                trackColor:
                                    MaterialStateProperty.all(Colors.black38),
                                activeColor: AppColors.LM_BACKGROUND_BASIC,
                                inactiveThumbColor:
                                    AppColors.LM_BACKGROUND_BASIC,
                                activeThumbImage: const AssetImage(
                                    'assets/images/carpool.png'),
                                inactiveThumbImage: const AssetImage(
                                    'assets/images/driver.png'),
                                value: isDriver,
                                onChanged: (value) => setState(() {
                                  isDriver = !isDriver;
                                }),
                              ),
                            ),
                          ),
                        ),
                        Text(isDriver ? 'Switch to rider' : 'Switch to driver',
                            style: textStyle),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
