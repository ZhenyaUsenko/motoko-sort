import IC "mo:base/ExperimentalInternetComputer";
import Prim "mo:prim";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import { time } "mo:prim";
import { sortFloat } "./src/sortFloat";
import { sortInt8 } "./src/sortInt8";
import { sortInt8Desc } "./src/sortInt8Desc";
import { sortInt16 } "./src/sortInt16";
import { sortInt16Desc } "./src/sortInt16Desc";
import { sortInt32 } "./src/sortInt32";
import { sortInt32Desc } "./src/sortInt32Desc";
import { sortInt64 } "./src/sortInt64";
import { sortInt64Desc } "./src/sortInt64Desc";
import { sortNat8 } "./src/sortNat8";
import { sortNat8Desc } "./src/sortNat8Desc";
import { sortNat16 } "./src/sortNat16";
import { sortNat16Desc } "./src/sortNat16Desc";
import { sortNat32 } "./src/sortNat32";
import { sortNat32Desc } "./src/sortNat32Desc";
import { sortNat64 } "./src/sortNat64";
import { sortNat64Desc } "./src/sortNat64Desc";

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

    return -Prim.intToInt32(Prim.nat64ToNat(hash >> 31 ^ hash & 0x7fffffff));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func randomInt64(key: Nat64): Int64 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return -Prim.intToInt64(Prim.nat64ToNat(hash >> 31 ^ hash & 0x7fffffffffffffff));
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

    return Prim.intToNat32Wrap(Prim.nat64ToNat(hash >> 31 ^ hash & 0xffffffff));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func randomNat64(key: Nat64): Nat64 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return hash >> 31 ^ hash;
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
