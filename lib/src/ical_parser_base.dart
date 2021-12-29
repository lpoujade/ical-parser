import 'dart:collection';

class ICal {
  static Map<String, dynamic> toJson(String calData) {
    var cal = <String, dynamic>{};

    var currentMap = cal;
    var currentPath = Queue();

    var lines = calData.split('\n');

    String? key;

    loop:
    for(var line in lines) {
      if (line.startsWith(RegExp(r'\s'))) {
        // add to multiple-line
        line = line.substring(1);
        if(key != null) currentMap[key] += line;
      } else if(line.contains(':')) {
        var separator_pos = line.indexOf(':');

        key = line.substring(0, separator_pos).trim();
        var value = line.substring(separator_pos)
            .replaceFirst(':', '').trim();

        if(key == 'BEGIN') {
          // Skip
          if(value == 'VCALENDAR') continue loop;

          // Create array
          if(!currentMap.containsKey(value)) {
            currentMap[value] = [];
          }

          // Add new object
          var list = currentMap[value] as List;
          list.add(<String, dynamic>{});

          // Set new current position
          currentPath.add(currentMap);
          currentMap = list.last;

        } else if(key == 'END') {
          if(value == 'VCALENDAR') return cal;

          currentMap = currentPath.removeLast();

        } else{
          currentMap[key] = value;
        }
      } else {
        if(key != null) currentMap[key] += line;
      }
    }

    return cal;
  }

}
