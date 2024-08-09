import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_page.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null && _pageController.page!.round() != _currentPage) {
        _onPageChanged(_pageController.page!.round());
      }
    });
  }

  Future<void> _onPageChanged(int page) async {
    if (page == 1 && !(await _hasCameraPermission())) {
      await _requestCameraPermission();
    } else {
      setState(() {
        _currentPage = page;
      });
    }
  }

  Future<bool> _hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _currentPage = 1;
        _pageController.jumpToPage(1);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Camera access is required to scan IDs. Please grant camera permission.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _navigateToPage(int page) async {
    if (page == 1 && !(await _hasCameraPermission())) {
      await _requestCameraPermission();
    } else {
      _pageController.jumpToPage(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.black87],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: PageView(
              controller: _pageController,
              children: [
                _buildPage(
                  context,
                  'assets/167.png',
                  'Welcome to Scan my ID Express',
                  'The Digital Space We Need',
                ),
                _buildPage(
                  context,
                  'assets/cam.jpg',
                  'We need access to your camera to scan your ID',
                  'Please grant permission to proceed',
                ),
                _buildPage(
                  context,
                  'assets/id.png',
                  'Ensure image quality by scanning the entire ID card',
                  '',
                ),
                _buildLastPage(context),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Scan My ID'
                'Express',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cursive', // Italian-style font
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: _buildProgressIndicator(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: _currentPage > 0
                ? ElevatedButton(
              onPressed: () {
                _navigateToPage(_currentPage - 1);
              },
              child: Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            )
                : SizedBox.shrink(),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _currentPage < 3
                ? ElevatedButton(
              onPressed: () {
                _navigateToPage(_currentPage + 1);
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, String imagePath, String text, String subText) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 150, height: 150),
          SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            subText,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLastPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/get.jpg', width: 150, height: 150),
          SizedBox(height: 20),
          Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, PageRouteBuilder(
                transitionDuration: Duration(seconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: _currentPage == index ? 20 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.deepPurple : Colors.white30,
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}
