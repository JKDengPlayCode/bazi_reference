import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {

  const CircleImage({
    super.key,
    this.borderSize = 1,
    required this.image,
    this.size = 70,
    this.shadowColor,
    this.roundColor,
  });

  final ImageProvider image; //图片
  final double size; //大小
  final Color? shadowColor; //阴影颜色
  final Color? roundColor; //边框颜色
  final double borderSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: roundColor ?? Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.grey.withOpacity(0.3),
            offset: const Offset(0.0, 0.0),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(borderSize),
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
