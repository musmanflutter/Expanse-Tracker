import 'package:expanse_tracker/widgets/chart/chart.dart';
import 'package:expanse_tracker/widgets/expenses_list/expanses_list.dart';
import 'package:expanse_tracker/widgets/new_expanse.dart';
import 'package:flutter/material.dart';

import 'package:expanse_tracker/models/expanse.dart';

class Expanses extends StatefulWidget {
  const Expanses({super.key});

  @override
  State<Expanses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expanses> {
  final List<Expanse> _registeredExpanses = [
    Expanse(
      title: 'Fluter',
      amount: 22.55,
      date: DateTime.now(),
      //see we are are to use enums here.
      category: Categories.work,
    ),
    Expanse(
      title: 'cinema',
      amount: 10.55,
      date: DateTime.now(),
      category: Categories.leisure,
    ),
  ];

  void _addExpanse(Expanse expanse) {
    setState(() {
      _registeredExpanses.add(expanse);
    });
  }

  void _removeExpanse(Expanse expanse) {
    //index of method is used to get the position/index of an item
    final expanseIndex = _registeredExpanses.indexOf(expanse);
    setState(() {
      _registeredExpanses.remove(expanse);
    });
    //clearSnackBars will clear the current snackbar on the screen
    //if this isnt used, then the first snackbar will be shown for 3 sec
    //and if 2 items are deleted then it wont give snack bar immdeiately instead it will be shown after
    //3 sec when first snackbar is already disappered.
    ScaffoldMessenger.of(context).clearSnackBars();
    //scaffoldMessenger used to manage snack bars
    //showSnackBar shows a snack bar
    //snackbar is a dialog box which is shown at the bottom of the screen usually
    //containing some info and a method to undo a delete.
    ScaffoldMessenger.of(context).showSnackBar(
      //snackBar creates a snack bar
      SnackBar(
        //duration: for how long it should stay
        duration: const Duration(seconds: 3),
        //content to be displayed when its deleted
        content: const Text('Expanse deleted'),
        //action to be taken when its deleted
        //SnackBarAction create action for snack bar
        action: SnackBarAction(
            //label to be shown
            label: 'Undo',
            //action to be done
            onPressed: () {
              setState(() {
                //insert is used to insert on a fixed index
                _registeredExpanses.insert(expanseIndex, expanse);
              });
            }),
      ),
    );
  }

  void _openAddExpensesOver() {
    showModalBottomSheet(
      //isScrollControlled will take the entire screen for modal bottom sheet
      isScrollControlled: true,
      //useSafearea means dont screen part occupied by camera lets say
      //it ensures that camera, etc doesnt overlap ui on any device.
      useSafeArea: true,
      context: context,
      builder: (ctx) => NewExpanse(onAddExpanse: _addExpanse),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No Expanse found, start adding some'),
    );
//isnot epmty means if it contains a value
    if (_registeredExpanses.isNotEmpty) {
      mainContent = ExpansesList(
        expanses: _registeredExpanses,
        onRemoveExpanse: _removeExpanse,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Expanse Manager',
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOver,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      //if height is less then 600 then column will be shown
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpanses),
                //we are wrapping in expanded becuase we are using a list(Listtile) inside another list(Column)
                //that creates error, so we wrap it inside expanded to limit its height.
                Expanded(child: mainContent),
              ],
            )
          :
          //else row will be shown
          Row(
              children: [
                //we wrapped with expanded because chart contains width double.infinity while row contains the same.
                Expanded(child: Chart(expenses: _registeredExpanses)),
                //we are wrapping in expanded becuase we are using a list(Listtile) inside another list(Column)
                //that creates error, so we wrap it inside expanded to limit its height.
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
