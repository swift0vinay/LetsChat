import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math show sin, pi;
import 'package:flutter/animation.dart';


class Delayer extends Tween<double>{
  Delayer({double begin, double end, this.delay}) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 200,
      height: 200,
      child:Center(
        child: SpinKitCircle(
          color: Colors.black,
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }
}
class TestFile extends StatefulWidget {
  const TestFile({
    Key key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1400),
    this.controller,
  })  : assert(!(itemBuilder is IndexedWidgetBuilder && color is Color) && !(itemBuilder == null && color == null),
  'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  @override
  _TestFileState createState() => _TestFileState();
}

class _TestFileState extends State<TestFile> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: Delayer(begin: 0.0, end: 1.0, delay: i * .2).animate(_controller),
              child: SizedBox.fromSize(size: Size.square(widget.size * 0.5), child: _itemBuilder(i)),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: index==0?Theme.of(context).primaryColor
        :index==1?Theme.of(context).accentColor:Theme.of(context).secondaryHeaderColor
        , shape: BoxShape.circle));}
}

class Temp extends StatelessWidget {
  final int size;
  Temp({this.size});
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
        child:TestFile(
          color: Colors.lightGreen,
          size: size.toDouble(),
        )
    );
  }
}
