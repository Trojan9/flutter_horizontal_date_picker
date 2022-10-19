import 'package:flutter/material.dart';
import 'package:flutter_horizontal_date_picker/flutter_horizontal_date_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const int _kSampleItemCountDay = 40;
const int _kSampleItemCountHour = 40;
const int _kSampleItemCountMinute = 50;
const int _kSampleItemCountSecond = 60;

const Duration _kSampleDurationToEndDay = Duration(days: 40);
const Duration _kSampleDurationToEndHour = Duration(hours: 30);
const Duration _kSampleDurationToEndMinute = Duration(minutes: 100);
const Duration _kSampleDurationToEndSecond = Duration(seconds: 120);

class _MyAppState extends State<MyApp> {
  DateTime? selected0;
  DateTime? selected1;
  DateTime? selected2;
  DateTime? selected3;

  bool use000000 = false;
  DateTime get _now => use000000 ? DateTime.now().to000000 : DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (selected0 == null) {
      selected0 = _now.add(Duration(days: 5));
    }
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Horizontal Date Picker'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Skip current HH:mm:ss'),
                  Checkbox(
                    value: use000000,
                    onChanged: (value) {
                      setState(() {
                        use000000 = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FittedBox(
                child: Text(
                  "Days:\n$_now to ${_now.add(_kSampleDurationToEndDay)}\n$_kSampleItemCountDay items",
                  textAlign: TextAlign.center,
                ),
              ),
              HorizontalDatePicker(
                needFocus: true,
                begin: _now,
                end: _now.add(_kSampleDurationToEndDay),
                selected: selected0,
                onSelected: (item) {
                  setState(() {
                    selected0 = item;
                  });
                },
                itemBuilder: (DateTime itemValue, DateTime? selected) {
                  var isSelected =
                      selected?.difference(itemValue).inMilliseconds == 0;
                  return Text(
                    itemValue.formatted(pattern: "EEE\ndd/MM\nHH:mm:ss"),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
                itemCount: _kSampleItemCountDay,
                itemSpacing: 12,
              ),
              Divider(
                height: 12,
              ),
              FittedBox(
                child: Text(
                  "Hours:\n$_now to ${_now.add(_kSampleDurationToEndHour)}\n$_kSampleItemCountHour items",
                  textAlign: TextAlign.center,
                ),
              ),
              HorizontalDatePicker(
                begin: _now,
                end: _now.add(_kSampleDurationToEndHour),
                selected: selected1,
                onSelected: (item) {
                  setState(() {
                    selected1 = item;
                  });
                },
                itemBuilder: (DateTime itemValue, DateTime? selected) {
                  var isSelected =
                      selected?.difference(itemValue).inMilliseconds == 0;
                  return Text(
                    itemValue.formatted(pattern: "EEE\ndd/MM\nHH:mm:ss"),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
                itemCount: _kSampleItemCountHour,
                itemSpacing: 12,
              ),
              Divider(
                height: 12,
              ),
              FittedBox(
                child: Text(
                  "Minutes:\n$_now to ${_now.add(_kSampleDurationToEndMinute)}\n$_kSampleItemCountMinute items",
                  textAlign: TextAlign.center,
                ),
              ),
              HorizontalDatePicker(
                begin: _now,
                end: _now.add(_kSampleDurationToEndMinute),
                selected: selected2,
                onSelected: (item) {
                  setState(() {
                    selected2 = item;
                  });
                },
                itemBuilder: (DateTime itemValue, DateTime? selected) {
                  var isSelected =
                      selected?.difference(itemValue).inMilliseconds == 0;
                  return Text(
                    itemValue.formatted(pattern: "EEE\ndd/MM\nHH:mm:ss"),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
                itemCount: _kSampleItemCountMinute,
                itemSpacing: 12,
              ),
              Divider(
                height: 12,
              ),
              FittedBox(
                child: Text(
                  "Seconds:\n$_now to ${_now.add(_kSampleDurationToEndSecond)}\n$_kSampleItemCountSecond items",
                  textAlign: TextAlign.center,
                ),
              ),
              HorizontalDatePicker(
                begin: _now,
                end: _now.add(_kSampleDurationToEndSecond),
                selected: selected3,
                onSelected: (item) {
                  setState(() {
                    selected3 = item;
                  });
                },
                itemBuilder: (DateTime itemValue, DateTime? selected) {
                  var isSelected =
                      selected?.difference(itemValue).inMilliseconds == 0;
                  return Text(
                    itemValue.formatted(pattern: "EEE\ndd/MM\nHH:mm:ss"),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
                itemCount: _kSampleItemCountSecond,
                itemSpacing: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
