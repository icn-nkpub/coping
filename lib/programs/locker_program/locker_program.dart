import 'package:solana/solana.dart';

/// The locker program.
abstract class LockerProgram {
  static const programId = 'DmKUa9SjGHGu88Fdf7hvwLSArjfW6FQynaBHJpNzHqEP';

  static final Ed25519HDPublicKey id = Ed25519HDPublicKey.fromBase58(programId);
}
