-- | Q5: YOUR PERSONAL VARIANT (anti-collusion).
--   Your lecturer gives you (or your pair) a variant code such as "X3-Y1".
--   Every submission in the class has a DIFFERENT code. Implement ONLY the
--   X task and the Y task in your code (see the assignment brief, Q5).
--   Names and type signatures are FIXED (used by the automated tests).
module Variant
  ( myVariant
  , variantX
  , variantY
  ) where

import Order
    ( Order(paymentMethod, customerId), PaymentMethod(CashOnDelivery) )
import Toolkit (topNBy, compDescKey, groupAggregate, sumCalc)
import Data.List (sortOn)
import Analysis (orderProfit)

-- | Replace with the code given to you on eLearn, e.g. "X3-Y1".
--   A wrong or missing code scores 0 for Q5.
myVariant :: String
myVariant = "X3-Y4"

-- Top 3 customers by number of orders (value = count as a Double): count descending, ties by Customer ID ascending.
-- | Your X task. Returns (label, value) pairs in the order stated in the brief.
variantX :: [Order] -> [(String, Double)]
variantX orders = topNBy (compDescKey snd) 3 (sortOn fst (groupAggregate customerId (fromIntegral . length )orders))

-- A 15 rupee surcharge is added to the platform's revenue for every Cash on Delivery order.
-- | Your Y task: the platform's total profit under your "what-if" policy.
variantY :: [Order] -> Double
variantY orders = sumCalc (\order -> if (paymentMethod order == CashOnDelivery) 
  then orderProfit order + 15
  else orderProfit order) orders 
