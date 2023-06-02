import { Array_init = initArray; intToFloat; floatToInt; nat32ToNat = nat; intToNat32Wrap = nat32; abs } "mo:prim";

module {
  func sort<T>(
    array: [var T],
    map: (item: T) -> Float,
    twinArray: [var T],
    counts: [var Nat32],
    shiftedCounts: [var Nat32],
    subArray: Bool,
    from: Nat32,
    to: Nat32,
  ) {
    var prevValue = map(array[nat(from)]);
    var min = prevValue;
    var max = min;
    var sorted = true;
    var i = from +% 1;

    loop {
      let value = map(array[nat(i)]);

      if (value > max) max := value else if (value < min) min := value;

      if (sorted) if (prevValue > value) sorted := false else prevValue := value;

      i +%= 1;
    } while (i <= to);

    if (sorted) return;

    if (subArray) {
      i := from;

      loop {
        counts[nat(i)] := 0;

        i +%= 1;
      } while (i <= to);
    };

    i := from;

    let step = (max - min) / intToFloat(nat(to -% from));
    let fromFloat = intToFloat(nat(from));

    loop {
      let index = abs(floatToInt(fromFloat + (map(array[nat(i)]) - min) / step));

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
      let index = abs(floatToInt(fromFloat + (map(item) - min) / step));
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
          sort(array, map, twinArray, counts, shiftedCounts, true, i, i +% count -% 1);
        };
      };

      i +%= 1;
    } while (i <= to);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func sortFloat<T>(
    array: [var T],
    map: (item: T) -> Float,
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
