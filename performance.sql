-- Measure arbitrage performance between BX and Bittrex for return > 2% between 150 seconds.
-- https://docs.google.com/presentation/d/1o-PPkjiWHWACw4UFLo9oB_c1aeVjCOyjZnAXJO9KqIY/edit?usp=sharing
SELECT
  AVG(performance) AS perf,
  STD(performance) AS sd
FROM (
       SELECT performance
       FROM (
              SELECT
                DISTINCT
                t0.*,
                (t1.last2 / t0.last1) / t0.spread AS performance
              FROM history t0 LEFT JOIN (SELECT *
                                                   FROM history t1) t1
                  ON t1.coin = t0.coin AND t1.market1 = t0.market1 AND t1.market2 = t0.market2
              WHERE t0.market1 = 'bx' AND t0.market2 = 'bittrex' AND t0.spread > 1.05
                    AND TIMEDIFF(t1.last_update, t0.last_update) = 150) A) T;
