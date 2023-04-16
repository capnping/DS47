SELECT *,
RANK() OVER (
  PARTITION BY ship_mode
  ORDER BY COUNT(*)) 'Rank',
DENSE_RANK() OVER (
  PARTITION BY ship_mode
  ORDER BY COUNT(*)) 'Dense Rank',
PERCENT_RANK() OVER (
  PARTITION BY ship_mode
  ORDER BY COUNT(*)) 'Percent Rank'
FROM shipping_dimen
Window w as(PARTITION BY ship_mode
  ORDER BY COUNT(*));