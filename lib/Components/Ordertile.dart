import 'package:flutter/material.dart';

import '../Pages/Order_Screen_Admin.dart';

class Ordertile extends StatefulWidget {
  final String date;
  final String total;
  final String items;
  final String time;

  const Ordertile({
    Key? key,
    required this.date,
    required this.total,
    required this.items,
    required this.time,
  }) : super(key: key);

  @override
  State<Ordertile> createState() => _OrdertileState();
}

class _OrdertileState extends State<Ordertile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreenAdmin(
              date: widget.date,
              total: widget.total,
              items: widget.items,
              time: widget.time,
              shopName: 'Home Deco',
            ),
          ),
        );
      },
      child: Container(
        height: 150,
        width: 400,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.asset(
                  'lib/image/box.png',
                  width: 70,
                  height: 70,
                ),
                const SizedBox(width: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Date: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.date,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Time: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.time,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Total: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.total,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.items,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            ' Items',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
