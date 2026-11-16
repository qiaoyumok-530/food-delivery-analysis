-- | Prints the full report.
--   Usage:  cabal run food-delivery -- data/food_orders_new_delhi.csv
module Main (main) where

import System.Environment (getArgs)
import System.IO (hPutStrLn, stderr)

import Analysis ()

main :: IO ()
main = do
  args <- getArgs
  case args of
    [path] -> do
      contents <- readFile path
      putStrLn ("Loaded " ++ show (length (lines contents)) ++ " lines from " ++ path)
      -- TODO: parse, then print clearly labelled answers to Q1, Q2 and Q3
    _ -> hPutStrLn stderr "Usage: food-delivery <path-to-csv>"
