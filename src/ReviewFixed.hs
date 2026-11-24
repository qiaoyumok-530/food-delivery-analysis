-- | Part C: your corrected version of the AI-generated code.
--   Fix it YOURSELF (AI is not permitted for this part).
module ReviewFixed (reviewTopRestaurant) where
import Text.Read (readMaybe)
import Data.List (group, sort, sortBy)
import Data.Maybe (mapMaybe)

data Order = Order
  { restaurant :: String
  , orderValue :: Double
  , discount :: String
  } deriving (Show)

-- a) Correct CSV splitting using commas instead of words
splitCSV :: String -> [String]
splitCSV [] = [""]
splitCSV (',':xs) = "" : splitCSV xs
splitCSV (x:xs) =
  case splitCSV xs of
    [] -> [[x]]
    (y:ys) -> (x:y) : ys

-- b) Safer list indexing instead of !!
findAtIndex :: [a] -> Int -> Maybe a
findAtIndex [] _ = Nothing
findAtIndex (x:_) 0 = Just x
findAtIndex (_:xs) n = 
  if n < 0
  then Nothing
  else findAtIndex xs (n - 1)

-- c) Safe parsing using Maybe and readMaybe
parseLine :: String -> Maybe Order
parseLine line = do
  let cols = splitCSV line
  name <- findAtIndex cols 2
  valueText <- findAtIndex cols 5
  disc <- findAtIndex cols 8

  value <- readMaybe valueText :: Maybe Double
  return (Order name value disc)

-- d) Remove use of head into safe selection with correct descending order
countGroup :: [String] -> Maybe (String,Int)
countGroup [] = Nothing
countGroup (name:rest) = Just (name, 1 + length rest)

topRestaurant :: [Order] -> Maybe (String,Int)
topRestaurant os =
  case sortBy compareCount counts of
    [] -> Nothing
    ((name, count):_) -> Just (name, count)
  where
    names = map restaurant os
    sortedNames = sort names
    groupedNames = group sortedNames
    counts = mapMaybe countGroup groupedNames

    -- e) Sort counts in descending order and smallest restaurant ID
    compareCount (id1, a) (id2, b)
      | a /= b = compare b a
      | otherwise = compare id1 id2

-- | Given the whole CSV text, return the restaurant with the most orders
--   and its count (ties: smallest Restaurant ID). Nothing if there are no
--   valid rows. Must never crash.
--reviewTopRestaurant = error "TODO: reviewTopRestaurant"
-- Corrected function

reviewTopRestaurant :: String -> Maybe (String, Int)
reviewTopRestaurant contents =
  let orders = mapMaybe parseLine (drop 1 (lines contents))
  in topRestaurant orders
