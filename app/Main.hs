module Main where

import           Data.List                      ( intercalate )
import           SmokeTest                      ( smokeTest )
import           System.Environment             ( getArgs )

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["0", host, port] -> smokeTest host port
    otherwise ->
      error
        "Expected args are: [problemNumber, host, port], for instance: [0, localhost, 8080]"
