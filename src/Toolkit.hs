-- | Q4: your reusable, polymorphic, higher-order toolkit.
--   The three functions below are REQUIRED (names and types are fixed).
--   Add more of your own and REUSE them in Analysis.hs.
module Toolkit
  ( countBy
  , groupAggregate
  , average
  , sumCalc
  , topNBy
  , sortDesc
  , compDescKey
  ) where

import qualified Data.Map.Strict as Map
import Data.Ord (Down(..))
import Data.List (sortBy)
import Data.List (sortOn)

-- | Count elements by key. Result sorted by key (ascending).
--   countBy length ["a","bb","cc"] == [(1,1),(2,2)]
countBy :: Ord k => (a -> k) -> [a] -> [(k, Int)]
countBy funcToApply = Map.toAscList . Map.fromListWith (+) . map (\x -> (funcToApply x, 1))
--Map.fromListWith (+) combined all existed things

-- | Group by key, then summarise each group. Result sorted by key.
--   groupAggregate fst (sum . map snd) [("a",1),("b",2),("a",3)] == [("a",4),("b",2)]
groupAggregate :: Ord k => (a -> k) -> ([a] -> v) -> [a] -> [(k, v)]
groupAggregate funcToApply aggFunc = 
  map (\(k, xs) -> (k, aggFunc xs)) -- perform the aggregate function
  . Map.toAscList . Map.fromListWith (flip (++)) -- combine the same items in the tuple (preserve the original order)
  . map (\x -> (funcToApply x, [x])) -- make a list with tuples to store each item

-- | Average of a projection. Nothing for an empty list.
average :: Fractional b => (a -> b) -> [a] -> Maybe b
average funcToApply wholeList = 
  case map funcToApply wholeList of
        [] -> Nothing -- check empty list
        values ->
            Just (sum values / fromIntegral (length values))

sumCalc :: Num b => (a -> b) -> [a] -> b
sumCalc funcToApply = sum . map funcToApply

-- topNBy must be stable sorting!!!!!
topNBy :: (a -> a -> Ordering) -> Int -> [a] -> [a]
topNBy comparator n = 
  take n . sortBy comparator

sortDesc :: Ord b => (a -> b) -> [a] -> [a]
sortDesc keyToSort = sortOn (Down . keyToSort)

compDescKey :: Ord b => (a -> b) -> a -> a -> Ordering
compDescKey key a b = compare (key b) (key a) -- compare in descending order
