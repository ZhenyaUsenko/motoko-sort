import Prim "mo:prim";
import { nat8ToNat16; nat16ToNat32; nat64ToNat; intToNat32Wrap; nat32ToNat = nat; nat32ToNat64 = nat64 } "mo:prim";

module {
  func sort2<T>(
    array: [var T],
    map: (item: T) -> Nat8,
    from: Nat32,
  ) {
    let index1 = nat(from);
    let index2 = nat(from +% 1);
    let item1 = array[index1];
    let item2 = array[index2];

    if (map(item1) < map(item2)) {
      array[index1] := item2;
      array[index2] := item1;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func sort3<T>(
    array: [var T],
    map: (item: T) -> Nat8,
    from: Nat32,
  ) {
    let index1 = nat(from);
    let index2 = nat(from +% 1);
    let index3 = nat(from +% 2);
    var item1 = array[index1];
    var item2 = array[index2];
    var item3 = array[index3];

    if (map(item1) < map(item2)) {
      let temp = item1;

      item1 := item2;
      item2 := temp;
    };

    if (map(item1) < map(item3)) {
      let temp = item1;

      item1 := item3;
      item3 := temp;
    };

    if (map(item2) < map(item3)) {
      let temp = item2;

      item2 := item3;
      item3 := temp;
    };

    array[index1] := item1;
    array[index2] := item2;
    array[index3] := item3;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func sort4<T>(
    array: [var T],
    map: (item: T) -> Nat8,
    from: Nat32,
  ) {
    let index1 = nat(from);
    let index2 = nat(from +% 1);
    let index3 = nat(from +% 2);
    let index4 = nat(from +% 3);
    var item1 = array[index1];
    var item2 = array[index2];
    var item3 = array[index3];
    var item4 = array[index4];

    if (map(item1) < map(item2)) {
      let temp = item1;

      item1 := item2;
      item2 := temp;
    };

    if (map(item3) < map(item4)) {
      let temp = item3;

      item3 := item4;
      item4 := temp;
    };

    if (map(item1) < map(item3)) {
      let temp = item1;

      item1 := item3;
      item3 := temp;
    };

    if (map(item2) < map(item4)) {
      let temp = item2;

      item2 := item4;
      item4 := temp;
    };

    if (map(item2) < map(item3)) {
      let temp = item2;

      item2 := item3;
      item3 := temp;
    };

    array[index1] := item1;
    array[index2] := item2;
    array[index3] := item3;
    array[index4] := item4;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  func sort<T>(
    array: [var T],
    map: (item: T) -> Nat8,
    twinArray: [var T],
    counts: [var Nat32],
    shiftedCounts: [var Nat32],
    fullArray: Bool,
    from: Nat32,
    to: Nat32,
  ) {
    var prevValue = map(array[nat(from)]);
    var min = prevValue;
    var max = min;
    var sorted = true;
    var i = from +% 1;

    if (fullArray) {
      for (item in array.vals()) {
        let value = map(item);

        if (value > max) max := value else if (value < min) min := value;

        if (sorted) if (prevValue < value) sorted := false else prevValue := value;
      };

      if (sorted) return;

      let minMaxDiff = nat64(nat16ToNat32(nat8ToNat16(max -% min)));
      let scale = 0xffffffffffffffff / minMaxDiff;
      let step = scale *% minMaxDiff / nat64(to -% from);
      let to64 = nat64(to);

      for (item in array.vals()) {
        let index = nat64ToNat(to64 -% scale *% nat64(nat16ToNat32(nat8ToNat16(map(item) -% min))) / step);

        counts[index] +%= 1;
      };

      i := from;

      var totalCount = from;

      for (count in counts.vals()) {
        if (count != 0) {
          shiftedCounts[nat(totalCount)] := count;
          counts[nat(i)] := totalCount;
          totalCount +%= count;
        };

        i +%= 1;
      };

      for (item in array.vals()) {
        let index = nat64ToNat(to64 -% scale *% nat64(nat16ToNat32(nat8ToNat16(map(item) -% min))) / step);
        let count = counts[index];

        twinArray[nat(count)] := item;
        counts[index] := count +% 1;
      };

      i := from;

      for (item in twinArray.vals()) {
        array[nat(i)] := item;

        i +%= 1;
      };

      i := from;

      for (count in shiftedCounts.vals()) {
        if (count > 1) {
          if (count == 2) {
            sort2(array, map, i);
          } else if (count == 3) {
            sort3(array, map, i);
          } else if (count == 4) {
            sort4(array, map, i);
          } else {
            sort(array, map, twinArray, counts, shiftedCounts, false, i, i +% count -% 1);
          };
        };

        i +%= 1;
      };
    } else {
      loop {
        let value = map(array[nat(i)]);

        if (value > max) max := value else if (value < min) min := value;

        if (sorted) if (prevValue < value) sorted := false else prevValue := value;

        i +%= 1;
      } while (i <= to);

      if (sorted) return;

      i := from;

      loop {
        counts[nat(i)] := 0;

        i +%= 1;
      } while (i <= to);

      i := from;

      let minMaxDiff = nat64(nat16ToNat32(nat8ToNat16(max -% min)));
      let scale = 0xffffffffffffffff / minMaxDiff;
      let step = scale *% minMaxDiff / nat64(to -% from);
      let to64 = nat64(to);

      loop {
        let index = nat64ToNat(to64 -% scale *% nat64(nat16ToNat32(nat8ToNat16(map(array[nat(i)]) -% min))) / step);

        counts[index] +%= 1;

        i +%= 1;
      } while (i <= to);

      i := from;

      var totalCount = from;

      loop {
        let iNat = nat(i);
        let count = counts[iNat];

        if (count != 0) {
          shiftedCounts[nat(totalCount)] := count;
          counts[iNat] := totalCount;
          totalCount +%= count;
        };

        i +%= 1;
      } while (i <= to);

      i := from;

      loop {
        let item = array[nat(i)];
        let index = nat64ToNat(to64 -% scale *% nat64(nat16ToNat32(nat8ToNat16(map(item) -% min))) / step);
        let count = counts[index];

        twinArray[nat(count)] := item;
        counts[index] := count +% 1;

        i +%= 1;
      } while (i <= to);

      i := from;

      loop {
        let iNat = nat(i);

        array[iNat] := twinArray[iNat];

        i +%= 1;
      } while (i <= to);

      i := from;

      loop {
        let count = shiftedCounts[nat(i)];

        if (count > 1) {
          if (count == 2) {
            sort2(array, map, i);
          } else if (count == 3) {
            sort3(array, map, i);
          } else if (count == 4) {
            sort4(array, map, i);
          } else {
            sort(array, map, twinArray, counts, shiftedCounts, false, i, i +% count -% 1);
          };
        };

        i +%= 1;
      } while (i <= to);
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func sortNat8Desc<T>(
    array: [var T],
    map: (item: T) -> Nat8,
  ) {
    let size = array.size();

    if (size >= 2) sort(
      array,
      map,
      Prim.Array_init<T>(size, array[0]),
      Prim.Array_init<Nat32>(size, 0),
      Prim.Array_init<Nat32>(size, 0),
      true,
      0:Nat32,
      intToNat32Wrap(size) -% 1,
    );
  };
};
