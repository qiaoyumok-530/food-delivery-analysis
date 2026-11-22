-- | Part C: your corrected version of the AI-generated code.
--   Fix it YOURSELF (AI is not permitted for this part).
module ReviewFixed (reviewTopRestaurant) where

import Data.List (group, sort, sortBy)
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)

data Order = Order
  { restaurant :: String
  , orderValue :: Double
  , discount :: String
  } deriving (Show)

-- (a) Correct CSV splitting using commas instead of words
splitCSV :: String -> [String]
splitCSV [] = [""]
splitCSV (',':xs) = "" : splitCSV xs
splitCSV (x:xs) =
  case splitCSV xs of
    [] -> [[x]]
    (y:ys) -> (x:y) : ys

-- (b) Safe list indexing instead of !!
safeIndex :: [a] -> Int -> Maybe a
safeIndex [] _ = Nothing
safeIndex (x:_) 0 = Just x
safeIndex (_:xs) n
  | n < 0 = Nothing
  | otherwise = safeIndex xs (n - 1)

-- (b, c) Safe parsing using Maybe and readMaybe
parseLine :: String -> Maybe Order
parseLine line = do
  let cols = splitCSV line

  name <- safeIndex cols 2
  valueText <- safeIndex cols 5
  disc <- safeIndex cols 8

  value <- readMaybe valueText :: Maybe Double

  return (Order name value disc)

-- (d, e) Safe selection with correct descending order
topRestaurant :: [Order] -> Maybe String
topRestaurant os =
  case sortBy compareCount counts of
    [] -> Nothing
    ((name, _):_) -> Just name
  where
    counts = map (\g -> (head g, length g))
             (group (sort (map restaurant os)))

-- (e) Sort counts in descending order
    compareCount (_, a) (_, b) = compare b a


-- | Given the whole CSV text, return the restaurant with the most orders
--   and its count (ties: smallest Restaurant ID). Nothing if there are no
--   valid rows. Must never crash.
--reviewTopRestaurant :: String -> Maybe (String, Int)
--reviewTopRestaurant = error "TODO: reviewTopRestaurant"
-- Corrected function
reviewTopRestaurant :: String -> Maybe String
reviewTopRestaurant contents =
  let orders = mapMaybe parseLine (drop 1 (lines contents))
  in topRestaurant orders
