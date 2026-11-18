-- | Parsing (Part B) and the answers to Q1–Q3.
--   Names and type signatures are FIXED: they are used by the automated tests.
--   Implement every function. Do not use partial functions (head, tail, !!,
--   read, fromJust) unless you justify them in a comment.
module Analysis
  ( -- * Parsing
    parseDiscount
  , parsePayment
  , parseOrders
    -- * Q1 Restaurant demand
  , topRestaurants
  , ordersByPayment
    -- * Q2 The real cost of discounts
  , discountAmount
  , discountTotals
  , costliestOffer
  , averageDiscount
    -- * Q3 Profitability
  , orderProfit
  , totalProfit
  , lossPercentage
  , topProfitRestaurants
  ) where

import Order
import Toolkit (topNBy, countBy, compDescKey, groupAggregate, sumCalc, average)
import Data.Char (isDigit, toLower)
import Data.List (elemIndex)
import Data.List (sortOn)
import Data.Maybe (isNothing, listToMaybe)
import Text.Read (readMaybe)

-- ---------------------------------------------------------------- Parsing

-- | "" / "None" -> Just NoDiscount; "10%" / "5% on App" -> Just (Percent 5);
--   "50 off Promo" -> Just (Flat 50); anything unrecognised -> Nothing.
parseDiscount :: String -> Maybe Discount
parseDiscount discountText
  | normalised == "none" || normalised == "" = Just NoDiscount -- ND for discount text = none
  | not (any isDigit normalised) = Nothing -- no digit in the discount text = Nothing
  | otherwise =
      case break (=='%') normalised of -- break the discount text into 2 parts, first without %, second with % 
        (number, '%':_) ->
          Percent <$> readMaybe number -- percent becomes the number in the front part

        (remainingText, _) -> -- if no %
          case words remainingText of
            number:"off":_ -> -- there's an off word inside the discount text
              Flat <$> readMaybe number -- number becomes flat discount

            _ -> Nothing -- Nothing if no off word

  where 
    normalised = map toLower (unwords(words discountText))


-- | "Credit Card" | "Digital Wallet" | "Cash on Delivery" (else Nothing).
parsePayment :: String -> Maybe PaymentMethod
parsePayment paymentText = 
  case paymentText of
    "Credit Card" -> Just CreditCard
    "Digital Wallet" -> Just DigitalWallet
    "Cash on Delivery" -> Just CashOnDelivery
    _ -> Nothing

-- | Parse the WHOLE CSV text (including the header row).
--   Locate columns by their header NAME, not by a fixed position.
--   Returns the valid orders and the number of data rows that were skipped
--   because they were malformed (wrong number of fields, bad number,
--   unknown payment method or unrecognised discount). Blank lines are ignored.

-- I decide to have a helper function to parse each row
-- First: Split data row
splitField :: String -> [String]
splitField [] = [""]
splitField row = 
  let (field, remaining) = break (== ',') row
  in case remaining of 
    [] -> [field]
    (_:rest) -> field : splitField rest


-- Second: Retrieve the specific field from a row
getRowField :: Int -> [String] -> Maybe String
getRowField positionNum row =
  case drop positionNum row of
    (field:_) -> Just field
    [] -> Nothing

-- Third: Retrive field using its header name
getFieldByName :: String -> [String] -> [String] -> Maybe String
getFieldByName dataNeed allHeaders fieldsPerRow =
  case elemIndex dataNeed allHeaders of -- find position of a column using header name
    Just positionNum -> getRowField positionNum fieldsPerRow
    Nothing -> Nothing

parseOrderRow :: [String] -> [String] -> Maybe Order
parseOrderRow allHeaders perRow 
  | length allHeaders /= length perRow = Nothing
  | otherwise =
    Order
      <$> getFieldByName "Order ID" allHeaders perRow
      <*> getFieldByName "Customer ID" allHeaders perRow
      <*> getFieldByName "Restaurant ID" allHeaders perRow
      <*> getFieldByName "Order Date and Time" allHeaders perRow
      <*> getFieldByName "Delivery Date and Time" allHeaders perRow
      <*> (getFieldByName "Order Value" allHeaders perRow >>= readMaybe)
      <*> (getFieldByName "Delivery Fee" allHeaders perRow >>= readMaybe)
      <*> (getFieldByName "Payment Method" allHeaders perRow >>= parsePayment)
      <*> (getFieldByName "Discounts and Offers" allHeaders perRow >>= parseDiscount)
      <*> (getFieldByName "Commission Fee" allHeaders perRow >>= readMaybe)
      <*> (getFieldByName "Payment Processing Fee" allHeaders perRow >>= readMaybe)
      <*> (getFieldByName "Refunds/Chargebacks" allHeaders perRow >>= readMaybe)
    
parseOrders :: String -> ([Order], Int)
parseOrders dataset =
   case lines dataset of
    [] -> ([], 0)
    headerLine:rowLines ->
      let allHeaders =splitField headerLine
          nonBlankRows = filter (not . null) rowLines
          results = map (parseOrderRow allHeaders . splitField) nonBlankRows
          validOrders = [order | Just order <- results]
          skippedRow = length (filter isNothing results)
      in (validOrders, skippedRow)

-- ------------------------------------------------------- Q1 Restaurant demand

-- | Top n restaurants by number of orders: count descending,
--   ties broken by Restaurant ID ascending.
topRestaurants :: Int -> [Order] -> [(String, Int)]
topRestaurants n orders = topNBy (compDescKey snd) n (sortOn fst (countBy restaurantId orders))

-- | Number of orders per payment method, sorted by PaymentMethod
--   (CreditCard, DigitalWallet, CashOnDelivery). Omit methods with 0 orders.
ordersByPayment :: [Order] -> [(PaymentMethod, Int)]
ordersByPayment orders = countBy paymentMethod orders

-- ------------------------------------------------ Q2 The real cost of discounts

-- | Discount amount for an order of the given Order Value.
--   Percent p -> value * p / 100;  Flat x -> x;  NoDiscount -> 0.
discountAmount :: Double -> Discount -> Double
discountAmount orderValue discount = 
  case discount of
    Percent p -> orderValue * p / 100
    Flat x -> x
    NoDiscount -> 0.0 

-- | Total discount amount per offer type (excluding NoDiscount),
--   sorted by Discount.
discountTotals :: [Order] -> [(Discount, Double)]
discountTotals orders = 
  groupAggregate fst (sumCalc snd) ordersWithDiscount
    where
      filteredOrders = filter ((/= NoDiscount) . discountOffer) orders
      ordersWithDiscount = map (\order -> ( discountOffer order, discountAmount (orderValue order) (discountOffer order))) filteredOrders

-- | The offer type with the largest total discount (Nothing if none).
costliestOffer :: [Order] -> Maybe (Discount, Double)
costliestOffer orders = listToMaybe (topNBy (compDescKey snd) 1 (discountTotals orders))

-- | Average discount amount over ALL orders (Nothing for no orders).
averageDiscount :: [Order] -> Maybe Double
averageDiscount orders = average (\order -> discountAmount (orderValue order) (discountOffer order)) orders

-- ---------------------------------------------------------- Q3 Profitability

-- | profit = Commission Fee
--          - (Delivery Fee + Payment Processing Fee + discount amount + Refunds/Chargebacks)
orderProfit :: Order -> Double
orderProfit order = (commissionFee order) - (deliveryFee order + paymentProcessFee order + (discountAmount (orderValue order) (discountOffer order)) + refundsChargebacks order) 
  -- Profit = Commission Fee - (Delivery Fee + Payment Processing Fee + Discount Amount + Refunds/Chargebacks)

-- | Sum of orderProfit over all orders.
totalProfit :: [Order] -> Double
totalProfit orders = sumCalc orderProfit orders 

-- | Percentage (0–100) of orders with profit < 0. Nothing for no orders.
lossPercentage :: [Order] -> Maybe Double
lossPercentage orders = average (\order -> if orderProfit order < 0 then 100 else 0) orders

-- | Top n restaurants by total profit: profit descending,
--   ties broken by Restaurant ID ascending.
topProfitRestaurants :: Int -> [Order] -> [(String, Double)]
topProfitRestaurants n orders = topNBy (compDescKey snd) n (sortOn fst (groupAggregate restaurantId (sumCalc orderProfit) orders))
