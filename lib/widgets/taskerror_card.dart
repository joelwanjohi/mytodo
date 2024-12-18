import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mytodo/theme/theme.dart';

class TaskErrorCard extends ConsumerWidget {
  const TaskErrorCard(
    this.error,
    this.stackTrace, {
    super.key,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = sIsDark.value;
    Logger().e(error, stackTrace: stackTrace);
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color:
              isDarkMode ? cFlexSchemeDark().error : cFlexSchemeLight().error,
          width: 2.0,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                  color: isDarkMode
                      ? cFlexSchemeDark().error
                      : cFlexSchemeLight().error,
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          error.toString(),
                          maxLines: 4,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: isDarkMode
                                ? cFlexSchemeDark().error
                                : cFlexSchemeDark().error,
                          ),
                        ),
                        subtitle: Text(
                          stackTrace.toString(),
                          maxLines: 4,
                          overflow: TextOverflow.fade,
                        ),
                        trailing: FaIcon(
                          FontAwesomeIcons.triangleExclamation,
                          color: isDarkMode
                              ? cFlexSchemeDark().error
                              : cFlexSchemeLight().error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Divider(thickness: 2.0),
                    const SizedBox(height: 4.0),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Category: ERROR'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('Created: ERROR'),
                            Text(
                              'Due: ERROR',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
