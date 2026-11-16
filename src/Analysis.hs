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
import Toolkit ()

-- ---------------------------------------------------------------- Parsing

-- | "" / "None" -> Just NoDiscount; "10%" / "5% on App" -> Just (Percent 5);
--   "50 off Promo" -> Just (Flat 50); anything unrecognised -> Nothing.
parseDiscount :: String -> Maybe Discount
parseDiscount = error "TODO: parseDiscount"

-- | "Credit Card" | "Digital Wallet" | "Cash on Delivery" (else Nothing).
parsePayment :: String -> Maybe PaymentMethod
parsePayment = error "TODO: parsePayment"

-- | Parse the WHOLE CSV text (including the header row).
--   Locate columns by their header NAME, not by a fixed position.
--   Returns the valid orders and the number of data rows that were skipped
--   because they were malformed (wrong number of fields, bad number,
--   unknown payment method or unrecognised discount). Blank lines are ignored.
parseOrders :: String -> ([Order], Int)
parseOrders = error "TODO: parseOrders"

-- ------------------------------------------------------- Q1 Restaurant demand

-- | Top n restaurants by number of orders: count descending,
--   ties broken by Restaurant ID ascending.
topRestaurants :: Int -> [Order] -> [(String, Int)]
topRestaurants = error "TODO: topRestaurants"

-- | Number of orders per payment method, sorted by PaymentMethod
--   (CreditCard, DigitalWallet, CashOnDelivery). Omit methods with 0 orders.
ordersByPayment :: [Order] -> [(PaymentMethod, Int)]
ordersByPayment = error "TODO: ordersByPayment"

-- ------------------------------------------------ Q2 The real cost of discounts

-- | Discount amount for an order of the given Order Value.
--   Percent p -> value * p / 100;  Flat x -> x;  NoDiscount -> 0.
discountAmount :: Double -> Discount -> Double
discountAmount = error "TODO: discountAmount"

-- | Total discount amount per offer type (excluding NoDiscount),
--   sorted by Discount.
discountTotals :: [Order] -> [(Discount, Double)]
discountTotals = error "TODO: discountTotals"

-- | The offer type with the largest total discount (Nothing if none).
costliestOffer :: [Order] -> Maybe (Discount, Double)
costliestOffer = error "TODO: costliestOffer"

-- | Average discount amount over ALL orders (Nothing for no orders).
averageDiscount :: [Order] -> Maybe Double
averageDiscount = error "TODO: averageDiscount"

-- ---------------------------------------------------------- Q3 Profitability

-- | profit = Commission Fee
--          - (Delivery Fee + Payment Processing Fee + discount amount + Refunds/Chargebacks)
orderProfit :: Order -> Double
orderProfit = error "TODO: orderProfit"

-- | Sum of orderProfit over all orders.
totalProfit :: [Order] -> Double
totalProfit = error "TODO: totalProfit"

-- | Percentage (0–100) of orders with profit < 0. Nothing for no orders.
lossPercentage :: [Order] -> Maybe Double
lossPercentage = error "TODO: lossPercentage"

-- | Top n restaurants by total profit: profit descending,
--   ties broken by Restaurant ID ascending.
topProfitRestaurants :: Int -> [Order] -> [(String, Double)]
topProfitRestaurants = error "TODO: topProfitRestaurants"
