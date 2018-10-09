import re
import sys

from pylint import checkers
from pylint import interfaces

# Maximum number of characters that should be in a line.
_LINE_LENGTH_MAX = 80
# Matches URLs that start with http or https, like https://ketohub.io.
_URL_PATTERN = re.compile(
    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)'
)
# Matches triple single or double quotes.
_TRIPLE_QUOTE_PATTERN = re.compile(r'(\'\'\'|\"\"\")')
# Matches a line containing a string.
_STRING_PATTERN = re.compile(r'(\'.+\')|(\".+\")')
# Matches a comment line.
_COMMENT_PATTERN = re.compile(r'(^|\s)#')
# Matches raw strings, for example r'whatever'.
_RAW_STRING_PATTERN = re.compile(r'(r\'.+\')')


class LineLengthChecker(checkers.BaseChecker):
    """PyLint AST based checker to verify line length requirements.

    Line lengths are verified using the following rules:
        - Generally, lines should not exceed _LINE_LENGTH_MAX.
        - It is always okay to exceed this limit if the line contains a URL.
        - Raw strings can exceed the limit.
        - Lines that are within a triple-quoted string may also exceed the limit
          if the triple-quoted string is not a docstring.
        - Only comments, docstrings, or lines containing a string are
            checked.
    """
    __implements__ = interfaces.IAstroidChecker

    class _MessageC0001(object):
        pass

    name = 'line-length'
    priority = -1
    msgs = {
        'C0001':
        ('Lines should not be longer than %d characters.' % _LINE_LENGTH_MAX,
         ('line-over-max-length'), _MessageC0001)
    }

    options = ()

    def visit_function(self, node):
        self._check_docstring(node)

    def visit_class(self, node):
        self._check_docstring(node)

    def visit_module(self, node):
        self._check_docstring(node)

    def leave_module(self, node):
        """Called after all of the nodes within a module have been visited."""
        self._process_module(node)

    def _check_docstring(self, node):
        doc = node.doc
        if not doc:
            return
        lines = node.doc.split('\n')
        for line_offset, line in enumerate(lines):
            self._check_line_length(line, node.fromlineno + line_offset, node)

    def _process_module(self, node):
        """Check the line length of all lines of interest within a module.

        Iterates through all the lines in a module, checking that all lines of
        interest do not exceed the line length max unless a URL is present.
        Handles the module's content as a stream instead of as AST nodes.

        Lines of interest include comments and lines that contain strings.

        Args:
            node: AST node object for the module.
        """
        with node.stream() as stream:
            for line_number, line in enumerate(stream):
                if _is_line_of_interest(line):
                    self._check_line_length(line, line_number, node)

    def _check_line_length(self, line, line_number, node):
        """Check if length of line is valid.

        Args:
            line: String of line that we're verifying.
            line_number: Zero-indexed line number of line.
            node: AST node that the line belongs to.
        """
        if not _over_line_length(line):
            return
        if _contains_url(line):
            return
        if _contains_a_raw_string(line):
            return
        if not _is_one_line_triple_quote(line):
            # We add 1 to the line number because arrays are 0 indexed
            # but line numbers are not.
            self.add_message('C0001', node=node, line=line_number + 1)


def _is_line_of_interest(line):
    """Checks if line is a comment or contains a string."""
    return any([_contains_a_string(line), _is_a_comment_line(line)])


def _is_one_line_triple_quote(line):
    return len(_TRIPLE_QUOTE_PATTERN.findall(line)) == 2


def _contains_a_raw_string(line):
    return _RAW_STRING_PATTERN.search(line)


def _contains_a_string(line):
    return _STRING_PATTERN.search(line)


def _is_a_comment_line(line):
    return _COMMENT_PATTERN.search(line)


def _contains_url(line):
    return _URL_PATTERN.search(line)


def _over_line_length(line):
    return len(line) > _LINE_LENGTH_MAX + 1


def register(linter):
    """Pylint will call this func to register all checkers in this module."""
    this_module = sys.modules[__name__]
    for member in dir(this_module):
        if (not member.endswith('Checker') or
                member in ('BaseChecker', 'IAstroidChecker')):
            continue
        cls = getattr(this_module, member)
        linter.register_checker(cls(linter))
