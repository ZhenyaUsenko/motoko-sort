import Prim "mo:prim";
import { intToNat32Wrap; nat32ToNat = nat } "mo:prim";

module {
  public func sortBoolDesc<T>(
    array: [var T],
    map: (item: T) -> Bool,
  ) {
    let size = array.size();

    if (size >= 2) {
      let twinArray = Prim.Array_init<T>(size, array[0]);
      let lastIndex = intToNat32Wrap(size) -% 1;
      var falseIndex = lastIndex;
      var trueIndex = 0:Nat32;

      for (item in array.vals()) {
        if (map(item)) {
          twinArray[nat(trueIndex)] := item;

          trueIndex +%= 1;
        } else {
          twinArray[nat(falseIndex)] := item;

          falseIndex -%= 1;
        };
      };

      let lastTrueIndex = trueIndex;

      falseIndex := lastIndex;
      trueIndex := 0;

      for (item in twinArray.vals()) {
        if (trueIndex == lastTrueIndex) {
          array[nat(falseIndex)] := item;

          falseIndex -%= 1;
        } else {
          array[nat(trueIndex)] := item;

          trueIndex +%= 1;
        };
      };
    };
  };
};
