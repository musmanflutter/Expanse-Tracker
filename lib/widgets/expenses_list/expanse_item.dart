import 'package:flutter/material.dart';

import 'package:expanse_tracker/models/expanse.dart';

class ExpanseItem extends StatelessWidget {
  const ExpanseItem(this.expanse, {super.key});

  final Expanse expanse;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expanse.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  //toStringAsFixed: means show only 2 digits after the . like 12.5645 will
                  //be 12.56 only
                  //$ is a special syntax used to insert some value in string
                  //\$ means this is not a dart method instead its a sign to be shown
                  //first we showed that sign then with $ we added rest value withit.
                  '\$${expanse.amount.toStringAsFixed(2)}',
                ),
                //spacer takes all the available space in a row or a column. hera it will push
                //text to right and row to left and will take space b\w them.
                const Spacer(),
                Row(
                  children: [
                    //this will return a category value to category icons
                    //and that will show the icon
                    Icon(categoryIcons[expanse.category]),
                    const SizedBox(width: 8),
                    Text(
                      //this will format the date.
                      expanse.formatDate,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
