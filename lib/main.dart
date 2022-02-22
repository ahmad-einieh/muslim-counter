//--no-sound-null-safety

import 'package:counter/about-me.dart';
import 'package:counter/data-prefenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/src/block_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

import 'ad_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBox.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    //DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  // // // // // // // // //
  InterstitialAd? _interstitialAd;

  bool _isInterstitialAdReady = false;

  /* void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (_) => false); //here
            },
          );
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }*/

// // // // // // // // //

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  initState() {
    super.initState();
    setState(() {
      color = Color(DataBox.getColor() ?? 4280391411);
      if (DataBox.getCounter() != null) totalCounter = DataBox.getCounter()!;
    });
    // // // // // // // // // // // // // // //
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
    // // // // //
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (_) => false); //here
            },
          );
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  int counter = 0;
  int totalCounter = 0;

// ignore: non_constant_identifier_names
  void ITC() {
    setState(() {
      totalCounter++;
    });
  }

  void makeZeroTotal() {
    setState(() {
      totalCounter = 0;
    });
  }

  Future<void> incrementCounter() async {
    if (num != null && num == counter + 1) {
      if (await Vibration.hasAmplitudeControl()) {
        Vibration.vibrate(amplitude: 128);
      }
    }
    setState(() {
      counter++;
    });
  }

  void makeZero() {
    setState(() {
      counter = 0;
    });
  }

  void makeZero1() {
    setState(() {
      counter = 0;
      num = null;
    });
  }

// // // // // // // //

// blue color = 4280391411 //
// black color = 4278190080 //

  Color? color;

// // // // // // //
  int? num;
  var x = "";

//TextEditingController _con = TextEditingController();
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter"),
        backgroundColor: color ?? Color(4280391411),
        brightness: Brightness.light,
      ),
      endDrawer: Drawer(
        child: Container(
          color: color!.withOpacity(0.2),
          child: ListView(
            children: [
              DrawerHeader(
                  child: Container(
                      child: Image.asset("assets/images/one.jpg",
                          fit: BoxFit.fill))),
              ListTile(
                title: Text("pick color"),
                leading: Icon(Icons.color_lens),
                onTap: () => showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text("select your color"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BlockPicker(
                                onColorChanged: (Color value) async {
                                  await DataBox.setColor(value.value);
                                },
                                pickerColor: color ?? Color(4280391411),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      color = Color(
                                          DataBox.getColor() ?? 4280391411);
                                    });
                                    Navigator.pop(ctx);
                                  },
                                  child: Text("close"))
                            ],
                          ),
                        )),
              ),
              Divider(),
              ListTile(
                title: Text("total: ${DataBox.getCounter()}"),
                leading: Icon(Icons.plus_one),
                onLongPress: () {
                  makeZeroTotal();
                  DataBox.setCounter(totalCounter);
                },
              ),
              Divider(),
              ListTile(
                title: Text("about me"),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => About()),
                    PageTransition(
                        type: PageTransitionType.bottomToTop, child: About()),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text("share app"),
                leading: Icon(Icons.share),
                onTap: () {
                  Share.share(
                      'https://drive.google.com/drive/folders/1bwm6svMvqHbux-V7bjFqku96bLJsfjlp?usp=sharing');
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              color: color!.withOpacity(0.2),
              width: double.infinity,
              height: double.infinity,
              child: TextButton(
                onPressed: () {
                  incrementCounter();
                  ITC();
                  DataBox.setCounter(totalCounter);
                },
                /*onLongPress: () {
              makeZero();
            },*/
                child: Text(
                  '$counter',
                  style: TextStyle(
                    fontFamily: "Parisienne",
                    fontSize: counter >= 100 ? 124 : 200,
                    fontWeight: FontWeight.bold,
                    color: color ?? Color(4280391411),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-0.9, -0.95),
              child: ElevatedButton(
                onPressed: makeZero,
                onLongPress: makeZero1,
                child: Icon(Icons.settings_backup_restore),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                  primary: color,
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.9, -0.95),
              child: ElevatedButton(
                onLongPress: () {
                  //_loadInterstitialAd();
                  if (_isInterstitialAdReady) {
                    _interstitialAd?.show();
                  }
                },
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: color!.withOpacity(0.9),
                        title: Text("enter your count"),
                        content: TextField(
                          controller: _textEditingController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                const Radius.circular(12.0),
                              ),
                            ),
                            labelText: 'count',
                            labelStyle:
                                TextStyle(color: Colors.black.withOpacity(0.8)),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(num =
                                    int.parse(_textEditingController.text));
                              },
                              child: Text("ok")),
                        ],
                      );
                    }),
                child: Icon(Icons.settings_outlined),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                  primary: color,
                ),
              ),
            ),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
        ),
      ),
    );
  }

// AlertDialog alert =
}
