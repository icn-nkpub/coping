import 'dart:convert';

import 'package:dependencecoping/programs/locker_program/locker_program.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

/// The locker instruction for the locker program.
class LockerInstruction extends Instruction {
  factory LockerInstruction({
    required final List<Ed25519HDPublicKey> signers,
  }) {
    final accounts = signers.map(_addressToAccount).toList(growable: false);

    return LockerInstruction._(
      accounts: accounts,
      data: ByteArray(utf8.encode('')),
    );
  }

  LockerInstruction._({
    required super.accounts,
    required super.data,
  }) : super(
          programId: LockerProgram.id,
        );

  static AccountMeta _addressToAccount(final Ed25519HDPublicKey address) =>
      AccountMeta.writeable(pubKey: address, isSigner: true);
}
