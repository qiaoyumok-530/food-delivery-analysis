-- | Q4: your reusable, polymorphic, higher-order toolkit.
--   The three functions below are REQUIRED (names and types are fixed).
--   Add more of your own and REUSE them in Analysis.hs.
module Toolkit
  ( countBy
  , groupAggregate
  , average
  ) where

-- | Count elements by key. Result sorted by key (ascending).
--   countBy length ["a","bb","cc"] == [(1,1),(2,2)]
countBy :: Ord k => (a -> k) -> [a] -> [(k, Int)]
countBy = error "TODO: countBy"

-- | Group by key, then summarise each group. Result sorted by key.
--   groupAggregate fst (sum . map snd) [("a",1),("b",2),("a",3)] == [("a",4),("b",2)]
groupAggregate :: Ord k => (a -> k) -> ([a] -> v) -> [a] -> [(k, v)]
groupAggregate = error "TODO: groupAggregate"

-- | Average of a projection. Nothing for an empty list.
average :: Fractional b => (a -> b) -> [a] -> Maybe b
average = error "TODO: average"
