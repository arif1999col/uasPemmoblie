import 'package:flutter/material.dart';

import '../models/barang.dart';
import '../models/crud.dart';
import './homee_screen.dart';

class EntryForm extends StatefulWidget {
  final String barcode;
  final Barang barang;

  EntryForm(this.barcode, this.barang);
  @override
  EntryFormState createState() => EntryFormState(this.barang);
}

class EntryFormState extends State<EntryForm> {
  Barang barang;

  EntryFormState(this.barang);

  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (barang != null) {
      namaController.text = barang.nama;
      hargaController.text = barang.harga;
    }
  }

  CRUD dbHelper = CRUD();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: barang == null ? Text('Tambah Data') : Text('Ubah Data'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.blue[100],
            ),

            margin: EdgeInsets.only(top: 10),
            // width: MediaQuery.of(context).size.width - 30,
            child: Column(
              children: [
                // nama
                Padding(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                  child: TextField(
                    controller: namaController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Nama Barang',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: TextField(
                    controller: hargaController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Harga',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.blueAccent,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Simpan',
                            textScaleFactor: 1.5,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          onPressed: () async {
                            if (barang == null) {
                              barang = Barang(namaController.text,
                                  hargaController.text, widget.barcode);
                              int result = await dbHelper.insert(barang);
                            } else {
                              barang.nama = namaController.text;
                              barang.harga = hargaController.text;

                              dbHelper.update(barang);
                            }
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return HomeScreen(2);
                            }));
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.redAccent,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Batal',
                            textScaleFactor: 1.5,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return HomeScreen(2);
                            }));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
