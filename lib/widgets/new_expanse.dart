import 'package:flutter/material.dart';
import 'package:expanse_tracker/models/expanse.dart';

class NewExpanse extends StatefulWidget {
  const NewExpanse({super.key, required this.onAddExpanse});

  final void Function(Expanse expanse) onAddExpanse;

  @override
  State<NewExpanse> createState() => _NewExpanseState();
}

class _NewExpanseState extends State<NewExpanse> {
  //texteditingcontroller: allows to store a value in a variable
  final _titalController = TextEditingController();
  final _amountController = TextEditingController();
  //? means datetime can be null as well
  DateTime? _selectedDate;

  Categories _selectedCategory = Categories.leisure;

  //async and awai are being used for getting the future value(date to be select) here
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    //await means this value will be availabale in future .
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
      initialDate: now,
    );
    //this code will be executed once a value is available
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpanse() {
    //double.tryparse convert a string to double if possible,
    //ifnot like Hello cant be convert then it will return null.
    final enterdAmount = double.tryParse(_amountController.text);
    final amountInvalid = enterdAmount == null || enterdAmount <= 0;
    //.text means text of title get
    //trim means removing any white spaces
    //isempty means if its empty
    //if any of these 3 confition returns true, an error message will be given
    if (_titalController.text.trim().isEmpty ||
        amountInvalid ||
        _selectedDate == null) {
      //showDialog shows a dialog box
      showDialog(
        context: context,
        //alertDialog shows a special style of alert dialog
        builder: (ctx) => AlertDialog(
          //shows a title
          title: const Text('Invalid Text'),
          //show a text below title
          content: const Text(
              'Please make sure to enter a valid title,amount,category and date'),
          //shows button/actions to be taken
          actions: [
            TextButton(
                onPressed: () {
                  //it will close the dialog box
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
      //if a value is false we dont want to return anything
      return;
    }
    widget.onAddExpanse(
      Expanse(
        title: _titalController.text,
        amount: enterdAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  //this method is used to delete variables when they are not needed anymore.
  //it will free space
  void dispose() {
    //when modalsheet is closed, this method will delete the space occupied by _titleController.
    _titalController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //.viewinsets means part that are overlapping ui
    //its is being overlapped from bottom in this case if in landscape mode
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    //layoutbuilder gives us constrains as well which can be used to set sizing.
    return LayoutBuilder(builder: (ctx, constraints) {
      //we are getting max width based on available width.
      final width = constraints.maxWidth;
      //the reaosn for wrapping in sizedbox is so that it takes full screen height.
      return SizedBox(
        height: double.infinity,
        //the reason of wrapping in single child scroll view is, without it, it will cause some
        //size issues in landscape mode.
        child: SingleChildScrollView(
          child: Padding(
            //fromLTRB means vdifferent values for left top right bottom
            padding: EdgeInsets.fromLTRB(
              16,
              48,
              16,
              //keyboardSpace is the size being occupied by bottom overlapping
              //this will make sure that it shows fine in landscape mode
              keyboardSpace + 16,
            ),
            child: Column(
              children: [
                //if width is above or equals 600, only this row will be executed
                //this row will place both title and amount next to each other.
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          //here the data will be stored in _titalController with
                          //the help of controller.
                          controller: _titalController,
                          //maxlength: means we cant add more than 50 characters
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            //prefix text means a text to be shown before amount
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                //if width is below 600 this code will be executed
                //showing title and amount on different lines.
                else
                  TextField(
                    //here the data will be stored in _titalController with
                    //the help of controller.
                    controller: _titalController,
                    //maxlength: means we cant add more than 50 characters
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),

                //this is for 2nd line if its above 600 then it will
                //show category picker and date picker on the next line
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        //value: The value of the currently selected [DropdownMenuItem]. leisure in this case
                        value: _selectedCategory,
                        //.values means all the values in enum
                        //since items want a list of dropdown items while categories contains a list of Categories
                        //we need to use map to convert it to that type.
                        items: Categories.values
                            .map(
                              (category) => DropdownMenuItem(
                                //this is bts, user wont see it
                                //it means that the selected item will be stored in value
                                value: category,
                                //.name is name of enums
                                //.toUpperCase is used to convert that enum to string all uppercase
                                child: Text(category.name.toUpperCase()),
                              ),
                            )

                            ///tolist is used to convert it to match required type(list)
                            .toList(),
                        //that value will be used here in onChanged
                        onChanged: (value) {
                          //if value is empty it wil return nothing
                          if (value == null) {
                            return;
                          }
                          //else if it has value, _Selectedcategory will be updated
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //if selecteddate isnt null, then format that date ac to formatter method
                            // !mark after selecteddate is telling that this cant be null.
                            Text(_selectedDate == null
                                ? 'No Date Selected'
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      //we are wrapping textfield inside expanded becuase textfield
                      //tries to take as much space vertically as possible and row
                      //doesnt restrict it so expanded will restrict it
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            //prefix text means a text to be shown before amount
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      //we are wrapping row with expanded because row inside
                      //row creates size problems.
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //if selecteddate isnt null, then format that date ac to formatter method
                            // !mark after selecteddate is telling that this cant be null.
                            Text(_selectedDate == null
                                ? 'No Date Selected'
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                //this if will run for the last line
                //if condition is true then on last line only 2 buttons will be shown.
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          //navigator.pop: removes the current screen which is bottom
                          //sheet in this case
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpanse,
                        child: const Text('Save Expanse'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      //items want a list of dropdown items
                      DropdownButton(
                        //value: The value of the currently selected [DropdownMenuItem]. leisure in this case
                        value: _selectedCategory,
                        //.values means all the values in enum
                        //since items want a list of dropdown items while categories contains a list of Categories
                        //we need to use map to convert it to that type.
                        items: Categories.values
                            .map(
                              (category) => DropdownMenuItem(
                                //this is bts, user wont see it
                                //it means that the selected item will be stored in value
                                value: category,
                                //.name is name of enums
                                //.toUpperCase is used to convert that enum to string all uppercase
                                child: Text(category.name.toUpperCase()),
                              ),
                            )

                            ///tolist is used to convert it to match required type(list)
                            .toList(),
                        //that value will be used here in onChanged
                        onChanged: (value) {
                          //if value is empty it wil return nothing
                          if (value == null) {
                            return;
                          }
                          //else if it has value, _Selectedcategory will be updated
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          //navigator.pop: removes the current screen which is bottom
                          //sheet in this case
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpanse,
                        child: const Text('Save Expanse'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
