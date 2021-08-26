import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freezed_riverpod/controllers/auth_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedUser = "";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase riverpod',
      home: Navigator(
        pages: [
          MaterialPage(child: UserView((user) {
            setState(() => _selectedUser = user);
          })),
          if (_selectedUser != null)
            MaterialPage(child: UserDetailsView(_selectedUser))
        ],
        onPopPage: (route, result) {
          _selectedUser = null;
          return route.didPop(result);
        },
      ),
    );
  }
}

class UserView extends StatelessWidget {
  final _users = ["Ram", "Shyam", "Bibek"];
  final ValueChanged didSelectUser;
  UserView(this.didSelectUser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Users")),
        body: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return Card(
                  child: ListTile(
                title: Text(user),
                onTap: () => didSelectUser(user),
              ));
            }));
  }
}

class UserDetailsView extends StatelessWidget {
  final String user;

  UserDetailsView(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("User Details")),
        body: Center(child: Text("Hello, $user")));
  }
}

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final authControllerState = watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text("Shopping List"),
          leading: authControllerState.state != null
              ? IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () =>
                      context.read(authControllerProvider).signOut(),
                )
              : null),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("testing").snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final docData = snapshot.data?.docs[index].data();
              // final dateTime = (docData['timestamp'] as Timestamp).toDate();
              return ListTile(
                title: Text("Hello"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => FirebaseFirestore.instance
            .collection("testing")
            .add({"timestamp": Timestamp.fromDate(DateTime.now())}),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
