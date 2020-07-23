import 'package:dropdown_suggestions_form_field/dropdown_suggestions_form_field.dart';
import 'package:flutter/material.dart';
import 'package:meds/ui/views/add_med/widgets/error_msg_w.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sized_context/sized_context.dart';

class EditableDropdownWidget extends StatelessWidget {
  EditableDropdownWidget({Key key, @required int index, @required String fieldName, Function onSave})
      : _index = 30 + index * 80.0,
        onSave = onSave,
        _fieldName = fieldName,
        super(key: key);

  final double _index;
  final Function onSave;
  final String _fieldName;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _index,
      child: ChangeNotifierProvider<ViewModel>(
        create: (_) => ViewModel(),
        child: Consumer<ViewModel>(
          builder: (context, model, child) {
            return buildFormField(context);
          },
        ),
      ),
    );
  }

  Widget buildFormField(BuildContext context) {
    ViewModel model = context.watch();
    return Stack(
      children: <Widget>[
        Container(
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
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(horizontal: context.widthPct(0.10)),
          alignment: Alignment.center,
          width: context.widthPct(0.80),
          child: DropdownSuggestionsFormField<String>(
            cardShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            ),
            key: model.dropDownSuggestionKey,
            onFieldSubmitted: model.onSubmitted,
            suggestionNotMatch: null,
            suggestionNotMatchMessage: ' ',
            suggestionMaxHeight: 150,
            filter: (value) {
              if (value == '?') return model.suggestions;
              List<String> filtered = [];
              for (String v in model.suggestions) {
                if (v.contains(value)) filtered.add(v);
              }
              return filtered;
            },
            items: model.suggestions,
            itemBuilder: (BuildContext context, int index, AsyncSnapshot<List<String>> snapshot) {
              String suggestion = snapshot.data.elementAt(index);
              return ItemBuilder(model: model, index: index, onSave: onSave, suggestion: suggestion);
            },
            onSelected: (String suggestion) => {},
            textStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Instructions: ? for a full list',
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
          ),
        ),
        // TODO: The error message is not displayed due to scoping issues.
        // FIXME:
        ErrorMsgWidget(fieldName: _fieldName),
      ],
    );
  }
}

class ItemBuilder extends StatelessWidget {
  const ItemBuilder({
    Key key,
    @required this.model,
    @required this.index,
    @required this.suggestion,
    @required this.onSave,
  }) : super(key: key);

  final ViewModel model;
  final int index;
  final String suggestion;
  final Function onSave;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direction) => model.onDismissed(suggestion),
      child: ListTile(
        dense: true,
        onTap: () {
          onSave(suggestion);
          model.onSelected(suggestion);
        },
        title: Text(
          '$suggestion',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ViewModel extends ChangeNotifier {
  SharedPreferences prefs;

  ViewModel() {
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    List<String> s = prefs.getStringList('suggestions');
    if (s != null && s.length > 0) suggestions = s;
  }

  void saveSuggestions() {
    prefs.setStringList('suggestions', suggestions);
  }

  String title = 'Editable DropDown List';

  GlobalKey<DropdownSuggestionsFormFieldState> dropDownSuggestionKey = GlobalKey<DropdownSuggestionsFormFieldState>();

  List<String> suggestions = ['daily', 'twice daily', 'before bed'];
  String currentValue;
  int selectedIndex;

  void onDismissed(String suggestion) {
    suggestions.removeAt(suggestions.indexOf(suggestion));
    saveSuggestions();
    notifyListeners();
  }

  void onSelected(String value) {
    dropDownSuggestionKey.currentState.onSelect(value);
    if (value == currentValue) return;
    currentValue = value;
  }

  void onSubmitted(String value) {
    if (value.length < 4) return;
    if (!suggestions.contains(value)) {
      suggestions.add(value);
      saveSuggestions();
      currentValue = value;
      notifyListeners();
    }
  }
}
