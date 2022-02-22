import 'package:counter/data-prefenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ad_helper.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  //List<Color> colorList = List.generate(5, (index) => Colors.primaries[index]);
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId1,
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
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Me"),
        backgroundColor: Color(DataBox.getColor() ?? 4280391411),
      ),
      body: Container(
        color: Color(DataBox.getColor() ?? 4280391411).withOpacity(0.2),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ahmad einieh",
                      style: ts,
                    ),
                  ],
                ),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.5),
                  color: Color((DataBox.getColor() ?? 4280391411))
                      .withOpacity(0.3),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.5),
                  color: Color((DataBox.getColor() ?? 4280391411))
                      .withOpacity(0.3),
                ),
                child: TextButton(
                  onPressed: () {
                    Clipboard.setData(
                        new ClipboardData(text: "abomoaz3375@gamil.com"));
                  },
                  child: Text(
                    "ahmad.ainieh2@gmail.com",
                    style: ts,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.5),
                  color: Color((DataBox.getColor() ?? 4280391411))
                      .withOpacity(0.3),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextButton(
                    onPressed: () =>
                        _launchURL('https://github.com/ahmad-prog'),
                    child: Text(
                      "GitHub",
                      style: ts,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.5),
                  color: Color((DataBox.getColor() ?? 4280391411))
                      .withOpacity(0.3),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextButton(
                    onPressed: () =>
                        _launchURL('https://paypal.me/proahmad?locale.x=ar_EG'),
                    child: Text(
                      "PayPal",
                      style: ts,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle ts = TextStyle(fontSize: 25, color: Colors.grey);

  _launchURL(link) async {
    //const url = link;
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

}
