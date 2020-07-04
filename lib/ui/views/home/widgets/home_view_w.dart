import 'package:meds/core/constants.dart';
import 'package:meds/ui/views/add_med/add_med_view.dart';
import 'package:meds/ui/views/home/widgets/app_bar_w.dart';
import 'package:meds/ui/views/home/widgets/detail_card_w.dart';
import 'package:meds/ui/views/home/widgets/error_msg_w.dart';
import 'package:meds/ui/views/home/widgets/list_view_card.dart';
import 'package:meds/ui/views/widgets/stack_modal_blur.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeViewWidget extends StatelessWidget with Logger {
  HomeViewWidget() {
    setDebug(HOME_DEBUG);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    HomeViewModel _model = Provider.of(context);

    log('Meds available: ${_model.numberOfMeds}', linenumber: lineNumber(StackTrace.current));

    if (!_model.bottomsSet) {
      _model.setBottoms(
        cardUp: context.heightPct(0.14),
        cardDn: -(context.heightPct(1.0) + context.heightPct(0.14)),
      );
    }
    return SafeArea(
      child: Material(
        elevation: 10,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: HomeAppBar(),
          body: Stack(
            children: <Widget>[
              // This is the BACKGROUND image
              Positioned(
                top: context.heightPct(0.20),
                left: (context.widthPct(0.15)),
                child: Image.asset(
                  'assets/meds.png',
                  width: context.widthPct(0.70),
                ),
              ),
              ListView.builder(
                itemCount: _model.numberOfMeds,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _model.setActiveMedIndex(index);
                      _model.showDetailCard();
                    },
                    child: Dismissible(
                      key: UniqueKey(),
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.6,
                        DismissDirection.startToEnd: 0.6,
                      },
                      background: const Background(),
                      secondaryBackground: const SecondaryBackground(),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          /// Start edit process here and return false to not dismiss
                          ///
                          navigateToAddMed(context, index, _model);
                          return false;
                        }

                        /// true triggers a delete
                        return true;
                      },
                      onDismissed: (DismissDirection direction) {
                        return handleDismiss(_model, direction, index);
                      },
                      child: Container(
                        width: context.widthPx,
                        child: ListViewCard(index: index),
                      ),
                    ),
                  );
                },
              ),
              const ErrorMsgWidget(),
              if (_model.detailCardVisible)
                const StackModalBlur(),
              DetailCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// navigateToAddMed is done this way to eliminate an exception.
  ///   If the navigation is not done here, the Dismissible AnimationController
  ///   throws an exception for calling reverse() after dispose()
  ///
  Future navigateToAddMed(BuildContext context, int index, HomeViewModel _model) async {
    bool result = await Navigator.pushNamed<bool>(context, addMedRoute, arguments: AddMedArguments(editIndex: index));
    if (result != null && result) {
      _model.modelDirty(true);
    }
  }

  handleDismiss(HomeViewModel model, DismissDirection direction, int index) {
    // Get a reference to the swiped item
    //model.setActiveMedIndex(index);
    final swipedMed = model.getMedAt(index);

    // Remove it from the list
    model.delete(swipedMed);

    String action;
    if (direction == DismissDirection.endToStart)
      action = "Deleted";
    else
      action = "Edited";

    _scaffoldKey.currentState
        .showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(_scaffoldKey.currentContext).primaryColor,
            content: Text(
              '$action. Do you want to undo?',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
                label: "Undo",
                textColor: Colors.yellowAccent,
                onPressed: () async {
                  // Deep copy the deleted medication
                  final newMed = swipedMed.copyWith();
                  // Save the newly created medication
                  log('${newMed.mfg}', linenumber: lineNumber(StackTrace.current));
                  if (newMed.mfg.contains('Unknown')) await model.setDefaultMedImage(newMed.rxcui);
                  model.save(newMed);
                }),
          ),
        )
        .closed
        .then((reason) {
      if (reason != SnackBarClosedReason.action) {
        // The SnackBar was dismissed by some other means
        // other than clicking of action button
      }
    });
  }
}

class Background extends StatelessWidget {
  const Background({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        color: Colors.purple,
        child: ListTile(
          leading: Icon(Icons.edit),
          title: Text(
            'Edit',
            style: TextStyle(),
          ),
        ));
  }
}

class SecondaryBackground extends StatelessWidget {
  const SecondaryBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: ListTile(
          trailing: Icon(Icons.delete_forever),
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Delete',
              style: TextStyle(),
            ),
          ),
        ));
  }
}
