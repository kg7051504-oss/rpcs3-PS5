#!/usr/bin/env python3
"""Resolve zdiff3 conflict hunks in a file, in order.

usage: resolve_conflict.py FILE SPEC [SPEC...]
SPEC per hunk: ours | theirs | both (ours then theirs) | both-rev (theirs then ours)
             | @path  (replacement text read from path)
"""
import sys

def main():
    path, specs = sys.argv[1], sys.argv[2:]
    lines = open(path).read().split('\n')
    out, i, h = [], 0, 0
    while i < len(lines):
        if not lines[i].startswith('<<<<<<< '):
            out.append(lines[i]); i += 1; continue
        ours, base, theirs, cur = [], [], [], 'ours'
        i += 1
        while not lines[i].startswith('>>>>>>> '):
            l = lines[i]
            if l.startswith('||||||| '): cur = 'base'
            elif l == '=======': cur = 'theirs'
            else: {'ours': ours, 'base': base, 'theirs': theirs}[cur].append(l)
            i += 1
        i += 1
        spec = specs[h]; h += 1
        if spec == 'ours': out += ours
        elif spec == 'theirs': out += theirs
        elif spec == 'both': out += ours + theirs
        elif spec == 'both-rev': out += theirs + ours
        elif spec.startswith('@'): out += open(spec[1:]).read().rstrip('\n').split('\n')
        else: sys.exit(f'bad spec {spec}')
    if h != len(specs): sys.exit(f'{path}: {h} hunks but {len(specs)} specs')
    open(path, 'w').write('\n'.join(out))
    print(f'{path}: resolved {h} hunk(s)')

main()
