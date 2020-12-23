import 'dart:math';

extension Strings on String {
  String trimIndent() {
    var lines = this.split(RegExp("\r\n|\r|\n"));

    var minIndent = lines.where((line) => line.trim().isNotEmpty).map((line) {
      var index = line.indexOf(RegExp("\S"));
      return index > -1 ? index : line.length - 1;
    }).reduce(min);

    // remove indent
    lines = lines
        .map(
            (line) => line.length <= minIndent ? '' : line.substring(minIndent))
        .toList();

    return lines.join("\n");
  }
}
