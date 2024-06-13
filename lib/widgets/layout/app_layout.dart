import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final List<Widget> children;
  final dynamic appBar;
  final bool extendBodyBehindAppBar;
  final bool isSingleChildScrollView;
  final bool topLinearGradient;
  final List<double> topLinearGradientStops;

  const AppLayout({
    super.key,
    this.children = const <Widget>[],
    this.appBar,
    this.extendBodyBehindAppBar = false,
    this.isSingleChildScrollView = false,
    this.topLinearGradient = true,
    this.topLinearGradientStops = const [0.2, 0.5],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            extendBodyBehindAppBar == false && topLinearGradient == true
                ? Theme.of(context).primaryColor
                : Colors.white,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: topLinearGradientStops,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        body: isSingleChildScrollView
            ? SingleChildScrollView(
                child: Column(children: children.isNotEmpty ? children : []))
            : Column(
                children: children.isNotEmpty ? children : [],
              ),
      ),
    );
  }
}
