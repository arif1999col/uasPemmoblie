import 'package:flutter/material.dart';
import '../widgets/summary_card.dart';
import './webview_screen.dart';

class Indonesia extends StatelessWidget {
  final double height;
  final data;

  Indonesia({this.height, this.data});

  @override
  Widget build(BuildContext context) {
    String kode = "https://covid19.go.id/";
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: const Text(
            'LAPORAN JUMLAH KASUS DI INDONESIA',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Divider(),
        Expanded(
          flex: 2,
          child: GridView.count(
            childAspectRatio: height / 350,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: <Widget>[
              SummaryCard(
                total: data.summary.confirmed.toString(),
                label: 'Terkonfirmasi',
                color: Colors.yellowAccent[100],
                size: 35,
              ),
              SummaryCard(
                total: data.summary.activeCare.toString(),
                label: 'Dalam Perawatan',
                color: Colors.purple[100],
                size: 35,
              ),
              SummaryCard(
                total: data.summary.recovered.toString(),
                label: 'Sembuh',
                color: Colors.greenAccent[100],
                size: 35,
              ),
              SummaryCard(
                total: data.summary.deaths.toString(),
                label: 'Meninggal',
                color: Colors.red[300],
                size: 35,
              ),
            ],
          ),
        ),
        FlatButton(
          onPressed: kode == ""
              ? () {}
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebScreen(kode),
                    ),
                  );
                },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Center(
                child: Text(
                  "Selengkapnya",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
        )
      ],
    );
  }
}
