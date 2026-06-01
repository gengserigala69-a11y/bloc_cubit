import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_cubit/counter/cubit/counter_cubit.dart';
import 'package:bloc_cubit/counter/view/counter_view.dart';
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CounterView();
  }
}