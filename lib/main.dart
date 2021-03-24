import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snapwork_demo/constant.dart';
import 'package:date_util/date_util.dart';

void main() {
  return runApp(
    MyApp(),
  );
}

Map<String, String> events = {};

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int year;
  int month;

  var _yearDropDownItems = kYearDropDown
      .map(
        (value) => DropdownMenuItem<String>(
          value: value.toString(),
          child: Text(
            value.toString(),
          ),
        ),
      )
      .toList();
  var _monthDropDownItems = kMonthDropDown.entries
      .map(
        (e) => DropdownMenuItem<String>(
          value: e.key.toString(),
          child: Text(
            e.value,
          ),
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();

    log(kYearDropDown.toString());
    year = DateTime.now().year;
    month = DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Events'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.blue[900],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    value: year.toString(),
                    onChanged: (String newValue) {
                      year = int.parse(newValue);
                      setState(() {});
                    },
                    items: _yearDropDownItems,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.blue[900],
                      filled: true,
                    ),
                    // hint: const Text('Select State'),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.blue[900],

                    style: TextStyle(
                      color: Colors.white,
                    ),
                    value: month.toString(),
                    onChanged: (String newValue) {
                      month = int.parse(newValue);
                      setState(() {});
                    },
                    items: _monthDropDownItems,

                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(),
                      fillColor: Colors.blue[900],
                    ),
                    // hint: const Text('Select State'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: DateUtil().daysInMonth(month, year),
                  itemBuilder: (context, index) {
                    var eventMonth =
                        DateUtil().month(month).toString().substring(0, 3);
                    var eventDay = index + 1;
                    String title = (events['$eventDay-$eventMonth-$year'] ==
                            null)
                        ? ''
                        : events['$eventDay-$eventMonth-$year'].split(",")[0];
                    String dateTime = (events['$eventDay-$eventMonth-$year'] ==
                            null)
                        ? ''
                        : events['$eventDay-$eventMonth-$year'].split(",")[1];
                    String description =
                        (events['$eventDay-$eventMonth-$year'] == null)
                            ? ''
                            : events['$eventDay-$eventMonth-$year']
                                .split(",")[2];
                    String time =
                        (events['$eventDay-$eventMonth-$year'] == null)
                            ? ''
                            : dateTime.split(" ")[0];
                    return Container(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EventDetail(
                                    appointmentDate:
                                        '$eventDay-$eventMonth-$year',
                                    title: title,
                                    description: description,
                                    time: time);
                              }));
                              setState(() {});
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dateTime),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(title),
                              ],
                            ),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  eventDay.toString() ?? '',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  kMonthDropDown[month.toString()].toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Divider(
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class EventDetail extends StatefulWidget {
  final appointmentDate;
  final title;
  final description;
  final time;

  const EventDetail(
      {Key key, this.appointmentDate, this.title, this.description, this.time})
      : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  TextEditingController _cTitle;
  TextEditingController _cDescription;
  TextEditingController _cTime;

  @override
  void initState() {
    super.initState();

    _cTitle = TextEditingController(text: widget.title);
    _cDescription = TextEditingController(text: widget.description);

    _cTime = TextEditingController(text: widget.time);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Even Details'),
        centerTitle: true,
        leading: TextButton(
          child: Text(
            'Back',
            style: TextStyle(
              color: Colors.white60,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: size.width * 0.3,
                  child: Text(
                    'Date & Time',
                  ),
                ),
                Container(
                  width: size.width * 0.3,
                  child: TextField(
                    controller: _cTime,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'HH:MM',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(widget.appointmentDate),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.3,
                  child: Text(
                    'Title',
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _cTitle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Description',
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: _cDescription,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    log('taped');
                    var day = widget.appointmentDate.toString().split("-")[0];
                    var month = widget.appointmentDate.toString().split("-")[1];

                    var year = widget.appointmentDate.toString().split("-")[2];
                    if (_cTitle.text.isNotEmpty &&
                        _cTime.text.isNotEmpty &&
                        _cDescription.text.isNotEmpty) {
                      events['$day-$month-$year'] =
                          '${_cTitle.text},${_cTime.text} ${widget.appointmentDate.toString()},${_cDescription.text}';
                      log(events.toString());
                    }

                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width,
                    height: 50,
                    color: Colors.blue[900],
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
