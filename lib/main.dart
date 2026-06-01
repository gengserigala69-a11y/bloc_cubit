import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_cubit/app.dart';
import 'package:bloc_cubit/counter_observe.dart';

void main() {
  Bloc.observer = const CounterObserver();
  runApp(CounterApp());
}