String capitalizeWords(String text) {
  String symbol = "";
  String newText = "";
  if (text.contains(" ")) {
    symbol = " ";
  } else if (text.contains("_")) {
    symbol = "_";
  } else if (text.contains("-")) {
    symbol = "-";
  }
  if (symbol == " " || symbol == "_" || symbol == "-") {
//Test Title, Test word, test Word, table_name, poly-name
    List words = text.split(symbol);
    words.forEach((word) {
      if (word.toString().length < 4)
        newText += word.toString() + symbol;
      else
        newText +=
            word.substring(0, 1).toUpperCase() + word.substring(1) + symbol;
    });
  } else {
    //varName, Title, ClassName
    newText = text.substring(0, 1).toUpperCase() + text.substring(1);
  }
  return newText;
}
