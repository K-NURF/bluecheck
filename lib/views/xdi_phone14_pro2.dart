import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class XDIPhone14Pro2 extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  XDIPhone14Pro2({
    required Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(size: 116.0, middle: 0.5054),
            Pin(size: 116.0, start: 10),
            child:
                // Adobe XD layer: 'BlueCheck__8_-remov…' (shape)
                Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Bluecheck-name.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 44.0, end: 43.0),
            Pin(size: 62.0, middle: 0.4418),
            child:TextFormField(
                // controller: _emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Email',
                  helperText: 'A valid email e.g. joe.doe@gmail.com',
                ),
                // validator: (_) => _state.email.displayError?.text(),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
          ),
          Pinned.fromPins(
            Pin(start: 44.0, end: 43.0),
            Pin(size: 62.0, middle: 0.5608),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
