#!/usr/bin/python
"""
Partial tool to locate and remedy divergent encodings or mojibake in a repo.
Incomplete, but may help in the future

find . -iname "*py|*js" -exec grep --color='auto' -P -n "[\x80-\xFF]" {} \;
"""

a = "this.label = '\x97' + this.name;"

b = a.decode('cp1252')
c = a.encode('utf-8')
