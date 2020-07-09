import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/locator.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/doctor_data.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/views/doctors/doctors_viewmodel.dart';

class DoctorsView extends StatelessWidget with Logger {
  final DoctorsViewModel _model = locator();
  final LoggerViewModel _debug = locator();

  @override
  Widget build(BuildContext context) {
    setDebug(_debug.isDebugging(DOCTOR_DEBUG));
    log('Building');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context, _model.addedDoctors);
            },
          ),
          title: Text('Manage your Doctors'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              tooltip: "Add a new doctor",
              icon: Icon(Icons.add_circle, color: Colors.white),
              padding: EdgeInsets.all(0.0),
              onPressed: () async {
                Navigator.pushNamed(context, addDoctorRoute);
              },
            ),
          ],
        ),
        body: DoctorListView(),
      ),
    );
  }
}

class DoctorListView extends StatefulWidget with Logger {
  final LoggerViewModel _debug = locator();

  @override
  _DoctorListViewState createState() {
    setDebug(_debug.isDebugging(DOCTOR_DEBUG));
    return _DoctorListViewState();
  }
}

class _DoctorListViewState extends State<DoctorListView> {
  DoctorsViewModel _model = locator();

  @override
  initState() {
    _model.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    _model.removeListener(update);
    super.dispose();
  }

  void update() {
    widget.log(
      'DoctorViewModel reported an update',
      linenumber: widget.lineNumber(StackTrace.current),
    );
    setState(() {});
  }

  DoctorData getDoctorByName(String name) {
    _model.getDoctorByName(name);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _model.numberOfDoctors,
      itemBuilder: (context, index) {
        DoctorData doctorData = _model.doctorByIndex(index);
        getDoctorByName(doctorData.name);
        return Dismissible(
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
              _model.setActiveDoctor(index);

              /// edit item : launch edit function from here
              Navigator.pushNamed(context, addDoctorRoute);
              return false;
            }

            /// delete
            return true;
          },
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              /// Handle delete operations here
              _model.deleteDoctor(index);
            } else if (direction == DismissDirection.startToEnd) {
              /// This never happens because confirmDismiss returns false
              /// for startToEnd swipe, therefore the item is not dismissed
              print('EDIT');
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 6),
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                child: Image.asset('assets/doctor.png'),
              ),
              title: Text(
                '${doctorData.name}: ${doctorData.id}',
                style: TextStyle(color: Colors.black),
              ),
              trailing: Text(
                '${doctorData.phone}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 4,
        );
      },
    );
  }
}
