import 'package:flutter/material.dart';
import 'package:sized_context/sized_context.dart';

import 'package:meds/core/mixins/logger.dart';
import 'package:meds/ui/views/add_med/widgets/error_msg_w.dart';

class AddMedField extends StatelessWidget with Logger {
  AddMedField({Key key, @required int index, String initialValue, Function onSave, String hint, String error})
      : _index = 30 + index * 80.0,
        _initialValue = initialValue,
        _onSave = onSave,
        _hint = hint,
        _error = error,
        super(key: key);

  final double _index;
  final String _initialValue;
  final Function _onSave;
  final String _hint;
  final String _error;

  @override
  Widget build(BuildContext context) {
    setDebug(false);
    log('Re-Building');
    return Positioned(
      top: _index,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0.0, 5.0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
            borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: context.widthPct(0.10)),
        alignment: Alignment.center,
        width: context.widthPct(0.80),
        child: Stack(children: <Widget>[
          TextFormField(
            initialValue: _initialValue,
            enableSuggestions: true,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _hint,
              hintStyle: TextStyle(color: Colors.grey[700]),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            // The validator receives the text that the user has entered.
            //validator: _validator,
            onSaved: _onSave,
          ),
          ErrorMsgWidget(error: _error),
        ]),
      ),
    );
  }
}