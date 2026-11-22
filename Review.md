Question 1 

a. Incorrect CSV data passing using words - The words function separates text by whitespaces instead of commas. The resulting list does not correspond to the actual CSV columns. 

b. Unsafe list indexing using !! - parseLine line =
  Order (cols !! 2) (read (cols !! 5)) (cols !! 8) - The !! operator is a partial function because it causes a runtime exception when the index is outside the list boundaries. If a CSV row contains fewer than nine fields, the program will crash.

c. Unsafe conversion using read - read function is partial because it crashes when the input cannot be converted into a Double. For example, if the CSV contains "N/A" instead of a number, the program will produce a runtime exception.

d. Unsafe use of head - head is a partial function because it causes a runtime error when given an empty list. If counts is empty, sortBy also returns an empty list, so calling head will crash the program.

e. Incorrect sorting order : compareCount (_, a) (_, b) = compare a b - compare a b sorts the order counts in ascending order. Therefore, head selects the restaurant with the fewest orders instead of the most orders.