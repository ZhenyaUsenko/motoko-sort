# Motoko Sort

Fast sorting algorithm implemented in Motoko language

## Algorithm description

1) initialize the sorting *range* to **[0, length - 1]**
2) iterate through the *range* and find **min** and **max** values
    - fast return if no cases with **(prev value > value)** found
3) set all items from the *range* in the **counts** array to **0**
4) for each **item** from the *range* in the input array
    - calculate a new **index**  as `rangeFrom + (item - min) / ((max - min) / (rangeTo - rangeFrom))`
    - increment **counts** array at this **index**
5) initialize **totalCount** to *rangeFrom*
6) for each **count** from the *range* in the **counts** array which is not **0**
    - set **shifterCounts** array at index **totalCount** to **count**
    - replace **count** in the **counts** array with **totalCount**
    - add **count** to **totalCount**
7) for each **item** from the *range* in the input array
    - calculate a new **index**  as `rangeFrom + (item - min) / ((max - min) / (rangeTo - rangeFrom))`
    - get **count** from **counts** array at this **index**
    - set **twinArray** at index **count** to current **item**
    - increment **counts** array at **index**
8) update all items from the *range* in the input array with values from **twinArray**
9) for each **index** and **count** from the *range* in the **shifterCounts** array where **count** is greater than **1** run steps **2-9** with the *range* set to **[index, index + count - 1]**