import 'package:flutter/material.dart';

typedef void OnOpen();
typedef void OnClose();
typedef void OnOffsetChange(double offset);

enum ScrollState { ScrollToLeft, NONE }

class ResideMenu extends StatefulWidget {
  // your content View
  final Widget child;

  //left or right Menu View
  final Widget? leftView;

  //shadow elevation
  final double elevation;

  // it will control the menu Action,such as openMenu,closeMenu
  final MenuController? controller;

  // used to set bottom bg and color
  final BoxDecoration decoration;

  final OnOpen? onOpen;

  final OnClose? onClose;

  final bool enableScale, enableFade;

  final OnOffsetChange? onOffsetChange;

  final Widget? appBarTitle;

  final Widget? appBarTrailing;

  final Widget? fab;

  final FloatingActionButtonLocation? fabLocation;

  ResideMenu.scaffold(
      {required this.child,
      Widget? leftBuilder,
      MenuScaffold? leftScaffold,
      this.appBarTitle,
      this.appBarTrailing,
      this.fab,
      this.fabLocation,
      this.decoration: const BoxDecoration(),
      this.elevation: 12.0,
      this.onOpen,
      this.enableScale: true,
      this.enableFade: true,
      this.onClose,
      this.onOffsetChange,
      this.controller,
      Key? key})
      : leftView = leftScaffold,
        super(key: key);

  @override
  _ResideMenuState createState() => new _ResideMenuState();
}

class _ResideMenuState extends State<ResideMenu> with TickerProviderStateMixin {
  //determine width
  double _width = 0.0;
  late var _controller = MenuController(vsync: this);
  ValueNotifier<ScrollState> _scrollState =
      ValueNotifier<ScrollState>(ScrollState.NONE);

  //  Curve the content screen borders
  double borderRadius = 0.0;

  void _toggleBorderRadius(double value) {
    setState(() {
      borderRadius = value;
    });
  }

  void _onScrollMove(DragUpdateDetails details) {
    double offset = details.delta.dx / _width * 2.0;
    if (_controller.value == 0.0) {
      if (details.delta.dy.abs() > details.delta.dx.abs() ||
          details.delta.dx.abs() < 10) return;
    }

    _controller.value += offset;
  }

  void _onScrollEnd(DragEndDetails details) {
    if (_controller.value > 0.5) {
      _controller.openMenu();
    } else {
      _controller.closeMenu();
    }
  }

  void _handleScrollChange() {
    _scrollState.value =
        _controller.value == 0.0 ? ScrollState.NONE : ScrollState.ScrollToLeft;
    if (widget.onOffsetChange != null) {
      widget.onOffsetChange!(_controller.value.abs());
    }

    //  Keep the content screen borders curved only if the drawer is opened
    if (_controller.value > 0.001)
      _toggleBorderRadius(20);
    else
      _toggleBorderRadius(0);
  }

  void _handleScrollEnd(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_controller.value == 1.0) {
        if (widget.onOpen != null) {
          widget.onOpen!();
        }
      } else {
        if (widget.onClose != null) {
          widget.onClose!();
        }
      }
    }
  }

  // update listener
  void _update() {
    final MenuController newController = widget.controller ??
        MenuController(
          vsync: this,
        );
    if (newController == _controller) return;
    // if (_controller != null)
    _controller
      ..removeListener(_handleScrollChange)
      ..removeStatusListener(_handleScrollEnd);
    _controller = newController;
    _controller
      ..addListener(_handleScrollChange)
      ..addStatusListener(_handleScrollEnd);

    _toggleBorderRadius(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _update();
  }

  @override
  void initState() {
    super.initState();
    _scrollState.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollState.dispose();
    _controller
      ..removeListener(_handleScrollChange)
      ..removeStatusListener(_handleScrollEnd);
    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  @override
  void didUpdateWidget(ResideMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, cons) {
      _width = cons.biggest.width;
      return WillPopScope(
        child: GestureDetector(
          onPanUpdate: _onScrollMove,
          onPanEnd: _onScrollEnd,
          child: new Stack(
            children: <Widget>[
              if (_scrollState.value != ScrollState.NONE)
                new Container(
                  decoration: widget.decoration,
                ),
              if (_scrollState.value != ScrollState.NONE)
                MenuTransition(
                  offset: _controller,
                  child: new Container(
                    margin: new EdgeInsets.only(
                      right: cons.biggest.width * 0.3,
                    ),
                    child: widget.leftView,
                  ),
                ),
              ContentTransition(
                  enableScale: widget.enableScale,
                  child: new Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.zero,
                        width: cons.biggest.width,
                        height: cons.biggest.height,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(borderRadius),
                                bottomLeft: Radius.circular(borderRadius)),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.black12.withOpacity(0.3),
                                offset: Offset(15.0, 15.0),
                                blurRadius: widget.elevation * 0.66,
                              ),
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadius),
                            bottomLeft: Radius.circular(borderRadius),
                          ),
                          child: Scaffold(
                            resizeToAvoidBottomInset: true,
                            backgroundColor: Colors.white,
                            appBar: AppBar(
                              toolbarHeight: 70,
                              elevation: 0,
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.white,
                              leading: GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AnimatedIcon(
                                    icon: AnimatedIcons.menu_close,
                                    progress: _controller,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                ),
                                onTap: () {
                                  _controller.isOpen
                                      ? _controller.closeMenu()
                                      : _controller.openMenu();
                                  print('${_controller.value}');
                                },
                              ),
                              title: widget.appBarTitle,
                              actions: [
                                widget.appBarTrailing ?? SizedBox.shrink()
                              ],
                            ),
                            body: widget.child,
                            floatingActionButton: widget.fab,
                            floatingActionButtonLocation: widget.fabLocation,
                          ),
                        ),
                      ),
                      if (_scrollState.value != ScrollState.NONE)
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (c, w) {
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: 80.0),
                                width: cons.biggest.width,
                                height: cons.biggest.height,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  color: new Color.fromARGB(
                                      !widget.enableFade
                                          ? 0
                                          : (125 * _controller.value.abs())
                                              .toInt(),
                                      0,
                                      0,
                                      0),
                                ),
                              ),
                              onTap: () {
                                _controller.closeMenu();
                              },
                            );
                          },
                        )
                    ].toList(),
                  ),
                  menuOffset: _controller),
            ].toList(),
          ),
        ),
        onWillPop: () async {
          if (_controller.value != 0) {
            _controller.closeMenu();
            return false;
          }
          return true;
        },
      );
    });
  }
}

class MenuController extends AnimationController {
  bool _isOpen = false;

  MenuController(
      {required TickerProvider vsync,
      Duration openDuration: const Duration(milliseconds: 300)})
      : super(
            vsync: vsync,
            lowerBound: 0.0,
            upperBound: 1.0,
            duration: openDuration,
            value: 0.0);

  Future<void> openMenu({AnimationController? controller}) {
    return animateTo(1.0).then((_) {
      _isOpen = true;
      if (controller != null) controller.forward();
    });
  }

  Future<void> closeMenu({AnimationController? controller}) {
    return animateTo(0.0).then((_) {
      _isOpen = false;
      if (controller != null) controller.reverse();
    });
  }

  bool get isOpen => _isOpen;

  bool get isClose => !_isOpen;
}

class MenuTransition extends AnimatedWidget {
  final Widget child;

  final Animation<double>? offset;

  MenuTransition({required this.child, this.offset, Key? key})
      : super(key: key, listenable: offset!);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, cons) {
      double width = cons.biggest.width;
      double height = cons.biggest.height;
      final Matrix4 transform = new Matrix4.identity()
        ..scale(2 - offset!.value.abs(), 2 - offset!.value.abs(), 1.0);
      return Opacity(
        opacity: offset!.value.abs(),
        child: new Transform(
            transform: transform,
            child: child,
            origin: new Offset(width / 2, height / 2)),
      );
    });
  }
}

class ContentTransition extends AnimatedWidget {
  final Widget child;

  final bool? enableScale;

  ContentTransition(
      {required this.child,
      required Animation<double> menuOffset,
      Key? key,
      this.enableScale})
      : super(key: key, listenable: menuOffset);

  Animation<double> get menuOffset => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, cons) {
      double width = cons.biggest.width;
      double val = menuOffset.value;
      final Matrix4 transform = new Matrix4.identity();
      if (enableScale!) {
        transform.scale(1.0 - 0.25 * val.abs(), 1 - 0.25 * val.abs(), 1.0);
      }

      transform.translate(val * 0.8 * width);
      return Transform(
        alignment: Alignment.center,
        transform: transform,
        child: child,
      );
    });
  }
}

class MenuScaffold extends StatelessWidget {
  final Widget children;
  final Widget header;
  final Widget footer;
  final double topMargin;

  MenuScaffold(
      {Key? key,
      required this.children,
      this.topMargin: 50.0,
      Widget? header,
      Widget? footer})
      : header = header ?? new Container(height: 20.0),
        footer = footer ?? new Container(height: 20.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: new Container(
          padding: new EdgeInsets.only(top: this.topMargin),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[header, children, footer],
          ),
        ),
      ),
    );
  }
}
