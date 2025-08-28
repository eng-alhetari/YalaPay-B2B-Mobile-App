import 'package:flutter/material.dart';

class StylesDetails {
  

  TextStyle headingStyle (Color color) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: color,
    );
  }

  TextStyle largerHeadingStyle (Color color) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 19,
      color: color,
    );
  }

  TextStyle detailStyle (Color color) {
    return TextStyle(
      fontSize: 17,
      color: color,
    );
  }

  TextStyle largerDetailStyle (Color color) {
    return TextStyle(
      fontSize: 20,
      color: color,
    );
  }

  List<Widget> cardHeadingDetailEntry ({required String heading, required String detail, required Icon icon}){
    return [
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Text('  $heading   ', style: headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
      ],
      ),
      const SizedBox(height: 10,),
      Text(detail, style: detailStyle(const Color.fromARGB(255, 122, 122, 122)),),
    ];
  } 
  
  List<Widget> headingDetailEntry ({required String heading, required String detail, required Icon icon}){
    return [
      ...cardHeadingDetailEntry(detail: detail, heading: heading, icon: icon),
      const SizedBox(height: 30,),
    ];
  } 

  List<Widget> cardHeadingDetailEntryWithBorder ({required String heading, required String detail, required Icon icon, required Color? textColor, required Color? backgroundColor}){
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        Text('  $heading   ', style: headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
      ],
      ),
      const SizedBox(height: 10,),
      Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            width: 5.0,
            color: backgroundColor!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('   $detail   ', style: detailStyle(textColor!),)
        ),
    ];
  } 

  List<Widget> headingDetailEntryWithBorder ({required String heading, required String detail, required Icon icon, required Color? textColor, required Color? backgroundColor}){
    return [
      ...cardHeadingDetailEntryWithBorder(detail: detail, heading: heading, icon: icon, textColor: textColor, backgroundColor: backgroundColor),
      const SizedBox(height: 30,),
    ];
  } 

  List<Widget> chequeHeadingDetailEntry ({required String heading, required String detail, required Icon icon}){
    return [
      Row(
      children: [
        icon,
        Text('  $heading   ', style: headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
      ],
      ),
      const SizedBox(height: 10,),
      Text(detail, style: detailStyle(const Color.fromARGB(255, 122, 122, 122)),),
      const SizedBox(height: 30,),
    ];
  } 

  List<Widget> chequeHeadingDetailEntryWithBorder ({required String heading, required String detail, required Icon icon, required Color? textColor, required Color? backgroundColor}){
    return [
      Row(
      children: [
        icon,
        Text('  $heading   ', style: headingStyle(const Color.fromARGB(255, 122, 122, 122)),),
      ],
      ),
      const SizedBox(height: 10,),
      Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            width: 5.0,
            color: backgroundColor!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('   $detail   ', style: detailStyle(textColor!),)
        ),
        const SizedBox(height: 30,),
    ];
  } 
}