import 'package:flutter/material.dart';

import 'package:expanse_tracker/models/expanse.dart';
import 'package:expanse_tracker/widgets/expenses_list/expanse_item.dart';

class ExpansesList extends StatelessWidget {
  const ExpansesList(
      {super.key, required this.expanses, required this.onRemoveExpanse});

  final List<Expanse> expanses;
  final void Function(Expanse expanse) onRemoveExpanse;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expanses.length,
        //dismissible makes its child removeable by swiping
        itemBuilder: (context, index) => Dismissible(
              //background to be shown when a widget is dragged
              background: Container(
                //.error means a special color theme
                //withOpacity defines a opacity for that error color
                color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              ),
              //key is just a unique identifier
              //valuekey helps creating a unique key, takes a unique identifier, and
              //delete a list virtually not physically
              key: ValueKey(expanses[index]),
              //this is action to be taken just like onPresed
              //we are using an anonymous function because it requires a function
              //that reacts diffrently according to right or left swap
              //we take direction but didnt used it
              onDismissed: (direction) {
                onRemoveExpanse(expanses[index]);
              },
              child: ExpanseItem(
                expanses[index],
              ),
            ));
  }
}
