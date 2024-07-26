import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:sqflite/sql.dart';

dynamic database;
//List<Map<String, dynamic>> list = [];
List listOfCards = [];

class CardInfo {
  int cardId;
  String cardTitle;
  String cardDescription;
  String cardDate;

  int isTaskCompleted = 1;

  CardInfo(
      {this.cardId = 0,
      required this.cardTitle,
      required this.cardDescription,
      required this.cardDate,
      this.isTaskCompleted = 1});

  Map<String, dynamic> cardDataIntoMap() {
    return {
      'cardTitle': cardTitle,
      'cardDescription': cardDescription,
      'cardDate': cardDate,
      'isTaskCompleted': isTaskCompleted,
    };
  }
}

Future createDatabase() async {
  print("CREATE DATABASE , ${listOfCards}");
  database = await openDatabase(join(await getDatabasesPath(), 'ToDoListDB.db'),
      version: 1, onCreate: (db, version) async {
    await db.execute('''CREATE TABLE ToDoList(
    cardId INTEGER PRIMARY KEY,
    cardTitle TEXT,
    cardDescription TEXT,
    cardDate TEXT,
    isTaskCompleted INT)''');
  });
  await getCardDetailsList();
  print("AFTER CREATING DATABASE , ${listOfCards}");
}

Future<void> insertData(CardInfo card) async {
  final localDB = await database;
  print("INSERT DATA , ${listOfCards}");

  await localDB.insert(
    "ToDoList",
    card.cardDataIntoMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  await getCardDetailsList();
  
}

Future getCardDetailsList() async {
  final localDB = await database;
  print("CREATE LIST, $localDB , $listOfCards");
  List<Map<String, dynamic>> list = await localDB.query("ToDoList");

  listOfCards = List.generate(list.length, (index) {
    return CardInfo(
      cardId: list[index]['cardId'],
      cardTitle: list[index]['cardTitle'],
      cardDescription: list[index]['cardDescription'],
      cardDate: list[index]['cardDate'],
      isTaskCompleted: list[index]['isTaskCompleted'],
    );
  });
  
}

void deleteCardFromDatabase(CardInfo card) async {
  final localDB = await database;
  print("DELETE DATABASE , ${listOfCards}");

  await localDB.delete(
    'ToDoList',
    where: 'cardId = ?',
    whereArgs: [card.cardId],
  );
  //listOfCards = await getCardDetailsList();
}

Future updateCardInDatabase(CardInfo card) async {
  final localDB = await database;
  print("UPDATE DATABASE , ${listOfCards}");

  await localDB.update('ToDoList', card.cardDataIntoMap(),
      where: 'cardId = ?', whereArgs: [card.cardId]);
  await getCardDetailsList();
}
