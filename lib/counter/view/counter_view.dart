import 'package:bloc_cubit/core/theme/theme_cubit.dart';
import 'package:bloc_cubit/core/widgets/app_drawer.dart';
import 'package:bloc_cubit/counter/cubit/counter_cubit.dart';
import 'package:bloc_cubit/counter/cubit/counter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<CounterCubit, CounterState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.counter == 10) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Counter mencapai 10")));
        }
        // jika counter < 0, maka tampilkan alert dialog
        if (state.counter < 0) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Warning"),
                content: Text("Counter Negatif!"),
              );
            },
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Counter Page"),
          // tambahkan action button untuk toggle theme
          actions: [
            IconButton(
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
              icon: const Icon(Icons.dark_mode),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<CounterCubit, CounterState>(
                builder: (context, state) {
                  return Text(
                    '${state.counter}',
                    style: textTheme.displayMedium,
                  );
                },
              ),

              BlocSelector<CounterCubit, CounterState, bool>(
                selector: (state) => state.isEven,
                builder: (context, isEven) {
                  return Text(isEven ? "Genap" : "Ganjil");
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              key: const Key('counterView_increment_floatingActionButton'),
              child: const Icon(Icons.add),
              onPressed: () => context.read<CounterCubit>().increment(),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              key: const Key('counterView_decrement_floatingActionButton'),
              child: const Icon(Icons.remove),
              onPressed: () => context.read<CounterCubit>().decrement(),
            ),
          ],
        ),
      ),
    );
  }
}
