import 'package:flutter/material.dart';
import 'package:up2btangki/models/item.dart';
import 'package:firebase_database/firebase_database.dart';

class CardWidgetPerbaikan extends StatelessWidget {
  final Item item;

  const CardWidgetPerbaikan({required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.reference),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        _deleteItem(context);
      },
      child: InkWell(
        onLongPress: () {
          Navigator.pushNamed(context, '/item', arguments: item);
        },
        child: Card(
          color: Color.fromARGB(255, 245, 245, 245),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(8),
            title: Text(
              '${item.keterangan}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xff4a4a4a),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama?.join(', ') ?? '', // Display the list as a comma-separated string
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff4a4a4a),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${item.tanggal}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff808080),
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () {
                _showDetailDialog(context);
              },
              child: Icon(
                Icons.info_outline,
                color: Color(0xff4a4a4a),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 297,
            height: 220,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 243, 229, 33),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Detail Perbaikan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Teknisi: ${item.nama?.join(', ')}'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Tanggal: ${item.tanggal}'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Waktu: ${item.waktu} '),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 8),
                      child: Text('Keterangan: ${item.keterangan} '),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteItem(BuildContext context) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Center(
          child: Text(
            'Konfirmasi',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data ini?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: Text(
              'Tidak',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: Text(
              'Ya',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );

  if (shouldDelete == true) {
    final databaseReference = FirebaseDatabase.instance.ref().child('xmaintenance');

    try {
      await databaseReference.child(item.reference).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item deleted successfully'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete item: $error'),
        ),
      );
    }
  }
}

}
