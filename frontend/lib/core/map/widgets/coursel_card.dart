import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/constants.dart';

Widget carouselCard(int index, num distance, num duration) {
  return Card(
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurants[index]['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(restaurants[index]['items'],
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Distance',
                            style:
                                TextStyle(color: AppColors.PRIMARY_500),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${distance.toStringAsFixed(2)}kms',
                            style:
                                const TextStyle(color: AppColors.PRIMARY_500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Travel Time',
                            style:
                                TextStyle(color: AppColors.PRIMARY_500),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${duration.toStringAsFixed(2)} mins',
                          style: const TextStyle(color: AppColors.PRIMARY_500),
                        ),
                      ],
                    ),
                  ],
                ),
              
                
                
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
