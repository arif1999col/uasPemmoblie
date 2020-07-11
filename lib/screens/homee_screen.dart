import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/navButton_widget.dart';
import 'package:barcode_scan/barcode_scan.dart';

import './form_screen.dart';
import '../widgets/navButton_widget.dart';
import '../widgets/list_widget.dart';
import '../models/barang.dart';
import '../models/crud.dart';
import '../home.dart';

class HomeScreen extends StatefulWidget {
  int _index;
  HomeScreen(this._index);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CRUD dbHelper = CRUD();
  Future<List<Barang>> future;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget._index;
  }

//barcode
  String kode = "";
  var getKode;
  Future scanBarcode() async {
    getKode = await BarcodeScanner.scan();

    setState(() {
      kode = getKode.rawContent;
    });
    if (kode != "") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return EntryForm(kode, null);
      }));
    }
  }
//end

////mencari berdasarkan barcode atau nama
  String nama = "";
  String barcode = "";
  void cariBerdasarkanNama(String nama) {
    setState(() {
      future = dbHelper.cariBarang(nama, null);
    });
  }

  var getBarcode;
  void cariBerdasarkanBarcode(String barcode) {
    setState(() {
      future = dbHelper.cariBarang(null, barcode);
    });
  }
//end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 1
          ? AppBar(
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              elevation: 0.0,
              title: TextField(
                controller: null,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  setState(() {
                    nama = value;
                    Future<List<Barang>> hasil =
                        dbHelper.cariBarang(nama, null);
                    future = hasil;
                  });
                },
                style: TextStyle(color: Colors.white70, fontSize: 18),
                decoration: InputDecoration(
                    hintText: " Cari",
                    hintStyle: TextStyle(fontSize: 18, color: Colors.white70),
                    fillColor: Colors.blueAccent,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white54,
                      size: 30,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(
                          Icons.memory,
                          color: Colors.white54,
                          size: 30,
                        ),
                        onPressed: () async {
                          getBarcode = await BarcodeScanner.scan();
                          setState(() {
                            barcode = getBarcode.rawContent;
                          });
                          if (barcode != "") {
                            cariBerdasarkanBarcode(barcode);
                          }
                        })),
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                ),
              ],
            )
          : AppBar(
              title: _currentIndex == 2
                  ? Text(
                      'List Barang',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Tambah Barang',
                      style: TextStyle(color: Colors.white),
                    ),
              centerTitle: true,
              backgroundColor: Colors.blue[900],
              elevation: 0,
            ),
      body: Container(
        height: 5000.0,
        width: 500.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://images.pexels.com/photos/2098427/pexels-photo-2098427.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _currentIndex == 2
                  ? ListScreen(null)
                  : barcode == ""
                      ? nama == ""
                          ? Container()
                          : Container(
                              child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "hasil pencaharian nama: ${nama}",
                                    style: TextStyle(color: Colors.blue[500]),
                                  ),
                                ),
                                ListScreen(future),
                              ],
                            ))
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "hasil pencaharian barcode: ${barcode}",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                              ListScreen(future),
                            ],
                          ),
                        )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.only(),
        decoration: BoxDecoration(
          color: Colors.black12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                scanBarcode();
              },
              child: NavButton(Icons.data_usage, 0, _currentIndex),
            ),
            GestureDetector(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        },
        tooltip: 'Info Corona',
        child: Icon(Icons.info),
        backgroundColor: Colors.blue[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
