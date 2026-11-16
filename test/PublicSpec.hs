-- AUTO-GENERATED test runner (public tests). No external test libraries needed.
module Main (main) where

import Control.Exception (SomeException, evaluate, try)
import Data.IORef
import System.Exit (exitFailure, exitSuccess)
import Text.Printf (printf)

import Analysis
import Order
import ReviewFixed
import Toolkit
import Variant

approx :: Double -> Double -> Bool
approx a b = abs (a - b) <= 1e-6 * max 1 (abs b)

approxM :: Maybe Double -> Maybe Double -> Bool
approxM (Just a) (Just b) = approx a b
approxM Nothing Nothing = True
approxM _ _ = False

approxPairs :: Eq k => [(k, Double)] -> [(k, Double)] -> Bool
approxPairs xs ys = length xs == length ys && and (zipWith (\(k1, a) (k2, b) -> k1 == k2 && approx a b) xs ys)

approxPairM :: Eq k => Maybe (k, Double) -> Maybe (k, Double) -> Bool
approxPairM (Just x) (Just y) = approxPairs [x] [y]
approxPairM Nothing Nothing = True
approxPairM _ _ = False

-- | Run one check: (category, name, marks, actual (shown), passed?)
check :: IORef [(String, String, Int, Bool)] -> String -> String -> Int -> IO (String, Bool) -> IO ()
check ref cat name w act = do
  r <- try (act >>= \(s, ok) -> evaluate (length s) >> return (s, ok))
  (shown, ok) <- case r of
    Left e -> return ("EXCEPTION: " ++ takeWhile (/= '\n') (show (e :: SomeException)), False)
    Right v -> return v
  printf "%s [%s] %-45s %s\n" (if ok then "PASS" else "FAIL") cat name (if ok then "" else "got " ++ take 120 shown)
  modifyIORef ref ((cat, name, w, ok) :)

t :: Show a => a -> Bool -> IO (String, Bool)
t v ok = return (show v, ok)

main :: IO ()
main = do
  ref <- newIORef []
  let c = check ref
  c "toolkit" "countBy" 1 (let v = countBy length ["a","bb","cc","d"] in t v (v == [(1,2),(2,2)]))
  c "toolkit" "groupAggregate" 1 (let v = groupAggregate fst (sum . map snd) [("a",1::Int),("b",2),("a",3)] in t v (v == [("a",4),("b",2)]))
  c "toolkit" "average (non-empty)" 1 (let v = average fromIntegral [1,2,3,4::Int] :: Maybe Double in t v (approxM v (Just 2.5)))
  c "toolkit" "average (empty)" 1 (let v = average id ([] :: [Double]) in t v (v == Nothing))
  c "parsing" "parseDiscount ''" 1 (let v = parseDiscount "" in t v (v == Just NoDiscount))
  c "parsing" "parseDiscount 'None'" 1 (let v = parseDiscount "None" in t v (v == Just NoDiscount))
  c "parsing" "parseDiscount '10%'" 1 (let v = parseDiscount "10%" in t v (v == Just (Percent 10.0)))
  c "parsing" "parseDiscount '5% on App'" 1 (let v = parseDiscount "5% on App" in t v (v == Just (Percent 5.0)))
  c "parsing" "parseDiscount '15% New User'" 1 (let v = parseDiscount "15% New User" in t v (v == Just (Percent 15.0)))
  c "parsing" "parseDiscount '50 off Promo'" 1 (let v = parseDiscount "50 off Promo" in t v (v == Just (Flat 50.0)))
  c "parsing" "parseDiscount 'Buy 1 Get 1'" 1 (let v = parseDiscount "Buy 1 Get 1" in t v (v == Nothing))
  c "parsing" "parsePayment 'Credit Card'" 1 (let v = parsePayment "Credit Card" in t v (v == Just CreditCard))
  c "parsing" "parsePayment 'Digital Wallet'" 1 (let v = parsePayment "Digital Wallet" in t v (v == Just DigitalWallet))
  c "parsing" "parsePayment 'Cash on Delivery'" 1 (let v = parsePayment "Cash on Delivery" in t v (v == Just CashOnDelivery))
  c "parsing" "parsePayment 'Bitcoin'" 1 (let v = parsePayment "Bitcoin" in t v (v == Nothing))
  c "q2" "discountAmount 1000 (Percent 10)" 1 (let v = discountAmount 1000 (Percent 10) in t v (approx v 100))
  c "q2" "discountAmount 1000 (Flat 50)" 1 (let v = discountAmount 1000 (Flat 50) in t v (approx v 50))
  c "q2" "discountAmount 1000 (NoDiscount)" 1 (let v = discountAmount 1000 (NoDiscount) in t v (approx v 0))
  c "q2" "discountAmount 333 (Percent 15)" 1 (let v = discountAmount 333 (Percent 15) in t v (approx v 49.95))
  c "robust" "parseOrders on empty text" 1 (let (os, sk) = parseOrders "" in t (length os, sk) (null os && sk == 0))
  c "robust" "empty list: topRestaurants" 1 (let v = topRestaurants 3 [] in t v (null v))
  c "robust" "empty list: costliestOffer" 1 (let v = costliestOffer [] in t v (v == Nothing))
  c "robust" "empty list: averageDiscount" 1 (let v = averageDiscount [] in t v (v == Nothing))
  c "robust" "empty list: lossPercentage" 1 (let v = lossPercentage [] in t v (v == Nothing))
  c "variant" "myVariant is a valid code (X1..X4-Y1..Y4)" 1 (let v = myVariant in t v (v `elem` [x ++ "-" ++ y | x <- ["X1","X2","X3","X4"], y <- ["Y1","Y2","Y3","Y4"]]))
  c "review" "reviewTopRestaurant on empty text" 1 (let v = reviewTopRestaurant "" in t v (v == Nothing))
  txt_sample <- readFile "data/sample_orders.csv"
  let (os_sample, sk_sample) = parseOrders txt_sample
  c "parsing" "[sample] valid orders" 2 (let v = length os_sample in t v (v == 12))
  c "parsing" "[sample] skipped rows" 2 (let v = sk_sample in t v (v == 2))
  c "q1" "[sample] topRestaurants 3" 2 (let v = topRestaurants 3 os_sample in t v (v == [("R1001", 4), ("R1002", 4), ("R1003", 4)]))
  c "q1" "[sample] ordersByPayment" 2 (let v = ordersByPayment os_sample in t v (v == [(CreditCard, 7), (DigitalWallet, 3), (CashOnDelivery, 2)]))
  c "q2" "[sample] discountTotals" 2 (let v = discountTotals os_sample in t v (approxPairs v [((Percent 5.0), (259.70000000000005)), ((Percent 15.0), (142.35)), ((Flat 50.0), (50.0))]))
  c "q2" "[sample] costliestOffer" 2 (let v = costliestOffer os_sample in t v (approxPairM v (Just ((Percent 5.0), 259.70000000000005))))
  c "q2" "[sample] averageDiscount" 2 (let v = averageDiscount os_sample in t v (approxM v (Just (37.67083333333333))))
  c "q3" "[sample] totalProfit" 2 (let v = totalProfit os_sample in t v (approx v (534.9499999999999)))
  c "q3" "[sample] lossPercentage" 2 (let v = lossPercentage os_sample in t v (approxM v (Just (16.666666666666668))))
  c "q3" "[sample] topProfitRestaurants 3" 2 (let v = topProfitRestaurants 3 os_sample in t v (approxPairs v [("R1002", (230.65)), ("R1001", (176.8)), ("R1003", (127.5))]))
  let expX_sample k = case k of
        "X1" -> Just [("R1001", (5370.0)), ("R1003", (5324.0)), ("R1002", (4078.0))]
        "X2" -> Just [("CreditCard", (57.142857142857146)), ("DigitalWallet", (66.66666666666667)), ("CashOnDelivery", (0.0))]
        "X3" -> Just [("C1000", (2.0)), ("C1012", (2.0)), ("C1003", (1.0))]
        "X4" -> Just [("Percent 5.0", (1298.5)), ("Percent 15.0", (949.0)), ("Flat 50.0", (1084.0)), ("NoDiscount", (1257.5))]
        _ -> Nothing
  let expY_sample k = case k of
        "Y1" -> Just (830.3900000000001)
        "Y2" -> Just (534.9499999999999)
        "Y3" -> Just (584.9499999999999)
        "Y4" -> Just (564.9499999999999)
        _ -> Nothing
  c "variant" "[sample] variantX (your X task)" 3 (let v = variantX os_sample in t v (maybe False (approxPairs v) (expX_sample (take 2 myVariant))))
  c "variant" "[sample] variantY (your Y task)" 3 (let v = variantY os_sample in t v (maybe False (approx v) (expY_sample (drop 3 myVariant))))
  c "review" "[sample] reviewTopRestaurant" 2 (let v = reviewTopRestaurant txt_sample in t v (v == Just ("R1001", 4)))
  rs <- readIORef ref
  let total = sum [w | (_, _, w, _) <- rs]
      got   = sum [w | (_, _, w, True) <- rs]
      cats  = foldr (\(k, _, _, _) acc -> if k `elem` acc then acc else k : acc) [] (reverse rs)
  putStrLn ""
  mapM_ (\k -> printf "SUMMARY %-12s %d/%d\n" k (sum [w | (k', _, w, True) <- rs, k' == k]) (sum [w | (k', _, w, _) <- rs, k' == k])) (reverse cats)
  printf "SCORE %d/%d\n" got total
  if got == total then exitSuccess else exitFailure
