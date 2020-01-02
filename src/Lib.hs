module Lib
  ( game
  ) where

import Data.Maybe (maybe)
import Prelude hiding (Either(..))
import System.Random (randomIO)
import System.IO (hFlush, stdout)

import Board (Board, gameOver, genBoard, genNewCell, makeMerge)
import Direction (Direction, readDirection)

game :: IO ()
game = do
  putStrLn prompt
  board <- genBoard <$> random
  loop board

prompt :: String
prompt =
  unlines
    [ ""
    , "This is 2048 in Haskell"
    , "Control: w (or up) | a (or left) | s (or down) | d (or right)"
    , "Enjoy"
    ]

loop :: Board -> IO ()
loop board = do
  draw board
  if gameOver board
    then putStrLn "Game over."
    else makeTurn board >>= loop

getTurn :: IO Direction
getTurn = do
  putStr "your turn: " >> flush
  direction <- readDirection <$> getLine
  maybe (putStrLn "Try again" >> getTurn) return direction

makeTurn :: Board -> IO Board
makeTurn board = do
  turn <- getTurn
  let boardAfterTurn = makeMerge turn board
  if boardAfterTurn /= board
    then genNewCell boardAfterTurn <$> random
    else return board

draw :: Board -> IO ()
draw = print

random :: IO Int
random = randomIO

flush :: IO ()
flush = hFlush stdout