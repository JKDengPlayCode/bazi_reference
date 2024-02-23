import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.menu,
        //     semanticLabel: 'menu',
        //   ),
        //   onPressed: () {
        //     print('Menu button');
        //   },
        // ),
        title: const Text('建设中...'),
        // centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  width: 120,
                ),
                const SizedBox(height: 16.0),
                const Text('卜算子'),
              ],
            ),
            const SizedBox(height: 100.0),
            // [Name]
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: true,
                labelText: '用户名',
              ),
            ),
            // spacer
            const SizedBox(height: 30.0),
            // [Password]
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                filled: true,
                labelText: '密码',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30.0),
            ButtonBar(
              children: <Widget>[
                FilledButton(
                  child: const Text('重置'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                ElevatedButton(
                  child: const Text('登录'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
