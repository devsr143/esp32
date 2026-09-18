enum CommandType {
  forward,
  backward,
  left,
  right,
  circle,
  stop,
  loop,
  delay,
}

class ProgramBlock {
  ProgramBlock({
    required this.id,
    required this.type,
    this.seconds = 1.0,
    this.degrees = 90,
  });

  final int id;
  final CommandType type;

  double seconds;
  int degrees;
}


