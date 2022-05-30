import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_api/bloc/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomUser(),
    );
  }
}

class RandomUser extends StatefulWidget {
  const RandomUser({Key? key}) : super(key: key);

  @override
  State<RandomUser> createState() => _RandomUserState();
}

class _RandomUserState extends State<RandomUser>
    with SingleTickerProviderStateMixin {
  late UserBloc userBloc;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    userBloc = UserBloc();
    userBloc.add(GeteUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.cyan,
          Color.fromARGB(255, 206, 114, 145),
          Color.fromARGB(255, 240, 230, 135)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: BlocConsumer<UserBloc, UserState>(
          bloc: userBloc,
          listener: (context, state) {
            if (state is UserErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message.toString())));
            }
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is UserLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is UserFetchedState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            state.userModel.results.last.picture.large),
                        radius: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                            ),
                            Text(state.userModel.results.last.name.title),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                                  Text(state.userModel.results.last.name.first),
                            ),
                            Text(state.userModel.results.last.name.last)
                          ],
                        ),
                      ),
                      TabBar(
                        unselectedLabelColor: Colors.blueAccent[100],
                        labelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(text: "Main info"),
                          Tab(text: "Location"),
                          Tab(
                            text: "Email",
                          )
                        ],
                        controller: _tabController,
                      ),
                      SizedBox(
                        width: 400,
                        height: 350,
                        child:
                            TabBarView(controller: _tabController, children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Name"),
                                  Text("FirstName"),
                                  Text("LastName"),
                                  Text("Gender"),
                                  Text("DateOFBirth"),
                                  Text("Age"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Value"),
                                  Text(
                                      state.userModel.results.first.name.first),
                                  Text(state.userModel.results.first.name.last),
                                  Text(state.userModel.results.first.gender),
                                  Text(state.userModel.results.first.dob
                                      .toString()),
                                  Text(state
                                      .userModel.results.first.registered.age
                                      .toString()),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Name:"),
                                  Text("Country:"),
                                  Text("State:"),
                                  Text("City:"),
                                  Text("Street:"),
                                  Text("Pastcode:"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Value"),
                                  Text(state.userModel.results.first.location
                                      .country),
                                  Text(state
                                      .userModel.results.first.location.state),
                                  Text(state
                                      .userModel.results.first.location.city),
                                  Text(state.userModel.results.first.location
                                      .street.name),
                                  Text(state
                                      .userModel.results.first.location.postcode
                                      .toString()),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Name"),
                                  Text("Email:"),
                                  Text("Username:"),
                                  Text("Phone:"),
                                  Text("Cell:"),
                                  Text("Registered:"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Value"),
                                  Text(state.userModel.results.first.email),
                                  Text(state
                                      .userModel.results.first.login.username),
                                  Text(state.userModel.results.first.phone),
                                  Text(state.userModel.results.first.cell),
                                  Text(state
                                      .userModel.results.first.registered.date
                                      .toString()),
                                ],
                              )
                            ],
                          )
                        ]),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            userBloc.add(GeteUserEvent());
                          },
                          child: const Icon(Icons.autorenew))
                    ],
                  ),
                ),
              );
            }
            if (state is UserErrorState) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    userBloc.add(GeteUserEvent());
                  },
                  child: Text("Try again"),
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
