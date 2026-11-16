-- Part C: the AI-generated code to review. NOT part of the build. Write your fix in src/ReviewFixed.hs.
-- AI-generated answer to Question 1 (reproduced as received)
module Main where

import Data.List (group, sortBy)

data Order = Order
  { restaurant :: String
  , orderValue :: Double
  , discount   :: String
  }

parseLine :: String -> Order
parseLine line = Order (cols !! 2) (read (cols !! 5)) (cols !! 8)
  where
    cols = words line

topRestaurant :: [Order] -> String
topRestaurant os = fst (head (sortBy compareCount counts))
  where
    counts = map (\g -> (head g, length g)) (group (map restaurant os))
    compareCount (_, a) (_, b) = compare a b

averageOrderValue :: [Order] -> Double
averageOrderValue os = sum (map orderValue os) / fromIntegral (length os)

main :: IO ()
main = do
  contents <- readFile "food_orders_new_delhi.csv"
  let orders = map parseLine (lines contents)
  putStrLn ("Most popular restaurant: " ++ topRestaurant orders)
  print (averageOrderValue orders)
