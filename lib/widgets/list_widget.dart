import 'package:flutter/material.dart';
import 'dart:async';

import '../models/barang.dart';
import '../models/crud.dart';
import '../screens/form_screen.dart';

class ListScreen extends StatefulWidget {
  Future<List<Barang>> cariBarang;
  ListScreen(this.cariBarang);
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  CRUD dbHelper = CRUD();
  Future<List<Barang>> future;
  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void updateListView() {
    if (widget.cariBarang == null) {
      setState(() {
        future = dbHelper.getBarangList();
      });
    } else {
      future = widget.cariBarang;
    }
  }

  Card cardo(Barang barang) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      margin: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
      color: Colors.blueAccent,
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.white10,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(barang.harga,
                  style: TextStyle(
                    color: Colors.white70,
                  )),
            )),
        title: Text(
          barang.nama,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(barang.barcode.toString(),
            style: TextStyle(color: Colors.white70)),
        trailing: GestureDetector(
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 28,
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Warning",
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    ),
                    content: Text("Ingin Menghapus ${barang.nama}?"),
                    actions: [
                      FlatButton(
                        onPressed: () async {
                          int result = await dbHelper.delete(barang);
                          if (result > 0) {
                            updateListView();
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Iya",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      FlatButton(
                        child: Text("Tidak"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          },
        ),
        onTap: () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return EntryForm(null, barang);
          }));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: FutureBuilder<List<Barang>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Container(
              child: Column(
                  children: snapshot.data.map((todo) => cardo(todo)).toList()),
            );
          } else {
            return Center(child: Text("Tidak Terdapat Data"));
          }
        },
      ),
    );
  }
}
