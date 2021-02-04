"""Define a bunch of routines to quickly format numbers into a given unit."""

from typing import Tuple, Optional


def series(power: float, units: Tuple[str], fallback: Optional[str] = None):
    """Define a callable to format units in a series.

    A series is a collection of units of values increasing linearly from an
    initial unit. For example there're 1024 bytes in 1 KB, 1024 KB in 1 MB,
    1024 MB in 1 GB. In this case every time we multiply a number by 1024 we
    move to the next unit in the series.

    Parameters
    ----------
    power
      The power by which numbers in the series will increase.
    units
      The units in the power series from smallest to largest values.
    fallback
      The unit value to return when a given input is too large to
      fit into any of the specified units.

    """
    def series_wrapper(count: float, limit: float=power) -> Tuple[float, str]:
        """Return the value of count in the current series.

        Parameters
        ----------
        count
          The numerical value to reduce to a unit value in the current
          series.
        limit
          The maximum possible value in a given unit that's acceptable.
          For example if this is value is set to 100 then the returned
          count is guaranteed to be the first unit value less than 100.

        """
        for unit in units:
            if count < limit:
                return count, unit
            count /= power
        return count, fallback
    return series_wrapper


bytes = series(2 ** 10, ('B', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'), ' ')
