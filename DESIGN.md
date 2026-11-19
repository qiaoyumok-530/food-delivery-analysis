Section 1
data Order = Order
 { orderId       ::   String,
   customerId    ::   String,
   restaurantId  ::   String,
   orderDateTime ::   String,
   deliveryDateTime   ::   String,
   orderValue    ::   Double,
   deliveryFee   ::   Double,
   paymentMethod ::   PaymentMethod,
   discountOffer ::   Discount,
   commissionFee ::   Double,
   paymentProcessFee ::   Double,
   refundsChargebacks ::   Double
   } deriving (Show, Eq)

   a. orderId :: String
   - String is used because orderId is an identifier for a single order. Although it contains numeric characters, it does not refer to a quantity or amount. Furthermore, String has built-in instances of Eq and Ord for equality comparison and ordering operations that are important in analysis later.

   b. customerId :: String
   - String is used because customerId is an identifier for a single customer that placed orders. It contains alphanumeric prefixes like Customer ID C8270, which cannot be parsed into numeric types. In addition, the identifiers are not referring to quantities or amounts. Furthermore, String has built-in instances of Eq and Ord for equality comparison and ordering operations that are important in analysis later.

   c. restaurantId :: String
   - String is used because restaurantId is an identifier for a single restaurant in this platform. It contains alphanumeric prefixes like Restaurant ID R2924, which cannot be parsed into numeric types. In addition, the identifiers are not referring to quantities or amounts. Furthermore, String has built-in instances of Eq and Ord for equality comparison and ordering operations that are important in analysis later.

   d. orderDateTime :: String
   - orderDateTime represents the date and time when an order is placed. It is defined as String because Haskell's Prelude library does not provide a dedicated date and time type. As this project does not require date and time calculations, using String is simpler for parsing and avoids additional external library overhead. 

   e. deliveryDateTime :: String
   - deliveryDateTime represents the date and time when an order is delivered. It is defined as String because Haskell's Prelude library does not provide a dedicated date and time type. As this project does not require date and time calculations, using String is simpler for parsing and avoids additional external library overhead. 

   f. orderValue :: Double
   - orderValue represents the total amount of a single order. It is defined as Double. Although the dataset contains only whole numbers, calculations such as applying discount rate may require decimal results. Using Double allows these calculations to be performed directly without repeated type conversions during arithmetic operations.

   g. deliveryFee :: Double
   - deliveryFee represents the delivery charge for a single order. It is defined as Double. Although the dataset contains only whole numbers, calculations such as order profit calculations may require decimal results. Using Double allows these calculations to be performed directly without repeated type conversions during arithmetic operations.

   h. paymentMethod :: PaymentMethod
   - paymentMethod refers to the payment method used by a customer for a single order. It is defined as PaymentMethod instead of String because sum type in Haskell can restrict the payment method to the predefined constructors only including CreditCard, DigitalWallet and CashOnDelivery. This makes the data more consistent and avoids unrecognised or invalid data being accepted during parsing. 

   i. discountOffer :: Discount
   - discountOffer refers to the discount that is applied on a single order. It is defined as Discount instead of String because sum type in Haskell can restrict the discount being offered to the predefined constructors only including Percent, Flat and NoDiscount. This makes the data more consistent and avoids unrecognised or invalid data being accepted during parsing. 
   - Percent stores the percentage discount rate, Flat stores the fixed discount amount and NoDiscount indicates an order has no discount. The CSV text maps to the constructor using parseDiscount, for example, "5% on App" is converted to Percent 5, "50 off Promo" is converted to Flat 50, None is converted into NoDiscount and unrecognised text returns Nothing.

   j. commissionFee :: Double
   - commissionFee represents the commission earned by the platform from a single order. It is defined as Double. Although the dataset contains only whole numbers, calculations such as order profit calculations may require decimal results. Using Double allows these calculations to be performed directly without repeated type conversions during arithmetic operations.

   k. paymentProcessFee :: Double
   - paymentProcessFee represents the payment processing fee charged for a single order. It is defined as Double. Although the dataset contains only whole numbers, calculations such as order profit calculations may require decimal results. Using Double allows these calculations to be performed directly without repeated type conversions during arithmetic operations.

   l. refundsChargebacks :: Double
   - refundsChargebacks represents the total amount refunded to the customer or charged back for a single order. It is defined as Double. Although the dataset contains only whole numbers, calculations such as order profit calculations may require decimal results. Using Double allows these calculations to be performed directly without repeated type conversions during arithmetic operations.

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

a. String is chosen for identifiers such as orderId, customerId and restaurantId because they contain alphanumeric prefixes like Customer ID C8270, which cannot be parsed into numeric types. In addition, the identifiers are not referring to quantities or amounts. Furthermore, String has built-in instances for Eq and Ord for equality comparison and ordering that are important in analysis later.
Date and Time data including orderDateTime and delDateTime is defined with String as Haskell's Prelude library does not provide a dedicated date and time type. In this project, none of the tasks require to perform duration calculations. Thus, using String is simpler for parsing and avoids external library overhead. 

b. Double is used for monetary fields such as orderValue, deliveryFee, commissionFee, payProcessFee and refund. Although the dataset contains only whole numbers, using Integer may cause an extra step on calculations later such as applying discount rate. Using Double can prevent repeated type conversions for decimal results during arithmetic operations.

c. Sum types in PaymentMethod and Discount are integrated instead of using String to ensure that only the valid cases are accepted and essentially prevents invalid values. Additionally, for Discount, Percent and Flat store their respective rate or amount whereas NoDiscount takes no argument as no deduction is applied.

------------------------------------------------------------------------------------

Section 2
    splitField :: String -> [String]
    # Splits a single row of data into a list that contains all the fields belongs to that order.

    getRowField :: Int -> [String] -> Maybe String
    # Returns a particular item from a field list that is needed by using the column number.

    getFieldByName :: String -> [String] -> [String] -> Maybe String
    # Returns the particular field according to the header from a field list by using the header, returning Nothing if there is no such field.

    parseOrderRow :: [String] -> [String] -> Maybe Order
    # Returns an Order by using a list of headers and a list of fields, returning Nothing if the list of fields contain invalid data.

    parseOrders :: String -> ([Order], Int)
    # Parses the entire CSV text into a list of valid orders and returns the number of invalid data rows skipped.

    parsePayment :: String -> Maybe PaymentMethod
    # Converts the payment method text into its corresponding PaymentMethod, returning Nothing for unrecognised text.

Q1: a. topRestaurants :: Int -> [Order] -> [(String, Int)]
    # Returns the top n restaurants ranked by order count in descending order with its ascending order of restaurantID and number of orders.
    
    b. ordersByPayment :: [Order] -> [(PaymentMethod, Int)] 
    # Returns the total number of orders placed under each payment method.

Q2: a. parseDiscount :: String -> Maybe Discount
    # Converts the discount text into its respective Discount constructor such as Percent, Flat or NoDiscount, returning Nothing for the unrecognised offer text instead of ignoring it.

    b. discountAmount :: Double -> Discount -> Double
    # Returns the actual discount amount using the given order value and a Discount type.

    c. discountTotals :: [Order] -> [(Discount, Double)]
    # Returns the total discount amount for each Discount type across a list of orders.

    d. costliestOffer :: [Order] -> Maybe (Discount, Double)
    # Returns the Discount type with the highest total discount amount, returning Nothing when the order has no applicable discount offers.

    e. averageDiscount :: [Order] -> Maybe Double 
    # Returns the average discount amount per order, returning Nothing to avoid a zero division error when the order list is empty.

Q3: a. orderProfit :: Order -> Double
    # Returns the net profit or loss of an order.

    b. totalProfit :: [Order] -> Double
    # Returns the total net profit or loss across a list of orders.

    c. lossPercentage :: [Order] -> Maybe Double
    # Returns the percentage of orders that causes a loss from a list of orders, returning Nothing if the order list is empty.

    d. topProfitRestaurants :: Int -> [Order] -> [(String, Double)] 
    # Returns the top n restaurants ranked by total net profit descending with its ascending order of restaurantID.

Q4: a. countBy        :: Ord k => (a -> k) -> [a] -> [(k, Int)]
    # Groups items by a specific key that is extracted from a function and returns each key with its number of occurrences.

    b. groupAggregate :: Ord k => (a -> k) -> ([a] -> v) -> [a] -> [(k, v)]
    # Groups items by a specific key that is extracted from a function and performs an aggregation function to each group.

    c. average        :: Fractional b => (a -> b) -> [a] -> Maybe b
    # Returns the average of values obtained from a list, returning Nothing if the list is empty

    d. sumCalc :: Num b => (a -> b) -> [a] -> b
    # Applies a function to each item in a list to obtain a numeric value and returns the sum of them.

    e. topNBy :: (a -> a -> Ordering) -> Int -> [a] -> [a]
    # Sorts a list using a custom comparator and returns the top n items.

    f. compDescKey :: Ord b => (a -> b) -> a -> a -> Ordering
    # Compares two items based on a key that is extracted from a function input in descending order.

Q5: X3-Y4
    a. variantX :: [Order] -> [(String, Double)]
    # Returns the top 3 customers ranked by order count in descending order with its customerID and number of orders made.

    b. variantY :: [Order] -> Double
    # Calculates the total net profit across all orders and then adds amount of 15 for each CashOnDelivery order.

Section 4
How you will turn each "Discounts and Offers" text into a discount amount
Step 1: Parse the discount text into a Discount type
1. If the text is "None" or empty, it is NoDiscount
2. Check whether the discount text contains a number, if not returns Nothing
3. If yes, check whether the number is followed by a % character.
4. If there is a '%' after the number, it is Percent.
5. If there is an "off" keyword, it is Flat.
6. If the contains neither a '%' nor "off", returns Nothing
Step 2: Calculate the actual discount amount
Discount Type:
1. Percent: Order Value * Percent value / 100
2. Flat: Flat value
3. NoDiscount: 0

Profit Formula
# Profit = Commission Fee - (Delivery Fee + Payment Processing Fee + Discount Amount + Refunds/Chargebacks)