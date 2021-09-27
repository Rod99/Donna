import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WavesMobile extends StatelessWidget {
  const WavesMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [Colors.orange, const Color(0xffED9121)],
          [Colors.blue, Colors.lightBlueAccent],
        ],
        blur: const MaskFilter.blur(BlurStyle.solid, 10),
        durations: [
          5000,
          4000
        ],
        heightPercentages: [
          0.30,
          0.45
        ],
      ),
      waveAmplitude: 0,
      size: const Size(double.infinity, 150),
    );
  }
}
