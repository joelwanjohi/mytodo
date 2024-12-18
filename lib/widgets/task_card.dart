import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytodo/models/task_model.dart';
import 'package:mytodo/providers/tasklist_provider.dart';
import 'package:mytodo/theme/theme.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard(
    this.task, {
    super.key,
  });
  final Task task;

  @override
  ConsumerState<TaskCard> createState() {
    return TaskCardState();
  }
}

class TaskCardState extends ConsumerState<TaskCard> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = sIsDark.value;
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: widget.task.isCompleted
          ? isDarkMode
              ? cFlexSchemeDark().primaryContainer
              : cFlexSchemeLight().primaryContainer
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: widget.task.isCompleted
              ? isDarkMode
                  ? cFlexSchemeDark().primary
                  : cFlexSchemeLight().primary
              : isDarkMode
                  ? cFlexSchemeDark().outline
                  : cFlexSchemeLight().outline,
          width: 0.0,
        ),
      ),
      child: Stack(
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      ),
                      color: widget.task.category == 'personal'
                          ? isDarkMode
                              ? cFlexSchemeDark().primary
                              : cFlexSchemeLight().primary
                          : widget.task.category == 'work'
                              ? isDarkMode
                                  ? cFlexSchemeDark().secondary
                                  : cFlexSchemeLight().secondary
                              : widget.task.category == 'study'
                                  ? isDarkMode
                                      ? cFlexSchemeDark().tertiary
                                      : cFlexSchemeLight().tertiary
                                  : cFlexSchemeLight().primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 350,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              widget.task.title,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: widget.task.isCompleted
                                    ? isDarkMode
                                        ? cFlexSchemeDark().outline
                                        : cFlexSchemeLight().outline
                                    : null,
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              widget.task.description ?? 'No Description',
                              maxLines: 4,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: widget.task.isCompleted
                                    ? sIsDark.value
                                        ? cFlexSchemeDark().outline
                                        : cFlexSchemeLight().outline
                                    : null,
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: widget.task.isCompleted
                                ? GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(taskListProvider.notifier)
                                          .toggleCompleted(widget.task.id!);
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.circleCheck,
                                      color: sIsDark.value
                                          ? cFlexSchemeDark().primary
                                          : cFlexSchemeLight().primary,
                                      size: 20.0,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      confettiController.play();
                                      ref
                                          .read(taskListProvider.notifier)
                                          .toggleCompleted(widget.task.id!);
                                    },
                                    child: const FaIcon(
                                      FontAwesomeIcons.circle,
                                      size: 20.0,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        // const Divider(thickness: 2.0),
                        const SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.task.category ?? 'No Category'),
                            Row(
                              children: <Widget>[
                                // IconButton(
                                //   onPressed: () async {
                                //     await showModalBottomSheet<void>(
                                //       showDragHandle: true,
                                //       isScrollControlled: true,
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         return Column(
                                //           mainAxisSize: MainAxisSize.min,
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           children: <Widget>[
                                //             const Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.center,
                                //               children: <Widget>[
                                //                 Text(
                                //                   'Focus Mode',
                                //                   style: TextStyle(
                                //                     fontSize: 24.0,
                                //                     fontWeight: FontWeight.bold,
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //             const Divider(
                                //               thickness: 2,
                                //             ),
                                //             const SizedBox(height: 8.0),
                                //             TimePickerDialog(
                                //               initialTime: TimeOfDay.now(),
                                //             ),
                                //           ],
                                //         );
                                //       },
                                //     );
                                //   },
                                // //  icon: const FaIcon(FontAwesomeIcons.solidMoon)

                                // ),
                                const SizedBox(width: 8.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'Created: ${widget.task.createdDate!}',
                                    ),
                                    Text(
                                      'Due: ${widget.task.dueDate!}',
                                    ),
                                  ],
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
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: confettiController,
              numberOfParticles: 150,
            ),
          ),
        ],
      ),
    );
  }
}
