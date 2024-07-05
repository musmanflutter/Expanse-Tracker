import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

//Uuid() is a class bu uuid package that gives a unique id
const uuid = Uuid();

//enums: combination of predefined values
enum Categories { food, travel, leisure, work }

//creating a variable to format dates.
final formatter = DateFormat.yMd();

//we are defining a map of icons
const categoryIcons = {
  Categories.food: Icons.lunch_dining,
  Categories.travel: Icons.flight_takeoff,
  Categories.leisure: Icons.movie,
  Categories.work: Icons.work,
};

class Expanse {
  Expanse(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category
      //: id.. by this.. we are initialsing a propertly with a value
      //.v4 means a unique string id
      })
      : id = uuid.v4();
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  //we are making category properry of Categories type which means it could
  //only get accessed to those enums.
  final Categories category;

  String get formatDate {
    //this will return a formatted date
    //format string respresenting the date
    return formatter.format(date);
  }
}

//this class will be used for creating chark buckets.
class ExpanseBucket {
  ExpanseBucket({required this.category, required this.expenses});

//this constructor will filter out expanses with same category
  ExpanseBucket.forCategory(List<Expanse> allExpanse, this.category)
      : expenses = allExpanse.where((exp) => exp.category == category).toList();

  final Categories category;
  final List<Expanse> expenses;

  double get totalExpanses {
    double sum = 0;

//this is another syntax for for loop
//final exp means initializing a variable
//in expanses means go through each item in expanses and store it in exp each time
    for (final exp in expenses) {
      sum += exp.amount;
    }
    return sum;
  }
}
