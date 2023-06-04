import Array "mo:base/Array";
import Debug "mo:base/Debug";
import IC "mo:base/ExperimentalInternetComputer";
import Nat32 "mo:base/Nat32";
import Prim "mo:prim";
import { time } "mo:prim";
import { sortFloat } "./src/sort";
import { sortInt8; sortInt8Desc; sortInt16; sortInt16Desc; sortInt32; sortInt32Desc; sortInt64; sortInt64Desc } "./src/sort";
import { sortNat8; sortNat8Desc; sortNat16; sortNat16Desc; sortNat32; sortNat32Desc; sortNat64; sortNat64Desc } "./src/sort";

actor Test {
  func randomNat64(key: Nat64): Nat64 {
    var hash = key;

    hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
    hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;

    return hash >> 31 ^ hash;
  };

  func randomNat32(key: Nat64): Nat32 {
    return Prim.intToNat32Wrap(Prim.nat64ToNat(randomNat64(key) & 0xffffffff));
  };

  func randomNat16(key: Nat64): Nat16 {
    return Prim.intToNat16Wrap(Prim.nat64ToNat(randomNat64(key) & 0xffff));
  };

  func randomNat8(key: Nat64): Nat8 {
    return Prim.intToNat8Wrap(Prim.nat64ToNat(randomNat64(key) & 0xff));
  };

  func randomInt64(key: Nat64): Int64 {
    return Prim.nat64ToInt64(randomNat64(key));
  };

  func randomInt32(key: Nat64): Int32 {
    return Prim.nat32ToInt32(Prim.intToNat32Wrap(Prim.nat64ToNat(randomNat64(key) & 0xffffffff)));
  };

  func randomInt16(key: Nat64): Int16 {
    return Prim.nat16ToInt16(Prim.intToNat16Wrap(Prim.nat64ToNat(randomNat64(key) & 0xffff)));
  };

  func randomInt8(key: Nat64): Int8 {
    return Prim.nat8ToInt8(Prim.intToNat8Wrap(Prim.nat64ToNat(randomNat64(key) & 0xff)));
  };

  func randomFloat(key: Nat64): Float {
    return Prim.intToFloat(Prim.nat64ToNat(randomNat64(key)));
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public query func test(): async Text {
    var randomSeed = 1:Nat64;

    let array = Array.init<Nat32>(100000, 0);

    for (i in array.keys()) {
      array[i] := randomNat32(randomSeed);

      randomSeed +%= 1;
    };

    var heap = Prim.rts_heap_size();

    let cost = IC.countInstructions(func() {
      //Array.sortInPlace(array, Nat32.compare);
      sortNat32<Nat32>(array, func(item) = item);
    });

    heap := Prim.rts_heap_size() - heap;

    let iter = array.keys();
    var errorsCount = 0:Nat32;

    ignore iter.next();

    for (i in iter) {
      if (array[i - 1] > array[i]) errorsCount +%= 1;
    };

    return "cost - " # debug_show(cost) # ", heap - " # debug_show(heap) # ", errors - " # debug_show(errorsCount);
  };
};
