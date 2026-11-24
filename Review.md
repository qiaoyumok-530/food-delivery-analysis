-- Question 1 --

a. Incorrect CSV data passing using words - " cols = words line " 
: The words function separates text by whitespaces instead of commas. The resulting list does not correspond to the actual CSV columns. 

b. Unsafe list indexing using !! - " parseLine line = Order (cols !! 2) (read (cols !! 5)) (cols !! 8) " 
: The !! operator is a partial function because it causes a runtime exception when the index is not inside the list boundaries. If a CSV row contains fewer than nine fields, the program will produce an error.

c. Incorrect input handling using read - " (read (cols !! 5)) "
: Read function is partial because it crashes when the input cannot be converted into Double. For example, if the CSV contains "N/A" instead of a number, the program will throw a runtime exception.

d. Possible error when using head - " topRestaurant os = fst (head (sortBy compareCount counts)) , where
    counts = map (\g -> (head g, length g)) (group (map restaurant os)) "
: Head is a partial function because it causes a runtime error when given an empty list. If counts is empty, sortBy also returns an empty list, so calling head will crash the program.

e. Incorrect sorting order - " compareCount (_, a) (_, b) = compare a b "
: Compare a b sorts the order counts in ascending order. Therefore, head selects the restaurant with the fewest orders instead of the most orders.

-- Question 3 --

I learned that we cannot blindly trust AI-generated code just because it compiles successfully, as it may still contain mistakes. For example, I discovered that functions such as `!!`, and `read` can cause runtime errors, while incorrect sorting can produce wrong results. Therefore, I will always test AI-generated code and understand how its functions work before accepting it.