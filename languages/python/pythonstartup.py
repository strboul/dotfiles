"""
Python startup file
https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
"""

def dirr(fun):
    """
    Simple wrapper to `dir()` that does not show the
    methods starting with underscores
    """
    return [x for x in __builtins__.dir(fun) if not x.startswith('__')]

