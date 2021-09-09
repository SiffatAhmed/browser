import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  TextEditingController textEditingController = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var urlString = "https://www.google.com";
  var urls = ["https://www.google.com"];
  var linkscounter = 0;
  launchUrl() {
    setState(
      () {
        RegExp urlExp1 = RegExp(
            r"(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?");
        RegExp urlExp2 = RegExp(
            r"[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?");
        if (urlExp1.hasMatch(textEditingController.text)) {
          urlString = textEditingController.text;
        } else if (urlExp2.hasMatch(textEditingController.text)) {
          urlString = "https://" + textEditingController.text;
        } else {
          urlString = "https://www." + textEditingController.text;
        }
        textEditingController.text = urlString;

        flutterWebviewPlugin.reloadUrl(urlString);
        urls.add(urlString);
        ++linkscounter;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = urlString;
    flutterWebviewPlugin.onStateChanged.listen(
      (WebViewStateChanged wvs) {
        print(wvs.type);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: false,
          controller: textEditingController,
          cursorColor: Colors.white,
          cursorWidth: 0.3,
          textInputAction: TextInputAction.go,
          onSubmitted: (url) => launchUrl(),
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter URL Here",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => launchUrl(),
          ),
          IconButton(
            icon: Icon(Icons.settings_backup_restore_outlined),
            onPressed: () {
              setState(
                () {
                  urlString = textEditingController.text;
                  flutterWebviewPlugin.reloadUrl(urlString);
                },
              );
            },
          ),
        ],
      ),
      url: urlString,
      clearCache: true,
      withZoom: true,
      supportMultipleWindows: true,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(
                  () {
                    urlString = urls[--linkscounter];
                    flutterWebviewPlugin.reloadUrl(urlString);
                    textEditingController.text = urlString;
                  },
                );
              },
            ),
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(
                    () {
                      urlString = urls[++linkscounter];
                      flutterWebviewPlugin.reloadUrl(urlString);
                      textEditingController.text = urlString;
                    },
                  );
                }),
            IconButton(
              icon: Icon(Icons.power_settings_new_outlined),
              onPressed: () {
                SystemNavigator.pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
