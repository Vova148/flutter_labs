import 'package:flutter/material.dart';

import 'helpers/flashlight_control.dart';


class FlashLight extends StatelessWidget {
  const FlashLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashlight Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                FlashlightControl.turnOn();
              },
              child: const Text('Turn On Flashlight'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FlashlightControl.turnOff();
              },
              child: const Text('Turn Off Flashlight'),
            ),
          ],
        ),
      ),
    );
  }
}
