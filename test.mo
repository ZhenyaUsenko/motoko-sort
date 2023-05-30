import IC "mo:base/ExperimentalInternetComputer";
import Prim "mo:prim";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import { time } "mo:prim";
import { sortFloat } "./src/sortFloat";
import { sortInt8 } "./src/sortInt8";
import { sortInt16 } "./src/sortInt16";
import { sortInt32 } "./src/sortInt32";
import { sortNat8 } "./src/sortNat8";
import { sortNat16 } "./src/sortNat16";
import { sortNat32 } "./src/sortNat32";

actor Test {
  func randomFloat(key: Nat64): Float {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return Prim.intToFloat(Prim.nat64ToNat(hash >> 31 ^ hash));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func randomInt8(key: Nat64): Int8 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return -Prim.intToInt8(Prim.nat64ToNat(hash >> 31 ^ hash & 0x7f));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func randomInt16(key: Nat64): Int16 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return -Prim.intToInt16(Prim.nat64ToNat(hash >> 31 ^ hash & 0x7fff));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func randomInt32(key: Nat64): Int32 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return -Prim.intToInt32(Prim.nat64ToNat(hash >> 31 ^ hash & 0x3fffffff));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func randomNat8(key: Nat64): Nat8 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return Prim.intToNat8Wrap(Prim.nat64ToNat(hash >> 31 ^ hash & 0xff));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func randomNat16(key: Nat64): Nat16 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return Prim.intToNat16Wrap(Prim.nat64ToNat(hash >> 31 ^ hash & 0xffff));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func randomNat32(key: Nat64): Nat32 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return Prim.intToNat32Wrap(Prim.nat64ToNat(hash >> 31 ^ hash & 0x3fffffff));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public query func test(): async Text {
    var randomSeed = 1:Nat64;

    let array = Array.init<Nat32>(100000, 0);

    for (i in array.keys()) {
      array[i] := randomNat32(randomSeed);

      randomSeed +%= 1;
    };

    let cost = IC.countInstructions(func() {
      sortNat32<Nat32>(array, func(item) = item);
    });

    let iter = array.keys();
    var errorsCount = 0:Nat32;

    ignore iter.next();

    for (i in iter) {
      if (array[i - 1] > array[i]) errorsCount +%= 1;
    };

    return "cost - " # debug_show(cost) # ", errors - " # debug_show(errorsCount);
  };
};
