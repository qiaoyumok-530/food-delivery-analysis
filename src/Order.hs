-- | Data types for one food delivery order.
--   Part A: design these yourself (record syntax, sum types).
--   REQUIRED by the interface: the type names Order, Discount and
--   PaymentMethod, and the constructors of Discount and PaymentMethod below.
--   You may add fields to Order and add deriving clauses.
module Order
  ( Order (..)
  , Discount (..)
  , PaymentMethod (..)
  ) where

-- | How the customer paid. (Constructors are fixed by the interface.)
data PaymentMethod
  = CreditCard
  | DigitalWallet
  | CashOnDelivery
  deriving (Show, Eq, Ord)

-- | A parsed "Discounts and Offers" value. (Constructors are fixed.)
--   "10%" and "15% New User" -> Percent 10 / Percent 15
--   "50 off Promo"           -> Flat 50
--   "" or "None"             -> NoDiscount
data Discount
  = Percent Double
  | Flat Double
  | NoDiscount
  deriving (Show, Eq, Ord)

-- | One order. TODO (Part A): design the fields you need.
data Order = Order
  { restaurantId :: String
  -- TODO: add the remaining fields
  }
  deriving (Show, Eq)
