import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  // عرض SnackBar
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }


  static String formatTemp(double temp) {
    return '${temp.toInt()}°';
  }


  static String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE، d MMMM y', 'ar');
    return formatter.format(now);
  }


  static String getDayName(int index) {
    const days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];
    return days[index % days.length];
  }
}