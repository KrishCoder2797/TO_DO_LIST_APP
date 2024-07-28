import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqflite.dart';
import 'databaseConnections.dart';

//import 'package:path/path.dart';
dynamic database;

class ToDoApp2 extends StatefulWidget {
  const ToDoApp2({super.key});

  @override
  State<ToDoApp2> createState() => _ToDoApp2State();
}

class _ToDoApp2State extends State<ToDoApp2> {
  TextEditingController titleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int isTaskCompleted = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future _showCalendar(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        String dateInString = DateFormat.yMMMd().format(pickedDate);
        dateController.text = dateInString;
      });
    }
  }

  void doNothing(BuildContext context) {}

  CardInfo _addNewCard() {
    CardInfo card = CardInfo(
      cardTitle: titleController.text,
      cardDescription: passwordController.text,
      cardDate: dateController.text,
    );
    listOfCards.add(card);
    return card;
  }

  Future _showModelBottomSheet(bool isEdit, [CardInfo? card]) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                    child: Text(
                      "Create Task",
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          color: const Color.fromRGBO(137, 0, 255, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        statesController: MaterialStatesController(),
                        maxLines: null,
                        controller: titleController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Title",
                          //hintText: "Enter Title",
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please Enter Title";
                          }
                          RegExp specialChars =
                              RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
                          if (specialChars.hasMatch(value)) {
                            return 'Special characters are not allowed';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Description",
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          color: const Color.fromRGBO(137, 0, 255, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        maxLines: null,
                        controller: passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Description",
                          //hintText: "Enter Password",

                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please Enter Description";
                          }
                          RegExp specialChars = RegExp(r'[@#\$%^&*()?":{}|<>]');
                          if (specialChars.hasMatch(value)) {
                            return 'Special characters are not allowed';
                          }
                          final RegExp regex = RegExp(r'[^\d]');
                          if (!regex.hasMatch(value)) {
                            return 'Only integer input not allowed,please enter mix value';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Date",
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          color: const Color.fromRGBO(137, 0, 255, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        readOnly: true,
                        onTap: () {
                          _showCalendar(context);
                        },
                        maxLines: null,
                        controller: dateController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Date",
                          // hintText: "Enter Date",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _showCalendar(context);
                            },
                            child: const Icon(
                              Icons.calendar_month,
                              size: 25,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(137, 0, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please Select Date";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      bool allTextFieldsArValidated =
                          _formKey.currentState!.validate();

                      if (allTextFieldsArValidated) {
                        if (isEdit) {
                          print(titleController.text);
                          print(passwordController.text);
                          print(dateController.text);
                          //UPDATE THE DATA IN LISTOFCARDS
                          card!.cardTitle = titleController.text;
                          card.cardDescription = passwordController.text;
                          card.cardDate = dateController.text;
                          //UPDATE THE DATA IN DATABASE
                          updateCardInDatabase(card);
                        } else {
                          //ADD NEW ENTRY IN DATABASE
                          //_addNewCard() ADD NEW ENTRY IN THE LISTOFCARDS
                          insertData(_addNewCard());
                        }

                        setState(() {
                          Navigator.of(context).pop();
                        });
                        titleController.clear();
                        passwordController.clear();
                        dateController.clear();
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 380,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(137, 0, 255, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _deleteCard(CardInfo card) {
    listOfCards.remove(card);

    //DELETE THE ENTRY FROM DATABASE TABLE
    
    deleteCardFromDatabase(card);
  }

  void _editCard(CardInfo card) {
    titleController.text = card.cardTitle;
    passwordController.text = card.cardDescription;
    dateController.text = card.cardDate;
    _showModelBottomSheet(true, card);
    //UPDATE THE DATA ON EDIT BUTTON
    // updateCardInDatabase(card);
  }

  Widget _card(int index) {
    return Slidable(
      closeOnScroll: true,
      endActionPane: ActionPane(
        dragDismissible: true,
        motion: const DrawerMotion(),
        extentRatio: 0.4,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _editCard(listOfCards[index]);
                    setState(() {});
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color.fromRGBO(137, 0, 255, 1),
                    radius: 15,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _deleteCard(listOfCards[index]);
                    setState(() {
                      // Slidable.of(context)
                      //     ?.dismiss(ResizeRequest(Duration.zero, () {}));
                    });
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color.fromRGBO(137, 0, 255, 1),
                    radius: 15,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              color: Color.fromRGBO(137, 0, 255, 1),
              spreadRadius: -5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 55,
              width: 55,
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.white,
                ),
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const CircleAvatar(
                //   backgroundImage: NetworkImage(
                //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwtrpb7XOu_s7IXVxL1A6XIVh27I5MIYnWXw21wfGrFA&s"),
                // ),
                backgroundImage: AssetImage('lib/image/img2.png'),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                SizedBox(
                  width: 245,
                  child: Text(
                    listOfCards[index].cardTitle,
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 245,
                  height: 58,
                  child: Text(
                    listOfCards[index].cardDescription,
                    style: GoogleFonts.quicksand(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  child: Text(
                    listOfCards[index].cardDate,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                if (listOfCards[index].isTaskCompleted == 0) {
                  listOfCards[index].isTaskCompleted = 1;
                } else {
                  listOfCards[index].isTaskCompleted = 0;
                }
                //UPDATE THE DATA IN DATABASE
                setState(() {
                  updateCardInDatabase(listOfCards[index]);
                });
              },
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: (listOfCards[index].isTaskCompleted == 0)
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 28,
                  color: (listOfCards[index].isTaskCompleted == 0)
                      ? Colors.green
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future initializeTheData() async {
    await createDatabase();
    await getCardDetailsList();
    setState(() {});
  }

  @override
  void initState() {
    print("IN INITSTATE");
    super.initState();

    initializeTheData();
  }

  bool isListEmpty() {
    if (listOfCards.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(137, 0, 255, 1),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(
            top: 90,
            left: 25,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              // height: 29,
              child: Text(
                "Good morning",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 27,
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            SizedBox(
              //height: 38,
              child: Text(
                "Pranav",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 35,
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 40,
        ),
        Expanded(
          child: Container(
            //height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(217, 217, 217, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 17,
                  child: Text(
                    "CREATE TO DO LIST",
                    style: GoogleFonts.quicksand(
                      color: const Color.fromRGBO(0, 0, 0, 1),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    //height: 590,
                    padding: const EdgeInsets.only(
                      top: 35,
                      left: 10,
                      right: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: isListEmpty()
                        ? Image.asset('lib/image/person.jpg')
                        : ListView.builder(
                            itemCount: listOfCards.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _card(index);
                            }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showModelBottomSheet(false);
        },
        backgroundColor: const Color.fromRGBO(137, 0, 255, 1),
        shape: const CircleBorder(
            side: BorderSide(
          color: Colors.white,
          width: 0.5,
        )),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 45,
        ),
      ),
    );
  }
}
