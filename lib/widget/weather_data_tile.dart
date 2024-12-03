import 'package:flutter/material.dart';

class WeatherDataTile extends StatelessWidget {
  final String index1, index2, value1, value2;
  const WeatherDataTile({super.key, required this.index1, required this.index2, required this.value1, required this.value2});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(index1,style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              color: Colors.white
            ),),
            Text(index2,style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              color: Colors.white
            ),),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(value1,style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white
            ),),
             Text(value2,style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white
            ),),
          ],
        ),
      ],
    );
  }
}
