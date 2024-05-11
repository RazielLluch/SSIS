import 'dart:io';
import 'package:csv/csv.dart' as csv;
class FileHandler{

  late final Directory dir;
  late final filename;

  FileHandler(this.filename){
    dir = Directory.fromUri(Uri.directory('userdata'));
  }

  String getDirectory(){
    return dir.absolute.path;
  }

  Future<List<List>> readFile() async{
    File csvFile = File('${getDirectory()}$filename.csv');
    return await csvToList(csvFile);
  }

  Future<void> init(List<List> data) async{

    String directory = '${getDirectory()}$filename.csv';
    // print('This is your file directory: $directory');
    await File(directory).create(recursive: true).then((File file){
    });

    await appendCsv(data);
  }

  Future<void> appendCsv(List<List> data)async{

    // print("appedCsv Start\n");

    File csvFile = File('${getDirectory()}$filename.csv');
    List<List> csvList = await csvToList(csvFile);

    // print('1: $csvList');

    for(int i = 0; i < data.length; i++){
      csvList.add(data[i]);
    }

    // print('2: $csvList');
    String csv = await listToCsv(csvList);
    // print('3: $csv');

    await saveCsvFile(csv, csvFile);
    // print("appendCsv end");
  }

  Future<void> editCsv(int index, List data)async{

    File csvFile = File('${getDirectory()}$filename.csv');
    List<List> csvList = await csvToList(csvFile);

    csvList[index] = data;

    String csv = await listToCsv(csvList);

    await saveCsvFile(csv, csvFile);
  }

  Future<void> deleteCsv(int index) async{

    File csvFile = File('${getDirectory()}$filename.csv');
    List<List> csvList = await csvToList(csvFile);

    csvList.remove(csvList[index]);

    String csv = await listToCsv(csvList);

    await saveCsvFile(csv, csvFile);
  }

  saveCsvFile(String data, File csvFile)async{
    csvFile.writeAsStringSync(data);
  }

  Future<String> listToCsv(List<List> listToConvert) async{
    csv.ListToCsvConverter c = const csv.ListToCsvConverter();
    return c.convert(listToConvert, fieldDelimiter: ','); //default field delimiter is ','
  }

  Future<List<List>> csvToList(File myCsvFile)async{

    csv.CsvToListConverter c =
    const csv.CsvToListConverter(eol: "\r\n", fieldDelimiter: ",");

    // print('converting csv to list: ${myCsvFile.readAsStringSync()}');
    return c.convert(myCsvFile.readAsStringSync());
  }
}

void main(){


}
