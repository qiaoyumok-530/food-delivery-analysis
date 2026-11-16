Section 1
data Order = Order
 { orderID       ::   String,
   customerID    ::   String,
   restaurantID  ::   String,
   orderDateTime ::   String,
   delDateTime   ::   String,
   orderValue    ::   Double,
   deliveryFee   ::   Double,
   paymentMethod ::   PaymentMethod,
   discountOffer ::   Discount,
   commissionFee ::   Double,
   payProcessFee ::   Double,
   refund        ::   Double
   } deriving (Show, Eq)

data PaymentMethod
  = CreditCard
  | DigitalWallet
  | CashOnDelivery
  deriving (Show, Eq, Ord)

data Discount
  = Percent Double
  | Flat Double
  | NoDiscount
  deriving (Show, Eq, Ord)

a. String is chosen for identifiers such as orderID, customerID and restaurantID because they contain alphanumeric prefixes like Customer ID C8270, which cannot be parsed into numeric types. In addition, the identifiers are not referring to quantities or amounts. Furthermore, String has built-in instances for Eq and Ord for equality comparison and ordering that are important in analysis later.
Date and Time data including orderDateTime and delDateTime is defined with String as Haskell's Prelude library does not provide a dedicated date and time type. In this project, none of the tasks require to perform duration calculations. Thus, using String is simpler for parsing and avoids external library overhead. 

b. Double is used for monetary fields such as orderValue, deliveryFee, commissionFee, payProcessFee and refund. Although the dataset contains only whole numbers, using Integer may cause an extra step on calculations later such as applying discount rate. Using Double can prevent repeated type conversions during arithmetic operations.

c. Sum types in PaymentMethod and Discount are integrated instead of using String to ensure that only the valid cases are accepted and essentially prevents invalid values. Additionally, for Discount, Percent and Flat store their respective rate or amount whereas NoDiscount takes no argument as no eduction is applied.

------------------------------------------------------------------------------------

Section 2
Q1: a. topRestaurants :: [Order] -> [(String, Int)]
    # Returns the top 3 restaurants with its restaurantID and number of orders in descending order of the order count.
    
    b. ordersByPayment :: [Order] -> [(PaymentMethod, Int)] 
    # Returns the total number of orders placed under each payment method.

Q2: a. parseDiscount :: String -> Either String Discount
    # Converts the discount text into its respective Discount value, returning Left with the discount text to report the unrecognised offer text instead of ignoring it.

    b. discountAmount :: Order -> Double
    # Returns the actual discount amount for an order.

    c. discountTotals :: [Order] -> [(Discount, Double)]
    # Returns the total discount cost for each Discount type across a list of orders.

    d. costliestOffer :: [Order] -> (Discount, Double)
    # Returns the Discount type that costs the platform the most money with its discounted amount.

    e. averageDiscount :: [Order] -> Maybe Double 
    # Returns the average discount amount per order, returning Nothing to avoid a zero division error when the order list is empty.

Q3: a. orderProfit :: Order -> Double
    # Returns the net profit or loss of an order.

    b. totalProfit :: [Order] -> Double
    # Returns the total net profit or loss across all orders for the platform.

    c. lossPercentage :: [Order] -> Double
    # Returns the percentage of orders that cause a loss from a list of orders.

    d. topProfitRestaurants :: [Order] -> [(String, Double)] 
    # Returns the top 3 restaurants ranked by total net profit descending with its restaurantID.

Q4: a. countBy        :: Ord k => (a -> k) -> [a] -> [(k, Int)]
    # Groups an item by a specific property and returns each property paired with its element count

    b. groupAggregate :: Ord k => (a -> k) -> ([a] -> v) -> [a] -> [(k, v)]
    # Groups an item by a specific property and performs an aggregation function to each group

    c. average        :: Fractional b => (a -> b) -> [a] -> Maybe b
    # Returns the average value from a list, returning Nothing if the list is empty

    d. sumCalc :: Num b => (a -> b) -> [a] -> b
    # Obtains a numeric value from each element in a list and returns their total sum.

    e. filterBy :: (a -> Bool) -> [a] -> [a]
    # Apply a function that return a bool value for an item according to a specified condition on a list of items and return the True items.

    f. topNBy :: (a -> a -> Ordering) -> Int -> [a] -> [a]
    # Sort a list using a custom comparator and returns the top n elements.

Q5: X3-Y4
    a. variantX :: [Order] -> [(String, Double)]
    # Return the top 3 customers ranked by order count descending with its customerID and number of orders made.

    b. variantY :: [Order] -> Double
    # Calculates the total net profit across all orders and then add amount of 15 to every CashOnDelivery order.