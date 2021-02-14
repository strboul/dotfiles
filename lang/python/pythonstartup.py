"""
Python startup file
https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
"""

def dirr(obj):
    """
    Simple wrapper to `dir()` not showing methods starting with '__'.
    """
    return [x for x in __builtins__.dir(obj) if not x.startswith('__')]


# set prompt
import sys
sys.ps1 = "\033[1;34mpy>>\033[0m " # prompt
sys.ps2 = "\033[1;35m...\033[0m "  # continue
