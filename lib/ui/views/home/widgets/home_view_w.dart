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
import 'package:meds/core/models/med_data.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeViewWidget extends StatelessWidget with Logger {
  HomeViewWidget() {
    setDebug(false);
  }

  @override
  Widget build(BuildContext context) {
    HomeViewModel _model = Provider.of(context);

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
                  MedData medData = _model.medList[index];
                  log('Item # : $index', linenumber: lineNumber(StackTrace.current));
                  return GestureDetector(
                    onTap: () {
                      _model.setActiveMedIndex(index);
                      _model.showDetailCard();
                    },
                    child: Dismissible(
                      key: UniqueKey(),
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.7,
                        DismissDirection.startToEnd: 0.6,
                      },
                      background: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.purple,
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text(
                              'Edit',
                              style: TextStyle(),
                            ),
                          )),
                      secondaryBackground: Container(
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
                          )),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          /// Start edit process here and return false to not dismiss
                          bool result = await Navigator.pushNamed<bool>(context, addMedRoute,
                              arguments: AddMedArguments(editIndex: index));
                          if (result != null && result) {
                            _model.modelDirty(true);
                          }
                          return false;
                        }
                        /// true triggers a delete
                        return true;
                      },
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.endToStart) {
                          /// Handle delete operations here
                          _model.delete(medData);
                          log('Deleted from model: ${medData.name}');
                        } else if (direction == DismissDirection.startToEnd) {
                          /// This never happens because confirmDismiss returns false
                          /// for startToEnd swipe, therefore the item is not dismissed
                          print('EDIT');
                        }
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
}
