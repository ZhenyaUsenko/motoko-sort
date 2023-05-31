import { Array_init = initArray; nat8ToNat; int8ToNat8; nat32ToNat = nat; nat64ToNat; intToNat32Wrap = nat32; intToNat64Wrap = nat64 } "mo:prim";

module {
  func sort<T>(
    array: [var T],
    map: (item: T) -> Int8,
    twin: [var T],
    counts: [var Nat32],
    gaplessCounts: [var Nat32],
    subArray: Bool,
    from: Nat32,
    to: Nat32,
  ) {
    var min = map(array[nat(to)]);
    var max = min;
    var i = from;

    while (i < to) {
      let value = map(array[nat(i)]);

      if (value > max) max := value else if (value < min) min := value;

      i +%= 1;
    };

    if (min == max) return;

    if (subArray) {
      i := from;

      while (i <= to) {
        counts[nat(i)] := 0;

        i +%= 1;
      };
    };

    i := from;

    let minMaxDiff = nat64(nat8ToNat(int8ToNat8(max -% min)));
    let scale = 0xffffffffffffffff / minMaxDiff;
    let step = scale *% minMaxDiff / nat64(nat(to -% from));
    let from64 = nat64(nat(from));

    while (i <= to) {
      let index = nat64ToNat(from64 +% scale *% nat64(nat8ToNat(int8ToNat8(map(array[nat(i)]) -% min))) / step);

      counts[index] +%= 1;

      i +%= 1;
    };

    i := from;

    var totalCount = from;

    while (i <= to) {
      let iNat = nat(i);
      let count = counts[iNat];

      if (count != 0) {
        gaplessCounts[nat(totalCount)] := count;
        counts[iNat] := totalCount;
        totalCount +%= count;
      };

      i +%= 1;
    };

    i := from;

    while (i <= to) {
      let iNat = nat(i);
      let index = nat64ToNat(from64 +% scale *% nat64(nat8ToNat(int8ToNat8(map(array[iNat]) -% min))) / step);
      let count = counts[index];

      twin[nat(count)] := array[iNat];
      counts[index] := count +% 1;

      i +%= 1;
    };

    i := from;

    while (i <= to) {
      let iNat = nat(i);

      array[iNat] := twin[iNat];

      i +%= 1;
    };

    i := from;

    while (i <= to) {
      let count = gaplessCounts[nat(i)];

      if (count > 1) {
        if (count == 2) {
          let index1 = nat(i);
          let index2 = nat(i +% 1);
          let item1 = array[index1];
          let item2 = array[index2];

          if (map(item1) > map(item2)) {
            array[index1] := item2;
            array[index2] := item1;
          };
        } else if (count == 3) {
          let index1 = nat(i);
          let index2 = nat(i +% 1);
          let index3 = nat(i +% 2);
          var item1 = array[index1];
          var item2 = array[index2];
          var item3 = array[index3];

          if (map(item1) > map(item2)) {
            let temp = item1;

            item1 := item2;
            item2 := temp;
          };

          if (map(item1) > map(item3)) {
            let temp = item1;

            item1 := item3;
            item3 := temp;
          };

          if (map(item2) > map(item3)) {
            let temp = item2;

            item2 := item3;
            item3 := temp;
          };

          array[index1] := item1;
          array[index2] := item2;
          array[index3] := item3;
        } else if (count == 4) {
          let index1 = nat(i);
          let index2 = nat(i +% 1);
          let index3 = nat(i +% 2);
          let index4 = nat(i +% 3);
          var item1 = array[index1];
          var item2 = array[index2];
          var item3 = array[index3];
          var item4 = array[index4];

          if (map(item1) > map(item2)) {
            let temp = item1;

            item1 := item2;
            item2 := temp;
          };

          if (map(item3) > map(item4)) {
            let temp = item3;

            item3 := item4;
            item4 := temp;
          };

          if (map(item1) > map(item3)) {
            let temp = item1;

            item1 := item3;
            item3 := temp;
          };

          if (map(item2) > map(item4)) {
            let temp = item2;

            item2 := item4;
            item4 := temp;
          };

          if (map(item2) > map(item3)) {
            let temp = item2;

            item2 := item3;
            item3 := temp;
          };

          array[index1] := item1;
          array[index2] := item2;
          array[index3] := item3;
          array[index4] := item4;
        } else {
          sort(array, map, twin, counts, gaplessCounts, true, i, i +% count -% 1);
        };
      };

      i +%= 1;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func sortInt8<T>(
    array: [var T],
    map: (item: T) -> Int8,
  ) {
    let size = array.size();

    if (size >= 2) sort(
      array,
      map,
      initArray<T>(size, array[0]),
      initArray<Nat32>(size, 0),
      initArray<Nat32>(size, 0),
      false,
      0:Nat32,
      nat32(size) -% 1,
    );
  };
};
