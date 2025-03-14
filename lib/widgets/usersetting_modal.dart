import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytodo/providers/displayname_provider.dart';
import 'package:mytodo/providers/smiley_provider.dart';
import 'package:mytodo/providers/sneakpeek_provider.dart';
import 'package:mytodo/services/firebase_service.dart';
import 'package:mytodo/services/navigation.dart';
import 'package:mytodo/theme/theme.dart';
import 'package:mytodo/widgets/deleteuser_modal.dart';
import 'package:mytodo/widgets/signout_modal.dart';
import 'package:mytodo/widgets/username_modal.dart';
import 'package:signals/signals_flutter.dart';

class UserSettingsModal extends ConsumerStatefulWidget {
  const UserSettingsModal({super.key});

  @override
  ConsumerState<UserSettingsModal> createState() {
    return UserSettingsModalState();
  }
}

class UserSettingsModalState extends ConsumerState<UserSettingsModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'User Settings',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(thickness: 4.0),

          // Profile ListTile.
          ListTile(
            onTap: () async {
              // If user is a sneak peeker, close the modal and show a snack.
              if (ref.watch(isSneakPeekerProvider)) {
                Navigator.pop(context);
                showSneakPeekerSnack(context);
              }
              // If user is not a sneak peeker, show the second modal to change
              // the username.
              else {
                await showModalBottomSheet<BottomSheet>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (BuildContext context) {
                    return const UsernameModal();
                  },
                );
              }
            },
            // title: Text(ref.watch(displayNameProvider)),
            // subtitle: const Text('profile emoji'),
            // trailing: FaIcon(ref.watch(smileyProvider)),
          ),

          // Change thememode ListTile.
          ListTile(
            onTap: () {
              // Whether the user is a sneak peeker or not, change the theme.
              sIsDark.value = !sIsDark.value;
              // If the user is not a sneak peeker, update the theme in the
              // Firestore database as well.
              if (!ref.watch(isSneakPeekerProvider)) {
                FirebaseService(ref).updateThemeMode((Object error) {
                  // If anything goes wrong:
                  showErrorSnack(context, error);
                }, (String success) {
                  // If all goes well: Do nothing.
                });
              }
            },
            title: sIsDark.watch(context)
                ? const Text('Dark Mode')
                : const Text('Light Mode'),
            subtitle: const Text('App theme'),
            trailing: sIsDark.watch(context)
                ? const FaIcon(FontAwesomeIcons.moon)
                : const FaIcon(FontAwesomeIcons.sun),
          ),

          // Change themecolor ListTile.
          // ListTile(
          //   onTap: () {
          //     // Whether the user is a sneak peeker or not, change the color.
          //     sIsGreen.value = !sIsGreen.value;
          //     // If the user is not a sneak peeker, update the color in the
          //     // Firestore database as well.
          //     if (!ref.watch(isSneakPeekerProvider)) {
          //       FirebaseService(ref).updateThemeColor((Object error) {
          //         // If anything goes wrong:
          //         showErrorSnack(context, error);
          //       }, (String success) {
          //         // If all goes well: Do nothing.
          //       });
          //     }
          //   },
          //   title: sIsGreen.watch(context)
          //       ? const Text('Green Money')
          //       : const Text('Espresso'),
          //   subtitle: const Text('Change the app colors'),
          //   trailing: sIsGreen.watch(context)
          //       ? const FaIcon(FontAwesomeIcons.moneyBills)
          //       : const FaIcon(FontAwesomeIcons.mugHot),
          // ),

          // Sign out listtile.
          // ListTile(
          //   onTap: () async {
          //     if (ref.watch(isSneakPeekerProvider)) {
          //       Navigation.navigateToLoginScreen(context);
          //       showSuccessSnack(context);
          //     } else {
          //       await showModalBottomSheet<BottomSheet>(
          //         isScrollControlled: true,
          //         showDragHandle: true,
          //         context: context,
          //         builder: (BuildContext context) {
          //           return const SignoutModal();
          //         },
          //       );
          //     }
          //   },
          //   title: const Text('Sign Out'),
          //   subtitle: const Text('BACK'),
          //   trailing: const FaIcon(
          //     FontAwesomeIcons.personWalkingDashedLineArrowRight,
          //   ),
          // ),
          // Delete user listtile.
          ListTile(
            onTap: () async {
              if (ref.watch(isSneakPeekerProvider)) {
                showSneakPeekerSnack(context);
              } else {
                await showModalBottomSheet<BottomSheet>(
                  isScrollControlled: true,
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const DeleteUserModal();
                  },
                );
              }
            },
            title: const Text('Delete Account'),
            subtitle: const Text('Remove'),
            trailing: const FaIcon(FontAwesomeIcons.trashCan),
          ),
        ],
      ),
    );
  }

  void showErrorSnack(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$error'),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            sIsDark.value ? cFlexSchemeDark().error : cFlexSchemeLight().error,
      ),
    );
  }

  void showSuccessSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully signed out!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSneakPeekerSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You are currently in sneak peek mode. '
            'Please sign in to get access.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            sIsDark.value ? cFlexSchemeDark().error : cFlexSchemeLight().error,
      ),
    );
  }
}
