class CounterState {
  final int counter;
  final bool isEven;

  CounterState({required this.counter, required this.isEven});

  // digunakan untuk membuat state baru, tanpa mengubah state lama
  CounterState copyWith({int? counter, bool? isEven}) {
    return CounterState(
      counter: counter ?? this.counter,
      isEven: isEven ?? this.isEven,
    );
  }
}